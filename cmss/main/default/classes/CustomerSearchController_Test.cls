/**
 * Created by a.olexova on 3/24/2020.
 */

@IsTest
private class CustomerSearchController_Test {

    static Account personClient, personClient2, personProspect1, personProspect2, businessClient, businessClient2, businessProspect1;
    static Asset asset1, asset2, asset3, asset4;
    static Lead lead1;

    static final String ACCOUNT_OBJECT_STRING = CustomerSearchController.ACCOUNT_OBJECT_STRING;
    static final String LEAD_OBJECT_STRING = CustomerSearchController.LEAD_OBJECT_STRING;
    static final String ASSET_OBJECT_STRING = CustomerSearchController.ASSET_OBJECT_STRING;

    static void testSetup() {
        personClient = getPersonAccountNoInsert('Filoména', 'Fialková', '9011111111', null, '1');
        personClient2 = getPersonAccountNoInsert('Andrej', 'Andrejovič', '8922222222', '12345678', '1');
        personProspect1 = getPersonAccountNoInsert('Rudolf', 'Rudý', '8833333333', null, '3');
        personProspect2 = getPersonAccountNoInsert('Zuzana', 'Zelená', '8744444444', '87654321', '4');
        businessClient = getBusinessAccountNoInsert('Brýle s.r.o.', '11122233', '1');
        businessClient2 = getBusinessAccountNoInsert('Výmysl a.s.', '33344455', '1');
        businessProspect1 = getBusinessAccountNoInsert('Nový dům', '55566677', '3');
        insert new List<Account>{
                personClient, personClient2, personProspect1, personProspect2, businessClient, businessClient2, businessProspect1
        };

        asset1 = new Asset (Name = '1111111111', AccountId = personClient.Id);
        asset2 = new Asset (Name = '2222222222', AccountId = personClient2.Id);
        asset3 = new Asset (Name = '3333333333', AccountId = businessClient.Id);
        asset4 = new Asset (Name = '4444444444', AccountId = businessClient2.Id);
        insert new List<Asset>{
                asset1, asset2, asset3, asset4
        };

        lead1 = new Lead (FirstName = 'Aneta', LastName = 'Antonínová', PersonalIdentificationNr__c = '1234567890');
        insert lead1;
    }

    @IsTest
    static void findRecordsTestPosCompRegNum() {
        testSetup();
        List<Id> fixedSearchResults= new List<Id>();
        fixedSearchResults.add(businessClient.Id);
        Test.setFixedSearchResults(fixedSearchResults);
        CustomerSearchController.SearchCriteriaDTO searchCriteria = new CustomerSearchController.SearchCriteriaDTO(null, null, null, businessClient.CompanyRegistrationNumber__c, null, CustomerSearchController.CLIENTS);
        Test.startTest();
        List<CustomerSearchController.SearchResultDTO> results = CustomerSearchController.findRecords(searchCriteria);
        Test.stopTest();
    }

    @IsTest
    static void findRecordsTestPosBirthNum() {
        testSetup();
        List<Id> fixedSearchResults= new List<Id>();
        fixedSearchResults.add(personClient.Id);
        Test.setFixedSearchResults(fixedSearchResults);
        CustomerSearchController.SearchCriteriaDTO searchCriteria = new CustomerSearchController.SearchCriteriaDTO(personClient.FirstName, null, personClient.PersonalIdentificationNr__c, null, null, CustomerSearchController.CLIENTS);
        Test.startTest();
        List<CustomerSearchController.SearchResultDTO> results = CustomerSearchController.findRecords(searchCriteria);
        Test.stopTest();
    }

    @IsTest
    static void findRecordsTestPosBirthNumLeads() {
        testSetup();
        List<Id> fixedSearchResults= new List<Id>();
        fixedSearchResults.add(Lead1.Id);
        Test.setFixedSearchResults(fixedSearchResults);
        CustomerSearchController.SearchCriteriaDTO searchCriteria = new CustomerSearchController.SearchCriteriaDTO(lead1.FirstName, null, lead1.PersonalIdentificationNr__c, null, null, CustomerSearchController.LEADS);
        Test.startTest();
        List<CustomerSearchController.SearchResultDTO> results = CustomerSearchController.findRecords(searchCriteria);
        Test.stopTest();
    }

    @IsTest
    static void findRecordsTestPosAssetNum() {
        testSetup();
        List<Id> fixedSearchResults= new List<Id>();
        fixedSearchResults.add(asset1.Id);
        Test.setFixedSearchResults(fixedSearchResults);
        CustomerSearchController.SearchCriteriaDTO searchCriteria = new CustomerSearchController.SearchCriteriaDTO(null, null, null, null, asset1.Name, CustomerSearchController.CLIENTS);
        Test.startTest();
        List<CustomerSearchController.SearchResultDTO> results = CustomerSearchController.findRecords(searchCriteria);
        Test.stopTest();
    }

    @IsTest
    static void findRecordsTestNoResultCompRegNum() {
        testSetup();
        CustomerSearchController.SearchCriteriaDTO searchCriteria = new CustomerSearchController.SearchCriteriaDTO(null, null, null, businessClient.CompanyRegistrationNumber__c, null, CustomerSearchController.PROSPECTS);
        Test.startTest();
        List<CustomerSearchController.SearchResultDTO> results = CustomerSearchController.findRecords(searchCriteria);
        Test.stopTest();
    }

    @IsTest
    static void findRecordsTestNoResultBirthNum() {
        testSetup();
        CustomerSearchController.SearchCriteriaDTO searchCriteria = new CustomerSearchController.SearchCriteriaDTO(personClient.FirstName, personClient.LastName.substring(2), personClient.PersonalIdentificationNr__c, null, null, CustomerSearchController.CLIENTS);
        Test.startTest();
        List<CustomerSearchController.SearchResultDTO> results = CustomerSearchController.findRecords(searchCriteria);
        Test.stopTest();
    }

    @IsTest
    static void getQueryStringTestAccountClient() {
        testSetup();
        String expectedQueryString = 'FIND \'' + personClient.PersonalIdentificationNr__c + ' AND ' + personClient.FirstName + '*' + ' AND ' + personClient.LastName.substring(0,2) + '*\'' + ' IN ALL FIELDS RETURNING ' + ACCOUNT_OBJECT_STRING + 'IsPersonAccount = true AND AccountStatus__c = \'1\')';
        CustomerSearchController.firstName = personClient.FirstName;
        CustomerSearchController.lastName = personClient.LastName.substring(0,2);
        CustomerSearchController.birthNumber = personClient.PersonalIdentificationNr__c;
        Test.startTest();
        String query = CustomerSearchController.getQueryString();
        System.assertEquals(expectedQueryString, query, 'returned query not as expected.');
        Test.stopTest();
    }

    @IsTest
    static void getQueryStringTestAccountProspect() {
        testSetup();
        String expectedQueryString = 'FIND \'' + personClient.PersonalIdentificationNr__c + ' AND ' + personClient.FirstName + '*' + ' AND ' + personClient.LastName.substring(0,2) + '*\'' + ' IN ALL FIELDS RETURNING ' + ACCOUNT_OBJECT_STRING + 'IsPersonAccount = true AND AccountStatus__c != \'1\')';
        CustomerSearchController.firstName = personClient.FirstName;
        CustomerSearchController.lastName = personClient.LastName.substring(0,2);
        CustomerSearchController.birthNumber = personClient.PersonalIdentificationNr__c;
        CustomerSearchController.searchAmong = CustomerSearchController.PROSPECTS;
        Test.startTest();
        String query = CustomerSearchController.getQueryString();
        System.assertEquals(expectedQueryString, query, 'returned query not as expected.');
        Test.stopTest();
    }

    @IsTest
    static void getQueryStringTestAssetClient() {
        testSetup();
        String expectedQueryString = 'FIND \'' + asset3.Name + '*\' IN ALL FIELDS RETURNING ' + ASSET_OBJECT_STRING + 'Account.AccountStatus__c = \'1\')';
        CustomerSearchController.assetNumber = asset3.Name;
        Test.startTest();
        String query = CustomerSearchController.getQueryString();
        System.assertEquals(expectedQueryString, query, 'returned query not as expected.');
        Test.stopTest();
    }

    @IsTest
    static void getQueryStringTestAssetProspect() {
        testSetup();
        String expectedQueryString = 'FIND \'' + asset4.Name + '*\' IN ALL FIELDS RETURNING ' + ASSET_OBJECT_STRING + 'Account.AccountStatus__c != \'1\')';
        CustomerSearchController.assetNumber = asset4.Name;
        CustomerSearchController.searchAmong = CustomerSearchController.PROSPECTS;
        Test.startTest();
        String query = CustomerSearchController.getQueryString();
        System.assertEquals(expectedQueryString, query, 'returned query not as expected.');
        Test.stopTest();
    }

    @IsTest
    static void getQueryStringTestLead() {
        testSetup();
        String expectedQueryString = 'FIND \'' + personClient.PersonalIdentificationNr__c + ' AND ' + lead1.FirstName + '*' + ' AND ' + lead1.LastName + '*\' IN ALL FIELDS RETURNING ' + LEAD_OBJECT_STRING;
        CustomerSearchController.firstName = lead1.FirstName;
        CustomerSearchController.lastName = lead1.LastName;
        CustomerSearchController.birthNumber = personClient.PersonalIdentificationNr__c;
        CustomerSearchController.searchAmong = CustomerSearchController.LEADS;
        Test.startTest();
        String query = CustomerSearchController.getQueryString();
        System.assertEquals(expectedQueryString, query, 'returned query not as expected.');
        Test.stopTest();
    }

    /***********************************************             helping methods          *************************************************/

    static Account getPersonAccountNoInsert(String firstName, String lastName, String birthNumber, String compRegNum, String status) {
        String recordTypeId = RecordTypeUtils.getRecordTypeIdByDeveloperName('PersonAccount', 'Account');
        return new Account(
                FirstName = firstName,
                LastName = lastName,
                PersonalIdentificationNr__c = birthNumber,
                CompanyRegistrationNumber__c = compRegNum,
                AccountStatus__c = String.isBlank(status) ? '1' : status,
                RecordTypeId = recordTypeId
        );
    }

    static Account getBusinessAccountNoInsert(String name, String compRegNum, String status) {
        String recordTypeId = RecordTypeUtils.getRecordTypeIdByDeveloperName('Business_Account', 'Account');
        return new Account(
                Name = name,
                CompanyRegistrationNumber__c = compRegNum,
                AccountStatus__c = String.isBlank(status) ? '1' : status,
                RecordTypeId = recordTypeId
        );
    }
}