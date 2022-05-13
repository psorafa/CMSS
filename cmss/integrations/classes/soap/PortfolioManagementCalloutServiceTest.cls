@IsTest
private class PortfolioManagementCalloutServiceTest {
	@TestSetup
	static void insertCustomSettings() {
		insert TestDataFactory.getIntegrationSettings();
	}

	@IsTest
	static void testSetPortfolioManager() {
		User u = TestDataFactory.getUser(new User(CommissionAccountBase__c = 'CPU0'));
		User u2 = TestDataFactory.getUser(new User(CommissionAccountBase__c = 'CPU1'));
		insert new List<User>{ u, u2 };

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns3:ChangeCPEClientStateResponse xmlns:ns3=\"http://service.cmss.cz/person/PortfolioManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\"><ns3:responseBody><ns3:listOfRequestStatuses><ns3:listOfRequestStatusesItem><ns3:stateChangeRequestId>a0k1x00000AwCl9AAF</ns3:stateChangeRequestId><ns3:requestStatus>2</ns3:requestStatus></ns3:listOfRequestStatusesItem><ns3:listOfRequestStatusesItem><ns3:stateChangeRequestId>a0k1x00000AwCl9AAF</ns3:stateChangeRequestId><ns3:requestStatus>3</ns3:requestStatus></ns3:listOfRequestStatusesItem></ns3:listOfRequestStatuses></ns3:responseBody></ns3:ChangeCPEClientStateResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();
		PortfolioManagementRequest__c pmr = TestDataFactory.getPortfolioManagementRequest(
			new PortfolioManagementRequest__c(PortfolioManagerCPU__c = 'CPU0')
		);
		insert pmr;

		PortfolioManagementRequest__c queriedPMR = [
			SELECT PortfolioManager__c
			FROM PortfolioManagementRequest__c
			WHERE Id = :pmr.Id
		];
		System.assertEquals(u.Id, queriedPMR.PortfolioManager__c);

		pmr.PortfolioManagerCPU__c = u2.CommissionAccountBase__c;
		update pmr;
		Test.stopTest();

		queriedPMR = [SELECT PortfolioManager__c FROM PortfolioManagementRequest__c WHERE Id = :pmr.Id];
		System.assertEquals(u2.Id, queriedPMR.PortfolioManager__c);
	}

	@IsTest
	static void testSetPortfolioManagerNotFound() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns3:ChangeCPEClientStateResponse xmlns:ns3=\"http://service.cmss.cz/person/PortfolioManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\"><ns3:responseBody><ns3:listOfRequestStatuses><ns3:listOfRequestStatusesItem><ns3:stateChangeRequestId>a0k1x00000AwCl9AAF</ns3:stateChangeRequestId><ns3:requestStatus>2</ns3:requestStatus></ns3:listOfRequestStatusesItem><ns3:listOfRequestStatusesItem><ns3:stateChangeRequestId>a0k1x00000AwCl9AAF</ns3:stateChangeRequestId><ns3:requestStatus>3</ns3:requestStatus></ns3:listOfRequestStatusesItem></ns3:listOfRequestStatuses></ns3:responseBody></ns3:ChangeCPEClientStateResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		PortfolioManagementRequest__c pmr = TestDataFactory.getPortfolioManagementRequest(
			new PortfolioManagementRequest__c(
				PortfolioManagerCPU__c = '43429643927',
				ValidFrom__c = System.now().addDays(1)
			)
		);

		try {
			insert pmr;
			System.assert(false, 'This assert should not be reached.');
		} catch (DmlException e) {
			System.assert(e.getMessage().contains(Label.NoUserWithThisCPUFound));
		}
	}

	@IsTest
	static void testChangeCPEClientStateError() {
		Test.startTest();
		User u = TestDataFactory.getUser(new User(CommissionAccountBase__c = 'CPU0'));
		insert new List<User>{ u };
		Test.stopTest();

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns3:ChangeCPEClientStateResponse xmlns:ns3=\"http://service.cmss.cz/person/PortfolioManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\"><ns3:responseBody><ns3:listOfRequestStatuses><ns3:listOfRequestStatusesItem><ns3:stateChangeRequestId>a0k1x00000AwCl9AAF</ns3:stateChangeRequestId><ns3:requestStatus>2</ns3:requestStatus></ns3:listOfRequestStatusesItem><ns3:listOfRequestStatusesItem><ns3:stateChangeRequestId>a0k1x00000AwCl9AAF</ns3:stateChangeRequestId><ns3:requestStatus>3</ns3:requestStatus></ns3:listOfRequestStatusesItem></ns3:listOfRequestStatuses></ns3:responseBody></ns3:ChangeCPEClientStateResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		PortfolioManagementRequest__c pmr = TestDataFactory.getPortfolioManagementRequest(
			new PortfolioManagementRequest__c(BatchID__c = 'uweih567', PortfolioManagerCPU__c = 'CPU0')
		);
		PortfolioManagementRequest__c pmr2 = TestDataFactory.getPortfolioManagementRequest(
			new PortfolioManagementRequest__c(BatchID__c = '1kod983', PortfolioManagerCPU__c = 'CPU0')
		);

		try {
			insert new List<PortfolioManagementRequest__c>{ pmr, pmr2 };
			System.assert(false, 'This assert should not be reached.');
		} catch (DmlException e) {
			System.assert(
				e.getMessage().contains(PortfolioManagementRequestService.MULTIPLE_BATCH_IDS_ERR),
				e.getMessage()
			);
		}
	}

	@IsTest
	static void testChangeCPEClientStateFuture() {
		User u = TestDataFactory.getUser(new User(CommissionAccountBase__c = 'CPU0'));
		insert new List<User>{ u };

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns3:ChangeCPEClientStateResponse xmlns:ns3=\"http://service.cmss.cz/person/PortfolioManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\"><ns3:responseBody><ns3:listOfRequestStatuses><ns3:listOfRequestStatusesItem><ns3:stateChangeRequestId>a0k1x00000AwCl9AAF</ns3:stateChangeRequestId><ns3:requestStatus>2</ns3:requestStatus></ns3:listOfRequestStatusesItem><ns3:listOfRequestStatusesItem><ns3:stateChangeRequestId>a0k1x00000AwCl9AAF</ns3:stateChangeRequestId><ns3:requestStatus>3</ns3:requestStatus></ns3:listOfRequestStatusesItem></ns3:listOfRequestStatuses></ns3:responseBody></ns3:ChangeCPEClientStateResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		PortfolioManagementRequest__c pmr = TestDataFactory.getPortfolioManagementRequest(
			new PortfolioManagementRequest__c(PortfolioManagerCPU__c = 'CPU0')
		);
		Test.startTest();
		insert pmr;
		Test.stopTest();

		Log__c[] logs = [SELECT Payload__c FROM Log__c WHERE Message__c = 'Incoming response'];
		System.assertEquals(1, logs.size());
		System.assert(
			logs[0]
				.Payload__c.contains(
					'<ns3:listOfRequestStatuses><ns3:listOfRequestStatusesItem><ns3:stateChangeRequestId>a0k1x00000AwCl9AAF</ns3:stateChangeRequestId><ns3:requestStatus>2</ns3:requestStatus></ns3:listOfRequestStatusesItem><ns3:listOfRequestStatusesItem><ns3:stateChangeRequestId>a0k1x00000AwCl9AAF</ns3:stateChangeRequestId><ns3:requestStatus>3</ns3:requestStatus></ns3:listOfRequestStatusesItem></ns3:listOfRequestStatuses>'
				)
		);
	}
}
