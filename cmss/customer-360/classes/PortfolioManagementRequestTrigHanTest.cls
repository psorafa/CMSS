@IsTest
private class PortfolioManagementRequestTrigHanTest {
	@TestSetup
	static void insertCustomSettings() {
		insert TestDataFactory.getIntegrationSettings();
		insert TestDataFactory.getNumericalSettings();
	}

	@isTest
	static void testSetDefaultRequestStatus() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:ChangeCPEClientStateResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:emptyElement></ns3:emptyElement></ns3:responseBody></ns3:ChangeCPEClientStateResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		PortfolioManagementRequest__c request1 = TestDataFactory.getPortfolioManagementRequest(
			new PortfolioManagementRequest__c()
		);
		Test.startTest();
		insert request1;
		Test.stopTest();
		request1 = [SELECT RequestStatus__c FROM PortfolioManagementRequest__c WHERE Id = :request1.Id];

		System.assertNotEquals(null, request1.RequestStatus__c);
		System.assertEquals('4', request1.RequestStatus__c);
	}
}
