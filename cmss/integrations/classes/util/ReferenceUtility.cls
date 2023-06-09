public with sharing class ReferenceUtility {

	public static Account getAccountByGlobalId(String globalId) {
		for (Account a : [SELECT PersonContactId FROM Account WHERE GlobalId__c = :globalId LIMIT 1]) {
			return a;
		}
		throw new SOAPCommonTypes.BusinessException(201, 'Record not found: Client - Global ID: ' + globalId);
	}

	public static Asset getAssetByNumber(String assetNumber) {
		for (Asset a : [SELECT Id FROM Asset WHERE Name = :assetNumber LIMIT 1]) {
			return a;
		}
		throw new SOAPCommonTypes.BusinessException(201, 'Record not found: Asset - contractNumber: ' + assetNumber);
	}

	public static ClientZone__c getClientZoneByExternalId(String clientZoneExternalId) {
		for (ClientZone__c cz : [SELECT Id, Account__c, NumberOfAnnexes__c FROM ClientZone__c WHERE ExternalId__c = :clientZoneExternalId LIMIT 1]) {
			return cz;
		}
		throw new SOAPCommonTypes.BusinessException(201, 'Record not found: ClientZone - External ID: ' + clientZoneExternalId);
	}

	public static User getUserByCPU(String cpu) {
		if (!String.isEmpty(cpu)) {
			for (User user : [SELECT Id FROM User WHERE CommissionAccountNr__c = :cpu LIMIT 1]) {
				return user;
			}
		}
		throw new SOAPCommonTypes.BusinessException(201, 'Record not found: User - CPU: ' + cpu);
	}

	public static Map<String, Id> getAccountIdsByGlobalIds(List<SF_PersonManagementSOAPService.ClientRelationType> clientRelations) {
		Set<String> globalIds = new Set<String>();
		for (SF_PersonManagementSOAPService.ClientRelationType relation : clientRelations) {
			globalIds.add(relation.relatedClientId);
		}
		Map<String, Id> accountIdsByGlobalIds = new Map<String, Id>();
		for (Account client : [SELECT Id, GlobalId__c FROM Account WHERE GlobalId__c IN :globalIds]) {
			accountIdsByGlobalIds.put(client.GlobalId__c, client.Id);
		}
		for (SF_PersonManagementSOAPService.ClientRelationType relation : clientRelations) {
			if (relation.relatedClientId != null && !accountIdsByGlobalIds.containsKey(relation.relatedClientId)) {
				throw new SOAPCommonTypes.BusinessException(201, 'Record not found: Client - Global ID: ' + relation.relatedClientId);
			}
		}
		return accountIdsByGlobalIds;
	}

	public static Opportunity getOpportunityByExternalId(String externalId) {
		for (Opportunity opportunity : [SELECT Id FROM Opportunity WHERE ExternalId__c = :externalId LIMIT 1]) {
			return opportunity;
		}
		throw new SOAPCommonTypes.BusinessException(201, 'Record not found: Opportunity - External Id: ' + externalId);
	}
}