@IsTest
private class FinancialOperationServiceTest {
	@TestSetup
	static void insertCustomSettings() {
		insert TestDataFactory.getIntegrationSettings();
	}

	@IsTest
	static void coverHttp() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns3:GetFinancialOperationInfoResponse xmlns:ns3=\"http://service.cmss.cz/account/FinancialOperationService/v05/datatypes\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:ns4=\"http://service.cmss.cz/account/SB-FinancialOperationService/v05\"><ns3:responseBody><ns3:contractFinancialOperationInfoList><ns3:contractFinancialOperationInfo><ns3:valueDate>2016-10-10</ns3:valueDate><ns3:bookingCode>1000</ns3:bookingCode><ns3:senderReceiverName>Večeřa Pavel</ns3:senderReceiverName><ns3:senderReceiverAccountPrefix></ns3:senderReceiverAccountPrefix><ns3:senderReceiverAccountNumber>761768153</ns3:senderReceiverAccountNumber><ns3:senderReceiverBankIdNumber>0800</ns3:senderReceiverBankIdNumber><ns3:amount>500</ns3:amount><ns3:variableSymbol>159014020</ns3:variableSymbol><ns3:constantSymbol>379</ns3:constantSymbol><ns3:specificSymbol></ns3:specificSymbol><ns3:avField> </ns3:avField><ns3:bookingDate>2016-10-10</ns3:bookingDate><ns3:IBAN>CZ5608000000000761768153</ns3:IBAN><ns3:transactionDateTime>2016-10-10T20:10:26</ns3:transactionDateTime><ns3:transactionDescription>Platba bezhotovostní</ns3:transactionDescription></ns3:contractFinancialOperationInfo></ns3:contractFinancialOperationInfoList></ns3:responseBody></ns3:GetFinancialOperationInfoResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		FinancialOperationService.FinancialOperationServicePort testObject = new FinancialOperationService.FinancialOperationServicePort();
		Test.startTest();
		testObject.getFinancialOperationInfo_Http(null, null);
		Test.stopTest();
	}

	@isTest
	static void coverGeneratedCodeTypes() {
		FinancialOperationDataTypesService parentObject = new FinancialOperationDataTypesService();
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode mockNode = doc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'env');

		FinancialOperationDataTypesService.ContractFinancialOperationInfoListType Obj1 = new FinancialOperationDataTypesService.ContractFinancialOperationInfoListType();
		Obj1.populateXmlNode(mockNode);
		FinancialOperationDataTypesService.ContractFinancialOperationInfoRequestType Obj2 = new FinancialOperationDataTypesService.ContractFinancialOperationInfoRequestType();
		Obj2.populateXmlNode(mockNode);
		FinancialOperationDataTypesService.ContractFinancialOperationInfoType Obj3 = new FinancialOperationDataTypesService.ContractFinancialOperationInfoType();
		Obj3.populateXmlNode(mockNode);
		FinancialOperationDataTypesService.GetFinancialOperationInfoRequestBodyType Obj4 = new FinancialOperationDataTypesService.GetFinancialOperationInfoRequestBodyType();
		Obj4.populateXmlNode(mockNode);
		FinancialOperationDataTypesService.GetFinancialOperationInfoRequestType Obj5 = new FinancialOperationDataTypesService.GetFinancialOperationInfoRequestType();
		Obj5.populateXmlNode(mockNode);
		FinancialOperationDataTypesService.GetFinancialOperationInfoResponseBodyType Obj6 = new FinancialOperationDataTypesService.GetFinancialOperationInfoResponseBodyType();
		Obj6.populateXmlNode(mockNode);
	}
}
