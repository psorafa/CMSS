@IsTest
private class EDocumentSOAPServiceTest {
	@TestSetup
	static void insertCustomSettings() {
		insert TestDataFactory.getIntegrationSettings();
	}

	@IsTest
	static void testGetEDocument() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			null,
			new Map<String, String>{
				'GetDocumentBySBIdRequest' => '<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns3:GetDocumentBySBIdResponse xmlns:ns3=\"http://service.cmss.cz/edocument/EDocumentService/v05\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\"><ns3:responseBody><ns3:eDocumentData>JVBERi0xLjQNJeLjz9MNCjEgMCBvYmoNPDwvTWFya0luZm88PC9NYXJrZWQgdHJ1ZT4+L01ldGFkYXRhIDE4IDAgUi9PdXRwdXRJbnRlbnRzWzw8L0Rlc3RPdXRwdXRQcm9maWxlIDIxIDAgUi9PdXRwdXRDb25kaX</ns3:eDocumentData></ns3:responseBody></ns3:GetDocumentBySBIdResponse></soapenv:Body></soapenv:Envelope>'
			},
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		String response;
		Test.startTest();
		try {
			CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
			EDocumentSOAPService.GetDocumentBySBIdRequestBody body = new EDocumentSOAPService.GetDocumentBySBIdRequestBody();
			body.documentSBId = '123131321321';
			EDocumentSOAPService stub = new EDocumentSOAPService();
			response = stub.getDocumentBySBId_Http(header, body);
		} catch (Exception e) {
		} finally {
			Logger.saveLogs();
		}
		Test.stopTest();

		System.assert(response.startsWith('JVBERi0xLjQN'));

		List<Log__c> logs = [SELECT Id, ClassMethodName__c FROM Log__c WHERE Message__c = 'Outgoing request'];
		System.assert(logs.size() > 0);
	}

	@IsTest
	static void testGetEDocumentWrongId() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			null,
			new Map<String, String>{
				'GetDocumentBySBIdRequest' => '<soapenv:Envelope xmlns:soapenv=http://schemas.xmlsoap.org/soap/envelope/> <soapenv:Body> <soapenv:Fault> <faultcode>soapenv:Server</faultcode> <faultstring>EDocument with pressId:4171a459-9655-415c-afb6-0351a78e9c1 not found!</faultstring> <detail> <ns2:CMSSServiceFaultInfo xmlns:ns2=http://service.cmss.cz/common/CommonMessage/v01 xmlns:ns3=http://service.cmss.cz/edocument/EDocumentService/v05> <ns2:errorDetail/> <ns2:faultHeader> <ns2:conversationIdName>adf</ns2:conversationIdName> <ns2:conversationIdValue>afd</ns2:conversationIdValue> <ns2:correlationId>adf</ns2:correlationId> <ns2:messageId>adfafs</ns2:messageId> <ns2:physicalSource>adfa</ns2:physicalSource> <ns2:sourceSystem>afdafd</ns2:sourceSystem> <ns2:targetSystem>asdf</ns2:targetSystem> <ns2:timestamp>2021-09-22T08:50:43.969+02:00</ns2:timestamp> <ns2:userId>asdf</ns2:userId> </ns2:faultHeader> <ns2:message>EDocument not found!</ns2:message> <ns2:system>eRMS</ns2:system> </ns2:CMSSServiceFaultInfo> </detail> </soapenv:Fault> </soapenv:Body> </soapenv:Envelope>'
			},
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		String response;
		Exception ex;
		Test.startTest();
		try {
			CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
			EDocumentSOAPService.GetDocumentBySBIdRequestBody body = new EDocumentSOAPService.GetDocumentBySBIdRequestBody();
			body.documentSBId = '123131321321';
			EDocumentSOAPService stub = new EDocumentSOAPService();
			response = stub.getDocumentBySBId_Http(header, body);
		} catch (Exception e) {
			System.assertEquals('EDocument not found!', e.getMessage());
			ex = e;
		} finally {
			Logger.saveLogs();
		}
		Test.stopTest();

		System.assert(response == null);

		List<Log__c> logs = [SELECT Id, ClassMethodName__c FROM Log__c WHERE Message__c = 'Incoming response error'];
		System.assert(logs.size() > 0);
		System.assertEquals('EDocumentSOAPService.getDocumentBySBId_Http', logs[0].ClassMethodName__c);
	}

	@IsTest
	static void testGetEDocumentUknownError() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			null,
			new Map<String, String>{
				'GetDocumentBySBIdRequest' => '<soapenv:Envelope xmlns:soapenv=http://schemas.xmlsoap.org/soap/envelope/> <soapenv:Body>Unknown Error</soapenv:Body> </soapenv:Envelope>'
			},
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		String response;
		Exception ex;
		Test.startTest();
		try {
			CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
			EDocumentSOAPService.GetDocumentBySBIdRequestBody body = new EDocumentSOAPService.GetDocumentBySBIdRequestBody();
			body.documentSBId = '123131321321';
			EDocumentSOAPService stub = new EDocumentSOAPService();
			response = stub.getDocumentBySBId_Http(header, body);
		} catch (Exception e) {
			System.assertEquals('Unkown error', e.getMessage());
			ex = e;
		} finally {
			Logger.saveLogs();
		}
		Test.stopTest();

		System.assert(response == null);

		List<Log__c> logs = [SELECT Id, ClassMethodName__c FROM Log__c WHERE Message__c = 'Unexpected response'];
		System.assert(logs.size() > 0);
		System.assertEquals('EDocumentSOAPService.getDocumentBySBId_Http', logs[0].ClassMethodName__c);
	}
}
