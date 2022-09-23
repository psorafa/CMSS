@IsTest
public class LoanDetailInfoServiceTest {
	@TestSetup
	static void insertCustomSettings() {
		insert TestDataFactory.getIntegrationSettings();
	}

	@IsTest
	static void coverHttp() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><out:GetLoanDetailInfoResponse xmlns:out2=\"wsdl.http://service.cmss.cz/loan/LoanDetailInfoService/v05\" xmlns:io8=\"http://service.cmss.cz/common/datamodel/basictypes/v02\" xmlns:io6=\"http://www.ibm.com/xmlns/prod/websphere/http/sca/6.1.0\" xmlns:io7=\"http://www.w3.org/2005/08/addressing\" xmlns:out=\"http://service.cmss.cz/loan/LoanDetailInfoService/v05/datatypes\" xmlns:io4=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:io5=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:io2=\"http://www.ibm.com/websphere/sibx/smo/v6.0.1\" xmlns:in2=\"http://service.cmss.cz/loan/SB-LoanDetailInfoService/v05\" xmlns:io3=\"http://www.ibm.com/xmlns/prod/websphere/mq/sca/6.0.0\" xmlns:io=\"http://schemas.xmlsoap.org/ws/2004/08/addressing\" xmlns:in=\"wsdl.http://service.cmss.cz/loan/SB-LoanDetailInfoService/v05\" xmlns:xs4xs=\"http://www.w3.org/2001/XMLSchema\"><io4:responseHeader><io4:conversationIdName/><io4:conversationIdValue/><io4:correlationId>f9dfe7ba-cf8c-7029-52d2-19215459e9d9</io4:correlationId><io4:messageId>f9dfe7ba-cf8c-7029-52d2-19215459e9d9_resp</io4:messageId><io4:physicalSource>SBTESTWEB02.cmss.local</io4:physicalSource><io4:sourceSystem>StarBuild</io4:sourceSystem><io4:targetSystem>3</io4:targetSystem><io4:timestamp>2022-05-11T08:22:35.109Z</io4:timestamp><io4:userId>0051j00000AOn9nAAD</io4:userId></io4:responseHeader><out:responseBody><out:loanDetailInfo><out:signDate>2019-03-20</out:signDate><out:receiptDate>2019-04-05</out:receiptDate><out:approvalDate1>2019-04-05</out:approvalDate1><out:approvalDate2>2019-04-05</out:approvalDate2><out:acceptanceDate>2019-04-05</out:acceptanceDate><out:signDateOwner>2019-04-26</out:signDateOwner><out:loanUsageCode>3</out:loanUsageCode><out:realEstateUsageCode>1</out:realEstateUsageCode><out:loanPlaceCode>3</out:loanPlaceCode><out:personNumber>7200</out:personNumber><out:decisiveUserId>212</out:decisiveUserId><out:loanStateCode>6</out:loanStateCode><out:variableAmount>3300000</out:variableAmount><out:originalLoanModeCode>2</out:originalLoanModeCode><out:currentLoanModeCode>2</out:currentLoanModeCode><out:loanUsage2Code>0</out:loanUsage2Code><out:loanUsage3Desc/><out:listOfIndemnity><out:indemnityDetail><out:debtSecurityType>23</out:debtSecurityType><out:acceptableValue>840541,42</out:acceptableValue></out:indemnityDetail><out:indemnityDetail><out:debtSecurityType>37</out:debtSecurityType><out:acceptableValue>2459458,58</out:acceptableValue></out:indemnityDetail></out:listOfIndemnity><out:listOfPayments><out:paymentsDetail><out:payingSegmentPrefixNumber/><out:payingSegmentNumber>2107517869</out:payingSegmentNumber><out:payingSegmentBankCode>2700</out:payingSegmentBankCode><out:payingSegmentConstaintSymbol>0558</out:payingSegmentConstaintSymbol><out:payingSegmentVariableSymbol/><out:payingSegmentSpecificSymbol/><out:payingSegmentAV/><out:payingSegmentRecipient>AK Mach a Mrázik</out:payingSegmentRecipient></out:paymentsDetail></out:listOfPayments><out:listOfAccounts><out:accountDetail><out:accountIdNumber><basicNumber>1530886</basicNumber><checkNumber>9</checkNumber><endNumber>7</endNumber></out:accountIdNumber><out:accountType>2</out:accountType><out:interestRate>2,49</out:interestRate></out:accountDetail></out:listOfAccounts></out:loanDetailInfo></out:responseBody></out:GetLoanDetailInfoResponse>\r\n</soapenv:Body></soapenv:Envelope>'
			, null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		LoanDetailInfoService.LoanDetailInfoServicePort testObject = new LoanDetailInfoService.LoanDetailInfoServicePort();
		Test.startTest();
		testObject.getLoanDetailInfo_Http(null, null);
		Test.stopTest();
	}

	@isTest
	static void coverGeneratedCodeTypes() {
		LoanDetailInfoServiceDataTypes parentObject = new LoanDetailInfoServiceDataTypes();
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode mockNode = doc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'env');


		LoanDetailInfoServiceDataTypes.LoanDetailInfoType Obj1 = new LoanDetailInfoServiceDataTypes.LoanDetailInfoType();
		Obj1.populateXmlNode(mockNode);
		LoanDetailInfoServiceDataTypes.GetLoanDetailInfoRequestBodyType Obj2 = new LoanDetailInfoServiceDataTypes.GetLoanDetailInfoRequestBodyType();
		Obj2.populateXmlNode(mockNode);
		LoanDetailInfoServiceDataTypes.GetLoanDetailInfoRequestType Obj3 = new LoanDetailInfoServiceDataTypes.GetLoanDetailInfoRequestType();
		Obj3.populateXmlNode(mockNode);
		LoanDetailInfoServiceDataTypes.GetLoanDetailInfoResponseBodyType Obj5 = new LoanDetailInfoServiceDataTypes.GetLoanDetailInfoResponseBodyType();
		Obj5.populateXmlNode(mockNode);
	}
}