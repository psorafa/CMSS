@IsTest
public class UpdateLoanAssetsFlowControllerTest {
    
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
        
        List<UpdateLoanAssetsFlowController.Request> requests = new List<UpdateLoanAssetsFlowController.Request>();
        UpdateLoanAssetsFlowController.Request request = new UpdateLoanAssetsFlowController.Request();
        request.assetName = asset1.Name;
        request.assetId = asset1.Id;
        requests.add(request);
        
        QueueHttpMock mock = new QueueHttpMock();
        HttpResponse res1 = new HttpResponse();
        res1.setStatus('OK');
        res1.setStatusCode(200);
        res1.setBody('<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><out:GetLoanDetailInfoResponse xmlns:out2=\"wsdl.http://service.cmss.cz/loan/LoanDetailInfoService/v05\" xmlns:io8=\"http://service.cmss.cz/common/datamodel/basictypes/v02\" xmlns:io6=\"http://www.ibm.com/xmlns/prod/websphere/http/sca/6.1.0\" xmlns:io7=\"http://www.w3.org/2005/08/addressing\" xmlns:out=\"http://service.cmss.cz/loan/LoanDetailInfoService/v05/datatypes\" xmlns:io4=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:io5=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:io2=\"http://www.ibm.com/websphere/sibx/smo/v6.0.1\" xmlns:in2=\"http://service.cmss.cz/loan/SB-LoanDetailInfoService/v05\" xmlns:io3=\"http://www.ibm.com/xmlns/prod/websphere/mq/sca/6.0.0\" xmlns:io=\"http://schemas.xmlsoap.org/ws/2004/08/addressing\" xmlns:in=\"wsdl.http://service.cmss.cz/loan/SB-LoanDetailInfoService/v05\" xmlns:xs4xs=\"http://www.w3.org/2001/XMLSchema\"><io4:responseHeader><io4:conversationIdName/><io4:conversationIdValue/><io4:correlationId>f9dfe7ba-cf8c-7029-52d2-19215459e9d9</io4:correlationId><io4:messageId>f9dfe7ba-cf8c-7029-52d2-19215459e9d9_resp</io4:messageId><io4:physicalSource>SBTESTWEB02.cmss.local</io4:physicalSource><io4:sourceSystem>StarBuild</io4:sourceSystem><io4:targetSystem>3</io4:targetSystem><io4:timestamp>2022-05-11T08:22:35.109Z</io4:timestamp><io4:userId>0051j00000AOn9nAAD</io4:userId></io4:responseHeader><out:responseBody><out:loanDetailInfo><out:signDate>2019-03-20</out:signDate><out:receiptDate>2019-04-05</out:receiptDate><out:approvalDate1>2019-04-05</out:approvalDate1><out:approvalDate2>2019-04-05</out:approvalDate2><out:acceptanceDate>2019-04-05</out:acceptanceDate><out:signDateOwner>2019-04-26</out:signDateOwner><out:loanUsageCode>3</out:loanUsageCode><out:realEstateUsageCode>1</out:realEstateUsageCode><out:loanPlaceCode>3</out:loanPlaceCode><out:personNumber>7200</out:personNumber><out:decisiveUserId>212</out:decisiveUserId><out:loanStateCode>6</out:loanStateCode><out:variableAmount>3300000</out:variableAmount><out:originalLoanModeCode>2</out:originalLoanModeCode><out:currentLoanModeCode>2</out:currentLoanModeCode><out:loanUsage2Code>0</out:loanUsage2Code><out:loanUsage3Desc/><out:listOfIndemnity><out:indemnityDetail><out:debtSecurityType>23</out:debtSecurityType><out:acceptableValue>840541,42</out:acceptableValue></out:indemnityDetail><out:indemnityDetail><out:debtSecurityType>37</out:debtSecurityType><out:acceptableValue>2459458,58</out:acceptableValue></out:indemnityDetail></out:listOfIndemnity><out:listOfPayments><out:paymentsDetail><out:payingSegmentPrefixNumber/><out:payingSegmentNumber>2107517869</out:payingSegmentNumber><out:payingSegmentBankCode>2700</out:payingSegmentBankCode><out:payingSegmentConstaintSymbol>0558</out:payingSegmentConstaintSymbol><out:payingSegmentVariableSymbol/><out:payingSegmentSpecificSymbol/><out:payingSegmentAV/><out:payingSegmentRecipient>AK Mach a Mrázik</out:payingSegmentRecipient></out:paymentsDetail></out:listOfPayments><out:listOfAccounts><out:accountDetail><out:accountIdNumber><basicNumber>1530886</basicNumber><checkNumber>9</checkNumber><endNumber>7</endNumber></out:accountIdNumber><out:accountType>2</out:accountType><out:interestRate>2,49</out:interestRate></out:accountDetail></out:listOfAccounts></out:loanDetailInfo></out:responseBody></out:GetLoanDetailInfoResponse>\r\n</soapenv:Body></soapenv:Envelope>');
        HttpResponse res2 = new HttpResponse();
        res2.setStatus('OK');
        res2.setStatusCode(200);
        res2.setBody('<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><out:LoadPackagesListResponse xmlns:out2=\"wsdl.http://service.cmss.cz/loan/LoanService/v05\" xmlns:io8=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:io6=\"http://www.ibm.com/xmlns/prod/websphere/mq/sca/6.0.0\" xmlns:io7=\"http://www.ibm.com/xmlns/prod/websphere/http/sca/6.1.0\" xmlns:out=\"http://service.cmss.cz/loan/LoanService/v05/datatypes\" xmlns:io4=\"http://schemas.xmlsoap.org/ws/2004/08/addressing\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:io5=\"http://www.ibm.com/websphere/sibx/smo/v6.0.1\" xmlns:io2=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:in2=\"http://service.cmss.cz/loan/SB-LoanService/v05/datatypes\" xmlns:io3=\"http://service.cmss.cz/common/datamodel/basictypes/v02\" xmlns:io=\"http://www.w3.org/2005/08/addressing\" xmlns:in=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:xs4xs=\"http://www.w3.org/2001/XMLSchema\"><io8:responseHeader><io8:conversationIdName/><io8:conversationIdValue/><io8:correlationId>7e73a1f2-7021-f986-e59f-335e2b8f8b99</io8:correlationId><io8:messageId>7e73a1f2-7021-f986-e59f-335e2b8f8b99_resp</io8:messageId><io8:physicalSource>SBTESTWEB02.cmss.local</io8:physicalSource><io8:sourceSystem>StarBuild</io8:sourceSystem><io8:targetSystem>3</io8:targetSystem><io8:timestamp>2022-05-10T11:41:58.979Z</io8:timestamp><io8:userId>0051j00000AOn9nAAD</io8:userId></io8:responseHeader><out:responseBody><out:listOfPackages><out:packagesItem><out:packageId>951</out:packageId><out:packageType>CS_PACKAGE</out:packageType><out:discount>0</out:discount><out:validFrom>2019-03-22</out:validFrom></out:packagesItem><out:packagesItem><out:packageId>961</out:packageId><out:packageType>CS_PACKAGE</out:packageType><out:discount>0</out:discount><out:validFrom>2019-04-05</out:validFrom></out:packagesItem><out:packagesItem><out:packageId>940</out:packageId><out:packageType>CS_PACKAGE</out:packageType><out:discount>-0,4</out:discount><out:validFrom>2019-04-05</out:validFrom></out:packagesItem></out:listOfPackages></out:responseBody></out:LoadPackagesListResponse>\r\n</soapenv:Body></soapenv:Envelope>');  
        mock.addResponse(res1);
        mock.addResponse(res2);
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        List<String> errorMessages = new List<String>();
        List<String> errorMessagesCompareList = new List<String>();
        Test.startTest();
        List<List<String>> flowOutput = UpdateLoanAssetsFlowController.updateloanAssetsFlowHelper(requests);
        Test.stopTest();
        String errorMessage2 = LoanServiceController.loadPackagesListErrorMessage(res2);
        String errorMessage1 = LoanDetailInfoServiceController.loanDetailInfoErrorMessage(res1);
        errorMessages.add(errorMessage1);
        errorMessages.add(errorMessage2);
        errorMessagesCompareList.add(null);
        errorMessagesCompareList.add(null);
        Integer statusik = res1.getStatusCode();
        system.assertEquals( errorMessages,errorMessagesCompareList);
    }
    
    static void failedResponse() {
        Account acc = TestDataFactory.getAccount(new Account());
        insert acc;
        Asset asset1 = new Asset(Name = '1200373701', AccountId = acc.Id);
        insert asset1;
        
        List<UpdateLoanAssetsFlowController.Request> requests = new List<UpdateLoanAssetsFlowController.Request>();
        UpdateLoanAssetsFlowController.Request request = new UpdateLoanAssetsFlowController.Request();
        request.assetName = asset1.Name;
        request.assetId = asset1.Id;
        requests.add(request);
        
        QueueHttpMock mock = new QueueHttpMock();
        HttpResponse res1 = new HttpResponse();
        res1.setStatus('Internal Server Error');
        res1.setStatusCode(500);
        res1.setBody('<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><soapenv:Fault xmlns:m=\"http://schemas.xmlsoap.org/soap/envelope/\"><faultcode>m:Server</faultcode><faultstring>[]</faultstring><detail><io7:CMSSBusinessLogicFaultInfo xmlns:io7=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:io6=\"http://www.ibm.com/xmlns/prod/websphere/http/sca/6.1.0\" xmlns:xs4xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:in=\"wsdl.http://service.cmss.cz/loan/SB-LoanDetailInfoService/v05\" xmlns:io=\"http://www.w3.org/2005/08/addressing\" xmlns:io3=\"http://schemas.xmlsoap.org/ws/2004/08/addressing\" xmlns:io2=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:io5=\"http://www.ibm.com/xmlns/prod/websphere/mq/sca/6.0.0\" xmlns:out=\"wsdl.http://service.cmss.cz/loan/LoanDetailInfoService/v05\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:io4=\"http://www.ibm.com/websphere/sibx/smo/v6.0.1\" xsi:type=\"io7:CMSSBusinessLogicFaultInfo\"><io7:errorDetail>51502</io7:errorDetail><io7:errorNumber>51502</io7:errorNumber><io7:faultHeader><io7:conversationIdName></io7:conversationIdName><io7:conversationIdValue></io7:conversationIdValue><io7:correlationId>59ce4038-35de-a85e-141e-616d77e86e65</io7:correlationId><io7:messageId>59ce4038-35de-a85e-141e-616d77e86e65_error</io7:messageId><io7:physicalSource>SBTESTWEB02.cmss.local</io7:physicalSource><io7:sourceSystem>StarBuild</io7:sourceSystem><io7:targetSystem>3</io7:targetSystem><io7:timestamp>2022-05-12T11:56:11.519Z</io7:timestamp><io7:userId>0051j00000AOn9nAAD</io7:userId></io7:faultHeader><io7:message>nebyl nalezen úvěrový případ za dané loanIdNumber</io7:message><io7:system>StarBuild</io7:system></io7:CMSSBusinessLogicFaultInfo></detail></soapenv:Fault></soapenv:Body></soapenv:Envelope>');
        HttpResponse res2 = new HttpResponse();
        res2.setStatus('Internal Server Error');
        res2.setStatusCode(500);
        res2.setBody('<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><soapenv:Fault xmlns:m=\"http://schemas.xmlsoap.org/soap/envelope/\"><faultcode>m:Server</faultcode><faultstring>[]</faultstring><detail><io7:CMSSBusinessLogicFaultInfo xmlns:io7=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:io6=\"http://www.ibm.com/xmlns/prod/websphere/http/sca/6.1.0\" xmlns:xs4xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:in=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:io=\"http://www.w3.org/2005/08/addressing\" xmlns:io3=\"http://schemas.xmlsoap.org/ws/2004/08/addressing\" xmlns:io2=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:io5=\"http://www.ibm.com/xmlns/prod/websphere/mq/sca/6.0.0\" xmlns:out=\"wsdl.http://service.cmss.cz/loan/LoanService/v05\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:io4=\"http://www.ibm.com/websphere/sibx/smo/v6.0.1\" xsi:type=\"io7:CMSSBusinessLogicFaultInfo\"><io7:errorDetail>1</io7:errorDetail><io7:errorNumber>1</io7:errorNumber><io7:faultHeader><axis2ns11:conversationIdName xmlns:axis2ns11=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns0=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:ns1=\"http://service.cmss.cz/loan/SB-LoanService/v05\"></axis2ns11:conversationIdName><axis2ns11:conversationIdValue xmlns:axis2ns11=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns0=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:ns1=\"http://service.cmss.cz/loan/SB-LoanService/v05\"></axis2ns11:conversationIdValue><axis2ns11:correlationId xmlns:axis2ns11=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns0=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:ns1=\"http://service.cmss.cz/loan/SB-LoanService/v05\">a68108bd-09b2-764c-9148-e66f95599190</axis2ns11:correlationId><axis2ns11:messageId xmlns:axis2ns11=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns0=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:ns1=\"http://service.cmss.cz/loan/SB-LoanService/v05\">a68108bd-09b2-764c-9148-e66f95599190_error</axis2ns11:messageId><axis2ns11:physicalSource xmlns:axis2ns11=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns0=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:ns1=\"http://service.cmss.cz/loan/SB-LoanService/v05\">SBTESTWEB02.cmss.local</axis2ns11:physicalSource><axis2ns11:sourceSystem xmlns:axis2ns11=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns0=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:ns1=\"http://service.cmss.cz/loan/SB-LoanService/v05\">StarBuild</axis2ns11:sourceSystem><axis2ns11:targetSystem xmlns:axis2ns11=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns0=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:ns1=\"http://service.cmss.cz/loan/SB-LoanService/v05\">3</axis2ns11:targetSystem><axis2ns11:timestamp xmlns:axis2ns11=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns0=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:ns1=\"http://service.cmss.cz/loan/SB-LoanService/v05\">2022-05-12T11:56:12.238Z</axis2ns11:timestamp><axis2ns11:userId xmlns:axis2ns11=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns0=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:ns1=\"http://service.cmss.cz/loan/SB-LoanService/v05\">0051j00000AOn9nAAD</axis2ns11:userId></io7:faultHeader><io7:message>Zadané číslo úvěrového případu je neplatné</io7:message><io7:system>StarBuild</io7:system></io7:CMSSBusinessLogicFaultInfo></detail></soapenv:Fault></soapenv:Body></soapenv:Envelope>');  
        mock.addResponse(res1);
        mock.addResponse(res2);
        
        Test.setMock(HttpCalloutMock.class, mock);
        
        List<String> errorMessages = new List<String>();
        List<String> errorMessagesCompareList = new List<String>();
        errorMessagesCompareList.add('loanDetailInfoServiceErrorMessage: nebyl nalezen úvěrový případ za dané loanIdNumber');
        errorMessagesCompareList.add('loanService.LoadPackagesListErrorMessage: Zadané číslo úvěrového případu je neplatné');
        List<List<String>> errorOutput = new List<List<String>>();
        errorOutput.add(errorMessagesCompareList);
        Test.startTest();
        List<List<String>> flowOutput = UpdateLoanAssetsFlowController.updateloanAssetsFlowHelper(requests);
        Test.stopTest();
        String loadPackagesListErrorMessage = LoanServiceController.loadPackagesListErrorMessage(res2);
        String loanDetailInfoErrorMessage = LoanDetailInfoServiceController.loanDetailInfoErrorMessage(res1);
        errorMessages.add(loadPackagesListErrorMessage);
        errorMessages.add(loanDetailInfoErrorMessage);
        
        system.assertEquals( errorMessages.size(),2);
        system.assertEquals(flowOutput ,errorOutput);
    }
}