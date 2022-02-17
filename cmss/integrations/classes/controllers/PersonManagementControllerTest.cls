@IsTest
private class PersonManagementControllerTest {
	@TestSetup
	static void insertCustomSettings() {
		insert TestDataFactory.getIntegrationSettings();
	}

	@IsTest
	static void searchCSOBNonClientTest() {
		String lastName = 'Náglfóglburdenbaníková';
		String pid = '2553216087';

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns4:SearchCSOBSNonClientResponse xmlns:ns4=\"http://service.cmss.cz/person/PersonManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:ns3=\"http://service.cmss.cz/person/SB-ClientInfoService/v10\"><ns2:responseHeader></ns2:responseHeader><ns4:responseBody><ns4:jsonResponse>' +
			'{"getPersonCSOBDataResponse":{' +
			'"Account":{"Name":"Account 1","Birthdate__c":"1960-04-21","DateOfDeletion__c":"","ExternalId__c":"987654"},' +
			'"Asset":[{"Name":"Asset1","DueDate__c":"","ValidTo__c":"","ExternalId__c":"234567"},{"Name":"Asset2","ExternalId__c":"123456"}],' +
			'"ContactInformation":[{"Name":"Contact Information 1","ExternalId__c":"3456789"}]' +
			'}}' +
			'</ns4:jsonResponse></ns4:responseBody></ns4:SearchCSOBSNonClientResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();

		String result = PersonManagementController.searchCSOBNonClient(pid, lastName);
		Test.stopTest();

		PersonManagementUtility.UpdatePersonCSOBDataRequest deserializedResult = (PersonManagementUtility.UpdatePersonCSOBDataRequest) JSON.deserialize(
			result,
			PersonManagementUtility.UpdatePersonCSOBDataRequest.class
		);

		System.assertNotEquals(null, deserializedResult);
		System.assertEquals('987654', deserializedResult.Account.ExternalId__c);
		System.assertEquals(2, deserializedResult.Asset.size());
		System.assertEquals(1, deserializedResult.ContactInformation.size());
	}

	@IsTest
	static void searchCSOBNonClientEmptyResponseTest() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns4:SearchCSOBSNonClientResponse xmlns:ns4=\"http://service.cmss.cz/person/PersonManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:ns3=\"http://service.cmss.cz/person/SB-ClientInfoService/v10\"><ns2:responseHeader></ns2:responseHeader><ns4:responseBody><ns4:jsonResponse>' +
			'</ns4:jsonResponse></ns4:responseBody></ns4:SearchCSOBSNonClientResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();

		String result = PersonManagementController.searchCSOBNonClient('000000', 'None');
		Test.stopTest();

		System.assertEquals(null, result);
	}

	@IsTest
	static void searchCSOBNonClientExceptionTest() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns4:SearchCSOBSNonClientResponse xmlns:ns4=\"http://service.cmss.cz/person/PersonManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:ns3=\"http://service.cmss.cz/person/SB-ClientInfoService/v10\"><ns2:responseHeader></ns2:responseHeader><ns4:responseBody><ns4:jsonResponse>' +
			'reallyweirdresponse' +
			'</ns4:jsonResponse></ns4:responseBody></ns4:SearchCSOBSNonClientResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();

		try {
			String result = PersonManagementController.searchCSOBNonClient('000000', '???');
		} catch (Exception e) {
			System.assert(e instanceof IntegrationException);
		}
		Test.stopTest();
	}

	@IsTest
	static void updateCSOBNonClientTest() {
		String serializedUpdateRequest =
			'{"UpdatePersonCSOBDataRequest":{' +
			'"Account":{},' +
			'"Asset":[],' +
			'"ContactInformation":[]' +
			'}}';

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns4:UpdateCSOBNonClientResponse xmlns:ns4=\"http://service.cmss.cz/person/PersonManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:ns3=\"http://service.cmss.cz/person/SB-ClientInfoService/v10\"><ns2:responseHeader></ns2:responseHeader><ns4:responseBody><ns4:successful><Successful>true</Successful></ns4:successful></ns4:responseBody></ns4:UpdateCSOBNonClientResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();
		PersonManagementController.updateCSOBNonClient(serializedUpdateRequest);
		Test.stopTest();
	}

	@IsTest
	static void updateCSOBNonClientExceptionTest() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			500,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns4:UpdateCSOBNonClientResponse xmlns:ns4=\"http://service.cmss.cz/person/PersonManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:ns3=\"http://service.cmss.cz/person/SB-ClientInfoService/v10\"><ns2:responseHeader></ns2:responseHeader><ns4:responseBody><ns4:successful><Successful>true</Successful>weidresponse</ns4:successful></ns4:responseBody></ns4:UpdateCSOBNonClientResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();

		try {
			PersonManagementController.updateCSOBNonClient('serializedUpdateRequest');
		} catch (Exception e) {
			System.assert(e instanceof IntegrationException);
		}
		Test.stopTest();
	}
}
