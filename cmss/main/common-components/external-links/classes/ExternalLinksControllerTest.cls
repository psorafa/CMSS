@IsTest
private class ExternalLinksControllerTest {

    @IsTest
	static void testGetNelBaseUrl() {
        IntegrationSettings__c settings = IntegrationSettings__c.getInstance();
        settings.NELBaseUrl__c = 'https://some.url';
        upsert settings;

        Test.startTest();
        IntegrationSettings__c urls = ExternalLinksController.getIntegrationSettings();
        Test.stopTest();

        System.assertEquals(settings.NELBaseUrl__c, urls.NELBaseUrl__c);
	}

    @IsTest
    static void testGetClientGlobalId() {
        Account a = TestDataFactory.getAccount(new Account(GlobalId__c = 'GLID'));
        Account another = TestDataFactory.getAccount(new Account());
        insert new List<Account> {a, another};
        Task t = TestDataFactory.getTask(new Task(WhatId = a.Id));
        insert t;
        Opportunity o = TestDataFactory.getOpportunity(new Opportunity(AccountId = a.Id));
        insert o;

        Test.startTest();
        String globalIdFromAccount = ExternalLinksController.getClientGlobalId(a.Id);
        String globalIdFromTask = ExternalLinksController.getClientGlobalId(t.Id);
        String globalIdFromOpportunity = ExternalLinksController.getClientGlobalId(o.Id);
        Test.stopTest();

        System.assertEquals(a.GlobalId__c, globalIdFromAccount);
        System.assertEquals(a.GlobalId__c, globalIdFromTask);
        System.assertEquals(a.GlobalId__c, globalIdFromOpportunity);
    }

    @IsTest
    static void testGetObjectApiName() {
        Account account = TestDataFactory.getAccount(new Account());
        insert account;
        Opportunity opportunity = TestDataFactory.getOpportunity(new Opportunity());
        insert opportunity;

        String accountApiName = ExternalLinksController.getObjectApiName(account.Id);
        String opportunityApiName = ExternalLinksController.getObjectApiName(opportunity.Id);

        System.assertEquals(accountApiName, 'Account');
        System.assertEquals(opportunityApiName, 'Opportunity');
    }
}