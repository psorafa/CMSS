@isTest
private class PrecountAccountDataTest {
	@isTest
	static void testAllBatchesRun() {
		Account account = TestDataFactory.getAccount(new Account());
		insert account;

		Asset asset1 = TestDataFactory.getAsset(new Asset());
		asset1.AccountId = account.Id;
		asset1.ProductCloseDate__c = System.today().addDays(-5);

		Asset asset2 = TestDataFactory.getAsset(new Asset());
		asset2.AccountId = account.Id;
		asset2.ProductCloseDate__c = System.today().addDays(-4);
		insert new List<Asset>{asset1, asset2};

		Opportunity opportunity1 = TestDataFactory.getOpportunity();
		opportunity1.AccountId = account.Id;
		opportunity1.StageName = '1';
		opportunity1.CloseDate = System.today().addDays(2);
		Opportunity opportunity2 = TestDataFactory.getOpportunity();
		opportunity2.AccountId = account.Id;
		opportunity2.StageName = '2';
		opportunity2.CloseDate = System.today().addDays(1);
		Opportunity opportunity3 = TestDataFactory.getOpportunity();
		opportunity3.AccountId = account.Id;
		opportunity3.CloseDate = System.today().addDays(3);
		opportunity3.StageName = '3';
		insert new List<Opportunity>{opportunity1, opportunity2, opportunity3};

		Task task1 = new Task(WhatId = account.Id, Status = '1', ActivityDate = Date.today().addDays(1));
		Task task2 = new Task(WhatId = account.Id, Status = '3', ActivityDate = Date.today().addDays(1));
		insert new List<Task>{task1, task2};

		account.OpenedActivityDate__c = null;
		account.OpenedOpportunityDate__c = null;
		account.AssetLastCloseDate__c = null;
		account.LastInteractionDate__c = null;
		update account;

		Test.startTest();
		PrecountAccountDataSchedule sch = new PrecountAccountDataSchedule();
		sch.execute(null);
		Test.stopTest();
	}
}
