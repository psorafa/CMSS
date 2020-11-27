public with sharing class CaseService {
	public static void assignCaseID(List<Case> newCaseList) {
		Set<Id> ClientClaimRecordTypes = new Set<Id>{
			SObjectType.Case.getRecordTypeInfosByDeveloperName().get('NewClientClaim').getRecordTypeId(),
			SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ClientClaimConfirmationSent').getRecordTypeId(),
			SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ClosedClientClaim').getRecordTypeId()
		};
		Set<Id> GDPRRecordTypes = new Set<Id>{
			SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDPR').getRecordTypeId(),
			SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ClosedGDPRClaim').getRecordTypeId()
		};

		NumericalSeriesSettings__c lastIssuedCaseID = NumericalSeriesSettings__c.getOrgDefaults();

		if (lastIssuedCaseID.GDPRClaimID__c == null) {
			lastIssuedCaseID.GDPRClaimID__c = 0;
		} else if (lastIssuedCaseID.ClientClaimID__c == null) {
			lastIssuedCaseID.ClientClaimID__c = 0;
		}
		for (Case caseItem : newCaseList) {
			if (GDPRRecordTypes.contains(caseItem.RecordTypeId)) {
				lastIssuedCaseID.GDPRClaimID__c += 1;
				caseItem.CaseID__c = '' + Integer.valueOf(lastIssuedCaseID.GDPRClaimID__c) + Date.today().year();
			} else if (ClientClaimRecordTypes.contains(caseItem.RecordTypeId)) {
				lastIssuedCaseID.ClientClaimID__c += 1;
				caseItem.CaseID__c = '' + Date.today().year() + Integer.valueOf(lastIssuedCaseID.ClientClaimID__c);
			}
		}
		upsert lastIssuedCaseID;
	}
}
