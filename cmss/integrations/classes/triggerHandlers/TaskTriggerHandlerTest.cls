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

		Task task = new Task(WhatId = acc1.Id, OwnerId = u.Id, ActivityDate = Date.today().addYears(1));

		Test.startTest();
		insert task;
		Test.stopTest();

		System.assertEquals(accessShareSize + 1, AccessShareDao.getAllRecordsFromAccessShare().size());
		System.assertEquals(accountShareSize + 1, AccountShareDao.getAllRecordsFromAccountShare().size());
	}

	@isTest
	static void afterUpdateTest() {
		Account acc1 = TestDataFactory.getAccount(new Account());
		insert acc1;
		User u = TestDataFactory.getUser(new User());
		insert u;

		Integer accessShareSize = AccessShareDao.getAllRecordsFromAccessShare().size();
		Integer accountShareSize = AccountShareDao.getAllRecordsFromAccountShare().size();

		Task task = new Task(WhatId = acc1.Id, OwnerId = u.Id, ActivityDate = Date.today().addYears(1));

		insert task;
		task.Status = '0';

		Test.startTest();
		update task;
		Test.stopTest();

		System.assertEquals(accessShareSize, AccessShareDao.getAllRecordsFromAccessShare().size());
		System.assertEquals(accountShareSize, AccountShareDao.getAllRecordsFromAccountShare().size());
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
}
