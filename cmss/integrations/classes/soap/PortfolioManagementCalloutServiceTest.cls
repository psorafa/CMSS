@IsTest
private class PortfolioManagementCalloutServiceTest {
	@TestSetup
	static void insertCustomSettings() {
		insert TestDataFactory.getIntegrationSettings();
	}

	@IsTest
	static void testSetPortfolioManager() {
		User u = TestDataFactory.getUser(new User(CommissionAccountBase__c = 'CPU0', IsAgentActive__c = true));
		User u2 = TestDataFactory.getUser(new User(CommissionAccountBase__c = 'CPU1', IsAgentActive__c = true));
		insert new List<User>{ u, u2 };

		String portfolioMngmntRequestId =
			PortfolioManagementRequest__c.SObjectType.getDescribe().getKeyPrefix() + '0'.repeat(12);

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns3:ChangeCPEClientStateResponse xmlns:ns3=\"http://service.cmss.cz/person/PortfolioManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\"><ns3:responseBody><ns3:listOfRequestStatuses><ns3:listOfRequestStatusesItem><ns3:stateChangeRequestId>' +
			portfolioMngmntRequestId +
			'</ns3:stateChangeRequestId><ns3:requestStatus>2</ns3:requestStatus></ns3:listOfRequestStatusesItem><ns3:listOfRequestStatusesItem><ns3:stateChangeRequestId>' +
			portfolioMngmntRequestId +
			'</ns3:stateChangeRequestId><ns3:requestStatus>3</ns3:requestStatus></ns3:listOfRequestStatusesItem></ns3:listOfRequestStatuses></ns3:responseBody></ns3:ChangeCPEClientStateResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();
		PortfolioManagementRequest__c pmr = TestDataFactory.getPortfolioManagementRequest(
			new PortfolioManagementRequest__c(PortfolioManagerCPU__c = 'CPU0')
		);
		insert pmr;
		pmr.PortfolioManagerCPU__c = u2.CommissionAccountBase__c;
		update pmr;
		Test.stopTest();

		PortfolioManagementRequest__c queriedPMR = [
			SELECT PortfolioManager__c
			FROM PortfolioManagementRequest__c
			WHERE Id = :pmr.Id
		];
		System.assertEquals(u2.Id, queriedPMR.PortfolioManager__c);
	}

	@IsTest
	static void testSetPortfolioManagerNotFound() {
		String portfolioMngmntRequestId =
			PortfolioManagementRequest__c.SObjectType.getDescribe().getKeyPrefix() + '0'.repeat(12);
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns3:ChangeCPEClientStateResponse xmlns:ns3=\"http://service.cmss.cz/person/PortfolioManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\"><ns3:responseBody><ns3:listOfRequestStatuses><ns3:listOfRequestStatusesItem><ns3:stateChangeRequestId>' +
			portfolioMngmntRequestId +
			'</ns3:stateChangeRequestId><ns3:requestStatus>2</ns3:requestStatus></ns3:listOfRequestStatusesItem><ns3:listOfRequestStatusesItem><ns3:stateChangeRequestId>' +
			portfolioMngmntRequestId +
			'</ns3:stateChangeRequestId><ns3:requestStatus>3</ns3:requestStatus></ns3:listOfRequestStatusesItem></ns3:listOfRequestStatuses></ns3:responseBody></ns3:ChangeCPEClientStateResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		PortfolioManagementRequest__c pmr = TestDataFactory.getPortfolioManagementRequest(
			new PortfolioManagementRequest__c(PortfolioManagerCPU__c = 'CPU0', ValidFrom__c = System.now().addDays(1))
		);
		insert pmr;
		pmr.PortfolioManagerCPU__c = '4342964328';
		try {
			update pmr;
			System.assert(false, 'This assert should not be reached.');
		} catch (DmlException e) {
			System.assert(e.getMessage().contains(Label.NoUserWithThisCPUFound));
		}
	}

	@IsTest
	static void testCallCPEClientStateFuture() {
		User u = TestDataFactory.getUser(new User(CommissionAccountBase__c = 'CPU0', IsAgentActive__c = true));
		insert new List<User>{ u };

		String portfolioMngmntRequestId =
			PortfolioManagementRequest__c.SObjectType.getDescribe().getKeyPrefix() + '0'.repeat(12);

		PortfolioManagementRequest__c pmr = TestDataFactory.getPortfolioManagementRequest(
			new PortfolioManagementRequest__c(PortfolioManagerCPU__c = 'CPU0')
		);
        insert pmr;

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns3:ChangeCPEClientStateResponse xmlns:ns3=\"http://service.cmss.cz/person/PortfolioManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\"><ns3:responseBody><ns3:listOfRequestStatuses><ns3:listOfRequestStatusesItem><ns3:stateChangeRequestId>' +
			pmr.Id +
			'</ns3:stateChangeRequestId><ns3:requestStatus>2</ns3:requestStatus></ns3:listOfRequestStatusesItem></ns3:listOfRequestStatuses></ns3:responseBody></ns3:ChangeCPEClientStateResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		Test.startTest();
            PortfolioManagementRequestService.callCPEClientStateFuture(new Set<Id>{pmr.Case__c});
		Test.stopTest();

		Log__c[] logs = [SELECT Payload__c FROM Log__c WHERE Message__c = 'Incoming response'];
		System.assertEquals(1, logs.size());
		System.assert(
			logs[0]
				.Payload__c.contains(
					'<ns3:listOfRequestStatuses><ns3:listOfRequestStatusesItem><ns3:stateChangeRequestId>' +
					pmr.Id +
					'</ns3:stateChangeRequestId><ns3:requestStatus>2</ns3:requestStatus></ns3:listOfRequestStatusesItem></ns3:listOfRequestStatuses>'
				)
		);
	}
}
