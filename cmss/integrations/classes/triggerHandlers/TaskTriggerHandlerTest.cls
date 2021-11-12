@isTest
class TaskTriggerHandlerTest {
	@isTest
	static void afterInsertTest() {
		Account acc1 = TestDataFactory.getAccount(new Account());
		insert acc1;
		User u = TestDataFactory.getUser(new User());
		insert u;

		Integer accessShareSize = AccessShareDao.getAllRecordsFromAccessShare().size();
		Integer accountShareSize = AccountShareDao.getAllRecordsFromAccountShare().size();

		Task task = new Task(
			WhatId = acc1.Id,
			OwnerId = u.Id,
			ActivityDate = Date.today().addYears(1),
			Status = '1',
			Type = '5',
			IsVisibleInSelfService = false,
			Description = 'Some text that is a bit longer than 30 characters.'
		);

		Test.startTest();
		insert task;
		Test.stopTest();

		task = [SELECT ActivityType__c, IsVisibleInSelfService, Summary__c FROM Task WHERE Id = :task.Id];

		System.assertEquals(accessShareSize + 1, AccessShareDao.getAllRecordsFromAccessShare().size());
		System.assertEquals(accountShareSize + 1, AccountShareDao.getAllRecordsFromAccountShare().size());
		System.assertEquals('5', task.ActivityType__c);
		System.assertEquals(true, task.IsVisibleInSelfService);
		System.assertEquals(33, task.Summary__c.length());
		System.assert(task.Summary__c.endsWith('...'));
	}

	@isTest
	static void afterUpdateTest() {
		Account acc1 = TestDataFactory.getAccount(new Account());
		insert acc1;
		User u1 = TestDataFactory.getUser(new User());
		User u2 = TestDataFactory.getUser(new User());
		insert new List<User>{ u1, u2 };

		Integer accessShareSize = AccessShareDao.getAllRecordsFromAccessShare().size();
		Integer accountShareSize = AccountShareDao.getAllRecordsFromAccountShare().size();

		Task task = new Task(WhatId = acc1.Id, OwnerId = u1.Id, ActivityDate = Date.today().addYears(1));

		insert task;
		task.Status = '0';
		task.OwnerId = u2.Id;

		Test.startTest();
		update task;
		Test.stopTest();

		System.assertEquals(accessShareSize + 1, AccessShareDao.getAllRecordsFromAccessShare().size());
		System.assertEquals(accountShareSize + 1, AccountShareDao.getAllRecordsFromAccountShare().size());
	}

	@isTest
	static void beforeDeleteTest() {
		Account acc1 = TestDataFactory.getAccount(new Account());
		insert acc1;
		User u = TestDataFactory.getUser(new User());
		insert u;

		Task task = new Task(WhatId = acc1.Id, OwnerId = u.Id, ActivityDate = Date.today().addYears(1));

		insert task;

		delete task;

		Task[] usersTasks = [SELECT Id FROM Task WHERE OwnerId = :u.Id];

		System.assert(usersTasks.isEmpty());
	}

	@isTest
	static void accountFieldsUpdatedTest() {
		Account acc1 = TestDataFactory.getAccount(new Account());
		acc1.OpenedActivityDate__c = null;
		acc1.LastInteractionDate__c = null;
		Account acc2 = TestDataFactory.getAccount(new Account());
		acc2.OpenedActivityDate__c = Date.today().addDays(3);
		acc2.LastInteractionDate__c = Date.today().addDays(-5);

		insert new List<Account>{ acc1, acc2 };

		User u = TestDataFactory.getUser(new User());
		insert u;

		Task task1 = new Task(WhatId = acc1.Id, OwnerId = u.Id, Status = '1', ActivityDate = Date.today().addDays(1));
		Task task2 = new Task(WhatId = acc2.Id, OwnerId = u.Id, Status = '1', ActivityDate = Date.today().addDays(1));
		insert new List<Task>{ task1, task2 };

		Map<Id, Account> updatedAccounts = new Map<Id, Account>(
			[
				SELECT Id, OpenedActivityDate__c, LastInteractionDate__c
				FROM Account
				WHERE Id IN :(new List<Id>{ acc1.Id, acc2.Id })
			]
		);

		System.assertEquals(task1.ActivityDate, updatedAccounts.get(acc1.Id).OpenedActivityDate__c);
		System.assertEquals(null, updatedAccounts.get(acc1.Id).LastInteractionDate__c);
		System.assertEquals(task2.ActivityDate, updatedAccounts.get(acc2.Id).OpenedActivityDate__c);

		task1.Status = '3';
		update task1;

		updatedAccounts = new Map<Id, Account>(
			[SELECT Id, OpenedActivityDate__c, LastInteractionDate__c FROM Account WHERE Id = :acc1.Id]
		);

		System.assertEquals(Date.today(), updatedAccounts.get(acc1.Id).LastInteractionDate__c);
	}
}
