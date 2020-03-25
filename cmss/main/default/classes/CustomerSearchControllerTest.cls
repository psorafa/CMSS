/**
 * Created by a.kovacova on 3/24/2020.
 */

@IsTest
private class CustomerSearchControllerTest {

    static Account personClient;
    static Account personClient2;
    static Account personProspect1;
    static Account personProspect2;
    static Account businessClient;
    static Account businessClient2;
    static Account businessProspect1;
    static Account businessProspect2;
    static Asset asset1;
    static Asset asset2;
    static Asset asset3;
    static Asset asset4;

    static void testSetup() {
        personClient = getPersonAccountNoInsert('Filoména', 'Fialková', '9011111111', null, '1');
        personClient2 = getPersonAccountNoInsert('Andrej', 'Andrejovič', '8922222222', '12345678', '1');
        personProspect1 = getPersonAccountNoInsert('Rudolf', 'Rudý', '8833333333', null, '3');
        personProspect2 = getPersonAccountNoInsert('Zuzana', 'Zelená', '8744444444', '87654321', '4');
        businessClient = getBusinessAccountNoInsert('Brýle s.r.o.', '11122233', '1');
        businessClient2 = getBusinessAccountNoInsert('Výmysl a.s.', '33344455', '1');
        businessProspect1 = getBusinessAccountNoInsert('Nový dům', '55566677', '3');
        businessProspect2 = getBusinessAccountNoInsert('Rýchle prachy', '77788899', '4');
        insert new List<Account>{
                personClient, personClient2, personProspect1, personProspect2, businessClient, businessClient2, businessProspect1, businessProspect2
        };

        asset1 = new Asset (Name = '1111111111', AccountId = personClient.Id);
        asset2 = new Asset (Name = '2222222222', AccountId = personClient2.Id);
        asset3 = new Asset (Name = '3333333333', AccountId = businessClient.Id);
        asset4 = new Asset (Name = '4444444444', AccountId = businessClient2.Id);
        insert new List<Asset>{
                asset1, asset2, asset3, asset4
        };
    }

    @IsTest
    static void findRecordsTestPosCompRegNum() {
        testSetup();
        List<Id> fixedSearchResults= new List<Id>();
        fixedSearchResults.add(businessClient.Id);
        Test.setFixedSearchResults(fixedSearchResults);

        Test.startTest();
        List<SObject> results = CustomerSearchController.findRecords(null, null, null, businessClient.CompanyRegistrationNumber__c, null, CustomerSearchController.CLIENTS);
        Test.stopTest();
    }

    @IsTest
    static void findRecordsTestPosBirthNum1() {
        testSetup();
        List<Id> fixedSearchResults= new List<Id>();
        fixedSearchResults.add(personClient.Id);
        Test.setFixedSearchResults(fixedSearchResults);

        Test.startTest();
        List<SObject> results = CustomerSearchController.findRecords(personClient.FirstName, null, personClient.PersonalIdentificationNr__c, null, null, CustomerSearchController.CLIENTS);
        Test.stopTest();
    }

    @IsTest
    static void findRecordsTestPosBirthNum2() {
        testSetup();
        List<Id> fixedSearchResults= new List<Id>();
        fixedSearchResults.add(personClient2.Id);
        Test.setFixedSearchResults(fixedSearchResults);

        Test.startTest();
        List<SObject> results = CustomerSearchController.findRecords(personClient2.FirstName, null, personClient2.PersonalIdentificationNr__c, personClient2.CompanyRegistrationNumber__c, null, CustomerSearchController.CLIENTS);
        Test.stopTest();
    }

    @IsTest
    static void findRecordsTestPosAssetNum() {
        testSetup();
        List<Id> fixedSearchResults= new List<Id>();
        fixedSearchResults.add(asset1.Id);
        Test.setFixedSearchResults(fixedSearchResults);

        Test.startTest();
        List<SObject> results = CustomerSearchController.findRecords(null, null, null, null, asset1.Name, CustomerSearchController.CLIENTS);
        Test.stopTest();
    }

    @IsTest
    static void findRecordsTestPosAssetNumPartial() {
        testSetup();
        List<Id> fixedSearchResults= new List<Id>();
        fixedSearchResults.add(asset2.Id);
        Test.setFixedSearchResults(fixedSearchResults);

        Test.startTest();
        List<SObject> results = CustomerSearchController.findRecords(null, null, null, null, asset2.Name.substring(0,7), CustomerSearchController.CLIENTS);
        Test.stopTest();
    }

    @IsTest
    static void findRecordsTestNoResultCompRegNum() {
        testSetup();
        Test.startTest();
        List<SObject> results = CustomerSearchController.findRecords(null, null, null, businessClient.CompanyRegistrationNumber__c, null, CustomerSearchController.PROSPECTS);
        Test.stopTest();
    }

    @IsTest
    static void findRecordsTestNoResultBirthNum1() {
        testSetup();
        Test.startTest();
        List<SObject> results = CustomerSearchController.findRecords(personClient.FirstName, personClient.LastName.substring(2), personClient.PersonalIdentificationNr__c, null, null, CustomerSearchController.CLIENTS);
        Test.stopTest();
    }

    static Account getPersonAccountNoInsert(String firstName, String lastName, String birthNumber, String compRegNum, String status) {
        String recordTypeId = Utils.getRecordTypeIdByDeveloperName('PersonAccount', 'Account');
        return new Account(
                FirstName = firstName,
                LastName = LastName,
                PersonalIdentificationNr__c = birthNumber,
                CompanyRegistrationNumber__c = compRegNum,
                AccountStatus__c = String.isBlank(status) ? '1' : status,
                RecordTypeId = recordTypeId
        );
    }

    static Account getBusinessAccountNoInsert(String name, String compRegNum, String status) {
        String recordTypeId = Utils.getRecordTypeIdByDeveloperName('Business_Account', 'Account');
        return new Account(
                Name = name,
                CompanyRegistrationNumber__c = compRegNum,
                AccountStatus__c = String.isBlank(status) ? '1' : status,
                RecordTypeId = recordTypeId
        );
    }
}