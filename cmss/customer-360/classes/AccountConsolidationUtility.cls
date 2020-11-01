public without sharing class AccountConsolidationUtility {

	public static final String MERGE = '1';
	public static final String PARTIAL_MERGE = '2';
	public static final String SPLIT = '3';

	public final List<SObjectType> salesforceMasteredEntities = new List<SObjectType>{
		Case.SObjectType,
		Opportunity.SObjectType,
		Task.SObjectType,
		ClientZone__c.SObjectType
	};

	public final Map<SObjectType, String> relationFieldsMap = new Map<SObjectType, String>{
		Case.SObjectType => 'AccountId',
		Opportunity.SObjectType => 'AccountId',
		Task.SObjectType => 'WhatId',
		ClientZone__c.SObjectType => 'Account__c'
	};

	private List<ConsolidationResult__c> toBeMerged = new List<ConsolidationResult__c>();
	private List<ConsolidationResult__c> toCreateCases = new List<ConsolidationResult__c>();
	Map<String, Account> accountsByGlobalIdsMap;

	AccountConsolidationUtility(List<ConsolidationResult__c> consolidationResults) {
		for (ConsolidationResult__c consolidationResult : consolidationResults) {
			if (consolidationResult.ActionType__c == MERGE) {
				toBeMerged.add(consolidationResult);
			} else {
				toCreateCases.add(consolidationResult);
			}
		}
		accountsByGlobalIdsMap = prepareAccountsByGlobalIdsMap(getGlobalIds(consolidationResults));
	}

	public static void changeOwnerOfInvalidatedAccounts(List<Account> accounts) {
		// todo tohle asi vyndám do triggeru
		Id ownerForHiddenRecordsId = CommonSetting__c.getOrgDefaults().OwnerForHiddenRecords__c;
		if (ownerForHiddenRecordsId != null) {
			for (Account a : accounts) {
				if (a.IsInvalid__c && a.OwnerId != ownerForHiddenRecordsId) {
					a.OwnerId = ownerForHiddenRecordsId;
				}
			}
		}
	}

	public void process() {
		processMerges(toBeMerged);
		processCaseCreations(toCreateCases);
	}

	private void processMerges(List<ConsolidationResult__c> consolidationResults) {
		Map<SObjectType, List<SObject>> recordsToUpdate = initRecordsToUpdateMap();
		for (SObjectType sObjectType : salesforceMasteredEntities) {
			moveRelatedRecordsToNewAccount(sObjectType, consolidationResults);
		}
	}

	private void moveRelatedRecordsToNewAccount(SObjectType sObjectType, List<ConsolidationResult__c> consolidationResults) {
		// musim: najit vsechny related zaznamy pro old
		// zmenit na new
		// ...a ulozit, to vypada celkem ok
		Set<Id> oldAccountIds = new Set<Id>();
		for (ConsolidationResult__c consolidationResult : consolidationResults) {
			oldAccountIds.add(accountsByGlobalIdsMap.get(consolidationResult.OldGlobalID__c));
		}
		for (SObject record : selectRecords(sObjectType, oldAccountIds)) {

		}
		// todo jeste mi to chybi old-to-new globalId mapa
		// todo a taky nejak kontrolovat, ze novej account ma tu kleintskou zonu... popravde, nevimno
		// todo taky je moznost si ty data vyselectit uz vlastne v ramci accountu... coooo? bude to pak uplne jinak, ale mozna snazsi
	}

	private List<SObject> selectRecords(SObjectType sObjectType, Set<Id> accountIds) {
		String accountRelationField = relationFieldsMap.get(sObjectType);
		String query = 'SELECT Id, ' + accountRelationField + ' FROM ' + sObjectType + ' WHERE ' + accountRelationField + '(\'' + String.join(accountIds, '\',\'') + '\')';
		return Database.query(query);
	}

	private Map<SObjectType, List<SObject>> initRecordsToUpdateMap() {
		Map<SObjectType, List<SObject>> theMap = new Map<SObjectType, List<SObject>>();
		for (SObjectType sObjectType : salesforceMasteredEntities) {
			theMap.put(sObjectType, new List<SObject>());
		}
		return theMap;
	}

	private Set<String> getGlobalIds(List<ConsolidationResult__c> consolidationResults) {
		Set<String> globalIds = new Set<String>();
		for (ConsolidationResult__c consolidationResult : consolidationResults) {
			globalIds.add(consolidationResult.NewGlobalID__c);
			globalIds.add(consolidationResult.OldGlobalID__c);
		}
		return globalIds;
	}

	private Map<String, Account> prepareAccountsByGlobalIdsMap(Set<String> globalIds) {
		Map<String, Account> accountsByGlobalIds = new Map<String, Account>();
		for (Account a : [SELECT Id, GlobalId__c FROM Account WHERE GlobalId__c IN :globalIds]) {
			accountsByGlobalIds.put(a.GlobalId__c, a);
		}
		return accountsByGlobalIds;
	}

}