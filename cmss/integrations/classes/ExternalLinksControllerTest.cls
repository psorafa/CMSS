@IsTest
private class ExternalLinksControllerTest {

    @IsTest
	static void testGetNelBaseUrl() {
        IntegrationSettings__c settings = IntegrationSettings__c.getInstance();
        settings.NELBaseUrl__c = 'https://some.url';
        upsert settings;

        Test.startTest();
        String url = ExternalLinksController.getNelBaseUrl();
        Test.stopTest();

        System.assertEquals(settings.NELBaseUrl__c, url);
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
}