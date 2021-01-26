public without sharing class AccountConsolidationUtility {

	public static final String MERGE_ACTION_TYPE = '1';
	public static final String SPLIT_ACTION_TYPE = '2';
	public static final Id CLIENT_CONSOLIDATION_RT = Case.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Client_Consolidation').recordTypeId;

	private List<ConsolidationResult__c> toBeMerged = new List<ConsolidationResult__c>();
	private List<ConsolidationResult__c> toCreateCases = new List<ConsolidationResult__c>();

	Map<String, Account> oldAccountsByGlobalIdsMap;
	Map<String, Account> newAccountsByGlobalIdsMap;

	List<Case> casesToUpdate = new List<Case>();
	List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
	List<Task> tasksToUpdate = new List<Task>();
	List<ClientZone__c> clientZonesToUpdate = new List<ClientZone__c>();
	List<Case> casesToCreate = new List<Case>();

	public AccountConsolidationUtility(List<ConsolidationResult__c> consolidationResults) {
		for (ConsolidationResult__c consolidationResult : consolidationResults) {
			if (consolidationResult.OldGlobalID__c == null) {
				continue;
			}
			if (consolidationResult.ActionType__c == MERGE_ACTION_TYPE) {
				toBeMerged.add(consolidationResult);
			} else {
				toCreateCases.add(consolidationResult);
			}
		}
		initAccountsMaps(consolidationResults);
	}

	private void initAccountsMaps(List<ConsolidationResult__c> consolidationResults) {
		Set<String> oldGlobalIds = new Set<String>();
		Set<String> newGlobalIds = new Set<String>();
		for (ConsolidationResult__c result : consolidationResults) {
			oldGlobalIds.add(result.OldGlobalID__c);
			newGlobalIds.add(result.NewGlobalID__c);
		}
		oldGlobalIds.remove(null);
		newGlobalIds.remove(null);
		oldAccountsByGlobalIdsMap = mapAccountsByGlobalId([
			SELECT
				Id, GlobalId__c, (SELECT Id, AccountId FROM Cases), (SELECT Id, AccountId FROM Opportunities), (SELECT Id, WhatId FROM Tasks), (SELECT Id, Account__c FROM ClientZones__r)
			FROM Account
			WHERE GlobalId__c IN :oldGlobalIds
		]);
		newAccountsByGlobalIdsMap = mapAccountsByGlobalId([
			SELECT Id, GlobalId__c, (SELECT Id, Account__c FROM ClientZones__r)
			FROM Account
			WHERE GlobalId__c IN :newGlobalIds
		]);
	}

	private Map<String, Account> mapAccountsByGlobalId(List<Account> accounts) {
		Map<String, Account> accountMap = new Map<String, Account>();
		for (Account a : accounts) {
			accountMap.put(a.GlobalId__c, a);
		}
		return accountMap;
	}

	public void process() {
		processMerges();
		processCaseCreations();
		update casesToUpdate;
		update opportunitiesToUpdate;
		update tasksToUpdate;
		update clientZonesToUpdate;
		insert casesToCreate;
	}

	private void processMerges() {
		for (ConsolidationResult__c result : toBeMerged) {
			Account oldAccount = oldAccountsByGlobalIdsMap.get(result.OldGlobalID__c);
			Account newAccount = newAccountsByGlobalIdsMap.get(result.NewGlobalID__c);
			if (!oldAccount.ClientZones__r.isEmpty() && !newAccount.ClientZones__r.isEmpty()) {
				toCreateCases.add(result);
				continue;
			}
			reparentCases(oldAccount.Cases, newAccount.Id);
			reparentOpportunities(oldAccount.Opportunities, newAccount.Id);
			reparentTasks(oldAccount.Tasks, newAccount.Id);
			reparentClientZones(oldAccount.ClientZones__r, newAccount.Id);
		}
	}

	private void processCaseCreations() {
		for (ConsolidationResult__c result : toCreateCases) {
			casesToCreate.add(new Case(
				RecordTypeId = CLIENT_CONSOLIDATION_RT,
				Subject = 'Manual client consolidation',
				AccountId = oldAccountsByGlobalIdsMap.get(result.OldGlobalID__c).Id,
				ConsolidationResult__c = result.Id
			));
		}
	}

	private void reparentCases(List<Case> cases, Id newAccountId) {
		for (Case c : cases) {
			casesToUpdate.add(new Case(
				Id = c.Id,
				AccountId = newAccountId
			));
		}
	}

	private void reparentOpportunities(List<Opportunity> opportunities, Id newAccountId) {
		for (Opportunity o : opportunities) {
			opportunitiesToUpdate.add(new Opportunity(
				Id = o.Id,
				AccountId = newAccountId
			));
		}
	}

	private void reparentTasks(List<Task> tasks, Id newAccountId) {
		for (Task t : tasks) {
			tasksToUpdate.add(new Task(
				Id = t.Id,
				WhatId = newAccountId
			));
		}
	}

	private void reparentClientZones(List<ClientZone__c> clientZones, Id newAccountId) {
		for (ClientZone__c cz : clientZones) {
			clientZonesToUpdate.add(new ClientZone__c(
				Id = cz.Id,
				Account__c = newAccountId
			));
		}
	}
}