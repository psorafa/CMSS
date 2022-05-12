@IsTest
public class LoanDetailInfoServiceControllerTest {
    
    @TestSetup
    static void insertCustomSettings() {
        insert TestDataFactory.getIntegrationSettings();
    }
    
    @IsTest
    static void succsessResponse() {
        Account acc = TestDataFactory.getAccount(new Account());
        insert acc;
        Asset asset1 = new Asset(Name = '1200373701', AccountId = acc.Id);
        insert asset1;
        
        
        CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
            200,
            'OK',
            '<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><out:GetLoanDetailInfoResponse xmlns:out2=\"wsdl.http://service.cmss.cz/loan/LoanDetailInfoService/v05\" xmlns:io8=\"http://service.cmss.cz/common/datamodel/basictypes/v02\" xmlns:io6=\"http://www.ibm.com/xmlns/prod/websphere/http/sca/6.1.0\" xmlns:io7=\"http://www.w3.org/2005/08/addressing\" xmlns:out=\"http://service.cmss.cz/loan/LoanDetailInfoService/v05/datatypes\" xmlns:io4=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:io5=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:io2=\"http://www.ibm.com/websphere/sibx/smo/v6.0.1\" xmlns:in2=\"http://service.cmss.cz/loan/SB-LoanDetailInfoService/v05\" xmlns:io3=\"http://www.ibm.com/xmlns/prod/websphere/mq/sca/6.0.0\" xmlns:io=\"http://schemas.xmlsoap.org/ws/2004/08/addressing\" xmlns:in=\"wsdl.http://service.cmss.cz/loan/SB-LoanDetailInfoService/v05\" xmlns:xs4xs=\"http://www.w3.org/2001/XMLSchema\"><io4:responseHeader><io4:conversationIdName/><io4:conversationIdValue/><io4:correlationId>f9dfe7ba-cf8c-7029-52d2-19215459e9d9</io4:correlationId><io4:messageId>f9dfe7ba-cf8c-7029-52d2-19215459e9d9_resp</io4:messageId><io4:physicalSource>SBTESTWEB02.cmss.local</io4:physicalSource><io4:sourceSystem>StarBuild</io4:sourceSystem><io4:targetSystem>3</io4:targetSystem><io4:timestamp>2022-05-11T08:22:35.109Z</io4:timestamp><io4:userId>0051j00000AOn9nAAD</io4:userId></io4:responseHeader><out:responseBody><out:loanDetailInfo><out:signDate>2019-03-20</out:signDate><out:receiptDate>2019-04-05</out:receiptDate><out:approvalDate1>2019-04-05</out:approvalDate1><out:approvalDate2>2019-04-05</out:approvalDate2><out:acceptanceDate>2019-04-05</out:acceptanceDate><out:signDateOwner>2019-04-26</out:signDateOwner><out:loanUsageCode>3</out:loanUsageCode><out:realEstateUsageCode>1</out:realEstateUsageCode><out:loanPlaceCode>3</out:loanPlaceCode><out:personNumber>7200</out:personNumber><out:decisiveUserId>212</out:decisiveUserId><out:loanStateCode>6</out:loanStateCode><out:variableAmount>3300000</out:variableAmount><out:originalLoanModeCode>2</out:originalLoanModeCode><out:currentLoanModeCode>2</out:currentLoanModeCode><out:loanUsage2Code>0</out:loanUsage2Code><out:loanUsage3Desc/><out:listOfIndemnity><out:indemnityDetail><out:debtSecurityType>23</out:debtSecurityType><out:acceptableValue>840541,42</out:acceptableValue></out:indemnityDetail><out:indemnityDetail><out:debtSecurityType>37</out:debtSecurityType><out:acceptableValue>2459458,58</out:acceptableValue></out:indemnityDetail></out:listOfIndemnity><out:listOfPayments><out:paymentsDetail><out:payingSegmentPrefixNumber/><out:payingSegmentNumber>2107517869</out:payingSegmentNumber><out:payingSegmentBankCode>2700</out:payingSegmentBankCode><out:payingSegmentConstaintSymbol>0558</out:payingSegmentConstaintSymbol><out:payingSegmentVariableSymbol/><out:payingSegmentSpecificSymbol/><out:payingSegmentAV/><out:payingSegmentRecipient>AK Mach a Mrázik</out:payingSegmentRecipient></out:paymentsDetail></out:listOfPayments><out:listOfAccounts><out:accountDetail><out:accountIdNumber><basicNumber>1530886</basicNumber><checkNumber>9</checkNumber><endNumber>7</endNumber></out:accountIdNumber><out:accountType>2</out:accountType><out:interestRate>2,49</out:interestRate></out:accountDetail></out:listOfAccounts></out:loanDetailInfo></out:responseBody></out:GetLoanDetailInfoResponse>\r\n</soapenv:Body></soapenv:Envelope>'
            ,null,
            null
        );
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        Test.startTest();
        HTTPResponse rawResponse = LoanDetailInfoServiceController.loanDetailInfoRawResponse(asset1.Name);
        Test.stopTest();
        String errorMessage = LoanDetailInfoServiceController.loanDetailInfoErrorMessage(rawResponse);
        UpdateLoanAssetsFlowController.LoanDetailInfoResult result = LoanDetailInfoServiceController.loanDetailInfoResult(rawResponse);
        system.assertEquals( getExpectedResult(), result.toString());
        system.assertEquals( errorMessage, null);
    }
    
    @IsTest
    static void failResponse() {
        Account acc = TestDataFactory.getAccount(new Account());
        insert acc;
        Asset asset1 = new Asset(Name = '12003737010', AccountId = acc.Id);
        insert asset1;
        
        
        CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
            500,
            'Internal Server Error',
            '<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><soapenv:Fault xmlns:m=\"http://schemas.xmlsoap.org/soap/envelope/\"><faultcode>m:Server</faultcode><faultstring>[]</faultstring><detail><io7:CMSSBusinessLogicFaultInfo xmlns:io7=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:io6=\"http://www.ibm.com/xmlns/prod/websphere/http/sca/6.1.0\" xmlns:xs4xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:in=\"wsdl.http://service.cmss.cz/loan/SB-LoanDetailInfoService/v05\" xmlns:io=\"http://www.w3.org/2005/08/addressing\" xmlns:io3=\"http://schemas.xmlsoap.org/ws/2004/08/addressing\" xmlns:io2=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:io5=\"http://www.ibm.com/xmlns/prod/websphere/mq/sca/6.0.0\" xmlns:out=\"wsdl.http://service.cmss.cz/loan/LoanDetailInfoService/v05\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:io4=\"http://www.ibm.com/websphere/sibx/smo/v6.0.1\" xsi:type=\"io7:CMSSBusinessLogicFaultInfo\"><io7:errorDetail>51502</io7:errorDetail><io7:errorNumber>51502</io7:errorNumber><io7:faultHeader><io7:conversationIdName></io7:conversationIdName><io7:conversationIdValue></io7:conversationIdValue><io7:correlationId>835f8efd-94e3-6f96-e4ea-57d01881d6ba</io7:correlationId><io7:messageId>835f8efd-94e3-6f96-e4ea-57d01881d6ba_error</io7:messageId><io7:physicalSource>SBTESTWEB02.cmss.local</io7:physicalSource><io7:sourceSystem>StarBuild</io7:sourceSystem><io7:targetSystem>3</io7:targetSystem><io7:timestamp>2022-05-11T18:54:10.671Z</io7:timestamp><io7:userId>0051j00000AOn9nAAD</io7:userId></io7:faultHeader><io7:message>nebyl nalezen úvěrový případ za dané loanIdNumber</io7:message><io7:system>StarBuild</io7:system></io7:CMSSBusinessLogicFaultInfo></detail></soapenv:Fault></soapenv:Body></soapenv:Envelope>'
            ,null,
            null
        );
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        Test.startTest();
        HTTPResponse rawResponse = LoanDetailInfoServiceController.loanDetailInfoRawResponse(asset1.Name);
        Test.stopTest();
        String errorMessage = LoanDetailInfoServiceController.loanDetailInfoErrorMessage(rawResponse);
        UpdateLoanAssetsFlowController.LoanDetailInfoResult result = LoanDetailInfoServiceController.loanDetailInfoResult(rawResponse);
        system.assertEquals( result,null );
        system.assertEquals( errorMessage,'loanDetailInfoServiceErrorMessage: nebyl nalezen úvěrový případ za dané loanIdNumber' );
    }
    
    public static  String getExpectedResult(){
        UpdateLoanAssetsFlowController.LoanDetailInfoResult ldir = new UpdateLoanAssetsFlowController.LoanDetailInfoResult();
        ldir.variableAmount = 3300000;
        ldir.loanUsageCode = '3';
        ldir.loanUsage2Code = '0';
        ldir.signDate = date.newInstance(2019, 03, 20);
        ldir.approvalDate2 = date.newInstance(2019, 04, 05);
        ldir.loanStateCode = '6';
        ldir.personNumber = '7200';
        
        return ldir.toString();
    }
}