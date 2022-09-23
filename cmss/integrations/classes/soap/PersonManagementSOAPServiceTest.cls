@IsTest
private class PersonManagementSOAPServiceTest {
	@TestSetup
	static void insertCustomSettings() {
		insert TestDataFactory.getIntegrationSettings();
	}

	@IsTest
	static void coupleDocumentTest() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns4:CoupleDocumentResponse xmlns:ns4=\"http://service.cmss.cz/person/PersonManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:ns3=\"http://service.cmss.cz/person/SB-ClientInfoService/v10\"><ns2:responseHeader></ns2:responseHeader><ns4:responseBody>' +
				'</ns4:responseBody></ns4:CoupleDocumentResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();

		CommonMessageService.RequestHeader requestHeader = new CommonMessageService.RequestHeader();
		PersonManagementSOAPServiceTypes.CoupleDocumentRequestBody requestBody = new PersonManagementSOAPServiceTypes.CoupleDocumentRequestBody();

		PersonManagementSOAPService.PersonManagementServicePort port = new PersonManagementSOAPService.PersonManagementServicePort();
		PersonManagementSOAPServiceTypes.CoupleDocumentResponseBody coupleDocumentResponse = port.coupleDocument_Http(
			requestHeader,
			requestBody
		);

		Test.stopTest();
	}

	@IsTest
	static void createClientTest() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns4:CreateClientResponse xmlns:ns4=\"http://service.cmss.cz/person/PersonManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:ns3=\"http://service.cmss.cz/person/SB-ClientInfoService/v10\"><ns2:responseHeader></ns2:responseHeader><ns4:responseBody>' +
				'</ns4:responseBody></ns4:CreateClientResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();

		CommonMessageService.RequestHeader requestHeader = new CommonMessageService.RequestHeader();
		PersonManagementSOAPServiceTypes.CreateClientRequestBody requestBody = new PersonManagementSOAPServiceTypes.CreateClientRequestBody();

		PersonManagementSOAPService.PersonManagementServicePort port = new PersonManagementSOAPService.PersonManagementServicePort();
		PersonManagementSOAPServiceTypes.CreateClientResponseBody createClientResponse = port.createClient_Http(
			requestHeader,
			requestBody
		);

		Test.stopTest();
	}

	@IsTest
	static void createPersonRelationTest() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns4:CreatePersonRelationResponse xmlns:ns4=\"http://service.cmss.cz/person/PersonManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:ns3=\"http://service.cmss.cz/person/SB-ClientInfoService/v10\"><ns2:responseHeader></ns2:responseHeader><ns4:responseBody>' +
				'</ns4:responseBody></ns4:CreatePersonRelationResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();

		CommonMessageService.RequestHeader requestHeader = new CommonMessageService.RequestHeader();
		PersonManagementSOAPServiceTypes.CreatePersonRelationRequestBody requestBody = new PersonManagementSOAPServiceTypes.CreatePersonRelationRequestBody();

		PersonManagementSOAPService.PersonManagementServicePort port = new PersonManagementSOAPService.PersonManagementServicePort();
		PersonManagementSOAPServiceTypes.CreatePersonRelationResponseBody createPersonRelationResponse = port.createPersonRelation_Http(
			requestHeader,
			requestBody
		);

		Test.stopTest();
	}

	@IsTest
	static void getReservedGlobalIdTest() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns4:GetReservedGlobalIdResponse xmlns:ns4=\"http://service.cmss.cz/person/PersonManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:ns3=\"http://service.cmss.cz/person/SB-ClientInfoService/v10\"><ns2:responseHeader></ns2:responseHeader><ns4:responseBody>' +
				'</ns4:responseBody></ns4:GetReservedGlobalIdResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();

		CommonMessageService.RequestHeader requestHeader = new CommonMessageService.RequestHeader();
		PersonManagementSOAPServiceTypes.GetReservedGlobalIdRequestBody requestBody = new PersonManagementSOAPServiceTypes.GetReservedGlobalIdRequestBody();

		PersonManagementSOAPService.PersonManagementServicePort port = new PersonManagementSOAPService.PersonManagementServicePort();
		PersonManagementSOAPServiceTypes.GetReservedGlobalIdResponseBody getReservedGlobelIdResponse = port.getReservedGlobalId_Http(
			requestHeader,
			requestBody
		);

		Test.stopTest();
	}

	@IsTest
	static void searchCSOBNonClientTest() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns4:SearchCSOBSNonClientResponse xmlns:ns4=\"http://service.cmss.cz/person/PersonManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:ns3=\"http://service.cmss.cz/person/SB-ClientInfoService/v10\"><ns2:responseHeader></ns2:responseHeader><ns4:responseBody>' +
				'</ns4:responseBody></ns4:SearchCSOBSNonClientResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();

		CommonMessageService.RequestHeader requestHeader = new CommonMessageService.RequestHeader();
		PersonManagementSOAPServiceTypes.SearchCSOBSNonClientRequestBody requestBody = new PersonManagementSOAPServiceTypes.SearchCSOBSNonClientRequestBody();

		PersonManagementSOAPService.PersonManagementServicePort port = new PersonManagementSOAPService.PersonManagementServicePort();
		PersonManagementSOAPServiceTypes.SearchCSOBSNonClientResponseBody searchCSOBNonClientResponse = port.searchCSOBSNonClient_Http(
			requestHeader,
			requestBody
		);

		Test.stopTest();
	}

	@IsTest
	static void searchPersonByIdNumberTest() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns4:SearchPersonByIdNumberResponse xmlns:ns4=\"http://service.cmss.cz/person/PersonManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:ns3=\"http://service.cmss.cz/person/SB-ClientInfoService/v10\"><ns2:responseHeader></ns2:responseHeader><ns4:responseBody>' +
				'</ns4:responseBody></ns4:SearchPersonByIdNumberResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();

		CommonMessageService.RequestHeader requestHeader = new CommonMessageService.RequestHeader();
		PersonManagementSOAPServiceTypes.SearchPersonByIdNumberRequestBody requestBody = new PersonManagementSOAPServiceTypes.SearchPersonByIdNumberRequestBody();

		PersonManagementSOAPService.PersonManagementServicePort port = new PersonManagementSOAPService.PersonManagementServicePort();
		PersonManagementSOAPServiceTypes.SearchPersonByIdNumberResponseBody searchPersonByIdNumberResponse = port.searchPersonByIdNumber_Http(
			requestHeader,
			requestBody
		);

		Test.stopTest();
	}

	@IsTest
	static void updateClientTest() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns4:UpdateClientResponse xmlns:ns4=\"http://service.cmss.cz/person/PersonManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:ns3=\"http://service.cmss.cz/person/SB-ClientInfoService/v10\"><ns2:responseHeader></ns2:responseHeader><ns4:responseBody>' +
				'</ns4:responseBody></ns4:UpdateClientResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();

		CommonMessageService.RequestHeader requestHeader = new CommonMessageService.RequestHeader();
		PersonManagementSOAPServiceTypes.UpdateClientRequestBody requestBody = new PersonManagementSOAPServiceTypes.UpdateClientRequestBody();

		PersonManagementSOAPService.PersonManagementServicePort port = new PersonManagementSOAPService.PersonManagementServicePort();
		PersonManagementSOAPServiceTypes.UpdateClientResponseBody updateClientResponse = port.updateClient_Http(
			requestHeader,
			requestBody
		);

		Test.stopTest();
	}

	@IsTest
	static void updateCommunicationsTest() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns4:UpdateCommunicationsResponse xmlns:ns4=\"http://service.cmss.cz/person/PersonManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:ns3=\"http://service.cmss.cz/person/SB-ClientInfoService/v10\"><ns2:responseHeader></ns2:responseHeader><ns4:responseBody>' +
				'</ns4:responseBody></ns4:UpdateCommunicationsResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();

		CommonMessageService.RequestHeader requestHeader = new CommonMessageService.RequestHeader();
		PersonManagementSOAPServiceTypes.UpdateCommunicationsRequestBody requestBody = new PersonManagementSOAPServiceTypes.UpdateCommunicationsRequestBody();

		PersonManagementSOAPService.PersonManagementServicePort port = new PersonManagementSOAPService.PersonManagementServicePort();
		PersonManagementSOAPServiceTypes.UpdateCommunicationsResponseBody updateCommunicationsResponse = port.updateCommunications_Http(
			requestHeader,
			requestBody
		);

		Test.stopTest();
	}

	@IsTest
	static void updateCSOBNonClientTest() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns4:UpdateCSOBNonClientResponse xmlns:ns4=\"http://service.cmss.cz/person/PersonManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:ns3=\"http://service.cmss.cz/person/SB-ClientInfoService/v10\"><ns2:responseHeader></ns2:responseHeader><ns4:responseBody>' +
				'</ns4:responseBody></ns4:UpdateCSOBNonClientResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();

		CommonMessageService.RequestHeader requestHeader = new CommonMessageService.RequestHeader();
		PersonManagementSOAPServiceTypes.UpdateCSOBNonClientRequestBody requestBody = new PersonManagementSOAPServiceTypes.UpdateCSOBNonClientRequestBody();

		PersonManagementSOAPService.PersonManagementServicePort port = new PersonManagementSOAPService.PersonManagementServicePort();
		PersonManagementSOAPServiceTypes.UpdateCSOBNonClientResponseBody updateCSOBNonClientResponse = port.updateCSOBNonClient_Http(
			requestHeader,
			requestBody
		);

		Test.stopTest();
	}

	@IsTest
	static void validateClientTest() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns4:ValidateClientResponse xmlns:ns4=\"http://service.cmss.cz/person/PersonManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:ns3=\"http://service.cmss.cz/person/SB-ClientInfoService/v10\"><ns2:responseHeader></ns2:responseHeader><ns4:responseBody>' +
				'</ns4:responseBody></ns4:ValidateClientResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();

		CommonMessageService.RequestHeader requestHeader = new CommonMessageService.RequestHeader();
		PersonManagementSOAPServiceTypes.ValidateClientRequestBody requestBody = new PersonManagementSOAPServiceTypes.ValidateClientRequestBody();

		PersonManagementSOAPService.PersonManagementServicePort port = new PersonManagementSOAPService.PersonManagementServicePort();
		PersonManagementSOAPServiceTypes.ValidateClientResponseBody validateClientResponse = port.validateClient_Http(
			requestHeader,
			requestBody
		);

		Test.stopTest();
	}
}
