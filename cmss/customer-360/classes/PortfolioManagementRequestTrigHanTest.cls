@IsTest
private class PortfolioManagementRequestTrigHanTest {
	@TestSetup
	static void insertCustomSettings() {
		insert TestDataFactory.getNumericalSettings();
	}

	@isTest
	static void testBeforeUpdate() {
		PortfolioManagementRequest__c request = TestDataFactory.getPortfolioManagementRequest(
			new PortfolioManagementRequest__c()
		);
		insert request;
		request.ValidFrom__c = Date.today() + 1;
		Test.startTest();
		update request;
		Test.stopTest();

		request = [SELECT PortfolioManagerCPU__c FROM PortfolioManagementRequest__c WHERE Id = :request.Id];
		System.assertNotEquals(null, request.PortfolioManagerCPU__c);
	}

	@isTest
	static void testAfterInsert() {
		PortfolioManagementRequest__c requestWithoutExternalId = TestDataFactory.getPortfolioManagementRequest(
			new PortfolioManagementRequest__c()
		);
		PortfolioManagementRequest__c requestWithExternalId = TestDataFactory.getPortfolioManagementRequest(
			new PortfolioManagementRequest__c(ExternalId__c = '123456789')
		);

		Test.startTest();
		insert new List<PortfolioManagementRequest__c>{ requestWithoutExternalId, requestWithExternalId };
		Test.stopTest();

		requestWithExternalId = [
			SELECT Id, ExternalId__c
			FROM PortfolioManagementRequest__c
			WHERE Id = :requestWithExternalId.Id
		];
		requestWithoutExternalId = [
			SELECT Id, ExternalId__c
			FROM PortfolioManagementRequest__c
			WHERE Id = :requestWithoutExternalId.Id
		];

		System.assertEquals(requestWithoutExternalId.Id, requestWithoutExternalId.ExternalId__c);
		System.assertNotEquals(requestWithExternalId.Id, requestWithExternalId.ExternalId__c);
	}
}
