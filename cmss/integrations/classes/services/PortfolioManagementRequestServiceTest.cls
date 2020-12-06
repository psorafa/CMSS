@IsTest
private class PortfolioManagementRequestServiceTest {

	@IsTest
	static void testSetPortfolioManager() {
		User u = TestDataFactory.getUser(new User(CommissionAccountNr__c = 'CPU0'));
		User u2 = TestDataFactory.getUser(new User(CommissionAccountNr__c = 'CPU1'));
		insert new User[]{
			u, u2
		};

		Test.setMock(WebServiceMock.class, new PortfolioManagementServiceMock());
		PortfolioManagementRequest__c pmr = TestDataFactory.getPortfolioManagementRequest(new PortfolioManagementRequest__c(
			PortfolioManagerCPU__c = 'CPU0'
		));
		insert pmr;

		PortfolioManagementRequest__c queriedPMR = [SELECT PortfolioManager__c FROM PortfolioManagementRequest__c WHERE Id = :pmr.Id];
		System.assertEquals(u.Id, queriedPMR.PortfolioManager__c);

		pmr.PortfolioManagerCPU__c = u2.CommissionAccountNr__c;
		update pmr;

		queriedPMR = [SELECT PortfolioManager__c FROM PortfolioManagementRequest__c WHERE Id = :pmr.Id];
		System.assertEquals(u2.Id, queriedPMR.PortfolioManager__c);
	}

	@IsTest
	static void testSetPortfolioManagerNotFound() {
		Test.setMock(WebServiceMock.class, new PortfolioManagementServiceMock());
		PortfolioManagementRequest__c pmr = TestDataFactory.getPortfolioManagementRequest(
			new PortfolioManagementRequest__c(PortfolioManagerCPU__c = '43429643927'
		));

		try {
			insert pmr;
			System.assert(false, 'This assert should not be reached.');
		} catch (DmlException e) {
			System.assert(e.getMessage().contains(PortfolioManagementRequestService.NO_USER_WITH_SUCH_CPU_ERR));
		}
	}

	@IsTest
	static void testChangeCPEClientStateError() {
		User u = TestDataFactory.getUser(new User(CommissionAccountNr__c = 'CPU0'));
		insert new User[]{
			u
		};

		Test.setMock(WebServiceMock.class, new PortfolioManagementServiceMock());
		PortfolioManagementRequest__c pmr = TestDataFactory.getPortfolioManagementRequest(new PortfolioManagementRequest__c(
			BatchID__c = 'uweih567',
			PortfolioManagerCPU__c = 'CPU0'
		));
		PortfolioManagementRequest__c pmr2 = TestDataFactory.getPortfolioManagementRequest(new PortfolioManagementRequest__c(
			BatchID__c = '1kod983',
			PortfolioManagerCPU__c = 'CPU0'
		));

		try {
			insert new PortfolioManagementRequest__c[]{
				pmr, pmr2
			};
			System.assert(false, 'This assert should not be reached.');
		} catch (DmlException e) {
			System.assert(e.getMessage().contains(PortfolioManagementRequestService.MULTIPLE_BATCH_IDS_ERR), e.getMessage());
		}
	}

	@IsTest
	static void testChangeCPEClientStateFuture() {
		User u = TestDataFactory.getUser(new User(CommissionAccountNr__c = 'CPU0'));
		insert new User[]{
			u
		};

		Test.setMock(WebServiceMock.class, new PortfolioManagementServiceMock());
		PortfolioManagementRequest__c pmr = TestDataFactory.getPortfolioManagementRequest(new PortfolioManagementRequest__c(
			PortfolioManagerCPU__c = 'CPU0'
		));
		Test.startTest();
		insert pmr;
		Test.stopTest();

		Log__c[] logs = [SELECT Message__c, Payload__c FROM Log__c];
		System.assertEquals(1, logs.size());
		System.assertEquals('ChangeCPEClientState response', logs[0].Message__c);
		System.assertEquals('ok', ((Map<String, Object>) JSON.deserializeUntyped(logs[0].Payload__c)).get('emptyElement'));
	}
}
