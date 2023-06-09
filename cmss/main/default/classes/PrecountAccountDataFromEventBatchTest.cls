@isTest
public class PrecountAccountDataFromEventBatchTest {
	@isTest
	static void batchRunTest() {
		Account acc = TestDataFactory.getAccount(new Account());
		insert acc;
		Event event = new Event(
			WhatId = acc.Id,
			StartDateTime = system.today() - 6,
			EndDateTime = system.today() - 5,
			Subject = 'Call'
		);
		insert event;
		Test.startTest();
		PrecountAccountDataFromEventBatch batch = new PrecountAccountDataFromEventBatch();
		Database.executeBatch(batch);
		Test.stopTest();
		Account account = [SELECT Id, LastInteractionDate__c, OpenedActivityDate__c FROM Account WHERE Id = :acc.Id];
		event = [SELECT ActivityDate, EndDateTime FROM Event WHERE Id = :event.Id];
		System.assertEquals(account.LastInteractionDate__c, event.EndDateTime);
		System.assertEquals(account.OpenedActivityDate__c, event.ActivityDate);
	}
}
