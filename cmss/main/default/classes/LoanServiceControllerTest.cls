@IsTest
public class LoanServiceControllerTest {
    
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
            '<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><out:LoadPackagesListResponse xmlns:out2=\"wsdl.http://service.cmss.cz/loan/LoanService/v05\" xmlns:io8=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:io6=\"http://www.ibm.com/xmlns/prod/websphere/mq/sca/6.0.0\" xmlns:io7=\"http://www.ibm.com/xmlns/prod/websphere/http/sca/6.1.0\" xmlns:out=\"http://service.cmss.cz/loan/LoanService/v05/datatypes\" xmlns:io4=\"http://schemas.xmlsoap.org/ws/2004/08/addressing\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:io5=\"http://www.ibm.com/websphere/sibx/smo/v6.0.1\" xmlns:io2=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:in2=\"http://service.cmss.cz/loan/SB-LoanService/v05/datatypes\" xmlns:io3=\"http://service.cmss.cz/common/datamodel/basictypes/v02\" xmlns:io=\"http://www.w3.org/2005/08/addressing\" xmlns:in=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:xs4xs=\"http://www.w3.org/2001/XMLSchema\"><io8:responseHeader><io8:conversationIdName/><io8:conversationIdValue/><io8:correlationId>7e73a1f2-7021-f986-e59f-335e2b8f8b99</io8:correlationId><io8:messageId>7e73a1f2-7021-f986-e59f-335e2b8f8b99_resp</io8:messageId><io8:physicalSource>SBTESTWEB02.cmss.local</io8:physicalSource><io8:sourceSystem>StarBuild</io8:sourceSystem><io8:targetSystem>3</io8:targetSystem><io8:timestamp>2022-05-10T11:41:58.979Z</io8:timestamp><io8:userId>0051j00000AOn9nAAD</io8:userId></io8:responseHeader><out:responseBody><out:listOfPackages><out:packagesItem><out:packageId>951</out:packageId><out:packageType>CS_PACKAGE</out:packageType><out:discount>0</out:discount><out:validFrom>2019-03-22</out:validFrom></out:packagesItem><out:packagesItem><out:packageId>961</out:packageId><out:packageType>CS_PACKAGE</out:packageType><out:discount>0</out:discount><out:validFrom>2019-04-05</out:validFrom></out:packagesItem><out:packagesItem><out:packageId>940</out:packageId><out:packageType>CS_PACKAGE</out:packageType><out:discount>-0,4</out:discount><out:validFrom>2019-04-05</out:validFrom></out:packagesItem></out:listOfPackages></out:responseBody></out:LoadPackagesListResponse>\r\n</soapenv:Body></soapenv:Envelope>',
            null,
            null
        );
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        Test.startTest();
        HTTPResponse rawResponse = LoanServiceController.loadPackagesListRawResponse(asset1.Name);
        Test.stopTest();
        String errorMessage = LoanServiceController.loadPackagesListErrorMessage(rawResponse);
        List<UpdateLoanAssetsFlowController.LoadPackagesCalloutResult> result = LoanServiceController.loadPackagesResult(rawResponse);
        system.assertEquals( getExpectedResult(), result[0].toString());
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
            '<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><soapenv:Fault xmlns:m=\"http://schemas.xmlsoap.org/soap/envelope/\"><faultcode>m:Server</faultcode><faultstring>[]</faultstring><detail><io7:CMSSBusinessLogicFaultInfo xmlns:io7=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:io6=\"http://www.ibm.com/xmlns/prod/websphere/http/sca/6.1.0\" xmlns:xs4xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:in=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:io=\"http://www.w3.org/2005/08/addressing\" xmlns:io3=\"http://schemas.xmlsoap.org/ws/2004/08/addressing\" xmlns:io2=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:io5=\"http://www.ibm.com/xmlns/prod/websphere/mq/sca/6.0.0\" xmlns:out=\"wsdl.http://service.cmss.cz/loan/LoanService/v05\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:io4=\"http://www.ibm.com/websphere/sibx/smo/v6.0.1\" xsi:type=\"io7:CMSSBusinessLogicFaultInfo\"><io7:errorDetail>1</io7:errorDetail><io7:errorNumber>1</io7:errorNumber><io7:faultHeader><axis2ns13:conversationIdName xmlns:axis2ns13=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns0=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:ns1=\"http://service.cmss.cz/loan/SB-LoanService/v05\"></axis2ns13:conversationIdName><axis2ns13:conversationIdValue xmlns:axis2ns13=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns0=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:ns1=\"http://service.cmss.cz/loan/SB-LoanService/v05\"></axis2ns13:conversationIdValue><axis2ns13:correlationId xmlns:axis2ns13=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns0=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:ns1=\"http://service.cmss.cz/loan/SB-LoanService/v05\">9c0e205d-158b-2e5e-55ef-071f339dda62</axis2ns13:correlationId><axis2ns13:messageId xmlns:axis2ns13=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns0=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:ns1=\"http://service.cmss.cz/loan/SB-LoanService/v05\">9c0e205d-158b-2e5e-55ef-071f339dda62_error</axis2ns13:messageId><axis2ns13:physicalSource xmlns:axis2ns13=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns0=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:ns1=\"http://service.cmss.cz/loan/SB-LoanService/v05\">SBTESTWEB02.cmss.local</axis2ns13:physicalSource><axis2ns13:sourceSystem xmlns:axis2ns13=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns0=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:ns1=\"http://service.cmss.cz/loan/SB-LoanService/v05\">StarBuild</axis2ns13:sourceSystem><axis2ns13:targetSystem xmlns:axis2ns13=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns0=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:ns1=\"http://service.cmss.cz/loan/SB-LoanService/v05\">3</axis2ns13:targetSystem><axis2ns13:timestamp xmlns:axis2ns13=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns0=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:ns1=\"http://service.cmss.cz/loan/SB-LoanService/v05\">2022-05-12T16:02:11.851Z</axis2ns13:timestamp><axis2ns13:userId xmlns:axis2ns13=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ns0=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:ns1=\"http://service.cmss.cz/loan/SB-LoanService/v05\">0051j00000AOn9nAAD</axis2ns13:userId></io7:faultHeader><io7:message>Zadané číslo úvěrového případu je neplatné</io7:message><io7:system>StarBuild</io7:system></io7:CMSSBusinessLogicFaultInfo></detail></soapenv:Fault></soapenv:Body></soapenv:Envelope> ',
            null,
            null
        );
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        Test.startTest();
        HTTPResponse rawResponse = LoanServiceController.loadPackagesListRawResponse(asset1.Name);
        Test.stopTest();
        String errorMessage = LoanServiceController.loadPackagesListErrorMessage(rawResponse);
        List<UpdateLoanAssetsFlowController.LoadPackagesCalloutResult> result = LoanServiceController.loadPackagesResult(rawResponse);
        system.assertEquals( result,null );
        system.assertEquals( errorMessage,'loanService.LoadPackagesListErrorMessage: Zadané číslo úvěrového případu je neplatné' );
    }
    
    public static  String getExpectedResult(){
       UpdateLoanAssetsFlowController.LoadPackagesCalloutResult lpcr = new UpdateLoanAssetsFlowController.LoadPackagesCalloutResult();
                lpcr.packageId = '951';
                lpcr.packageType = 'CS_PACKAGE';
                lpcr.fee = null;
                lpcr.discount = '0';
                lpcr.validFrom =date.newInstance(2019, 03, 22);
                lpcr.validTo = null;
        
        return lpcr.toString();
    }
}