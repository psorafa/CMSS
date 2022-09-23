@isTest
public class MigrationPremiumControllerTest {

    private static Account theAccount;
    private static Product2 theProduct;
    private static Product_Relation__c theProductRelation;
    private static Product_Relation__c theProductRelation2;
    private static Product_Parameter__c theProductParameter1;
    private static Product_Parameter__c theProductParameter2;
    private static Product_Parameter__c theProductParameter3;
    private static Asset theAsset;
    private static Opportunity theOpp;
    private static List<MigrationPremiumTypes.PrintingProductParameter> pppList;
/*    private static Account_Address__c theAccountAddress;
    private static GetCardDetailMock mock;*/
    private static Migration_Process__mdt migrationPremiumProcessConfiguration {
        get{
            if(migrationPremiumProcessConfiguration == null){
                migrationPremiumProcessConfiguration = [SELECT Id, DeveloperName, Icon_Path__c, Title_CZ__c, Title_EN__c, New_Product_Button_SOQL__c,
                        Assets_In_Migration_Data_ID__c, Show_Current_Account_Products__c,
                        Show_Configuration_Subtab__c, Final_Step_Validation__c, New_Subproduct_Button_SOQL__c,
                        Case_Content__c, Case_Record_Type_Developer_Name__c, Case_Status__c,
                        Case_Subject__c, Case_Type__c, Product_Relation_Record_Type_Name__c, Assets_In_Migration_Data_ID_Read_only__c
                FROM Migration_Process__mdt
                WHERE DeveloperName = 'CSOBS_contract_cancelation' LIMIT 1];
            }
            return migrationPremiumProcessConfiguration;
        }
        set;
    }

    private static Migration_Process__mdt migrationPremiumProcessConfigurationAccountCancel {
        get{
            if(migrationPremiumProcessConfigurationAccountCancel == null){
                migrationPremiumProcessConfigurationAccountCancel = [SELECT Id, Icon_Path__c, Title_CZ__c, Title_EN__c, New_Product_Button_SOQL__c,
                        Assets_In_Migration_Data_ID__c, Show_Current_Account_Products__c,
                        Show_Configuration_Subtab__c, Final_Step_Validation__c, New_Subproduct_Button_SOQL__c,
                        Case_Content__c, Case_Record_Type_Developer_Name__c, Case_Status__c,
                        Case_Subject__c, Case_Type__c, Product_Relation_Record_Type_Name__c, Assets_In_Migration_Data_ID_Read_only__c
                FROM Migration_Process__mdt
                WHERE DeveloperName = 'CSOBS_contract_cancelation' LIMIT 1];
            }
            return migrationPremiumProcessConfigurationAccountCancel;
        }
        set;
    }

    private static Migration_Process__mdt migrationPremiumProcessSavingConfiguration {
        get{
            if(migrationPremiumProcessSavingConfiguration == null){
                migrationPremiumProcessSavingConfiguration = [SELECT Id, Icon_Path__c, Title_CZ__c, Title_EN__c, New_Product_Button_SOQL__c,
                        Assets_In_Migration_Data_ID__c, Show_Current_Account_Products__c,
                        Show_Configuration_Subtab__c, Final_Step_Validation__c, New_Subproduct_Button_SOQL__c,
                        Case_Content__c, Case_Record_Type_Developer_Name__c, Case_Status__c,
                        Case_Subject__c, Case_Type__c, Product_Relation_Record_Type_Name__c, Assets_In_Migration_Data_ID_Read_only__c
                FROM Migration_Process__mdt
                WHERE DeveloperName = 'CSOBS_contract_cancelation' LIMIT 1];
            }
            return migrationPremiumProcessSavingConfiguration;
        }
        set;
    }

    private static void setupData(){
        theAccount = TestDataFactory.getAccount();
        //theAccount.PersonBirthdate = Date.today();
        insert theAccount;
        theProduct = new Product2();
        theProduct.Name = 'Name';
        theProduct.Description = 'Test Product';
        theProduct.IsActive = true;
        insert theProduct;

        theProductRelation = new Product_Relation__c();
        theProductRelation.From__c = theProduct.Id;
        theProductRelation.To__c = null;
        theProductRelation.Type__c = 'Keep';
        insert theProductRelation;

        theProductRelation2 = new Product_Relation__c();
        theProductRelation2.From__c = theProduct.Id;
        theProductRelation2.To__c = null;
        theProductRelation2.Type__c = 'Keep';
        insert theProductRelation2;

        theAsset = new Asset();
        theAsset.AccountId = theAccount.Id;
        theAsset.Product2Id = theProduct.Id;
        theAsset.Name = 'test';
        insert theAsset;
        //theAccount.Date_of_Birth__c = Date.today();
        //update theAccount;
        //Product2 parentProduct = TestUtils.getProduct('dfj', '1816-34', 1, null, '1816-34');
        //theProduct = TestUtils.getProduct('Test Product', 'Test Product', '18', 1, parentProduct.Id, 'hsvjf', 'jsdij');
        //theProductRelation2 = TestUtils.getAndCreateProductRelation(null, null, 'Migration');
        theProductRelation2.RecordTypeId = Schema.getGlobalDescribe().get('Product_Relation__c').getDescribe().getRecordTypeInfosByDeveloperName().get(migrationPremiumProcessConfiguration.Product_Relation_Record_Type_Name__c).getRecordTypeId();
        update theProductRelation2;

        theProductParameter1 = new Product_Parameter__c();
        theProductParameter1.Name = 'testName';
        theProductParameter1.Product_Relation__c = theProductRelation.Id;
        insert theProductParameter1;

        theProductParameter2 = new Product_Parameter__c();
        theProductParameter2.Name = 'testName';
        theProductParameter2.Product_Relation__c = theProductRelation.Id;
        theProductParameter2.Product_Parameter__c = theProductParameter1.Id;
        insert theProductParameter2;

        theProductParameter3 = new Product_Parameter__c();
        theProductParameter3.Name = 'testName';
        theProductParameter3.Product_Relation__c = theProductRelation.Id;
        theProductParameter3.Product_Parameter__c = theProductParameter2.Id;
        insert theProductParameter3;
        theProductParameter3.Soql__c = 'SELECT Id, Name FROM Product2';
        theProductParameter3.SOQL_Background_Query__c = 'SELECT Id, Name FROM Product2 WHERE Name= :value';
        update theProductParameter3;
        /*theAsset = TestUtils.getAsset(theAccount.Id, theProduct.Id, '123345');
        theAsset.Product2 = theProduct;
        TestUtils.createProductIdsCS();
        TestUtils.getCcAppNameCustomSettings();
        TestUtils.setTHUBEndpointURL();
        TestUtils.setIntegrationCertificates();
        theAccountAddress = TestUtils.getAccountAddress(theAccount);
        Product2 domain = TestUtils.getProduct('domain', 'AccountNeedsRemControllerTest1', 1, null, '1816');
        Product2 category = TestUtils.getProduct('domain', 'AccountNeedsRemControllerTest2', 2, domain.Id, '1816');
        Product2 product = TestUtils.getProduct('domain', 'AccountNeedsRemControllerTest3', 2, category.Id, '551');
        theOpp = TestUtils.getOpportunity(theAccount.Id, domain.Id, category.Id, product.Id);
        theProduct.Subproduct_SOQL__c = 'SELECT Id FROM Product2 WHERE Id = \'' + theProduct.Id + '\'';
        update theProduct;*/
    }

/*    private static void setupDataAccountCancellation(){
        theAccount = TestDataFactory.getAccount();
        theAccount.PersonBirthdate = Date.today();
        //theAccount.Date_of_Birth__c = Date.today();
        update theAccount;
*//*        Product2 parentProduct = TestUtils.getProduct('dfj', '1816-34', 1, null, '1816-34');
        theProduct = TestUtils.getProduct('Test Product', 'Test Product', '18', 1, parentProduct.Id, 'hsvjf', 'jsdij');
        theProductRelation = TestUtils.getAndCreateProductRelation(theProduct.Id, null, 'Keep');
        theProductRelation2 = TestUtils.getAndCreateProductRelation(null, null, 'Cancel');
        theProductRelation2.RecordTypeId = Schema.getGlobalDescribe().get('Product_Relation__c').getDescribe().getRecordTypeInfosByDeveloperName().get(migrationPremiumProcessConfigurationAccountCancel.Product_Relation_Record_Type_Name__c).getRecordTypeId();
        update theProductRelation2;
        theProductParameter1 = TestUtils.getAndCreateProductParameterOnRelation(theProductRelation.Id);
        theProductParameter2 = TestUtils.getAndCreateChildProductParameterOnRelation(theProductRelation.Id, theProductParameter1.Id);
        theProductParameter3 = TestUtils.getAndCreateChildProductParameterOnRelation(theProductRelation.Id, theProductParameter2.Id);*//*
        theProductParameter3.Soql__c = 'SELECT Id, Name FROM Product2';
        theProductParameter3.SOQL_Background_Query__c = 'SELECT Id, Name FROM Product2 WHERE Name= :value';
        update theProductParameter3;
        theAsset = TestUtils.getAsset(theAccount.Id, theProduct.Id, '123345');
        theAsset.Product2 = theProduct;
*//*        TestUtils.createProductIdsCS();
        TestUtils.getCcAppNameCustomSettings();
        TestUtils.setTHUBEndpointURL();
        TestUtils.setIntegrationCertificates();
        theAccountAddress = TestUtils.getAccountAddress(theAccount);
        Product2 domain = TestUtils.getProduct('domain', 'AccountNeedsRemControllerTest1', 1, null, '1816');
        Product2 category = TestUtils.getProduct('domain', 'AccountNeedsRemControllerTest2', 2, domain.Id, '1816');
        Product2 product = TestUtils.getProduct('domain', 'AccountNeedsRemControllerTest3', 2, category.Id, '551');
        theOpp = TestUtils.getOpportunity(theAccount.Id, domain.Id, category.Id, product.Id);*//*
    }*/

/*    private static void setupICalcCustomSettings(String hHeight, String fHeight, String tmpId, String tmp2Id, String url){
        List<ICalc_Printing_Properties__c> csList = new List<ICalc_Printing_Properties__c>();
        ICalc_Printing_Properties__c cs = new ICalc_Printing_Properties__c();
        cs.Name = 'Header_Height';
        cs.Value__c = hHeight;
        csList.add(cs);
        ICalc_Printing_Properties__c cs2 = new ICalc_Printing_Properties__c();
        cs2.Name = 'Footer_Height';
        cs2.Value__c = fHeight;
        csList.add(cs2);
        ICalc_Printing_Properties__c cs3 = new ICalc_Printing_Properties__c();
        cs3.Name = 'Template_Id';
        cs3.Value__c = tmpId;
        csList.add(cs3);
        ICalc_Printing_Properties__c cs4 = new ICalc_Printing_Properties__c();
        cs4.Name = 'Template2_Id';
        cs4.Value__c = tmp2Id;
        csList.add(cs4);
        ICalc_Printing_Properties__c cs5 = new ICalc_Printing_Properties__c();
        cs5.Name = 'Quote_Template_Data_Viewer_URL';
        cs5.Value__c = url;
        csList.add(cs5);
        insert csList;
    }*/

    /*private static void setupValidationProdIdsCustomSettings(){
        List<Product_IDs__c> pidList = new List<Product_IDs__c>();
        Product_IDs__c pid = new Product_IDs__c();
        pid.Name = 'CSOB ELB 1';
        pid.Value__c = '255-3144';
        pidList.add(pid);
        Product_IDs__c pid2 = new Product_IDs__c();
        pid2.Name = 'CSOB ELB 2';
        pid2.Value__c = '255-329';
        pidList.add(pid2);
        Product_IDs__c pid3 = new Product_IDs__c();
        pid3.Name = 'CSOB ELB 3';
        pid3.Value__c = '551-2000';
        pidList.add(pid3);
        Product_IDs__c pid7 = new Product_IDs__c();
        pid7.Name = 'CSOB ELB 5';
        pid7.Value__c = '551-26164';
        pidList.add(pid7);
        Product_IDs__c pid4 = new Product_IDs__c();
        pid4.Name = 'PSB ELB 1';
        pid4.Value__c = '255-4076';
        pidList.add(pid4);
        Product_IDs__c pid5 = new Product_IDs__c();
        pid5.Name = 'PSB ELB 2';
        pid5.Value__c = '255-331';
        pidList.add(pid5);
        Product_IDs__c pid6 = new Product_IDs__c();
        pid6.Name = 'PSB ELB 3';
        pid6.Value__c = '551-556';
        pidList.add(pid6);
        insert pidList;
    }*/

    /*private static void setupICalcData(){
        List<Product_Parameter__c> ppList = new List<Product_Parameter__c>();
        Product_Parameter__c pp = new Product_Parameter__c();
        pp.Type__c = 'Base';
        pp.Parameter_Label__c = 'B1';
        ppList.add(pp);
        Product_Parameter__c pp2 = new Product_Parameter__c();
        pp2.Type__c = 'Base';
        pp2.Parameter_Label__c = 'B2';
        ppList.add(pp2);
        Product_Parameter__c pp3 = new Product_Parameter__c();
        pp3.Type__c = 'Supplement';
        pp3.Parameter_Label__c = 'S1';
        ppList.add(pp3);
        Product_Parameter__c pp4 = new Product_Parameter__c();
        pp4.Type__c = 'Supplement';
        pp4.Parameter_Label__c = 'S2';
        ppList.add(pp4);
        Product_Parameter__c pp5 = new Product_Parameter__c();
        pp5.Type__c = 'Theme';
        pp5.Parameter_Label__c = 'T1';
        ppList.add(pp5);
        Product_Parameter__c pp6 = new Product_Parameter__c();
        pp6.Type__c = 'Regular Investment';
        pp6.Parameter_Label__c = 'RI1';
        ppList.add(pp6);
        Product_Parameter__c pp7 = new Product_Parameter__c();
        pp7.Type__c = 'Theme';
        pp7.Parameter_Label__c = 'T2';
        ppList.add(pp7);
        insert ppList;
        pppList = new List<MigrationPremiumTypes.PrintingProductParameter>();
        MigrationPremiumTypes.PrintingProductParameter ppp = new MigrationPremiumTypes.PrintingProductParameter(pp.Parameter_Label__c, pp.Id, '45000', pp.Type__c);
        pppList.add(ppp);
        MigrationPremiumTypes.PrintingProductParameter ppp2 = new MigrationPremiumTypes.PrintingProductParameter(pp2.Parameter_Label__c, pp2.Id, '15000', pp2.Type__c);
        pppList.add(ppp2);
        MigrationPremiumTypes.PrintingProductParameter ppp3 = new MigrationPremiumTypes.PrintingProductParameter(pp3.Parameter_Label__c, pp3.Id, '30000', pp3.Type__c);
        pppList.add(ppp3);
        MigrationPremiumTypes.PrintingProductParameter ppp4 = new MigrationPremiumTypes.PrintingProductParameter(pp4.Parameter_Label__c, pp4.Id, '20000', pp4.Type__c);
        pppList.add(ppp4);
        MigrationPremiumTypes.PrintingProductParameter ppp5 = new MigrationPremiumTypes.PrintingProductParameter(pp5.Parameter_Label__c, pp5.Id, '35000', pp5.Type__c);
        pppList.add(ppp5);
        MigrationPremiumTypes.PrintingProductParameter ppp7 = new MigrationPremiumTypes.PrintingProductParameter(pp7.Parameter_Label__c, pp7.Id, '5000', pp7.Type__c);
        pppList.add(ppp7);
        MigrationPremiumTypes.PrintingProductParameter ppp6 = new MigrationPremiumTypes.PrintingProductParameter(pp6.Parameter_Label__c, pp6.Id, '1500', pp6.Type__c);
        pppList.add(ppp6);
    }*/

    @isTest
    public static void getRelationsOfMigratedProductTest(){
        setupData();
        //Test.setMock(WebServiceMock.class, new DpaaSWebServiceMockImpl());
        Test.startTest();
        MigrationPremiumController.getRelationsOfMigratedProduct(theAccount.Id, theProduct.Id,'', null, 1, false, migrationPremiumProcessConfiguration.Id);
        MigrationPremiumController.getRelationsOfMigratedProduct(theAccount.Id, theProduct.Id,'', theAsset.Id, 1, false, migrationPremiumProcessConfiguration.Id);
        MigrationPremiumController.getInvestmentRelations();
        Test.stopTest();
    }

    @isTest
    public static void fillCaseFieldsForExistingCaseTest(){
        setupData();
        //Test.setMock(WebServiceMock.class, new DpaaSWebServiceMockImpl());
        Test.startTest();
        MigrationPremiumController.fillCaseFieldsForExistingCase(migrationPremiumProcessConfiguration, '', '',/* String selectedAssetMainElement, String selectedAssetChildElement,*/ '');
        Test.stopTest();
    }

    // @isTest
    // public static void prepareCaseForTemplateTest(){
    //     setupData();
    //     //Test.setMock(WebServiceMock.class, new DpaaSWebServiceMockImpl());
    //     Test.startTest();
    //     MigrationPremiumController.CreateCaseWrapper theWrap = MigrationPremiumController.prepareCaseForTemplate('CSOBS_contract_cancelation', 'test');
    //     Test.stopTest();
    //     System.assert(theWrap.theCaseId != null);
    // }

    @isTest
    public static void getRecordTest(){
        setupData();
        //Test.setMock(WebServiceMock.class, new DpaaSWebServiceMockImpl());
        Test.startTest();
        MigrationPremiumController.ReturnObjectWrapper theWrap = MigrationPremiumController.getRecord(theAsset.Id, 'Asset');
        Test.stopTest();
        System.assert(theWrap.objectId != null);
    }

/*    @isTest
    public static void loadProductCategoriesTest(){
        setupData();

        Test.startTest();
        MigrationPremiumController.loadProductCategories(theProduct.Id);
        Test.stopTest();
    }*/

/*    @isTest
    public static void loadChildProductsTest(){
        setupData();

        Test.startTest();
        MigrationPremiumController.loadChildProducts(theProduct.Id);
        Test.stopTest();
    }*/

    @isTest
    public static void createCaseTest(){
        setupData();

        /*DMS_Document__c theDmsDocument = new DMS_Document__c();
        theDmsDocument.Case__c = TestUtils.getCase(theAccount, migrationPremiumProcessConfiguration.Case_Type__c, migrationPremiumProcessConfiguration.Case_Content__c).Id;
        theDmsDocument.External_ID__c = '1234567890test';
        insert theDmsDocument;*/

        Test.startTest();
        MigrationPremiumController.CreateCaseWrapper createCaseWrapper = MigrationPremiumController.createCase(theAccount.Id, null, 'conf', 'conf2', '{"ppid":{"fieldName":"Description","value":"some note"}}', 'some note', '', '', '', '', '', migrationPremiumProcessConfiguration.Id, '0',null,null,null,null,'submit','','template'/*, false, ''*/);
        Test.stopTest();

        Case theCase = [SELECT Id, /*Approval_Comment__c,*/ Migration_Premium_Product_List_Conf__c, Migration_Premium_Product_Relations_Conf__c, Description, PCF_Unfinished__c FROM Case WHERE Id =: createCaseWrapper.theCaseId];
        /*List<DMS_Document__c> docList = [SELECT Id, Case__c FROM DMS_Document__c WHERE Id = :theDmsDocument.Id LIMIT 1];*/
        System.assertNotEquals(null, theCase);
        System.assertEquals('conf', theCase.Migration_Premium_Product_List_Conf__c);
        System.assertEquals('conf2' + '0', theCase.Migration_Premium_Product_Relations_Conf__c);
        System.assertEquals('some note', theCase.Description);
        //System.assertEquals('testcomment', theCase.Approval_Comment__c);
        /*System.assertNotEquals(null, docList);
        System.assertNotEquals(true, docList.isEmpty());
        System.assertEquals(false, theCase.PCF_Unfinished__c);
        System.assertEquals(createCaseWrapper.theCaseId, docList.get(0).Case__c);*/
    }

    @isTest
    public static void createCaseTest2(){
        //setupData();
        Test.startTest();
        User user = TestDataFactory.getUser(new User());
        insert user;
        TestDataFactory.defaultCaseOwner = user;
        insert TestDataFactory.getPermissionSetAssignments(user.Id);
        Case c1 = new Case();
        Case c2 = new Case();
        System.runAs(user) {
            Account theAcc = TestDataFactory.getAccount();
            c1 = TestDataFactory.getCase(new Case(
                    Subject = 'Case1',
                    AccountId = theAcc.Id
            ));

            c2 = TestDataFactory.getCase(new Case(
                    Subject = 'Case2',
                    AccountId = theAcc.Id
            ));
            insert c1;
            insert c2;
            MigrationPremiumController.CreateCaseWrapper createCaseWrapper = MigrationPremiumController.createCase(theAcc.Id, null, 'conf', 'conf2', '{"ppid":{"fieldName":"Description","value":"some note"}}', 'some note', '', '', '', '', '', migrationPremiumProcessConfiguration.Id, '0',null,null,null,c1.Id,'submit','',''/*, false, ''*/);
            MigrationPremiumController.CreateCaseWrapper createCaseWrapper2 = MigrationPremiumController.createCase(theAcc.Id, null, 'conf', 'conf2', '{"ppid":{"fieldName":"Description","value":"some note"}}', 'some note', '', '', '', '', '', migrationPremiumProcessConfiguration.Id, '0',null,null,null,c2.Id,'draft','',''/*, false, ''*/);
        }

        Test.stopTest();
    }

    @isTest
    public static void createCaseAccountCancellationTest(){
        //setupDataAccountCancellation();
        Test.startTest();
        setupData();
        /*DMS_Document__c theDmsDocument = new DMS_Document__c();
        theDmsDocument.Case__c = TestUtils.getCase(theAccount, migrationPremiumProcessConfigurationAccountCancel.Case_Type__c, migrationPremiumProcessConfigurationAccountCancel.Case_Content__c).Id;
        theDmsDocument.External_ID__c = '1234567890test';
        insert theDmsDocument;
        Test.setMock(WebServiceMock.class, new DpaaSWebServiceMockImpl());*/

        MigrationPremiumController.CreateCaseWrapper createCaseWrapper = MigrationPremiumController.createCase(theAccount.Id, null, 'conf', '{"GENERAL":{"a2M4E000000HjDqUAK":{"selectedRelationId":"a2M4E000000HjDqUAK","productRelationList":[{"attributes":{"type":"Product_Relation__c","url":"/services/data/v49.0/sobjects/Product_Relation__c/a2M4E000000HjDqUAK"},"Id":"a2M4E000000HjDqUAK","Default_Name__c":"Rušení účtů","RecordTypeId":"0124E000000cG99QAE"}],"productParameterDefaults":{"a0f4E000009cRrAQAU":{"value":"a0f4E000009cRrFQAU","isForFinalValidation":null,"syncElementName":"undefined","stringValue":"Majitel"},"a0f4E000009cRtCQAU":{"value":"a0f4E000009cSW4QAM","isForFinalValidation":null},"a0f4E00000AdAJiQAN":{"value":"existující klient","assetValue":"existující klient","isForFinalValidation":null},"a0f4E00000AAIo4QAH":{"value":""},"a0f4E000009cSD4QAM":{"value":""},"a0f4E000009xo6mQAA":{"value":""},"a0f4E000009xo6rQAA":{"value":""},"a0f4E000009xo7NQAQ":{"value":""},"a0f4E000009cSDaQAM":{"value":""},"a0f4E000009cSDfQAM":{"value":""},"a0f4E000009xo9RQAQ":{"value":""},"a0f4E000009xo9MQAQ":{"value":""},"a0f4E000009xoIkQAI":{"value":""},"a0f4E000009cSEBQA2":{"value":""},"a0f4E00000AlYGoQAN":{"value":""},"a0f4E000009cSEGQA2":{"value":""},"a0f4E000009cSELQA2":{"value":""},"a0f4E000009xo7SQAQ":{"value":""},"a0f4E000009cRrBQAU":{"value":"a0f4E000009cRwBQAU","isForFinalValidation":null,"syncElementName":"undefined","stringValue":"Občanský průkaz"},"a0f4E000009cRxIQAU":{"value":""},"a0f4E000009cSAZQA2":{"value":""},"a0f4E000009cSB5QAM":{"value":""},"a0f4E000009cSBAQA2":{"value":""},"a0f4E000009cSJQQA2":{"value":"a0f4E000009cSToQAM","isForFinalValidation":null,"syncElementName":"SettlementType"},"a0f4E000009cSKcQAM":{"value":""},"a0f4E000009cSKmQAM":{"value":"a0B4E000002WvL5UAK","isForFinalValidation":null},"a0f4E00000AAIptQAH":{"value":""},"a0f4E00000AAIpyQAH":{"value":""},"a0f4E00000AAIq3QAH":{"value":""},"a0f4E00000AAIqZQAX":{"value":""}},"productName":"NAME","productId":null,"isOwner":null,"isCard":false,"enhancedProductParameterDefaults":null,"disponentText":null,"disponentId":null,"assetId":null,"assetBankSystem":null,"assetAccountNumber":null}},"999-01t4E000000H8vmQAC":{"1-01t4E000000H6nXQAS":{"selectedRelationId":"a2M4E000000h4U8UAI","productRelationList":[{"attributes":{"type":"Product_Relation__c","url":"/services/data/v49.0/sobjects/Product_Relation__c/a2M4E000000h4U8UAI"},"Id":"a2M4E000000h4U8UAI","Default_Name__c":"Odevzdal","From__c":"01t4E000000fZm1QAE","Is_Owner_Default__c":false,"Is_Dispatcher_Default__c":false,"Record_Type_Name__c":"CSOBS_contract_cancelation","Type__c":"Cancel","Order__c":"1","RecordTypeId":"0124E000000cG99QAE","From__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000fZm1QAE"},"CST_Value_ID__c":"1816-47","Name":"Debetní karty","Id":"01t4E000000fZm1QAE"}},{"attributes":{"type":"Product_Relation__c","url":"/services/data/v49.0/sobjects/Product_Relation__c/a2M4E000000h4UDUAY"},"Id":"a2M4E000000h4UDUAY","Default_Name__c":"Neodevzdal","From__c":"01t4E000000fZm1QAE","Is_Owner_Default__c":false,"Is_Dispatcher_Default__c":false,"Record_Type_Name__c":"CSOBS_contract_cancelation","Type__c":"Cancel","Order__c":"2","RecordTypeId":"0124E000000cG99QAE","From__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000fZm1QAE"},"CST_Value_ID__c":"1816-47","Name":"Debetní karty","Id":"01t4E000000fZm1QAE"}}],"productParameterDefaults":{},"productName":"Debit MC ctls","productId":"01t4E000000H6nXQAS","isOwner":true,"isCard":false,"enhancedProductParameterDefaults":null,"disponentText":null,"disponentId":null,"assetId":"02i4E0000027wtzQAA","assetBankSystem":"16","assetAccountNumber":"**** **** **26 5457"},"0-01t4E000000H8vmQAC":{"selectedRelationId":"a2M4E000000hMrkUAE","productRelationList":[{"attributes":{"type":"Product_Relation__c","url":"/services/data/v49.0/sobjects/Product_Relation__c/a2M4E000000hMrkUAE"},"Id":"a2M4E000000hMrkUAE","Default_Name__c":"Výpověď","From__c":"01t4E000000H6r9QAC","Is_Owner_Default__c":false,"Is_Dispatcher_Default__c":false,"Record_Type_Name__c":"CSOBS_contract_cancelation","Type__c":"Cancel","Order__c":"1","RecordTypeId":"0124E000000cG99QAE","From__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000H6r9QAC"},"CST_Value_ID__c":"1816-2","Name":"Běžné účty","Id":"01t4E000000H6r9QAC"}},{"attributes":{"type":"Product_Relation__c","url":"/services/data/v49.0/sobjects/Product_Relation__c/a2M4E000000HorJUAS"},"Id":"a2M4E000000HorJUAS","Default_Name__c":"Dohoda","From__c":"01t4E000000H6r9QAC","Is_Owner_Default__c":false,"Is_Dispatcher_Default__c":false,"Record_Type_Name__c":"CSOBS_contract_cancelation","Type__c":"Cancel","Order__c":"2","RecordTypeId":"0124E000000cG99QAE","From__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000H6r9QAC"},"CST_Value_ID__c":"1816-2","Name":"Běžné účty","Id":"01t4E000000H6r9QAC"}},{"attributes":{"type":"Product_Relation__c","url":"/services/data/v49.0/sobjects/Product_Relation__c/a2M4E000000hMrpUAE"},"Id":"a2M4E000000hMrpUAE","Default_Name__c":"Odstoupení","From__c":"01t4E000000H6r9QAC","Is_Owner_Default__c":false,"Is_Dispatcher_Default__c":false,"Record_Type_Name__c":"CSOBS_contract_cancelation","Type__c":"Cancel","Order__c":"3","RecordTypeId":"0124E000000cG99QAE","From__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000H6r9QAC"},"CST_Value_ID__c":"1816-2","Name":"Běžné účty","Id":"01t4E000000H6r9QAC"}},{"attributes":{"type":"Product_Relation__c","url":"/services/data/v49.0/sobjects/Product_Relation__c/a2M4E000000hMruUAE"},"Id":"a2M4E000000hMruUAE","Default_Name__c":"Výpověď pro nesouhlas se změnou OP a Sazebníku","From__c":"01t4E000000H6r9QAC","Is_Owner_Default__c":false,"Is_Dispatcher_Default__c":false,"Record_Type_Name__c":"CSOBS_contract_cancelation","Type__c":"Cancel","Order__c":"4","RecordTypeId":"0124E000000cG99QAE","From__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000H6r9QAC"},"CST_Value_ID__c":"1816-2","Name":"Běžné účty","Id":"01t4E000000H6r9QAC"}}],"productParameterDefaults":{"a0f4E00000AlM3RQAV":{"value":"1 měsíc","isForFinalValidation":null},"a0f4E00000AlXp3QAF":{"value":"30.06.2020"},"a0f4E00000AlM3SQAV":{"value":""},"a0f4E00000AlM3fQAF":{"value":"TRUE","assetValue":"TRUE","isForFinalValidation":null},"a0f4E00000AlM3aQAF":{"value":"a0f4E000009cSToQAM","isForFinalValidation":null,"syncElementName":"SettlementType","stringValue":"Převod na účet"},"a0f4E00000AlM3bQAF":{"value":"111","syncElementName":"transferBankAccount"},"a0f4E00000AlM48QAF":{"value":"111","syncElementName":"transferBankCode"},"a0f4E00000AlM3cQAF":{"value":"111","syncElementName":"transferVS"},"a0f4E00000AlM3dQAF":{"value":"111","syncElementName":"transferKS"},"a0f4E00000AlM3eQAF":{"value":"111","syncElementName":"transferSS"},"a0f4E00000AlM3uQAF":{"value":"a0B4E000002WvL5UAK","isForFinalValidation":null,"stringValue":"Okružní 207, Ruda, ČR"},"a0f4E00000AlM3wQAF":{"value":true,"assetValue":null,"isForFinalValidation":false,"syncElementName":"undefined"},"a0f4E00000AlM3xQAF":{"value":"111","syncElementName":"IBAN"},"a0f4E00000AlM3yQAF":{"value":"111","syncElementName":"BIC"},"a0f4E00000AlM3zQAF":{"value":"111","syncElementName":"recepientAddress"},"a0f4E00000AlM40QAF":{"value":"1111","syncElementName":"recepientBankAddress"},"a0f4E00000AlM41QAF":{"value":"111","syncElementName":"transferCurrency"},"a0f4E00000AlM42QAF":{"value":"a0f4E00000AlM4OQAV","isForFinalValidation":null,"syncElementName":"transferFeeCode","stringValue":"SHA"},"a0f4E00000AlM43QAF":{"value":true,"assetValue":null,"isForFinalValidation":false,"syncElementName":"transferToRussia"},"a0f4E00000AlM44QAF":{"value":"111","syncElementName":"transferBankAccountRussia"},"a0f4E00000AlM45QAF":{"value":"111","syncElementName":"BIK"},"a0f4E00000AlM3vQAF":{"value":"111","syncElementName":"VoCode"},"a0f4E00000AlM46QAF":{"value":"111","syncElementName":"transferTaxCode"},"a0f4E00000AlM47QAF":{"value":"111","syncElementName":"KPP"},"a0f4E00000AlM4CQAV":{"value":""},"a0f4E00000AlM4DQAV":{"value":""},"a0f4E00000AlM3gQAF":{"value":"a0f4E00000AlM4JQAV","isForFinalValidation":null},"a0f4E00000AlM3iQAF":{"value":""},"a0f4E00000AlM3jQAF":{"value":""},"a0f4E00000AlM3kQAF":{"value":""},"a0f4E00000AlM3lQAF":{"value":""},"a0f4E00000AlM3mQAF":{"value":""},"a0f4E00000AlM3nQAF":{"value":""},"a0f4E00000AlM3oQAF":{"value":"a0f4E00000AlM4NQAV","isForFinalValidation":null},"a0f4E00000AlM3hQAF":{"value":false,"assetValue":null,"isForFinalValidation":false},"a0f4E00000AlM3pQAF":{"value":""},"a0f4E00000AlM3qQAF":{"value":""},"a0f4E00000AlM3rQAF":{"value":""},"a0f4E00000AlM3sQAF":{"value":""},"a0f4E00000AlM3tQAF":{"value":""},"a0f4E00000AlM3XQAV":{"value":"2500","isForFinalValidation":null},"a0f4E00000AlM3WQAV":{"value":"-3 642.01","assetValue":"-3 642.01","isForFinalValidation":null},"a0f4E00000AlM3VQAV":{"value":"166","isForFinalValidation":null},"a0f4E00000AlM3TQAV":{"value":""},"a0f4E00000AlM49QAF":{"value":false,"assetValue":null,"isForFinalValidation":false},"a0f4E00000AlM3UQAV":{"value":"0","isForFinalValidation":null},"a0f4E00000AlM4BQAV":{"value":"1000","assetValue":"1000","isForFinalValidation":null},"a0f4E00000AlM3ZQAV":{"value":false,"assetValue":null,"isForFinalValidation":false},"a0f4E00000AlM3YQAV":{"value":true,"assetValue":null,"isForFinalValidation":false},"a0f4E00000ArJADQA3":{"value":"02i4E000000DlFXQA0","isForFinalValidation":null},"a0f4E00000AlM4AQAV":{"value":"ČSOB Internetové bankovnictví","assetValue":"ČSOB Internetové bankovnictví","isForFinalValidation":null}},"productName":"Běžný účet v CZK","productId":"01t4E000000H8vmQAC","isOwner":true,"isCard":false,"enhancedProductParameterDefaults":null,"disponentText":null,"disponentId":null,"assetId":"02i4E000001OyGaQAK","assetBankSystem":"2","assetAccountNumber":"34225734"}}}0', '{"ppid":{"fieldName":"Description","value":"testcomment"}}', 'some note', '', '', '', '', '', migrationPremiumProcessConfigurationAccountCancel.Id, '0',null,null,null,null,'submit','',''/*, false, ''*/);
        //MigrationPremiumController.CreateCaseWrapper createCaseWrapper = MigrationPremiumController.createCase(theAccount.Id, null, 'conf', '', '{"ppid":{"fieldName":"Approval_Comment__c","value":"testcomment"}}', 'some note', '', '', '', '', '', migrationPremiumProcessConfigurationAccountCancel.Id, '0',null,null,null,null,'submit','', false, '');
        Case theCase = [SELECT Id, /*Approval_Comment__c,*/ Migration_Premium_Product_List_Conf__c, Migration_Premium_Product_Relations_Conf__c, Description, PCF_Unfinished__c FROM Case WHERE Id =: createCaseWrapper.theCaseId];
        //List<DMS_Document__c> docList = [SELECT Id, Case__c FROM DMS_Document__c WHERE Id = :theDmsDocument.Id LIMIT 1];
        Test.stopTest();

        System.assertNotEquals(null, theCase);
        System.assertEquals('conf', theCase.Migration_Premium_Product_List_Conf__c);
        //System.assertEquals('conf2' + '0', theCase.Migration_Premium_Product_Relations_Conf__c);
        System.assertEquals('testcomment', theCase.Description);
/*        System.assertEquals('testcomment', theCase.Approval_Comment__c);
        System.assertNotEquals(null, docList);
        System.assertNotEquals(true, docList.isEmpty());*/
        System.assertEquals(false, theCase.PCF_Unfinished__c);
        //System.assertEquals(createCaseWrapper.theCaseId, docList.get(0).Case__c);
    }

   /* @isTest
    public static void deactivateCreditCardsTest(){
        setupDataAccountCancellation();
        DMS_Document__c theDmsDocument = new DMS_Document__c();
        theDmsDocument.Case__c = TestUtils.getCase(theAccount, migrationPremiumProcessConfigurationAccountCancel.Case_Type__c, migrationPremiumProcessConfigurationAccountCancel.Case_Content__c).Id;
        theDmsDocument.External_ID__c = '1234567890test';
        insert theDmsDocument;
        TestUtils.setupCsobApiCalls();
        TestUtils.setCredentials_CS_THUB_KEY();
        TestUtils.setTHUBEndpointURL();
        TestUtils.setIntegrationCertificates();
        mock = new GetCardDetailMock(new DPaaSWebServiceSearchMock());
        Test.setMock(WebServiceMock.class, mock);
        Test.startTest();

        MigrationPremiumController.DeactivationCardsWrapper cardsWrapper = MigrationPremiumController.deactivateCreditCards('{"selectedRow":null,"lastIndex":0,"itemMap":{"999-01t4E000000H8vmQAC":{"theProduct":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000H8vmQAC"},"Id":"01t4E000000H8vmQAC","Name":"Běžný účet v CZK","Product__c":"01t4E000000H6r9QAC","CST_Value_ID__c":"551-2","Product__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000H6r9QAC"},"Id":"01t4E000000H6r9QAC","CST_Value_ID__c":"1816-2"}},"theAsset":{"attributes":{"type":"Asset","url":"/services/data/v49.0/sobjects/Asset/02i4E000001OyGaQAK"},"Id":"02i4E000001OyGaQAK","Product2Id":"01t4E000000H8vmQAC","AccountId":"0014E00000908NMQAY","Account_Number__c":"34225734","Bank_System__c":"2","Brand__c":"1","Currence_CZK__c":"TRUE","RecordTypeId":"0124E0000004Ud0QAE","Assets__r":{"totalSize":1,"done":true,"records":[{"attributes":{"type":"Asset","url":"/services/data/v49.0/sobjects/Asset/02i4E0000027wtzQAA"},"Parent_Asset__c":"02i4E000001OyGaQAK","Id":"02i4E0000027wtzQAA","Name":"Debit MC ctls","Product2Id":"01t4E000000H6nXQAS","Card_Status__c":"1","Brand__c":"1","AccountId":"0014E00000908NMQAY","Account_Number__c":"**** **** **26 5457","Bank_System__c":"16","RecordTypeId":"0124E0000004UcfQAE","Product2":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000H6nXQAS"},"Name":"Debit MC ctls","Product__c":"01t4E000000fZm1QAE","CST_Value_ID__c":"551-6432","Id":"01t4E000000H6nXQAS","Product__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000fZm1QAE"},"Id":"01t4E000000fZm1QAE","CST_Value_ID__c":"1816-47"}},"Account":{"attributes":{"type":"Account","url":"/services/data/v49.0/sobjects/Account/0014E00000908NMQAY"},"Name":"Alois Hubálek","CUID__c":"73051","Id":"0014E00000908NMQAY","RecordTypeId":"0124E0000004IK5QAM"}}]},"Product2":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000H8vmQAC"},"Name":"Běžný účet v CZK","Id":"01t4E000000H8vmQAC"},"Account":{"attributes":{"type":"Account","url":"/services/data/v49.0/sobjects/Account/0014E00000908NMQAY"},"Name":"Alois Hubálek","CUID__c":"73051","Id":"0014E00000908NMQAY","RecordTypeId":"0124E0000004IK5QAM"}},"name":"Běžný účet v CZK","migrationProcess":{"attributes":{"type":"Migration_Process__mdt","url":"/services/data/v49.0/sobjects/Migration_Process__mdt/m064E0000008oKHQAY"},"Id":"m064E0000008oKHQAY","DeveloperName":"Account_Cancellation","Icon_Path__c":"csobIcon.png","Title_CZ__c":"Rušení účtu","Title_EN__c":"Account Cancellation","Assets_In_Migration_Data_ID__c":"1816-29;1816-24;1816-34;1816-2;1816-46;1816-47;1816-52;1816-43;1816-42;1816-26;1816-25;1816-5;1816-37","Show_Current_Account_Products__c":true,"Show_Configuration_Subtab__c":true,"Case_Content__c":"8","Case_Record_Type_Developer_Name__c":"Product_Service","Case_Status__c":"10","Case_Subject__c":"Rušení účtu","Case_Type__c":"Product Service","DMS_Document_Type_Data_ID__c":"214","Case_Branch_Data_Id__c":"6583","Product_Relation_Record_Type_Name__c":"Account_Cancellation","Sidebar_Main_Title_CZ__c":"Produkty Rušení","Sidebar_Main_Title_EN__c":"Cancellation Products","Show_KC_Authenticator__c":false,"Selected_Tab_Default__c":"General","All_DMS_Document_IDs__c":"214;1022;357","Show_File_Selector__c":true,"Show_General_Subtab__c":true,"Left_Panel_Hidator__c":false,"General_Subtab_CZ_Label__c":"OBECNÉ","General_Subtab_EN_Label__c":"Delivery address","Show_FO_Products_on_FOP__c":true,"Show_FOP_Products_on_FO__c":true,"Load_Parent_Product_Config__c":true,"At_Least_One_Attachment_Is_Required__c":false,"Transition_Subtab_CZ_Label__c":"ZPŮSOB ZRUŠENÍ PRODUKTU","Transition_Subtab_EN_Label__c":"Transitions","Configuration_Subtab_CZ_Label__c":"NASTAVENÍ","Configuration_Subtab_EN_Label__c":"Configuration","Overview_Tab_CZ_Label__c":"Tisk dokumentů a dokončení","Overview_Tab_EN_Label__c":"Overview","Configuration_Tab_CZ_Label__c":"Upřesnění rušení účtů a karet","Configuration_Tab_EN_Label__c":"Configuration","Use_Preterm_Document_List__c":false,"Assets_In_Migration_Data_ID_Read_only__c":"1816-46;1816-52;1816-43;1816-42;1816-26;1816-25;1816-5;1816-37","Assets_In_Migration_Card_ID__c":"1816-47","Document_Configurations__r":{"totalSize":1,"done":true,"records":[{"attributes":{"type":"Document_Configuration__mdt","url":"/services/data/v49.0/sobjects/Document_Configuration__mdt/m084E000000Cs7JQAS"},"Migration_Process__c":"m064E0000008oKHQAY","Id":"m084E000000Cs7JQAS","Data_ID__c":"1933","Label_CZ__c":"Zrušení účtu","Label_EN__c":"Product Cancellation","Order__c":1,"Pre_contract_document__c":false}]}},"lastIndex":1,"isSelected":false,"isReadOnly":false,"isMigrationCard":false,"index":999,"hasSubProducts":false,"dispatcher":null,"defaultSelected":false,"childItemMap":{"0-01t4E000000H6nXQAS":{"theProduct":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000H6nXQAS"},"Name":"Debit MC ctls","Product__c":"01t4E000000fZm1QAE","CST_Value_ID__c":"551-6432","Id":"01t4E000000H6nXQAS","Product__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000fZm1QAE"},"Id":"01t4E000000fZm1QAE","CST_Value_ID__c":"1816-47"}},"theAsset":{"attributes":{"type":"Asset","url":"/services/data/v49.0/sobjects/Asset/02i4E0000027wtzQAA"},"Parent_Asset__c":"02i4E000001OyGaQAK","Id":"02i4E0000027wtzQAA","Name":"Debit MC ctls","Product2Id":"01t4E000000H6nXQAS","Card_Status__c":"1","Brand__c":"1","AccountId":"0014E00000908NMQAY","Account_Number__c":"**** **** **26 5457","Bank_System__c":"16","RecordTypeId":"0124E0000004UcfQAE","Product2":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000H6nXQAS"},"Name":"Debit MC ctls","Product__c":"01t4E000000fZm1QAE","CST_Value_ID__c":"551-6432","Id":"01t4E000000H6nXQAS","Product__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000fZm1QAE"},"Id":"01t4E000000fZm1QAE","CST_Value_ID__c":"1816-47"}},"Account":{"attributes":{"type":"Account","url":"/services/data/v49.0/sobjects/Account/0014E00000908NMQAY"},"Name":"Alois Hubálek","CUID__c":"73051","Id":"0014E00000908NMQAY","RecordTypeId":"0124E0000004IK5QAM"}},"name":"Debit MC ctls","migrationProcess":{"attributes":{"type":"Migration_Process__mdt","url":"/services/data/v49.0/sobjects/Migration_Process__mdt/m064E0000008oKHQAY"},"Id":"m064E0000008oKHQAY","DeveloperName":"Account_Cancellation","Icon_Path__c":"csobIcon.png","Title_CZ__c":"Rušení účtu","Title_EN__c":"Account Cancellation","Assets_In_Migration_Data_ID__c":"1816-29;1816-24;1816-34;1816-2;1816-46;1816-47;1816-52;1816-43;1816-42;1816-26;1816-25;1816-5;1816-37","Show_Current_Account_Products__c":true,"Show_Configuration_Subtab__c":true,"Case_Content__c":"8","Case_Record_Type_Developer_Name__c":"Product_Service","Case_Status__c":"10","Case_Subject__c":"Rušení účtu","Case_Type__c":"Product Service","DMS_Document_Type_Data_ID__c":"214","Case_Branch_Data_Id__c":"6583","Product_Relation_Record_Type_Name__c":"Account_Cancellation","Sidebar_Main_Title_CZ__c":"Produkty Rušení","Sidebar_Main_Title_EN__c":"Cancellation Products","Show_KC_Authenticator__c":false,"Selected_Tab_Default__c":"General","All_DMS_Document_IDs__c":"214;1022;357","Show_File_Selector__c":true,"Show_General_Subtab__c":true,"Left_Panel_Hidator__c":false,"General_Subtab_CZ_Label__c":"OBECNÉ","General_Subtab_EN_Label__c":"Delivery address","Show_FO_Products_on_FOP__c":true,"Show_FOP_Products_on_FO__c":true,"Load_Parent_Product_Config__c":true,"At_Least_One_Attachment_Is_Required__c":false,"Transition_Subtab_CZ_Label__c":"ZPŮSOB ZRUŠENÍ PRODUKTU","Transition_Subtab_EN_Label__c":"Transitions","Configuration_Subtab_CZ_Label__c":"NASTAVENÍ","Configuration_Subtab_EN_Label__c":"Configuration","Overview_Tab_CZ_Label__c":"Tisk dokumentů a dokončení","Overview_Tab_EN_Label__c":"Overview","Configuration_Tab_CZ_Label__c":"Upřesnění rušení účtů a karet","Configuration_Tab_EN_Label__c":"Configuration","Use_Preterm_Document_List__c":false,"Assets_In_Migration_Data_ID_Read_only__c":"1816-46;1816-52;1816-43;1816-42;1816-26;1816-25;1816-5;1816-37","Assets_In_Migration_Card_ID__c":"1816-47","Document_Configurations__r":{"totalSize":1,"done":true,"records":[{"attributes":{"type":"Document_Configuration__mdt","url":"/services/data/v49.0/sobjects/Document_Configuration__mdt/m084E000000Cs7JQAS"},"Migration_Process__c":"m064E0000008oKHQAY","Id":"m084E000000Cs7JQAS","Data_ID__c":"1933","Label_CZ__c":"Zrušení účtu","Label_EN__c":"Product Cancellation","Order__c":1,"Pre_contract_document__c":false}]}},"lastIndex":0,"isSelected":false,"isReadOnly":false,"isMigrationCard":true,"index":0,"hasSubProducts":false,"dispatcher":null,"defaultSelected":null,"childItemMap":{}}}}}}', '{"GENERAL":{"a2M4E000000HjDqUAK":{"selectedRelationId":"a2M4E000000HjDqUAK","productRelationList":[{"attributes":{"type":"Product_Relation__c","url":"/services/data/v49.0/sobjects/Product_Relation__c/a2M4E000000HjDqUAK"},"Id":"a2M4E000000HjDqUAK","Default_Name__c":"Rušení účtů","RecordTypeId":"0124E000000cG99QAE"}],"productParameterDefaults":{"a0f4E000009cRrAQAU":{"value":"a0f4E000009cRrFQAU","isForFinalValidation":null,"syncElementName":"undefined","stringValue":"Majitel"},"a0f4E000009cRtCQAU":{"value":"a0f4E000009cSW4QAM","isForFinalValidation":null},"a0f4E00000AdAJiQAN":{"value":"existující klient","assetValue":"existující klient","isForFinalValidation":null},"a0f4E00000AAIo4QAH":{"value":""},"a0f4E000009cSD4QAM":{"value":""},"a0f4E000009xo6mQAA":{"value":""},"a0f4E000009xo6rQAA":{"value":""},"a0f4E000009xo7NQAQ":{"value":""},"a0f4E000009cSDaQAM":{"value":""},"a0f4E000009cSDfQAM":{"value":""},"a0f4E000009xo9RQAQ":{"value":""},"a0f4E000009xo9MQAQ":{"value":""},"a0f4E000009xoIkQAI":{"value":""},"a0f4E000009cSEBQA2":{"value":""},"a0f4E00000AlYGoQAN":{"value":""},"a0f4E000009cSEGQA2":{"value":""},"a0f4E000009cSELQA2":{"value":""},"a0f4E000009xo7SQAQ":{"value":""},"a0f4E000009cRrBQAU":{"value":"a0f4E000009cRwBQAU","isForFinalValidation":null,"syncElementName":"undefined","stringValue":"Občanský průkaz"},"a0f4E000009cRxIQAU":{"value":""},"a0f4E000009cSAZQA2":{"value":""},"a0f4E000009cSB5QAM":{"value":""},"a0f4E000009cSBAQA2":{"value":""},"a0f4E000009cSJQQA2":{"value":"a0f4E000009cSToQAM","isForFinalValidation":null,"syncElementName":"SettlementType"},"a0f4E000009cSKcQAM":{"value":""},"a0f4E000009cSKmQAM":{"value":"a0B4E000002WvL5UAK","isForFinalValidation":null},"a0f4E00000AAIptQAH":{"value":""},"a0f4E00000AAIpyQAH":{"value":""},"a0f4E00000AAIq3QAH":{"value":""},"a0f4E00000AAIqZQAX":{"value":""}},"productName":"NAME","productId":null,"isOwner":null,"isCard":false,"enhancedProductParameterDefaults":null,"disponentText":null,"disponentId":null,"assetId":null,"assetBankSystem":null,"assetAccountNumber":null}},"999-01t4E000000H8vmQAC":{"1-01t4E000000H6nXQAS":{"selectedRelationId":"a2M4E000000h4U8UAI","productRelationList":[{"attributes":{"type":"Product_Relation__c","url":"/services/data/v49.0/sobjects/Product_Relation__c/a2M4E000000h4U8UAI"},"Id":"a2M4E000000h4U8UAI","Default_Name__c":"Odevzdal","From__c":"01t4E000000fZm1QAE","Is_Owner_Default__c":false,"Is_Dispatcher_Default__c":false,"Record_Type_Name__c":"Account Cancellation","Type__c":"Cancel","Order__c":"1","RecordTypeId":"0124E000000cG99QAE","From__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000fZm1QAE"},"CST_Value_ID__c":"1816-47","Name":"Debetní karty","Id":"01t4E000000fZm1QAE"}},{"attributes":{"type":"Product_Relation__c","url":"/services/data/v49.0/sobjects/Product_Relation__c/a2M4E000000h4UDUAY"},"Id":"a2M4E000000h4UDUAY","Default_Name__c":"Neodevzdal","From__c":"01t4E000000fZm1QAE","Is_Owner_Default__c":false,"Is_Dispatcher_Default__c":false,"Record_Type_Name__c":"Account Cancellation","Type__c":"Cancel","Order__c":"2","RecordTypeId":"0124E000000cG99QAE","From__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000fZm1QAE"},"CST_Value_ID__c":"1816-47","Name":"Debetní karty","Id":"01t4E000000fZm1QAE"}}],"productParameterDefaults":{},"productName":"Debit MC ctls","productId":"01t4E000000H6nXQAS","isOwner":true,"isCard":false,"enhancedProductParameterDefaults":null,"disponentText":null,"disponentId":null,"assetId":"02i4E0000027wtzQAA","assetBankSystem":"16","assetAccountNumber":"**** **** **26 5457"},"0-01t4E000000H8vmQAC":{"selectedRelationId":"a2M4E000000hMrkUAE","productRelationList":[{"attributes":{"type":"Product_Relation__c","url":"/services/data/v49.0/sobjects/Product_Relation__c/a2M4E000000hMrkUAE"},"Id":"a2M4E000000hMrkUAE","Default_Name__c":"Dohoda","From__c":"01t4E000000H6r9QAC","Is_Owner_Default__c":false,"Is_Dispatcher_Default__c":false,"Record_Type_Name__c":"Account Cancellation","Type__c":"Cancel","Order__c":"1","RecordTypeId":"0124E000000cG99QAE","From__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000H6r9QAC"},"CST_Value_ID__c":"1816-2","Name":"Běžné účty","Id":"01t4E000000H6r9QAC"}},{"attributes":{"type":"Product_Relation__c","url":"/services/data/v49.0/sobjects/Product_Relation__c/a2M4E000000HorJUAS"},"Id":"a2M4E000000HorJUAS","Default_Name__c":"Dohoda","From__c":"01t4E000000H6r9QAC","Is_Owner_Default__c":false,"Is_Dispatcher_Default__c":false,"Record_Type_Name__c":"Account Cancellation","Type__c":"Cancel","Order__c":"2","RecordTypeId":"0124E000000cG99QAE","From__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000H6r9QAC"},"CST_Value_ID__c":"1816-2","Name":"Běžné účty","Id":"01t4E000000H6r9QAC"}},{"attributes":{"type":"Product_Relation__c","url":"/services/data/v49.0/sobjects/Product_Relation__c/a2M4E000000hMrpUAE"},"Id":"a2M4E000000hMrpUAE","Default_Name__c":"Odstoupení","From__c":"01t4E000000H6r9QAC","Is_Owner_Default__c":false,"Is_Dispatcher_Default__c":false,"Record_Type_Name__c":"Account Cancellation","Type__c":"Cancel","Order__c":"3","RecordTypeId":"0124E000000cG99QAE","From__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000H6r9QAC"},"CST_Value_ID__c":"1816-2","Name":"Běžné účty","Id":"01t4E000000H6r9QAC"}},{"attributes":{"type":"Product_Relation__c","url":"/services/data/v49.0/sobjects/Product_Relation__c/a2M4E000000hMruUAE"},"Id":"a2M4E000000hMruUAE","Default_Name__c":"Výpověď pro nesouhlas se změnou OP a Sazebníku","From__c":"01t4E000000H6r9QAC","Is_Owner_Default__c":false,"Is_Dispatcher_Default__c":false,"Record_Type_Name__c":"Account Cancellation","Type__c":"Cancel","Order__c":"4","RecordTypeId":"0124E000000cG99QAE","From__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000H6r9QAC"},"CST_Value_ID__c":"1816-2","Name":"Běžné účty","Id":"01t4E000000H6r9QAC"}}],"productParameterDefaults":{"a0f4E00000AlM3RQAV":{"value":"1 měsíc","isForFinalValidation":null},"a0f4E00000AlXp3QAF":{"value":"30.06.2020"},"a0f4E00000AlM3SQAV":{"value":""},"a0f4E00000AlM3fQAF":{"value":"TRUE","assetValue":"TRUE","isForFinalValidation":null},"a0f4E00000AlM3aQAF":{"value":"a0f4E000009cSToQAM","isForFinalValidation":null,"syncElementName":"SettlementType","stringValue":"Převod na účet"},"a0f4E00000AlM3bQAF":{"value":"111","syncElementName":"transferBankAccount"},"a0f4E00000AlM48QAF":{"value":"111","syncElementName":"transferBankCode"},"a0f4E00000AlM3cQAF":{"value":"111","syncElementName":"transferVS"},"a0f4E00000AlM3dQAF":{"value":"111","syncElementName":"transferKS"},"a0f4E00000AlM3eQAF":{"value":"111","syncElementName":"transferSS"},"a0f4E00000AlM3uQAF":{"value":"a0B4E000002WvL5UAK","isForFinalValidation":null,"stringValue":"Okružní 207, Ruda, ČR"},"a0f4E00000AlM3wQAF":{"value":true,"assetValue":null,"isForFinalValidation":false,"syncElementName":"undefined"},"a0f4E00000AlM3xQAF":{"value":"111","syncElementName":"IBAN"},"a0f4E00000AlM3yQAF":{"value":"111","syncElementName":"BIC"},"a0f4E00000AlM3zQAF":{"value":"111","syncElementName":"recepientAddress"},"a0f4E00000AlM40QAF":{"value":"1111","syncElementName":"recepientBankAddress"},"a0f4E00000AlM41QAF":{"value":"111","syncElementName":"transferCurrency"},"a0f4E00000AlM42QAF":{"value":"a0f4E00000AlM4OQAV","isForFinalValidation":null,"syncElementName":"transferFeeCode","stringValue":"SHA"},"a0f4E00000AlM43QAF":{"value":true,"assetValue":null,"isForFinalValidation":false,"syncElementName":"transferToRussia"},"a0f4E00000AlM44QAF":{"value":"111","syncElementName":"transferBankAccountRussia"},"a0f4E00000AlM45QAF":{"value":"111","syncElementName":"BIK"},"a0f4E00000AlM3vQAF":{"value":"111","syncElementName":"VoCode"},"a0f4E00000AlM46QAF":{"value":"111","syncElementName":"transferTaxCode"},"a0f4E00000AlM47QAF":{"value":"111","syncElementName":"KPP"},"a0f4E00000AlM4CQAV":{"value":""},"a0f4E00000AlM4DQAV":{"value":""},"a0f4E00000AlM3gQAF":{"value":"a0f4E00000AlM4JQAV","isForFinalValidation":null},"a0f4E00000AlM3iQAF":{"value":""},"a0f4E00000AlM3jQAF":{"value":""},"a0f4E00000AlM3kQAF":{"value":""},"a0f4E00000AlM3lQAF":{"value":""},"a0f4E00000AlM3mQAF":{"value":""},"a0f4E00000AlM3nQAF":{"value":""},"a0f4E00000AlM3oQAF":{"value":"a0f4E00000AlM4NQAV","isForFinalValidation":null},"a0f4E00000AlM3hQAF":{"value":false,"assetValue":null,"isForFinalValidation":false},"a0f4E00000AlM3pQAF":{"value":""},"a0f4E00000AlM3qQAF":{"value":""},"a0f4E00000AlM3rQAF":{"value":""},"a0f4E00000AlM3sQAF":{"value":""},"a0f4E00000AlM3tQAF":{"value":""},"a0f4E00000AlM3XQAV":{"value":"2500","isForFinalValidation":null},"a0f4E00000AlM3WQAV":{"value":"-3 642.01","assetValue":"-3 642.01","isForFinalValidation":null},"a0f4E00000AlM3VQAV":{"value":"166","isForFinalValidation":null},"a0f4E00000AlM3TQAV":{"value":""},"a0f4E00000AlM49QAF":{"value":false,"assetValue":null,"isForFinalValidation":false},"a0f4E00000AlM3UQAV":{"value":"0","isForFinalValidation":null},"a0f4E00000AlM4BQAV":{"value":"1000","assetValue":"1000","isForFinalValidation":null},"a0f4E00000AlM3ZQAV":{"value":false,"assetValue":null,"isForFinalValidation":false},"a0f4E00000AlM3YQAV":{"value":true,"assetValue":null,"isForFinalValidation":false},"a0f4E00000ArJADQA3":{"value":"02i4E000000DlFXQA0","isForFinalValidation":null},"a0f4E00000AlM4AQAV":{"value":"ČSOB Internetové bankovnictví","assetValue":"ČSOB Internetové bankovnictví","isForFinalValidation":null}},"productName":"Běžný účet v CZK","productId":"01t4E000000H8vmQAC","isOwner":true,"isCard":false,"enhancedProductParameterDefaults":null,"disponentText":null,"disponentId":null,"assetId":"02i4E000001OyGaQAK","assetBankSystem":"2","assetAccountNumber":"34225734"}}}0');
        Test.stopTest();
        System.assertEquals('success', cardsWrapper.successMessage);
        *//*Case theCase = [SELECT Id, Approval_Comment__c, Migration_Premium_Product_List_Conf__c, Migration_Premium_Product_Relations_Conf__c, Description, PCF_Unfinished__c FROM Case WHERE Id =: createCaseWrapper.theCaseId];
        List<DMS_Document__c> docList = [SELECT Id, Case__c FROM DMS_Document__c WHERE Id = :theDmsDocument.Id LIMIT 1];

        System.assertNotEquals(null, theCase);
        System.assertEquals('conf', theCase.Migration_Premium_Product_List_Conf__c);
        //System.assertEquals('conf2' + '0', theCase.Migration_Premium_Product_Relations_Conf__c);
        System.assertEquals('some note', theCase.Description);
        System.assertEquals('testcomment', theCase.Approval_Comment__c);
        System.assertNotEquals(null, docList);
        System.assertNotEquals(true, docList.isEmpty());
        System.assertEquals(false, theCase.PCF_Unfinished__c);
        System.assertEquals(createCaseWrapper.theCaseId, docList.get(0).Case__c);*//*
    }*/

//    @isTest static void assignCaseTest() {
//        setupData();
//
//        Test.startTest();
//        MigrationPremiumController.CreateCaseWrapper createCaseWrapper = MigrationPremiumController.createCase(theAccount.Id, null, 'conf', 'conf2', '{"ppid":{"fieldName":"Approval_Comment__c","value":"testcomment"}}', 'some note', null, '', '', '', '', migrationPremiumProcessConfiguration.Id, '0',null,null,null,null,'submit','', false, '');
//        Case theCase = [SELECT Id, PCF_Unfinished__c FROM Case WHERE Id =: createCaseWrapper.theCaseId];
//        System.assertNotEquals(null, theCase);
//        System.assertEquals(true, theCase.PCF_Unfinished__c);
//        String n = MigrationPremiumController.assignCase('notAnId', 'notAnId');
//        String s = MigrationPremiumController.assignCase(theCase.Id, migrationPremiumProcessConfiguration.Id);
//        Test.stopTest();
//
//        System.assertEquals(null, n);
//        System.assertEquals(theCase.Id, s);
//        Case assignCase = [SELECT Id, PCF_Unfinished__c FROM Case WHERE Id = :s];
//        System.assertEquals(false, assignCase.PCF_Unfinished__c);
//    }

 /*   @isTest static void getTerminationFeeTest() {
        setupDataAccountCancellation();
        theAsset.Quantity = 220;
        theAsset.Currency_Code__c = '39';
        CST_Value__c theCst = new CST_Value__c();
        CST_Value__c theCstRelated = new CST_Value__c();
        theCstRelated.Data_ID__C = '3';
        theCstRelated.CST_Value_ID__c = '3';
        insert theCstRelated;
        theCst.Related_Value_4__c = theCstRelated.Id;
        theCst.Data_ID__C = '54';
        theCst.CST_Value_ID__c = '54';
        insert theCst;
        theAsset.CST_Value__c = theCst.Id;
        update theAsset;
        Test.startTest();
        String valueRet = MigrationPremiumController.getTerminationFee(theAsset.Id, '1816-24');
        Test.stopTest();

        System.assertEquals(valueRet, null);

    }*/

    /*@isTest static void bagettaTest() {
        setupData();
        List<ISTS_Bagetta__c> listOfBaggetts = new List<ISTS_Bagetta__c>();
        ISTS_Bagetta__c theBagetta = new ISTS_Bagetta__c();
        theBagetta.Name = 'Sipo';
        theBagetta.Product_Parameter_Id__c = '1';
        ISTS_Bagetta__c theBagetta2 = new ISTS_Bagetta__c();
        theBagetta2.Name = 'Duchod';
        theBagetta2.Product_Parameter_Id__c = '2';
        ISTS_Bagetta__c theBagetta3 = new ISTS_Bagetta__c();
        theBagetta3.Name = 'Datum Podani';
        theBagetta3.Product_Parameter_Id__c = '3';
        ISTS_Bagetta__c theBagetta4 = new ISTS_Bagetta__c();
        theBagetta4.Name = 'Bagetta Date';
        theBagetta4.Product_Parameter_Id__c = '4';
        listOfBaggetts.add(theBagetta);
        listOfBaggetts.add(theBagetta2);
        listOfBaggetts.add(theBagetta3);
        listOfBaggetts.add(theBagetta4);
        insert listOfBaggetts;
        System.assertEquals(MigrationPremiumController.sipoId, theBagetta.Product_Parameter_Id__c);
        System.assertEquals(MigrationPremiumController.duchodId, theBagetta2.Product_Parameter_Id__c);
        System.assertEquals(MigrationPremiumController.datumPodaniId, theBagetta3.Product_Parameter_Id__c);
        System.assertEquals(MigrationPremiumController.bagettaDateId, theBagetta4.Product_Parameter_Id__c);
        System.assertEquals(MigrationPremiumController.migrationAsset, null);
        System.assertEquals(MigrationPremiumController.migrationProduct, null);
    }*/

    @isTest static void controllerTest2() {
        setupData();
        /*setupDataAccountCancellation();
        DMS_Document__c theDmsDocument = new DMS_Document__c();
        theDmsDocument.Case__c = TestUtils.getCase(theAccount, migrationPremiumProcessConfigurationAccountCancel.Case_Type__c, migrationPremiumProcessConfigurationAccountCancel.Case_Content__c).Id;
        theDmsDocument.External_ID__c = '1234567890test';
        insert theDmsDocument;*/
        Test.startTest();
        //Test.setMock(WebServiceMock.class, new DpaaSWebServiceMockImpl());
        System.debug('migrationPremiumProcessConfigurationAccountCancel: ' + migrationPremiumProcessConfigurationAccountCancel);
        System.debug('theAccount: ' + theAccount);
        //MigrationPremiumController.CreateCaseWrapper createCaseWrapper = MigrationPremiumController.createCase(theAccount.Id, null, '{"selectedRow":null,"lastIndex":1,"itemMap":{"0-01t4E000000H6JrQAK":{"theProduct":{"attributes":{"type":"Product2","url":"/services/data/v50.0/sobjects/Product2/01t4E000000H6JrQAK"},"Id":"01t4E000000H6JrQAK","Name":"Privátní portfolio Asset Management","CST_Value_ID__c":"551-156","Product__c":"01t4E000000H75EQAS","Product__r":{"attributes":{"type":"Product2","url":"/services/data/v50.0/sobjects/Product2/01t4E000000H75EQAS"},"Id":"01t4E000000H75EQAS"}},"theAsset":null,"name":"Privátní portfolio Asset Management","migrationProcess":{"attributes":{"type":"Migration_Process__mdt","url":"/services/data/v50.0/sobjects/Migration_Process__mdt/m064E0000000S8lQAE"},"Id":"m064E0000000S8lQAE","DeveloperName":"PPF","Icon_Path__c":"Dualni-klient-csob.svg","Do_Not_Create_a_Case__c":false,"Store_Last_Generated_Doc_To_JSK_OnSubmit__c":false,"Title_CZ__c":"Zřízení PPF","Title_EN__c":"Zřízení PPF","Assets_In_Migration_Data_ID__c":"1816-32","Show_Current_Account_Products__c":false,"Show_Configuration_Subtab__c":true,"Final_Step_Validation__c":"ELB + Email","Case_Content__c":"69","Case_Record_Type_Developer_Name__c":"Product_Service","Case_Status__c":"24","Send_To_BAW_After_Document_Pairing__c":false,"Case_Subject__c":"Zřízení PPF","Case_Type__c":"Product Service","DMS_Document_Type_Data_ID__c":"188;189","Representative_Relation_ID__c":"5,89","Case_Branch_Data_Id__c":"6469","Product_Relation_Record_Type_Name__c":"PPF","Show_KC_Authenticator__c":false,"Selected_Tab_Default__c":"Configuration","All_DMS_Document_IDs__c":"188;189","Show_File_Selector__c":false,"Show_General_Subtab__c":false,"Left_Panel_Hidator__c":true,"Show_FO_Products_on_FOP__c":false,"Show_FOP_Products_on_FO__c":false,"Load_Parent_Product_Config__c":true,"At_Least_One_Attachment_Is_Required__c":false,"Hide_Transition_Subtab__c":true,"Transition_Subtab_CZ_Label__c":"Varianta","Transition_Subtab_EN_Label__c":"Transitions","Configuration_Subtab_CZ_Label__c":"Nastavení","Configuration_Subtab_EN_Label__c":"Configuration","Overview_Tab_CZ_Label__c":"Tisk smlouvy a dokončení migrace","Overview_Tab_EN_Label__c":"Overview","Configuration_Tab_CZ_Label__c":"Konfigurace","Configuration_Tab_EN_Label__c":"Configuration","Case_Sent_Message__c":"Požadavek na zpracování pojištění byl úspěšně odeslán","Use_Preterm_Document_List__c":false,"Assign_To_User__c":false},"lastIndex":0,"isSelected":true,"isReadOnly":false,"isMigrationCard":false,"index":0,"hasSubProducts":false,"dispatcher":null,"defaultSelected":true,"childItemMap":{}}}}', '{"GENERAL":{"a2M4E000000HjDqUAK":{"selectedRelationId":"a2M4E000000HjDqUAK","productRelationList":[{"attributes":{"type":"Product_Relation__c","url":"/services/data/v49.0/sobjects/Product_Relation__c/a2M4E000000HjDqUAK"},"Id":"a2M4E000000HjDqUAK","Default_Name__c":"Rušení účtů","RecordTypeId":"0124E000000cG99QAE"}],"productParameterDefaults":{"a0f4E000009cRrAQAU":{"value":"a0f4E000009cRrFQAU","isForFinalValidation":null,"syncElementName":"undefined","stringValue":"Majitel"},"a0f4E000009cRtCQAU":{"value":"a0f4E000009cSW4QAM","isForFinalValidation":null},"a0f4E00000AdAJiQAN":{"value":"existující klient","assetValue":"existující klient","isForFinalValidation":null},"a0f4E00000AAIo4QAH":{"value":""},"a0f4E000009cSD4QAM":{"value":""},"a0f4E000009xo6mQAA":{"value":""},"a0f4E000009xo6rQAA":{"value":""},"a0f4E000009xo7NQAQ":{"value":""},"a0f4E000009cSDaQAM":{"value":""},"a0f4E000009cSDfQAM":{"value":""},"a0f4E000009xo9RQAQ":{"value":""},"a0f4E000009xo9MQAQ":{"value":""},"a0f4E000009xoIkQAI":{"value":""},"a0f4E000009cSEBQA2":{"value":""},"a0f4E00000AlYGoQAN":{"value":""},"a0f4E000009cSEGQA2":{"value":""},"a0f4E000009cSELQA2":{"value":""},"a0f4E000009xo7SQAQ":{"value":""},"a0f4E000009cRrBQAU":{"value":"a0f4E000009cRwBQAU","isForFinalValidation":null,"syncElementName":"undefined","stringValue":"Občanský průkaz"},"a0f4E000009cRxIQAU":{"value":""},"a0f4E000009cSAZQA2":{"value":""},"a0f4E000009cSB5QAM":{"value":""},"a0f4E000009cSBAQA2":{"value":""},"a0f4E000009cSJQQA2":{"value":"a0f4E000009cSToQAM","isForFinalValidation":null,"syncElementName":"SettlementType"},"a0f4E000009cSKcQAM":{"value":""},"a0f4E000009cSKmQAM":{"value":"a0B4E000002WvL5UAK","isForFinalValidation":null},"a0f4E00000AAIptQAH":{"value":""},"a0f4E00000AAIpyQAH":{"value":""},"a0f4E00000AAIq3QAH":{"value":""},"a0f4E00000AAIqZQAX":{"value":""}},"productName":"NAME","productId":null,"isOwner":null,"isCard":false,"enhancedProductParameterDefaults":null,"disponentText":null,"disponentId":null,"assetId":null,"assetBankSystem":null,"assetAccountNumber":null}},"999-01t4E000000H8vmQAC":{"1-01t4E000000H6nXQAS":{"selectedRelationId":"a2M4E000000h4U8UAI","productRelationList":[{"attributes":{"type":"Product_Relation__c","url":"/services/data/v49.0/sobjects/Product_Relation__c/a2M4E000000h4U8UAI"},"Id":"a2M4E000000h4U8UAI","Default_Name__c":"Odevzdal","From__c":"01t4E000000fZm1QAE","Is_Owner_Default__c":false,"Is_Dispatcher_Default__c":false,"Record_Type_Name__c":"CSOBS_contract_cancelation","Type__c":"Cancel","Order__c":"1","RecordTypeId":"0124E000000cG99QAE","From__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000fZm1QAE"},"CST_Value_ID__c":"1816-47","Name":"Debetní karty","Id":"01t4E000000fZm1QAE"}},{"attributes":{"type":"Product_Relation__c","url":"/services/data/v49.0/sobjects/Product_Relation__c/a2M4E000000h4UDUAY"},"Id":"a2M4E000000h4UDUAY","Default_Name__c":"Neodevzdal","From__c":"01t4E000000fZm1QAE","Is_Owner_Default__c":false,"Is_Dispatcher_Default__c":false,"Record_Type_Name__c":"CSOBS_contract_cancelation","Type__c":"Cancel","Order__c":"2","RecordTypeId":"0124E000000cG99QAE","From__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000fZm1QAE"},"CST_Value_ID__c":"1816-47","Name":"Debetní karty","Id":"01t4E000000fZm1QAE"}}],"productParameterDefaults":{},"productName":"Debit MC ctls","productId":"01t4E000000H6nXQAS","isOwner":true,"isCard":false,"enhancedProductParameterDefaults":null,"disponentText":null,"disponentId":null,"assetId":"02i4E0000027wtzQAA","assetBankSystem":"16","assetAccountNumber":"**** **** **26 5457"},"0-01t4E000000H8vmQAC":{"selectedRelationId":"a2M4E000000hMrkUAE","productRelationList":[{"attributes":{"type":"Product_Relation__c","url":"/services/data/v49.0/sobjects/Product_Relation__c/a2M4E000000hMrkUAE"},"Id":"a2M4E000000hMrkUAE","Default_Name__c":"Výpověď","From__c":"01t4E000000H6r9QAC","Is_Owner_Default__c":false,"Is_Dispatcher_Default__c":false,"Record_Type_Name__c":"CSOBS_contract_cancelation","Type__c":"Cancel","Order__c":"1","RecordTypeId":"0124E000000cG99QAE","From__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000H6r9QAC"},"CST_Value_ID__c":"1816-2","Name":"Běžné účty","Id":"01t4E000000H6r9QAC"}},{"attributes":{"type":"Product_Relation__c","url":"/services/data/v49.0/sobjects/Product_Relation__c/a2M4E000000HorJUAS"},"Id":"a2M4E000000HorJUAS","Default_Name__c":"Dohoda","From__c":"01t4E000000H6r9QAC","Is_Owner_Default__c":false,"Is_Dispatcher_Default__c":false,"Record_Type_Name__c":"CSOBS_contract_cancelation","Type__c":"Cancel","Order__c":"2","RecordTypeId":"0124E000000cG99QAE","From__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000H6r9QAC"},"CST_Value_ID__c":"1816-2","Name":"Běžné účty","Id":"01t4E000000H6r9QAC"}},{"attributes":{"type":"Product_Relation__c","url":"/services/data/v49.0/sobjects/Product_Relation__c/a2M4E000000hMrpUAE"},"Id":"a2M4E000000hMrpUAE","Default_Name__c":"Odstoupení","From__c":"01t4E000000H6r9QAC","Is_Owner_Default__c":false,"Is_Dispatcher_Default__c":false,"Record_Type_Name__c":"CSOBS_contract_cancelation","Type__c":"Cancel","Order__c":"3","RecordTypeId":"0124E000000cG99QAE","From__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000H6r9QAC"},"CST_Value_ID__c":"1816-2","Name":"Běžné účty","Id":"01t4E000000H6r9QAC"}},{"attributes":{"type":"Product_Relation__c","url":"/services/data/v49.0/sobjects/Product_Relation__c/a2M4E000000hMruUAE"},"Id":"a2M4E000000hMruUAE","Default_Name__c":"Výpověď pro nesouhlas se změnou OP a Sazebníku","From__c":"01t4E000000H6r9QAC","Is_Owner_Default__c":false,"Is_Dispatcher_Default__c":false,"Record_Type_Name__c":"CSOBS_contract_cancelation","Type__c":"Cancel","Order__c":"4","RecordTypeId":"0124E000000cG99QAE","From__r":{"attributes":{"type":"Product2","url":"/services/data/v49.0/sobjects/Product2/01t4E000000H6r9QAC"},"CST_Value_ID__c":"1816-2","Name":"Běžné účty","Id":"01t4E000000H6r9QAC"}}],"productParameterDefaults":{"a0f4E00000AlM3RQAV":{"value":"1 měsíc","isForFinalValidation":null},"a0f4E00000AlXp3QAF":{"value":"30.06.2020"},"a0f4E00000AlM3SQAV":{"value":""},"a0f4E00000AlM3fQAF":{"value":"TRUE","assetValue":"TRUE","isForFinalValidation":null},"a0f4E00000AlM3aQAF":{"value":"a0f4E000009cSToQAM","isForFinalValidation":null,"syncElementName":"SettlementType","stringValue":"Převod na účet"},"a0f4E00000AlM3bQAF":{"value":"111","syncElementName":"transferBankAccount"},"a0f4E00000AlM48QAF":{"value":"111","syncElementName":"transferBankCode"},"a0f4E00000AlM3cQAF":{"value":"111","syncElementName":"transferVS"},"a0f4E00000AlM3dQAF":{"value":"111","syncElementName":"transferKS"},"a0f4E00000AlM3eQAF":{"value":"111","syncElementName":"transferSS"},"a0f4E00000AlM3uQAF":{"value":"a0B4E000002WvL5UAK","isForFinalValidation":null,"stringValue":"Okružní 207, Ruda, ČR"},"a0f4E00000AlM3wQAF":{"value":true,"assetValue":null,"isForFinalValidation":false,"syncElementName":"undefined"},"a0f4E00000AlM3xQAF":{"value":"111","syncElementName":"IBAN"},"a0f4E00000AlM3yQAF":{"value":"111","syncElementName":"BIC"},"a0f4E00000AlM3zQAF":{"value":"111","syncElementName":"recepientAddress"},"a0f4E00000AlM40QAF":{"value":"1111","syncElementName":"recepientBankAddress"},"a0f4E00000AlM41QAF":{"value":"111","syncElementName":"transferCurrency"},"a0f4E00000AlM42QAF":{"value":"a0f4E00000AlM4OQAV","isForFinalValidation":null,"syncElementName":"transferFeeCode","stringValue":"SHA"},"a0f4E00000AlM43QAF":{"value":true,"assetValue":null,"isForFinalValidation":false,"syncElementName":"transferToRussia"},"a0f4E00000AlM44QAF":{"value":"111","syncElementName":"transferBankAccountRussia"},"a0f4E00000AlM45QAF":{"value":"111","syncElementName":"BIK"},"a0f4E00000AlM3vQAF":{"value":"111","syncElementName":"VoCode"},"a0f4E00000AlM46QAF":{"value":"111","syncElementName":"transferTaxCode"},"a0f4E00000AlM47QAF":{"value":"111","syncElementName":"KPP"},"a0f4E00000AlM4CQAV":{"value":""},"a0f4E00000AlM4DQAV":{"value":""},"a0f4E00000AlM3gQAF":{"value":"a0f4E00000AlM4JQAV","isForFinalValidation":null},"a0f4E00000AlM3iQAF":{"value":""},"a0f4E00000AlM3jQAF":{"value":""},"a0f4E00000AlM3kQAF":{"value":""},"a0f4E00000AlM3lQAF":{"value":""},"a0f4E00000AlM3mQAF":{"value":""},"a0f4E00000AlM3nQAF":{"value":""},"a0f4E00000AlM3oQAF":{"value":"a0f4E00000AlM4NQAV","isForFinalValidation":null},"a0f4E00000AlM3hQAF":{"value":false,"assetValue":null,"isForFinalValidation":false},"a0f4E00000AlM3pQAF":{"value":""},"a0f4E00000AlM3qQAF":{"value":""},"a0f4E00000AlM3rQAF":{"value":""},"a0f4E00000AlM3sQAF":{"value":""},"a0f4E00000AlM3tQAF":{"value":""},"a0f4E00000AlM3XQAV":{"value":"2500","isForFinalValidation":null},"a0f4E00000AlM3WQAV":{"value":"-3 642.01","assetValue":"-3 642.01","isForFinalValidation":null},"a0f4E00000AlM3VQAV":{"value":"166","isForFinalValidation":null},"a0f4E00000AlM3TQAV":{"value":""},"a0f4E00000AlM49QAF":{"value":false,"assetValue":null,"isForFinalValidation":false},"a0f4E00000AlM3UQAV":{"value":"0","isForFinalValidation":null},"a0f4E00000AlM4BQAV":{"value":"1000","assetValue":"1000","isForFinalValidation":null},"a0f4E00000AlM3ZQAV":{"value":false,"assetValue":null,"isForFinalValidation":false},"a0f4E00000AlM3YQAV":{"value":true,"assetValue":null,"isForFinalValidation":false},"a0f4E00000ArJADQA3":{"value":"02i4E000000DlFXQA0","isForFinalValidation":null},"a0f4E00000AlM4AQAV":{"value":"ČSOB Internetové bankovnictví","assetValue":"ČSOB Internetové bankovnictví","isForFinalValidation":null}},"productName":"Běžný účet v CZK","productId":"01t4E000000H8vmQAC","isOwner":true,"isCard":false,"enhancedProductParameterDefaults":null,"disponentText":null,"disponentId":null,"assetId":"02i4E000001OyGaQAK","assetBankSystem":"2","assetAccountNumber":"34225734"}}}0', '', 'some note', '', '', '', '', '', migrationPremiumProcessConfigurationAccountCancel.Id, '0',null,null,null,null,'submit',''/*, false, ''*/);
        ApexPages.currentPage().getParameters().put('accountId', theAccount.Id);
        ApexPages.currentPage().getParameters().put('migration_process', 'CSOBS_contract_cancelation');
        //ApexPages.currentPage().getParameters().put('caseId', createCaseWrapper.theCaseId);
        MigrationPremiumController cntrl = new MigrationPremiumController();
        String mapOfProd = cntrl.mapOfReadOnlyProductsPerId;
        boolean isCz = cntrl.isCzech;
        Account theAcc = MigrationPremiumController.theAccount;
        String userID = MigrationPremiumController.theUserId;
        List<String> listOfStrings = cntrl.cancellatonValidation;
        //cntrl.isValid = true;
        Test.stopTest();
    }

    @isTest static void updateOppTest() {
        //setupDataAccountCancellation();
        theOpp = TestDataFactory.getOpportunity();
        insert theOpp;
        Test.startTest();
        //Test.setMock(WebServiceMock.class, new DpaaSWebServiceMockImpl());
        MigrationPremiumTypes.ApiFieldWrapper apiWrap = new MigrationPremiumTypes.ApiFieldWrapper();
        apiWrap.fieldName = 'Description';
        apiWrap.value = 'test';
        apiWrap.wantEncryptFields = 'false';
        Map<String, MigrationPremiumTypes.ApiFieldWrapper> mapOfApi = new Map<String, MigrationPremiumTypes.ApiFieldWrapper>();
        mapOfApi.put('1',apiWrap);
        MigrationPremiumController.OppWrapper theWrap = MigrationPremiumController.updateOpp(theOpp.Id, JSON.serialize(mapOfApi));
        Test.stopTest();
        System.assertEquals(theWrap.theOppId, theOpp.Id);
    }

    @isTest static void saveCaseAttachmentTest() {
        setupData();
        Test.startTest();
        MigrationPremiumController.CreateCaseWrapper createCaseWrapper = MigrationPremiumController.createCase(theAccount.Id, null, 'conf', 'conf2', '{"ppid":{"fieldName":"Description","value":"testcomment"}}', 'some note', null, '', '', '', '', migrationPremiumProcessConfiguration.Id, '0',null,null,null,null,'submit','',''/*, false, ''*/);
        Case theCase = [SELECT Id, PCF_Unfinished__c FROM Case WHERE Id =: createCaseWrapper.theCaseId];
        System.assertNotEquals(null, theCase);
        MigrationPremiumTypes.File theFile = new MigrationPremiumTypes.File();
        theFile.name='fName.txt';
        theFile.size='4';
        theFile.data='data';
        theFile.uniqueId='7007';
        String size = MigrationPremiumController.saveCaseAttachment(JSON.serialize(theFile), theCase.Id);
        Test.stopTest();
        System.assertEquals('4', size);
        //System.assertEquals(1, [SELECT Id FROM Attachment WHERE ParentId = :theCase.Id].size());
    }

    @isTest
    public static void getProductParametersTest(){
        setupData();

        Test.startTest();
        MigrationPremiumController.getProductParameters(theProductRelation.Id, null, migrationPremiumProcessConfiguration.Id, theAccount.Id, null, theProduct.Id);
        Test.stopTest();
    }

   /* @isTest
    public static void calculateBagettaDateTest(){
        setupData();
        *//*DMS_Document__c theDmsDocument = new DMS_Document__c();
        theDmsDocument.Case__c = TestUtils.getCase(theAccount, migrationPremiumProcessConfigurationAccountCancel.Case_Type__c, migrationPremiumProcessConfigurationAccountCancel.Case_Content__c).Id;
        theDmsDocument.External_ID__c = '1234567890test';
        insert theDmsDocument;*//*
        Test.startTest();
        String retValue = MigrationPremiumController.calculateBagettaDate('21.02.2000', false, false);
        Test.stopTest();
        system.assertEquals('7.3.2000', retValue);
    }*/

/*    @isTest
    public static void storeToJSKTest(){
//        TestUtils.createAddressConfigurationCustomSettings();
        Test.setMock(WebServiceMock.class, new DPaaSWebServiceSearchMock());

        GDPR_Custom_Settings__c gdprCs = new GDPR_Custom_Settings__c();
        gdprCs.Order_Document_ID__c = '196';
        gdprCs.Order2_Document_ID__c = '197';
        gdprCs.RH_Queue_Developer_Name__c = 'GDPR';
        gdprCs.Automatic_application__c = '70;74';
        gdprCs.Prolong_period__c = 60;
//        gdprCs.RH_Organization_Unit_ID__c = '212';
        insert gdprCs;

        TestUtils.setupDmsTypeOfDocCustomSettings();

        User u = TestUtils.getUser();
        Account acc = TestUtils.getPersonAccount('123456');
        Product2 pDomain = TestUtils.getProduct('testProductDomain', '1', 0, null, '1816');

        Case theCase =  TestUtils.getCase(acc, 'GDPR', '100', pDomain);
        theCase.Term_Prolongation__c = 0;
        theCase.Status = '10';
        theCase.Type_of_Request__c = '2';
        theCase.OwnerId = u.Id;
        theCase.Subject = 'GDPR test case parent';
        theCase.Answer_Form__c = '20';
        theCase.Language__c = '1';
        theCase.Handling_form__c = '9';
        theCase.Description = 'blabla';
        theCase.Application_Descriptions__c = '{"applicationDescriptionMap":{"71":"bla1","70":"bla0"}}';
        theCase.GDPR_Requirements__c = '70;71';
        theCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GDPR').getRecordTypeId();
        update theCase;

        DMS_Document__c doc = new DMS_Document__c();
        doc.Case__c = theCase.Id;
        doc.Type_Of_Document__c = '197';
        doc.Document_Name__c = 'aaa';
        String uniqueKey =
                EncodingUtil.convertToHex(
                        Crypto.generateDigest('MD5', Blob.valueOf(Crypto.getRandomLong().format()))
                );
        doc.External_ID__c = uniqueKey;
        doc.Account__c = acc.Id;
        insert doc;

        ApexPages.currentPage().getParameters().put('id', doc.Id);

        TestUtils.getOurDataIdForBankSystem();
        TestUtils.setTHUBEndpointURL();
        TestUtils.setIntegrationCertificates();
        TestUtils.getCredentials(GlobalConstants.CREDENTIALS_CS_THUB_KEY, 'thubuser', 'thubpwd');
        // CypherCloud API call
        TestUtils.getCcAppNameCustomSettings();
        Test.startTest();
        StoreDocumentApiTypes.Result_element resultElement = MigrationPremiumController.storeToJSK(doc.Id, true, '777', false);
        Test.stopTest();

        System.assertEquals(null, resultElement);

    }*/

    /*@isTest
    public static void getCaseStatusForSendingToBAWTest(){
        setupData();
        Test.startTest();
        DMS_Document__c theDmsDocument = new DMS_Document__c();
        theDmsDocument.Case__c = TestUtils.getCase(theAccount, migrationPremiumProcessConfigurationAccountCancel.Case_Type__c, migrationPremiumProcessConfigurationAccountCancel.Case_Content__c).Id;
        theDmsDocument.External_ID__c = '1234567890test';
        insert theDmsDocument;
        List<String> listOfIds = new List<String>();
        listOfIds.add(theDmsDocument.Id);
        String returnValue = MigrationPremiumController.getCaseStatusForSendingToBAW(listOfIds);
        Test.stopTest();
        System.assertEquals('10', returnValue);
    }*/

    @istest
    public static void getSubProductListTest(){
        setupData();

        Test.startTest();
        MigrationPremiumController.getSubProductList(null, migrationPremiumProcessConfiguration.Id);
        MigrationPremiumController.getSubProductList(theProduct.Id, migrationPremiumProcessConfiguration.Id);
        Test.stopTest();
    }

    @isTest
    public static void initTest(){
        setupData();
        //Test.setMock(WebServiceMock.class, new DpaaSWebServiceMockImpl());
        Test.startTest();
        ApexPages.currentPage().getParameters().put('accountId', theAccount.Id);
        ApexPages.currentPage().getParameters().put('assetId', theAsset.Id);
        ApexPages.currentPage().getParameters().put('migration_process', 'CSOBS_contract_cancelation');

        System.debug(theAsset.Id);
        MigrationPremiumController cntrl = new MigrationPremiumController();
        cntrl.selectedItems = new MigrationPremiumTypes.ItemsWrapper();
        cntrl.selectedItems.itemMap = new Map<String, MigrationPremiumTypes.Item>();
        MigrationPremiumTypes.Item parent = new MigrationPremiumTypes.Item(migrationPremiumProcessConfiguration, theAsset, true, 1, true);
        parent.theProduct = theProduct;
        MigrationPremiumTypes.Item child = new MigrationPremiumTypes.Item(migrationPremiumProcessConfiguration, theAsset, true, 1, true);
        child.theProduct = theProduct;
        parent.childItemMap.put(theAsset.Id, new MigrationPremiumTypes.Item(migrationPremiumProcessConfiguration, theAsset, true, 1, true));
        parent.childItemMap.get(theAsset.Id).theProduct = theProduct;
        cntrl.selectedItems.itemMap.put('1', parent);
        Test.stopTest();
        System.assertNotEquals(cntrl.assetProductRelationMapJSON, null);
    }

    @isTest
    public static void initTest2(){
        setupData();
        //Test.setMock(WebServiceMock.class, new DpaaSWebServiceMockImpl());
        Test.startTest();

        MigrationPremiumController.CreateCaseWrapper createCaseWrapper = MigrationPremiumController.createCase(theAccount.Id, null, '{}', '{}', '{"ppid":{"fieldName":"Description","value":"some note"}}', 'some note', '', '', '', '', '', migrationPremiumProcessConfiguration.Id, '0',null,null,null,null,'submit','',''/*, false, ''*/);

        ApexPages.currentPage().getParameters().put('accountId', theAccount.Id);
        //ApexPages.currentPage().getParameters().put('assetId', theAsset.Id);
        ApexPages.currentPage().getParameters().put('caseId', createCaseWrapper.theCaseId);
        ApexPages.currentPage().getParameters().put('migration_process', 'CSOBS_contract_cancelation');

        System.debug(theAsset.Id);
        MigrationPremiumController cntrl = new MigrationPremiumController();
        /*cntrl.selectedItems = new MigrationPremiumTypes.ItemsWrapper();
        cntrl.selectedItems.itemMap = new Map<String, MigrationPremiumTypes.Item>();
        MigrationPremiumTypes.Item parent = new MigrationPremiumTypes.Item(migrationPremiumProcessConfiguration, theAsset, true, 1, true);
        parent.theProduct = theProduct;
        MigrationPremiumTypes.Item child = new MigrationPremiumTypes.Item(migrationPremiumProcessConfiguration, theAsset, true, 1, true);
        child.theProduct = theProduct;
        parent.childItemMap.put(theAsset.Id, new MigrationPremiumTypes.Item(migrationPremiumProcessConfiguration, theAsset, true, 1, true));
        parent.childItemMap.get(theAsset.Id).theProduct = theProduct;
        cntrl.selectedItems.itemMap.put('1', parent);*/
        Test.stopTest();
        //System.assertNotEquals(cntrl.assetProductRelationMapJSON, null);
    }

    @isTest
    public static void testProperties(){
        setupData();
        //Test.setMock(WebServiceMock.class, new DPaaSWebServiceSearchMock());
        Test.startTest();
        ApexPages.currentPage().getParameters().put('accountId', theAccount.Id);
        ApexPages.currentPage().getParameters().put('assetId', theAsset.Id);
        ApexPages.currentPage().getParameters().put('migration_process', 'CSOBS_contract_cancelation');
        MigrationPremiumController cntrl = new MigrationPremiumController();
        cntrl.savedConfiguration = true;
        Test.stopTest();
        System.assertEquals(cntrl.savedProductRelationsData, null);
        System.assertEquals(cntrl.defaultNoteText, null);
        cntrl.savedConfiguration = false;
        System.assertNotEquals(cntrl.selectedItemsWrapperJSON, null);
        System.assertNotEquals(cntrl.allItemsJSON, null);
        System.assertEquals(cntrl.debetCardsList.isEmpty(), true);
/*        System.assertNotEquals(null, cntrl.finalStepValidation);
        System.assertEquals(null, cntrl.finalStepValEmail);
        System.assertEquals(1, cntrl.finalStepValErrSize);*/
        System.assert(!cntrl.showElDistribAgreement);
        System.assert(cntrl.elDistribAgreement);
        System.assertEquals(null, cntrl.firstUrlOfDmsDocument);
        System.assertEquals(null, cntrl.firstMessageBeforePrint);

    }

    @isTest
    public static void getProductParameters(){
        setupData();
        MigrationPremiumController.getProductParameters(theProductRelation.Id, theAsset.Id, migrationPremiumProcessConfiguration.Id, theAccount.Id, null, theProduct.Id);
    }

    @isTest static void getChildProductParametersFromSOQL(){
        setupData();
        MigrationPremiumController.getChildProductParametersFromSOQL(theProductParameter3);
    }

    @isTest static void getChildProductParametersFromSOQLWithEncNullChecks(){
        setupData();
        Test.startTest();
        theProductParameter3.SOQL__c = 'SELECT Id FROM Account';
        MigrationPremiumController.getChildProductParametersFromSOQL(theProductParameter3);
        Test.stopTest();
    }

    @isTest static void migrationPremiumTypesTest(){
        setupData();
        MigrationPremiumTypes.Item item1 = new MigrationPremiumTypes.Item(migrationPremiumProcessConfiguration, theAsset, 1);
        MigrationPremiumTypes.Item item2 = new MigrationPremiumTypes.Item(migrationPremiumProcessConfiguration, theAsset, theAccount.Id, 1);
        MigrationPremiumTypes.Item item3 = new MigrationPremiumTypes.Item(migrationPremiumProcessConfiguration, theAsset, false, 1);
        MigrationPremiumTypes.DispatcherWrapper wrapper = new MigrationPremiumTypes.DispatcherWrapper('1', '2', '3');
        MigrationPremiumTypes.TransitionItemDefault defaultX = new MigrationPremiumTypes.TransitionItemDefault();
        defaultX.value = '';
        defaultX.assetValue = '';
        MigrationPremiumTypes.TransitionItem tItem = new MigrationPremiumTypes.TransitionItem(theAsset, String.valueOf(theAccount.Id), '1', 'a', new List<Product_Relation__c>());
    }

    /*@isTest static void migrationPremiumExtension(){
        Test.setMock(WebServiceMock.class, new DpaaSWebServiceMockImpl());
        setupData();
        Test.startTest();
        String productListConf = '{"selectedRow":null,"lastIndex":1,"itemMap":{"1-01t4E000000CWoCQAW":{"theProduct":{"attributes":{"type":"Product2","url":"/services/data/v40.0/sobjects/Product2/01t4E000000CWoCQAW"},"CST_Value_ID__c":"551-14","Name":"ČSOB Aktivní konto v CZK","Product__c":"01t4E000000CX8oQAG","Id":"01t4E000000CWoCQAW"},"theAsset":{"attributes":{"type":"Asset","url":"/services/data/v40.0/sobjects/Asset/02i4E00000011PUQAY"},"Id":"02i4E00000011PUQAY","Product2Id":"01t4E000000CWoCQAW","AccountId":"0014E000002H7g0QAC","Account_Number__c":null,"RecordTypeId":"0124E000000061PQAQ","Product2":{"attributes":{"type":"Product2","url":"/services/data/v40.0/sobjects/Product2/01t4E000000CWoCQAW"},"CST_Value_ID__c":"551-14","Name":"ČSOB Aktivní konto v CZK","Product__c":"01t4E000000CX8oQAG","Id":"01t4E000000CWoCQAW"},"Account":{"attributes":{"type":"Account","url":"/services/data/v40.0/sobjects/Account/0014E000002H7g0QAC"},"Name":"Ondřej Brodecký","CUID__c":"12670538","Id":"0014E000002H7g0QAC","RecordTypeId":"0124E00000005tQQAQ"}},"name":"ČSOB Aktivní konto v CZK","lastIndex":0,"isSelected":true,"index":1,"dispatcher":null,"defaultSelected":true,"childItemMap":{}}}}';
        String productRelationsConf = '{"1-01t4E000000CWoCQAW":{"0-01t4E000000CWoCQAW":{"selectedRelationId":"a2H4E0000017UeBUAU","productRelationList":[{"attributes":{"type":"Product_Relation__c","url":"/services/data/v40.0/sobjects/Product_Relation__c/a2H4E0000017UeBUAU"},"Id":"a2H4E0000017UeBUAU","From__c":"01t4E000000CWoCQAW","To__c":"01t4E000000CX6uQAG","Is_Owner_Default__c":true,"Is_Dispatcher_Default__c":false,"To__r":{"attributes":{"type":"Product2","url":"/services/data/v40.0/sobjects/Product2/01t4E000000CX6uQAG"},"Name":"Premium Konto","Id":"01t4E000000CX6uQAG"}},{"attributes":{"type":"Product_Relation__c","url":"/services/data/v40.0/sobjects/Product_Relation__c/a2H4E0000001Dy8UAE"},"Id":"a2H4E0000001Dy8UAE","From__c":"01t4E000000CWoCQAW","To__c":"01t4E000000CWoHQAW","Is_Owner_Default__c":false,"Is_Dispatcher_Default__c":false,"To__r":{"attributes":{"type":"Product2","url":"/services/data/v40.0/sobjects/Product2/01t4E000000CWoHQAW"},"Name":"Prémiový účet v CZK","Id":"01t4E000000CWoHQAW"}}],"productName":"ČSOB Aktivní konto v CZK","isOwner":true,"isCard":false,"disponentText":null,"assetId":"02i4E00000011PUQAY","assetAccountNumber":"12345678","productParameterDefaults":{"a0A4E000000qCWnUAM":{"value":false},"a0A4E000000qCWoUAM":{"value":false},"a0A4E000000qCWpUAM":{"value":true},"a0A4E000000qCWqUAM":{"value":false},"a0A4E000000qCWrUAM":{"value":true},"a0A4E000000qCWsUAM":{"value":true},"a0A4E000000qCWtUAM":{"value":false},"a0A4E000000qCWuUAM":{"value":false},"a0A4E000000qCWlUAM":{"value":false},"a0A4E000000qEU1UAM":{"value":"Test 2","assetValue":"Test 2"},"a0A4E000000qCWmUAM":{"value":"a0A4E000000qCWwUAM","assetValue":"100000"},"a0A4E000000qFS5UAM":{"value":false}}}}}';
        MigrationPremiumController.generateIstsDocument(theAccount.Id, theAsset.Id, '142', 'ABC', productListConf, productRelationsConf, '', '', migrationPremiumProcessConfiguration.Id, '0', '','');
        MigrationPremiumIstsExtension ext = new MigrationPremiumIstsExtension();
        ext.createAddressFromData(theAccountAddress);
        Test.stopTest();
    }*/

    /*@isTest static void quoteGenerationErrTest(){
        Test.setMock(WebServiceMock.class, new DpaaSWebServiceMockImpl());
        setupICalcCustomSettings('100', '100', '', '', '/quote/quoteTemplateDataViewer.apexp?id={!QuoteId}&headerHeight={!HeaderHeight}&footerHeight={!FooterHeight}&summlid={!TemplateId}');
        setupData();
        Test.startTest();
        System.assert(MigrationPremiumController.generateQuoteForPrinting(null, null, null, null, null).contains('Neznám'));
        System.assert(MigrationPremiumController.generateQuoteForPrinting(theOpp.Id, null, null, null, null).contains('Neznám'));
        System.assert(MigrationPremiumController.generateQuoteForPrinting(theOpp.Id, null, null, theAccount.Id, null).contains('error'));
        Test.stopTest();
    }*/

    /*@isTest static void quoteGenerationErr2Test(){
        Test.setMock(WebServiceMock.class, new DpaaSWebServiceMockImpl());
        setupData();
        Test.startTest();
        System.assert(MigrationPremiumController.generateQuoteForPrinting(theOpp.Id, null, null, theAccount.Id, null).contains('error'));
        Test.stopTest();
    }*/

    /*@isTest static void quoteGenerationTest(){
        Test.setMock(WebServiceMock.class, new DpaaSWebServiceMockImpl());
        setupICalcCustomSettings('100', '100', 'abc', '', '/quote/quoteTemplateDataViewer.apexp?id={!QuoteId}&headerHeight={!HeaderHeight}&footerHeight={!FooterHeight}&summlid={!TemplateId}');
        setupData();
        setupICalcData();
        Test.startTest();
        System.assert(MigrationPremiumController.generateQuoteForPrinting(theOpp.Id, pppList, 150000.00, theAccount.Id, 'tpl1').contains('/quote/quoteTemplateDataViewer.apexp'));
        Test.stopTest();
    }*/

    /*@isTest static void migrationSavingAccountExtension(){
        Test.setMock(WebServiceMock.class, new DpaaSWebServiceMockImpl());
        setupData();
        Test.startTest();
        String productListConf = '{"selectedRow":null,"lastIndex":1,"itemMap":{"1-01t4E000000CWoCQAW":{"theProduct":{"attributes":{"type":"Product2","url":"/services/data/v40.0/sobjects/Product2/01t4E000000CWoCQAW"},"CST_Value_ID__c":"551-14","Name":"ČSOB Aktivní konto v CZK","Product__c":"01t4E000000CX8oQAG","Id":"01t4E000000CWoCQAW"},"theAsset":{"attributes":{"type":"Asset","url":"/services/data/v40.0/sobjects/Asset/02i4E00000011PUQAY"},"Id":"02i4E00000011PUQAY","Product2Id":"01t4E000000CWoCQAW","AccountId":"0014E000002H7g0QAC","Account_Number__c":null,"RecordTypeId":"0124E000000061PQAQ","Product2":{"attributes":{"type":"Product2","url":"/services/data/v40.0/sobjects/Product2/01t4E000000CWoCQAW"},"CST_Value_ID__c":"551-14","Name":"ČSOB Aktivní konto v CZK","Product__c":"01t4E000000CX8oQAG","Id":"01t4E000000CWoCQAW"},"Account":{"attributes":{"type":"Account","url":"/services/data/v40.0/sobjects/Account/0014E000002H7g0QAC"},"Name":"Ondřej Brodecký","CUID__c":"12670538","Id":"0014E000002H7g0QAC","RecordTypeId":"0124E00000005tQQAQ"}},"name":"ČSOB Aktivní konto v CZK","lastIndex":0,"isSelected":true,"index":1,"dispatcher":null,"defaultSelected":true,"childItemMap":{}}}}';
        String productRelationsConf = '{"1-01t4E000000CWoCQAW":{"0-01t4E000000CWoCQAW":{"selectedRelationId":"a2H4E0000017UeBUAU","productRelationList":[{"attributes":{"type":"Product_Relation__c","url":"/services/data/v40.0/sobjects/Product_Relation__c/a2H4E0000017UeBUAU"},"Id":"a2H4E0000017UeBUAU","From__c":"01t4E000000CWoCQAW","To__c":"01t4E000000CX6uQAG","Is_Owner_Default__c":true,"Is_Dispatcher_Default__c":false,"To__r":{"attributes":{"type":"Product2","url":"/services/data/v40.0/sobjects/Product2/01t4E000000CX6uQAG"},"Name":"Premium Konto","Id":"01t4E000000CX6uQAG"}},{"attributes":{"type":"Product_Relation__c","url":"/services/data/v40.0/sobjects/Product_Relation__c/a2H4E0000001Dy8UAE"},"Id":"a2H4E0000001Dy8UAE","From__c":"01t4E000000CWoCQAW","To__c":"01t4E000000CWoHQAW","Is_Owner_Default__c":false,"Is_Dispatcher_Default__c":false,"To__r":{"attributes":{"type":"Product2","url":"/services/data/v40.0/sobjects/Product2/01t4E000000CWoHQAW"},"Name":"Prémiový účet v CZK","Id":"01t4E000000CWoHQAW"}}],"productName":"ČSOB Aktivní konto v CZK","isOwner":true,"isCard":false,"disponentText":null,"assetId":"02i4E00000011PUQAY","assetAccountNumber":"12345678","productParameterDefaults":{"a0A4E000000qCWnUAM":{"value":false},"a0A4E000000qCWoUAM":{"value":false},"a0A4E000000qCWpUAM":{"value":true},"a0A4E000000qCWqUAM":{"value":false},"a0A4E000000qCWrUAM":{"value":true},"a0A4E000000qCWsUAM":{"value":true},"a0A4E000000qCWtUAM":{"value":false},"a0A4E000000qCWuUAM":{"value":false},"a0A4E000000qCWlUAM":{"value":false},"a0A4E000000qEU1UAM":{"value":"Test 2","assetValue":"Test 2"},"a0A4E000000qCWmUAM":{"value":"a0A4E000000qCWwUAM","assetValue":"100000"},"a0A4E000000qFS5UAM":{"value":false}}}}}';
        MigrationPremiumController.generateIstsDocument(theAccount.Id, theAsset.Id, '142', 'ABC', productListConf, productRelationsConf, '', '', migrationPremiumProcessSavingConfiguration.Id, '0', '','');
        MigrationPremiumIstsExtension ext = new MigrationPremiumIstsExtension();
        ext.createAddressFromData(theAccountAddress);
        Test.stopTest();
    }*/

    @isTest static void uniqueIdIsNotBlank(){
        setupData();
        //Test.setMock(WebServiceMock.class, new DPaaSWebServiceSearchMock());
        Test.startTest();
        ApexPages.currentPage().getParameters().put('accountId', theAccount.Id);
        ApexPages.currentPage().getParameters().put('assetId', theAsset.Id);
        ApexPages.currentPage().getParameters().put('migration_process', 'CSOBS_contract_cancelation');
        MigrationPremiumController cntrl = new MigrationPremiumController();
        String uniqueId = cntrl.uniqueId;
        Test.stopTest();
        System.assertEquals(false, String.isBlank(uniqueId));
    }

    /*@isTest static void addToAllMap(){
        setupData();
        Asset theAssetParamParent = TestUtils.getAsset(theAccount.Id, null, '12334542');
        Asset theAssetParam = TestUtils.getAsset(theAccount.Id, theAssetParamParent.Id, null, '1233454');
        Test.setMock(WebServiceMock.class, new DpaaSWebServiceMockImpl());
        ApexPages.currentPage().getParameters().put('accountId', theAccount.Id);
        ApexPages.currentPage().getParameters().put('assetId', theAsset.Id);
        Test.startTest();
        MigrationPremiumController cntrl = new MigrationPremiumController();
        cntrl.addToAllMap(theAssetParam, theAccount.Id, 10);
        Test.stopTest();
    }*/

   /* @isTest static void callWithExistingCaseid(){
        setupData();
        Test.setMock(WebServiceMock.class, new DpaaSWebServiceMockImpl());
        Asset theAssetParam = TestUtils.getAsset(theAccount.Id, null, '12334542');
        MigrationPremiumTypes.ItemsWrapper wrapper = new MigrationPremiumTypes.ItemsWrapper();
        wrapper.itemMap = new Map<String, MigrationPremiumTypes.Item>();
        wrapper.itemMap.put('1', new MigrationPremiumTypes.Item(migrationPremiumProcessConfiguration, theAssetParam, false, 0, true));


        Map<String, Map<String, MigrationPremiumTypes.TransitionItem>> transitionMap = new Map<String, Map<String, MigrationPremiumTypes.TransitionItem>>();


        Case theCase = new Case();
        theCase.AccountId = theAccount.Id;
        theCase.Migration_Premium_Product_List_Conf__c =  JSON.serialize(wrapper);
        theCase.Migration_Premium_Product_Relations_Conf__c = JSON.serialize(transitionMap);
        theCase.Description = 'adfjdsfj';
        insert theCase;
        ApexPages.currentPage().getParameters().put('caseId', theCase.Id);

        Test.startTest();
        MigrationPremiumController cntrl = new MigrationPremiumController();
        Test.stopTest();
    }*/

    /*@isTest static void callWithExistingProductId(){
        setupData();
        ApexPages.currentPage().getParameters().put('productId', theProduct.Id);
        Test.startTest();
        MigrationPremiumController cntrl = new MigrationPremiumController();
        Test.stopTest();
    }*/

    /*@isTest static void isCzechAndValidation(){
        theAccount = TestUtils.getPersonAccount('12345');
        theAccount.PersonBirthdate = Date.today();
        theAccount.Date_of_Birth__c = Date.today();
        update theAccount;
        setupValidationProdIdsCustomSettings();
        ApexPages.currentPage().getParameters().put('accountId', theAccount.Id);
        MigrationPremiumController cntrl = new MigrationPremiumController();
        Boolean isCzechCheck = cntrl.isCzech;
        cntrl.savedConfiguration = true;
        MigrationValidation.Result theResult1 = cntrl.finalStepValidation;
        cntrl.savedConfiguration = false;
        cntrl.finalStepValidation = null;
        MigrationValidation.Result theResult2 = cntrl.finalStepValidation;
        ApexPages.currentPage().getParameters().put('migration_process', 'Saving_Account');
        MigrationPremiumController cntrl2 = new MigrationPremiumController();
        cntrl2.savedConfiguration = false;
        MigrationValidation.Result theResult3 = cntrl2.finalStepValidation;
        System.assertNotEquals(null, isCzechCheck);
    }*/

    @isTest static void getDefaultValueFromAsset(){
        /*Account accountFO = TestUtils.getPersonAccount('12345');
        Product2 domain = TestUtils.getProduct('domain', 'AccountNeedsRemControllerTest1', 1, null, '1816');
        Product2 category = TestUtils.getProduct('domain', 'AccountNeedsRemControllerTest2', 2, domain.Id, '1816');
        Product2 product = TestUtils.getProduct('domain', 'AccountNeedsRemControllerTest3', 2, category.Id, '551');
        Asset theAsset = TestUtils.getAsset(accountFO.Id, product.Id, 'AccountNeedsRemControllerTest1');*/

        Product_Parameter__c theProductParameter = new Product_Parameter__c();
        theProductParameter.Algorithm_Mapping__c = 'Assets[Type_of_insurance__c=Ztráta].product_variant__c';
        insert theProductParameter;

        MigrationPremiumController.getDefaultValueFromAsset(theProductParameter, theAsset);
        //MigrationPremiumController.createFakeRowsForTest();
    }

    @isTest static void getSObjectRecTest(){
        List<String> listOfString = new List<String>();
        listOfString.add('Name');
        Account theAcc = TestDataFactory.getAccount();
        insert theAcc;
        MigrationPremiumController.getSObjectRec((SObject)theAcc, listOfString);
    }

   /* @isTest static void getDefaultValueFromAsset2(){
        *//*Account accountFO = TestUtils.getPersonAccount('12345');
        Product2 domain = TestUtils.getProduct('domain', 'AccountNeedsRemControllerTest1', 1, null, '1816');
        Product2 category = TestUtils.getProduct('domain', 'AccountNeedsRemControllerTest2', 2, domain.Id, '1816');
        Product2 product = TestUtils.getProduct('domain', 'AccountNeedsRemControllerTest3', 2, category.Id, '551');
        Asset theAsset = TestUtils.getAsset(accountFO.Id, product.Id, 'AccountNeedsRemControllerTest1');
        theAsset.Close_Date__c = Date.today();
        update  theAsset;*//*

        Product_Parameter__c theProductParameter = new Product_Parameter__c();
        theProductParameter.Algorithm_Mapping__c = 'Name';
        insert theProductParameter;

        String dateFromMethod = MigrationPremiumController.getDefaultValueFromAsset(theProductParameter, theAsset);
        Datetime dt = DateTime.newInstance(Integer.valueOf(Date.today().year()), Integer.valueOf(Date.today().month()), Integer.valueOf(Date.today().day()));
        System.assertEquals(dt.format('dd.MM.yyyy'), dateFromMethod);
        //MigrationPremiumController.createFakeRowsForTest();
    }*/

    /*@isTest static void getAssetsFromProductParameterFormulaTest(){
        Account accountFO = TestUtils.getPersonAccount('12345');
        Product2 domain = TestUtils.getProduct('domain', 'AccountNeedsRemControllerTest1', 1, null, '1816');
        Product2 category = TestUtils.getProduct('domain', 'AccountNeedsRemControllerTest2', 2, domain.Id, '1816');
        Product2 product = TestUtils.getProduct('domain', 'AccountNeedsRemControllerTest3', 2, category.Id, '551');
        Asset theAsset = TestUtils.getAsset(accountFO.Id, product.Id, 'AccountNeedsRemControllerTest1');
        theAsset.Close_Date__c = Date.today();
        update  theAsset;

        Product_Parameter__c theProductParameter = new Product_Parameter__c();
        theProductParameter.Algorithm_Mapping__c = 'Assets[Type_of_insurance__c=Ztráta].product_variant__c';
        insert theProductParameter;

        List<Product_Parameter__c> listOFPar = new List<Product_Parameter__c>();
        listOFPar.add(theProductParameter);
        Asset theAss = MigrationPremiumController.getAssetsFromProductParameterFormula(listOFPar, theAsset.Id);
    }*/

    @isTest static void checkDependencies(){
        setupData();
        Product_Parameter__c theProductParameter4 = new Product_Parameter__c();
        theProductParameter4.Name = 'testName';
        theProductParameter4.Product_Relation__c = theProductRelation.Id;
        theProductParameter4.Product_Parameter__c = theProductParameter2.Id;
        theProductParameter4.SOQL_Background_Query__c = 'FIND :value RETURNING Account(Id, name, FirstName,PersonEmail,LastName,PersonTitle,Suffix,tolabel(Nationality__c),Phone,FullAddress__c,IdCardValidTo__c,PlaceOfBirth__c,tolabel(Gender__c),Birthdate__c,tolabel(IdCardType__c),IdCardNumber__c,DateOfStayFrom__c,DateOfStayUntil__c,tolabel(StayType__c),PersonalIdentificationNr__c)|PersonalIdentificationNr__c';
        insert theProductParameter4;

        Product_Parameter__c theProductParameter5 = new Product_Parameter__c();
        theProductParameter5.Name = 'testName';
        theProductParameter5.Product_Relation__c = theProductRelation.Id;
        theProductParameter5.Product_Parameter__c = theProductParameter2.Id;
        theProductParameter5.Type__c = 'Select With Background Query';
        insert theProductParameter5;

        Threshold_Value__c thresholdValue = new Threshold_Value__c();
        thresholdValue.Text_Value__c = 'valueText';
        thresholdValue.Type__c = 'Show';
        insert thresholdValue;

        Threshold_Product_Parameter__c threshold = new Threshold_Product_Parameter__c();
        threshold.Product_Parameter__c = theProductParameter4.Id;
        threshold.Dependent_Product_Parameter__c = theProductParameter4.Id;
        threshold.Threshold_Value__c = thresholdValue.Id;
        insert threshold;

        Threshold_Product_Parameter__c threshold2 = new Threshold_Product_Parameter__c();
        threshold2.Product_Parameter__c = theProductParameter5.Id;
        threshold2.Dependent_Product_Parameter__c = theProductParameter5.Id;
        threshold2.Threshold_Value__c = thresholdValue.Id;
        insert threshold2;

        Test.startTest();
        MigrationPremiumController.checkDependencies(theProductParameter4.Id, '1', '2', 'valueId', 'valueText', false, true, theAccount.Id);
        MigrationPremiumController.checkDependencies(theProductParameter4.Id, '1', '2', 'valueId', 'valueText2', false, true, theAccount.Id);
        MigrationPremiumController.checkDependencies(theProductParameter4.Id, '1', '2', 'valueId', 'valueText', true, true, theAccount.Id);
        MigrationPremiumController.checkDependencies(theProductParameter5.Id, '1', '2', 'valueId', 'valueText', false, true, theAccount.Id);
        MigrationPremiumController.checkDependencies(theProductParameter5.Id, '1', '2', 'valueId', 'valueText2', false, true, theAccount.Id);
        MigrationPremiumController.checkDependencies(theProductParameter5.Id, '1', '2', 'valueId', 'valueText', true, true, theAccount.Id);
        Test.stopTest();
    }

    /*@isTest static void checkDependenciesInputWithBgQuery(){
        setupData();
        Product_Parameter__c theProductParameter4 = TestUtils.getAndCreateChildProductParameterOnRelation(theProductRelation.Id, theProductParameter2.Id);

        Threshold_Value__c thresholdValue = new Threshold_Value__c();
        thresholdValue.Text_Value__c = '1';
        thresholdValue.Type__c = 'Show';
        insert thresholdValue;

        Threshold_Product_Parameter__c threshold = new Threshold_Product_Parameter__c();
        threshold.Product_Parameter__c = theProductParameter3.Id;
        threshold.Dependent_Product_Parameter__c = theProductParameter4.Id;
        threshold.Threshold_Value__c = thresholdValue.Id;
        insert threshold;
        theProductParameter3.SOQL_Background_Query_Search_Using_DPaaS__c = true;
        theProductParameter3.Type__c = 'Input With Background Query';
        update theProductParameter3;

        Test.setMock(WebServiceMock.class, new DpaaSWebServiceMockImpl());

        Test.startTest();
        MigrationPremiumController.checkDependencies(theProductParameter3.Id, '1', '2', 'valueId', 'valueText', true, true, theAccount.Id);
        Test.stopTest();
    }*/

    /*@isTest static void checkDependenciesSelectWithBgQuery(){
        setupData();
        Product_Parameter__c theProductParameter4 = TestUtils.getAndCreateChildProductParameterOnRelation(theProductRelation.Id, theProductParameter2.Id);
        theProductParameter4.SOQL__c = 'SELECT Id, Product__r.CST_Value_ID__c FROM Product2 WHERE Name = \'Test Product\'';
        update theProductParameter4;

        Threshold_Value__c thresholdValue = new Threshold_Value__c();
        thresholdValue.Text_Value__c = 'Product__r.CST_Value_ID__c';
        thresholdValue.Type__c = 'Show';
        insert thresholdValue;

        Threshold_Product_Parameter__c threshold = new Threshold_Product_Parameter__c();
        threshold.Product_Parameter__c = theProductParameter3.Id;
        threshold.Dependent_Product_Parameter__c = theProductParameter4.Id;
        threshold.Threshold_Value__c = thresholdValue.Id;
        insert threshold;
        theProductParameter3.SOQL_Background_Query_Search_Using_DPaaS__c = true;
        theProductParameter3.Type__c = 'Select With Background Query';
        update theProductParameter3;

        //Test.setMock(WebServiceMock.class, new DpaaSWebServiceMockImpl());

        Test.startTest();
        MigrationPremiumController.checkDependencies(theProductParameter3.Id, '1', '2', 'valueId', 'valueText', true, true, theAccount.Id);
        Test.stopTest();
    }*/


    @isTest static void getValueFromSObjectTest(){
        Account localAccount = TestDataFactory.getAccount();
        insert localAccount;
        Asset theAsset = new Asset();
        theAsset.AccountId = localAccount.Id;
        theAsset.Name = 'name';
        insert theAsset;
        Test.startTest();
        String value = MigrationPremiumController.getValueFromSObject(localAccount, 'Name');
        value = MigrationPremiumController.getValueFromSObject(localAccount, 'Id, Name');
        System.debug(value);
        value = MigrationPremiumController.getValueFromSObject(theAsset, 'Account.Name');
        System.debug(value);
        Test.stopTest();
    }

    @isTest static void getEnhancedSoqlForMigrationObjectTest(){
        Account localAccount = TestDataFactory.getAccount();
        insert localAccount;
        Asset theAsset = new Asset();
        theAsset.AccountId = localAccount.Id;
        theAsset.Name = 'name';
        insert theAsset;
        Test.startTest();
        String value = MigrationPremiumController.getEnhancedSoqlForMigrationObject('migrationAsset:migration.Asset');
        value = MigrationPremiumController.getEnhancedSoqlForMigrationObject('theAccount:migration.Asset');
        value = MigrationPremiumController.getEnhancedSoqlForMigrationObject('migrationProduct:migration.Asset');
        Test.stopTest();
    }

    @isTest static void commonTest(){
        Account accountFO = TestDataFactory.getAccount();
        //setupValidationProdIdsCustomSettings();
        Test.setCurrentPage(Page.MigrationPremium);
        ApexPages.currentPage().getParameters().put('accountId', accountFO.Id);
        ApexPages.currentPage().getParameters().put('migration_process', 'CSOBS_contract_cancelation');
        MigrationPremiumController cntrl = new MigrationPremiumController();
        //String linkToScube = cntrl.linkToScube;
        //Boolean isWdeUUser = cntrl.isWdeUser;
        Set<String> documentIds = cntrl.allDmsDocumentIdSet;
        Set<String> documentRequiredIds = cntrl.requiredDmsDocumentIdSet;
        Boolean requiredButtonMapIsNotEmpty = cntrl.requiredButtonMapIsNotEmpty;
        //String accountCuid = MigrationPremiumController.accountCuid;
        Integer numOfDocumentsForPrint = cntrl.numOfDocumentsForPrint;
        //String printButtonMapJSON = cntrl.printButtonMapJSON;
        //MigrationValidation.Result result = cntrl.finalStepValidation;
        String firstDataIdOfDmsDocument = cntrl.firstDataIdOfDmsDocument;
        String metadataDocumentsJSON = cntrl.metadataDocumentsJSON;
        String firstTemplateCodeOfDmsDocument = cntrl.firstTemplateCodeOfDmsDocument;
        //String branchId = MigrationPremiumController.userPreferredBranchId;
        Boolean bioSigns = cntrl.bioSigns;
        //MigrationPremiumController.getDefaultBranchId();
    }

    /*@isTest static void crifLinkAndUserTest(){
        setupData();
        Test.setMock(WebServiceMock.class, new DPaaSWebServiceSearchMock());
        Test.startTest();
        ApexPages.currentPage().getParameters().put('accountId', theAccount.Id);
        MigrationPremiumController mpCtrl = new MigrationPremiumController();
        String crifLink = mpCtrl.linkToCRIF;
        String userOrgUnitId = mpCtrl.userOrgUnitId;
        String userName = mpCtrl.userName;
        System.assertEquals(null, crifLink);
        Link_To_CRIF__c theLinkToCrif = new Link_To_CRIF__c();
        theLinkToCrif.Name = 'Link';
        theLinkToCrif.Value__c = 'http://url.cz';
        insert theLinkToCrif;
        crifLink = mpCtrl.linkToCRIF;
        Test.stopTest();
        System.assertEquals('http://url.cz', crifLink);
    }*/

    @isTest static void getInputWithSOQLValueTest(){
        setupData();
        theProductParameter3.SOQL_Field_Name__c = 'Id';
        theProductParameter3.Soql__c = 'SELECT Id FROM Product2';
        update theProductParameter3;

        MigrationPremiumController.getInputWithSOQLValue(theProductParameter3);
    }

    @isTest static void translationCoverTest(){
        setupData();
        //Test.setMock(WebServiceMock.class, new DPaaSWebServiceSearchMock());
        Test.startTest();
        ApexPages.currentPage().getParameters().put('accountId', theAccount.Id);
        ApexPages.currentPage().getParameters().put('assetId', theAsset.Id);
        ApexPages.currentPage().getParameters().put('migration_process', 'CSOBS_contract_cancelation');
        MigrationPremiumController mpCtrl = new MigrationPremiumController();
        Test.stopTest();
        System.assertNotEquals(null, MigrationPremiumController.typeTranslationMap);
/*        System.assertNotEquals(null, mpCtrl.baseStr);
        System.assertNotEquals(null, mpCtrl.suplStr);
        System.assertNotEquals(null, mpCtrl.themeStr);
        System.assertNotEquals(null, mpCtrl.reginvStr);*/
    }

   /* @isTest static void externalLinkDataTest(){
        setupData();
        upsert new Integration_Certificates__c(Name='ScubeSwitch',Certificate_Name__c='Salesforce_CA_Signed_Cert_for_CSOBDEV_S3_Signing');

        Test.startTest();
        IntegrationUtils.jsonWithEndpoint s = MigrationPremiumController.getExternalLinkData(theProductParameter1);

        theProductParameter1.Type__c = MigrationPremiumController.TYPE_EXTERNAL_LINK;
        update theProductParameter1;
        IntegrationUtils.jsonWithEndpoint s2 = MigrationPremiumController.getExternalLinkData(theProductParameter1);

        theProductParameter1.Transaction_ID__c = MigrationPremiumController.SUBFLOW_CREATE_NEW_PROSPECT_TRANSACTION_ID;
        theProductParameter1.SCUBE_Transaction_Type__c = GlobalConstants.SCUBE_TRANSACTION_CALL_TYPE_SWITCH;
        update theProductParameter1;
        IntegrationUtils.jsonWithEndpoint s3 = MigrationPremiumController.getExternalLinkData(theProductParameter1);

        theProductParameter1.SCUBE_Transaction_Type__c = GlobalConstants.SCUBE_TRANSACTION_CALL_TYPE_SUBFLOW;
        update theProductParameter1;
        IntegrationUtils.jsonWithEndpoint s4 = MigrationPremiumController.getExternalLinkData(theProductParameter1);
        Test.stopTest();

        System.assertEquals(null, s);
        System.assertEquals(null, s2);
        System.assertNotEquals(null, s3);
        System.assertNotEquals(null, s4);
    }*/

    @isTest static void visibilityTypeTest(){
        setupData();
        Test.startTest();
        Product_Parameter__c theProductParameter4 = new Product_Parameter__c();
        theProductParameter4.Name = 'testName';
        theProductParameter4.Product_Relation__c = theProductRelation.Id;
        theProductParameter4.Product_Parameter__c = theProductParameter2.Id;
        insert theProductParameter4;
        Threshold_Value__c thresholdValue = new Threshold_Value__c();
        thresholdValue.Text_Value__c = 'Product__r.CST_Value_ID__c';
        thresholdValue.Type__c = 'Show';
        insert thresholdValue;
        Threshold_Product_Parameter__c threshold = new Threshold_Product_Parameter__c();
        threshold.Product_Parameter__c = theProductParameter3.Id;
        threshold.Dependent_Product_Parameter__c = theProductParameter4.Id;
        threshold.Threshold_Value__c = thresholdValue.Id;
        insert threshold;

        Set<String> ppSet = new Set<String>{theProductParameter3.Id, theProductParameter4.Id};
        MigrationPremiumTypes.ThresholdWrapper thresholdToProductParameter = MigrationPremiumController.getThresholdWrapper(ppSet);
        Map<String, Product_Parameter__c> l2ProductParameterMap = new Map<String, Product_Parameter__c>();
        l2ProductParameterMap.put(theProductParameter3.Id, theProductParameter3);
        MigrationPremiumTypes.VisibilityWrapper res = new MigrationPremiumTypes.VisibilityWrapper();

        MigrationPremiumController.getVisibilityType(thresholdToProductParameter, l2ProductParameterMap, theProductParameter4, theAsset, res);
        Test.stopTest();

        System.assertEquals(0, res.visibilityCount);
        System.assertEquals('Hide', res.visibilityType);
    }

    @isTest static void disponentTextFromAssetTest(){
        setupData();
        Test.startTest();
        Asset a = [SELECT Id, Account.Name FROM Asset WHERE Id = :theAsset.Id];
        String s  = MigrationPremiumController.getDisponentTextFromAsset(a);
        Test.stopTest();
        System.assertEquals('Test account 1', s);
    }

    /*@isTest static void cstProdDocMapTest(){
        CST_List_of_Values__c lv = TestUtils.getCstListOfValues('2225');
        CST_List_of_Values__c lv2 = TestUtils.getCstListOfValues('007');
        List<CST_Value__c> vList = TestUtils.getCstValues(lv, new List<String>{'123'});
        List<CST_Value__c> vList2 = TestUtils.getCstValues(lv2, new List<String>{'7'});
        vList.get(0).Related_Value__c = vList2.get(0).Id;
        update vList;
        String cstProdDocMapJSON = MigrationPremiumController.cstProdDocMapJSON;
        System.assertNotEquals(null, cstProdDocMapJSON);
        System.assert(cstProdDocMapJSON.startsWith('{"007-7":'));
    }*/

    @isTest static void baseUrlTest(){
        System.assertNotEquals(null, MigrationPremiumController.baseUrl);
    }

    /*@isTest static void migrationProcessGeneralSOQLsTest() {
        setupData();
        MigrationPremiumController.assetId = theAsset.Id;
        MigrationPremiumController.product2Id = theProduct.Id;
        Product2 p = MigrationPremiumController.migrationProduct;
        Asset a = MigrationPremiumController.migrationAsset;
        System.assertEquals(theAsset.Id, a.Id);
        System.assertEquals(theProduct.Id, p.Id);
    }*/

    /*@IsTest static void sendOutputTest(){
        MigrationPremiumController.sendOutput('123', 123, 'contact', 'offerType', '', 'PPF', new List<CebNotificationUtils.FileListWrapper>());
    }*/

//    @isTest static void enhanceTransitionItemForCancellationTest(){
//        String productRelationsConf = '';
//        Map<String, Map<String, MigrationPremiumTypes.TransitionItem>> productRelationsMap = (Map<String, Map<String, MigrationPremiumTypes.TransitionItem>>) JSON.deserialize(productRelationsConf, Map<String, Map<String, MigrationPremiumTypes.TransitionItem>>.class);
//        MigrationPremiumController ctnrl = new MigrationPremiumController();
//        ctnrl.enhanceTransitionItemForCancellation(productRelationsMap);
//    }

/*    @IsTest
    static void callSignBiometricEnvelopeTest() {
        TestUtils.setTHUBEndpointURL();
        TestUtils.setIntegrationCertificates();
        TestUtils.setCredentials_CS_THUB_KEY();
        Test.setMock(WebServiceMock.class, new BiometricEnvelopeApiMock());
        List<DMS_Document__c> DMSDocuments = BSSPCFUtilsTest.getDMSDocuments();
        Integer i = 0;
        for(DMS_Document__c DMSDocument:DMSDocuments) {
            DMSDocument.External_ID__c = 'EXTERNAL_ID-'+i++;
        }
        insert DMSDocuments;
        TestUtils.getCcAppNameCustomSettings();
        Map<Id,DMS_Document__c> DMSDocumentsMap = new Map<Id,DMS_Document__c>(DMSDocuments);
        Account acc = TestUtils.getPersonAccount('12345');
        Product2 prod = TestUtils.getProduct('Test Product', 'Test Product', '18', 1, null, 'hsvjf', 'jsdij');
        Asset ass = TestUtils.getAsset(acc.Id, prod.Id, '123345');
        Test.startTest();
        MigrationPremiumController.callSignBiometricEnvelope(new List<Id>(DMSDocumentsMap.keySet()),ass.Id, acc.Id, acc.FirstName, acc.LastName);
        MigrationPremiumController.checkIfPpfDraft(acc.Id);
        Test.stopTest();
    }*/
}