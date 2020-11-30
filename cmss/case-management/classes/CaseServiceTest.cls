@IsTest
private class CaseServiceTest {
	@IsTest
	static void assignCaseIDTest() {
		Case newClientCase = TestDataFactory.getCase(
			new Case(
				RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByDeveloperName()
					.get('NewClientClaim')
					.getRecordTypeId()
			)
		);
		Case newGDPRCase = TestDataFactory.getCase(
			new Case(
				RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDPR').getRecordTypeId()
			)
		);
		NumericalSeriesSettings__c customSettingsValue = new NumericalSeriesSettings__c();
		customSettingsValue.ClientClaimID__c = 2.0;
		customSettingsValue.GDPRClaimID__c = 5.0;
		insert customSettingsValue;

		Test.startTest();
		insert new List<Case>{ newClientCase, newGDPRCase };
		Test.stopTest();

		NumericalSeriesSettings__c newIssuedClaimID = [
			SELECT ClientClaimID__c, GDPRClaimID__c
			FROM NumericalSeriesSettings__c
			LIMIT 1
		];

		newClientCase = [SELECT CaseID__c FROM Case WHERE Id = :newClientCase.Id LIMIT 1];
		newGDPRCase = [SELECT CaseID__c FROM Case WHERE Id = :newGDPRCase.Id LIMIT 1];

		System.assertEquals(3, newIssuedClaimID.ClientClaimID__c);
		System.assertEquals(6, newIssuedClaimID.GDPRClaimID__c);
		System.assertEquals('' + Date.today().year() + '3', newClientCase.CaseID__c);
		System.assertEquals('6' + '' + Date.today().year(), newGDPRCase.CaseID__c);
	}
}
