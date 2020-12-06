@IsTest
private class PortfolioManagementRequestTrigHanTest {

	@IsTest
	static void testSetBatchId_single() {
		Test.setMock(WebServiceMock.class, new PortfolioManagementServiceMock());
		PortfolioManagementRequest__c request1 = TestDataFactory.getPortfolioManagementRequest(new PortfolioManagementRequest__c(
			BatchID__c = null
		));
		PortfolioManagementRequest__c request2 = TestDataFactory.getPortfolioManagementRequest(new PortfolioManagementRequest__c(
			BatchID__c = null
		));
		Test.startTest();
		insert request1;
		insert request2;
		Test.stopTest();
		request1 = [SELECT BatchID__c FROM PortfolioManagementRequest__c WHERE Id = :request1.Id];
		request2 = [SELECT BatchID__c FROM PortfolioManagementRequest__c WHERE Id = :request2.Id];

		System.assertNotEquals(null, request1.BatchID__c);
		System.assertNotEquals(null, request2.BatchID__c);
		System.assertNotEquals(request1.BatchID__c, request2.BatchID__c);
	}

	@IsTest
	private static void testSetBatchId_multiple() {
		Test.setMock(WebServiceMock.class, new PortfolioManagementServiceMock());
		PortfolioManagementRequest__c r1 = TestDataFactory.getPortfolioManagementRequest(new PortfolioManagementRequest__c(
			BatchID__c = 'test'
		));
		PortfolioManagementRequest__c r2 = TestDataFactory.getPortfolioManagementRequest(new PortfolioManagementRequest__c(
			BatchID__c = 'test'
		));
		PortfolioManagementRequest__c r3 = TestDataFactory.getPortfolioManagementRequest(new PortfolioManagementRequest__c(
			BatchID__c = 'test'
		));
		Test.startTest();
		insert new List<PortfolioManagementRequest__c> {
			r1, r2, r3
		};
		Test.stopTest();
		List<PortfolioManagementRequest__c> requests = [SELECT BatchID__c FROM PortfolioManagementRequest__c];
		System.assertNotEquals(null, requests.get(0).BatchID__c);
		System.assertEquals(requests.get(0).BatchID__c, requests.get(1).BatchID__c);
		System.assertEquals(requests.get(1).BatchID__c, requests.get(2).BatchID__c);
	}

	@IsTest
	private static void testSetBatchId_multipleNullBatchId() {
		Test.setMock(WebServiceMock.class, new PortfolioManagementServiceMock());
		PortfolioManagementRequest__c r1 = TestDataFactory.getPortfolioManagementRequest(new PortfolioManagementRequest__c(
			BatchID__c = null
		));
		PortfolioManagementRequest__c r2 = TestDataFactory.getPortfolioManagementRequest(new PortfolioManagementRequest__c(
			BatchID__c = null
		));
		PortfolioManagementRequest__c r3 = TestDataFactory.getPortfolioManagementRequest(new PortfolioManagementRequest__c(
			BatchID__c = null
		));
		Test.startTest();
		try {
			insert new List<PortfolioManagementRequest__c>{
				r1, r2, r3
			};
		} catch (DmlException e) {
			System.assert(e.getMessage().contains('BatchID__c is required in bulk insert'), e.getMessage());
		}
		Test.stopTest();
	}

}