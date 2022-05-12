@IsTest
public class LoanAssetsServicesTest {


    
    @TestSetup
    static void insertCustomSettings() {
        insert TestDataFactory.getIntegrationSettings();
    }
    
    @IsTest
    static void updateAsset() {
    Account acc = TestDataFactory.getAccount(new Account());
        insert acc;
        Asset asset1 = new Asset(Name = '1200373701', AccountId = acc.Id);
        insert asset1;
        UpdateLoanAssetsFlowController.Request request = new UpdateLoanAssetsFlowController.Request();
        request.assetId = asset1.Id;
        QueueHttpMock mock = new QueueHttpMock();
        HttpResponse res1 = new HttpResponse();
        res1.setStatus('OK');
        res1.setStatusCode(200);
        res1.setBody('<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><out:GetLoanDetailInfoResponse xmlns:out2=\"wsdl.http://service.cmss.cz/loan/LoanDetailInfoService/v05\" xmlns:io8=\"http://service.cmss.cz/common/datamodel/basictypes/v02\" xmlns:io6=\"http://www.ibm.com/xmlns/prod/websphere/http/sca/6.1.0\" xmlns:io7=\"http://www.w3.org/2005/08/addressing\" xmlns:out=\"http://service.cmss.cz/loan/LoanDetailInfoService/v05/datatypes\" xmlns:io4=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:io5=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:io2=\"http://www.ibm.com/websphere/sibx/smo/v6.0.1\" xmlns:in2=\"http://service.cmss.cz/loan/SB-LoanDetailInfoService/v05\" xmlns:io3=\"http://www.ibm.com/xmlns/prod/websphere/mq/sca/6.0.0\" xmlns:io=\"http://schemas.xmlsoap.org/ws/2004/08/addressing\" xmlns:in=\"wsdl.http://service.cmss.cz/loan/SB-LoanDetailInfoService/v05\" xmlns:xs4xs=\"http://www.w3.org/2001/XMLSchema\"><io4:responseHeader><io4:conversationIdName/><io4:conversationIdValue/><io4:correlationId>f9dfe7ba-cf8c-7029-52d2-19215459e9d9</io4:correlationId><io4:messageId>f9dfe7ba-cf8c-7029-52d2-19215459e9d9_resp</io4:messageId><io4:physicalSource>SBTESTWEB02.cmss.local</io4:physicalSource><io4:sourceSystem>StarBuild</io4:sourceSystem><io4:targetSystem>3</io4:targetSystem><io4:timestamp>2022-05-11T08:22:35.109Z</io4:timestamp><io4:userId>0051j00000AOn9nAAD</io4:userId></io4:responseHeader><out:responseBody><out:loanDetailInfo><out:signDate>2019-03-20</out:signDate><out:receiptDate>2019-04-05</out:receiptDate><out:approvalDate1>2019-04-05</out:approvalDate1><out:approvalDate2>2019-04-05</out:approvalDate2><out:acceptanceDate>2019-04-05</out:acceptanceDate><out:signDateOwner>2019-04-26</out:signDateOwner><out:loanUsageCode>3</out:loanUsageCode><out:realEstateUsageCode>1</out:realEstateUsageCode><out:loanPlaceCode>3</out:loanPlaceCode><out:personNumber>7200</out:personNumber><out:decisiveUserId>212</out:decisiveUserId><out:loanStateCode>6</out:loanStateCode><out:variableAmount>3300000</out:variableAmount><out:originalLoanModeCode>2</out:originalLoanModeCode><out:currentLoanModeCode>2</out:currentLoanModeCode><out:loanUsage2Code>0</out:loanUsage2Code><out:loanUsage3Desc/><out:listOfIndemnity><out:indemnityDetail><out:debtSecurityType>23</out:debtSecurityType><out:acceptableValue>840541,42</out:acceptableValue></out:indemnityDetail><out:indemnityDetail><out:debtSecurityType>37</out:debtSecurityType><out:acceptableValue>2459458,58</out:acceptableValue></out:indemnityDetail></out:listOfIndemnity><out:listOfPayments><out:paymentsDetail><out:payingSegmentPrefixNumber/><out:payingSegmentNumber>2107517869</out:payingSegmentNumber><out:payingSegmentBankCode>2700</out:payingSegmentBankCode><out:payingSegmentConstaintSymbol>0558</out:payingSegmentConstaintSymbol><out:payingSegmentVariableSymbol/><out:payingSegmentSpecificSymbol/><out:payingSegmentAV/><out:payingSegmentRecipient>AK Mach a Mrázik</out:payingSegmentRecipient></out:paymentsDetail></out:listOfPayments><out:listOfAccounts><out:accountDetail><out:accountIdNumber><basicNumber>1530886</basicNumber><checkNumber>9</checkNumber><endNumber>7</endNumber></out:accountIdNumber><out:accountType>2</out:accountType><out:interestRate>2,49</out:interestRate></out:accountDetail></out:listOfAccounts></out:loanDetailInfo></out:responseBody></out:GetLoanDetailInfoResponse>\r\n</soapenv:Body></soapenv:Envelope>');
        mock.addResponse(res1);
        Test.setMock(HttpCalloutMock.class, mock);
        UpdateLoanAssetsFlowController.LoanDetailInfoResult result = LoanDetailInfoServiceController.loanDetailInfoResult(res1);
        Asset asset = [SELECT CreditAmount__c,PurposeOfUse__c,PurposeOfUse2__c,RequestSignDate__c,SecondDecissionDate__c,Status__c,TipsterId__c FROM Asset WHERE Id =: asset1.Id];
        asset.CreditAmount__c = null;
        asset.PurposeOfUse__c = null;
        asset.PurposeOfUse2__c = null;
        asset.RequestSignDate__c = null;
        asset.SecondDecissionDate__c = null;
        asset.Status__c = null;
        asset.TipsterId__c = null;
        Test.startTest();
        LoanAssetsServices.updateLoanDetailInfo(result,request);
        Test.stopTest();
        Asset assetAfterUpdate = [SELECT CreditAmount__c,PurposeOfUse__c,PurposeOfUse2__c,RequestSignDate__c,SecondDecissionDate__c,Status__c FROM Asset WHERE Id =: asset1.Id];
        system.assertEquals(assetAfterUpdate.CreditAmount__c , 3300000);
        system.assertEquals(assetAfterUpdate.PurposeOfUse__c,'3');
        system.assertEquals(assetAfterUpdate.PurposeOfUse2__c,'0');
        system.assertEquals(assetAfterUpdate.RequestSignDate__c,date.newInstance(2019, 03, 20));
        system.assertEquals(assetAfterUpdate.SecondDecissionDate__c,date.newInstance(2019, 04, 05));
        system.assertEquals(assetAfterUpdate.Status__c,'6');
    }
   @IsTest
    static void updateLoadPackages() {
        Account acc = TestDataFactory.getAccount(new Account());
        insert acc;
        User user = new User(CommissionAccountBase__c = '7200');
        Asset asset1 = new Asset(Name = '1200373701', AccountId = acc.Id);
        insert asset1;
        LoanSurchargeDiscount__c lsd = new LoanSurchargeDiscount__c(Asset__c = asset1.Id, ExternalId__c = '940');
        insert lsd;
        UpdateLoanAssetsFlowController.Request request = new UpdateLoanAssetsFlowController.Request();
        request.assetId = asset1.Id;
        QueueHttpMock mock = new QueueHttpMock();
        HttpResponse res1 = new HttpResponse();
        res1.setStatus('OK');
        res1.setStatusCode(200);
        res1.setBody('<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><out:LoadPackagesListResponse xmlns:out2=\"wsdl.http://service.cmss.cz/loan/LoanService/v05\" xmlns:io8=\"http://service.cmss.cz/common/CommonMessage/v01\" xmlns:io6=\"http://www.ibm.com/xmlns/prod/websphere/mq/sca/6.0.0\" xmlns:io7=\"http://www.ibm.com/xmlns/prod/websphere/http/sca/6.1.0\" xmlns:out=\"http://service.cmss.cz/loan/LoanService/v05/datatypes\" xmlns:io4=\"http://schemas.xmlsoap.org/ws/2004/08/addressing\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:io5=\"http://www.ibm.com/websphere/sibx/smo/v6.0.1\" xmlns:io2=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:in2=\"http://service.cmss.cz/loan/SB-LoanService/v05/datatypes\" xmlns:io3=\"http://service.cmss.cz/common/datamodel/basictypes/v02\" xmlns:io=\"http://www.w3.org/2005/08/addressing\" xmlns:in=\"wsdl.http://service.cmss.cz/loan/SB-LoanService/v05\" xmlns:xs4xs=\"http://www.w3.org/2001/XMLSchema\"><io8:responseHeader><io8:conversationIdName/><io8:conversationIdValue/><io8:correlationId>7e73a1f2-7021-f986-e59f-335e2b8f8b99</io8:correlationId><io8:messageId>7e73a1f2-7021-f986-e59f-335e2b8f8b99_resp</io8:messageId><io8:physicalSource>SBTESTWEB02.cmss.local</io8:physicalSource><io8:sourceSystem>StarBuild</io8:sourceSystem><io8:targetSystem>3</io8:targetSystem><io8:timestamp>2022-05-10T11:41:58.979Z</io8:timestamp><io8:userId>0051j00000AOn9nAAD</io8:userId></io8:responseHeader><out:responseBody><out:listOfPackages><out:packagesItem><out:packageId>951</out:packageId><out:packageType>CS_PACKAGE</out:packageType><out:discount>0</out:discount><out:validFrom>2019-03-22</out:validFrom></out:packagesItem><out:packagesItem><out:packageId>961</out:packageId><out:packageType>CS_PACKAGE</out:packageType><out:discount>0</out:discount><out:validFrom>2019-04-05</out:validFrom></out:packagesItem><out:packagesItem><out:packageId>940</out:packageId><out:packageType>CS_PACKAGE</out:packageType><out:discount>-0,4</out:discount><out:validFrom>2019-04-05</out:validFrom></out:packagesItem></out:listOfPackages></out:responseBody></out:LoadPackagesListResponse>\r\n</soapenv:Body></soapenv:Envelope>');  
        mock.addResponse(res1);
        Test.setMock(HttpCalloutMock.class, mock);
        List<UpdateLoanAssetsFlowController.LoadPackagesCalloutResult> result = LoanServiceController.loadPackagesResult(res1);
        lsd.SurchargeDiscountId__c = null;
        lsd.ValidTo__c = null;
        lsd.ValidFrom__c = null;
        lsd.SurchargeDiscountAmount__c = null;
        Test.startTest();
        LoanAssetsServices.updateLoadPackages(result,request);
        Test.stopTest();
        LoanSurchargeDiscount__c lsdAfterUpdate = [SELECT SurchargeDiscountId__c,ValidTo__c,ValidFrom__c, SurchargeDiscountAmount__c FROM LoanSurchargeDiscount__c WHERE Id =: lsd.Id];
        system.assertEquals(lsdAfterUpdate.SurchargeDiscountId__c , 'CS_PACKAGE');
        system.assertEquals(lsdAfterUpdate.ValidTo__c,null);
        system.assertEquals(lsdAfterUpdate.ValidFrom__c,date.newInstance(2019, 04, 05));
        system.assertEquals(lsdAfterUpdate.SurchargeDiscountAmount__c,-0.4);
     
    }  
}