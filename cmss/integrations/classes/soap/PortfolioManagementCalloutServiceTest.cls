@IsTest
private class PortfolioManagementCalloutServiceTest {

	@IsTest
	static void testSetPortfolioManager() {
		User u = TestDataFactory.getUser(new User(CommissionAccountNr__c = 'CPU0'));
		User u2 = TestDataFactory.getUser(new User(CommissionAccountNr__c = 'CPU1'));
		insert new User[]{
			u, u2
		};

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
            200,
            'OK',
            '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:ChangeCPEClientStateResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:emptyElement></ns3:emptyElement></ns3:responseBody></ns3:ChangeCPEClientStateResponse></soapenv:Body></soapenv:Envelope>',
            null,
            null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        Test.startTest();
		PortfolioManagementRequest__c pmr = TestDataFactory.getPortfolioManagementRequest(new PortfolioManagementRequest__c(
			PortfolioManagerCPU__c = 'CPU0'
		));
		insert pmr;

		PortfolioManagementRequest__c queriedPMR = [SELECT PortfolioManager__c FROM PortfolioManagementRequest__c WHERE Id = :pmr.Id];
		System.assertEquals(u.Id, queriedPMR.PortfolioManager__c);

		pmr.PortfolioManagerCPU__c = u2.CommissionAccountNr__c;
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
            '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:ChangeCPEClientStateResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:emptyElement></ns3:emptyElement></ns3:responseBody></ns3:ChangeCPEClientStateResponse></soapenv:Body></soapenv:Envelope>',
            null,
            null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
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
        Test.startTest();
        User u = TestDataFactory.getUser(new User(CommissionAccountNr__c = 'CPU0'));
		insert new User[]{ u };
        Test.stopTest();

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
            200,
            'OK',
            '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:ChangeCPEClientStateResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:emptyElement></ns3:emptyElement></ns3:responseBody></ns3:ChangeCPEClientStateResponse></soapenv:Body></soapenv:Envelope>',
            null,
            null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
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

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
            200,
            'OK',
            '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:ChangeCPEClientStateResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:emptyElement>ok</ns3:emptyElement></ns3:responseBody></ns3:ChangeCPEClientStateResponse></soapenv:Body></soapenv:Envelope>',
            null,
            null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
		PortfolioManagementRequest__c pmr = TestDataFactory.getPortfolioManagementRequest(new PortfolioManagementRequest__c(
			PortfolioManagerCPU__c = 'CPU0'
		));
		Test.startTest();
		insert pmr;
		Test.stopTest();

		Log__c[] logs = [SELECT Payload__c FROM Log__c WHERE Message__c = 'changeCPEClientState response'];
		System.assertEquals(1, logs.size());
		System.assert(logs[0].Payload__c.contains('<ns3:emptyElement>ok</ns3:emptyElement>'));
	}
}
