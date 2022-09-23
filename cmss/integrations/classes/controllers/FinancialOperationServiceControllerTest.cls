@IsTest
private class FinancialOperationServiceControllerTest {
	@TestSetup
	static void insertCustomSettings() {
		insert TestDataFactory.getIntegrationSettings();
	}

	@IsTest
	static void coverGetData() {
		Account acc = new Account();
		acc.Name = 'testAcc';
		insert acc;
		Asset asset1 = new Asset(Name = '5910840802', AccountId = acc.Id);
		insert asset1;
		Date dateTo = Date.newInstance(2018, 1, 9);
		Date dateFrom = Date.newInstance(2018, 1, 10);
		Long adjustedAssetName = 5910840;

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns3:GetFinancialOperationInfoResponse xmlns:ns3=\"http://service.cmss.cz/account/FinancialOperationService/v05/datatypes\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:ns4=\"http://service.cmss.cz/account/SB-FinancialOperationService/v05\"><ns3:responseBody><ns3:contractFinancialOperationInfoList><ns3:contractFinancialOperationInfo><ns3:valueDate>2018-01-09</ns3:valueDate><ns3:bookingCode>1000</ns3:bookingCode><ns3:senderReceiverName>Pavel Večeřa</ns3:senderReceiverName><ns3:senderReceiverAccountPrefix></ns3:senderReceiverAccountPrefix><ns3:senderReceiverAccountNumber>7617681530</ns3:senderReceiverAccountNumber><ns3:senderReceiverBankIdNumber>5500</ns3:senderReceiverBankIdNumber><ns3:amount>500</ns3:amount><ns3:variableSymbol>159014020</ns3:variableSymbol><ns3:constantSymbol>379</ns3:constantSymbol><ns3:specificSymbol></ns3:specificSymbol><ns3:avField> </ns3:avField><ns3:bookingDate>2018-01-09</ns3:bookingDate><ns3:IBAN>CZ7555000000007617681530</ns3:IBAN><ns3:transactionDateTime>2018-01-09T20:19:22</ns3:transactionDateTime><ns3:transactionDescription>Platba bezhotovostní</ns3:transactionDescription></ns3:contractFinancialOperationInfo></ns3:contractFinancialOperationInfoList></ns3:responseBody></ns3:GetFinancialOperationInfoResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();

		String result = FinancialOperationsController.getData(dateTo, dateFrom, asset1.Id);
		Test.stopTest();
		List<FinancialOperationsController.DataWrapper> resultList = (List<FinancialOperationsController.DataWrapper>) JSON.deserialize(result, List<FinancialOperationsController.DataWrapper>.class);
		system.assertEquals(1, resultList.size());
		system.assertEquals(getExpectedResult(), result);

	}

	static String getExpectedResult() {
		List<FinancialOperationsController.DataWrapper> expectedResultList = new List<FinancialOperationsController.DataWrapper>();
		FinancialOperationsController.DataWrapper dw = new FinancialOperationsController.DataWrapper();
		dw.valueDate = date.newInstance(2018, 01, 09);
		dw.bookingCode = 1000;
		dw.senderReceiverName = 'Pavel Večeřa';
		dw.senderReceiverAccountPrefix = '';
		dw.senderReceiverAccountNumber = '7617681530';
		dw.senderReceiverBankIdNumber = '5500';
		dw.amount = '500';
		dw.variableSymbol = '159014020';
		dw.constantSymbol = '379';
		dw.specificSymbol = '';
		dw.avField = ' ';
		dw.bookingDate = date.newInstance(2018, 01, 09);
		dw.IBAN = 'CZ7555000000007617681530';
		dw.transactionDateTime = Datetime.newInstanceGMT(2018, 1, 9, 20, 19, 22);
		dw.transactionDescription = 'Platba bezhotovostní';
		expectedResultList.add(dw);
		return JSON.serialize(expectedResultList);
	}
}