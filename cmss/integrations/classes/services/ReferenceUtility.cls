public with sharing class ReferenceUtility {

	public static Account getAccountByGlobalId(String globalId) {
		for (Account a : [SELECT Id FROM Account WHERE GlobalId__c = :globalId LIMIT 1]) {
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

	public static ClientZone__c getClientZoneById(Id clientZoneId) {
		for (ClientZone__c cz : [SELECT Id FROM ClientZone__c WHERE Id = :clientZoneId LIMIT 1]) {
			return cz;
		}
		throw new SOAPCommonTypes.BusinessException(201, 'Record not found: ClientZone - Id: ' + clientZoneId);
	}
}