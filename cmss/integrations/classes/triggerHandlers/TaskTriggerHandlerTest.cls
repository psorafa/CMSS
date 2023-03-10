@isTest
class TaskTriggerHandlerTest {
	@TestSetup
	static void makeData() {
		insert TestDataFactory.getIntegrationSettings();
	}

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
			Description = 'Some text that is a bit longer than 30 characters.',
			Source__c = '54'
		);

		CalloutServiceMockImpl fakeSuccessResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns3:sendEmailResponse xmlns:ns3=\"http://service.cmss.cz/mail\" xmlns:ns2=\"http://service.cmss.cz/datamodel/mailservice/sendemail\" xmlns:ns4=\"http://service.cmss.cz/fault\"></ns3:sendEmailResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeSuccessResponse);

		Test.startTest();
		insert task;
		Test.stopTest();

		task = [
			SELECT ActivityType__c, IsVisibleInSelfService, Summary__c, Source__c, Category__c
			FROM Task
			WHERE Id = :task.Id
		];

		System.assertEquals(accessShareSize + 1, AccessShareDao.getAllRecordsFromAccessShare().size());
		System.assertEquals(accountShareSize + 1, AccountShareDao.getAllRecordsFromAccountShare().size());
		System.assertEquals('5', task.ActivityType__c);
		System.assertEquals(true, task.IsVisibleInSelfService);
		System.assertEquals(33, task.Summary__c.length());
		System.assert(task.Summary__c.endsWith('...'));
		System.assertEquals('1', task.Category__c);
	}

	@isTest
	static void afterUpdateInsertLetterRecordTypeTest() {
        Id letterRecordTypeId = RecordTypeUtils.getRecordTypeIdByDeveloperName('Letter', 'Task');
		Account acc1 = TestDataFactory.getAccount(new Account());
		insert acc1;
		User u = TestDataFactory.getUser(new User());
		insert u;

		Task task = new Task(
			WhatId = acc1.Id,
			OwnerId = u.Id,
			ActivityDate = Date.today().addYears(1),
			Type = '4',
            RecordTypeId = letterRecordTypeId
		);

		Test.startTest();
		insert task;
		task.ActivityDate = Date.today().addYears(2);
        update task;
		Test.stopTest();

		task = [
			SELECT ActivityType__c
			FROM Task
			WHERE Id = :task.Id
		];

		System.assertEquals('4', task.ActivityType__c);
	}

	@isTest
	static void afterUpdateTest() {
		Account acc1 = TestDataFactory.getAccount(new Account());
		insert acc1;
		User u1 = TestDataFactory.getUser(new User());
		User u2 = TestDataFactory.getUser(new User());
		insert new List<User>{u1, u2};

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
	static void beforeDeleteTestForRestrictedUser() {
		Account acc1 = TestDataFactory.getAccount(new Account());
		insert acc1;
		User u = TestDataFactory.getUserWithProfile(new User(), 'CMSS User');
		insert u;

		Task task = new Task(WhatId = acc1.Id, OwnerId = u.Id, ActivityDate = Date.today().addYears(1));
		insert task;

		Exception expectedException;

		Test.startTest();
		System.runAs(u) {
			try {
				delete task;
			} catch (Exception e) {
				expectedException = e;
			}
		}
		Test.stopTest();

		Task[] usersTasks = [SELECT Id FROM Task WHERE OwnerId = :u.Id];

		System.assert(!usersTasks.isEmpty());
		System.assert(expectedException.getMessage().contains(Label.YouDoNotHavePermissionToDeleteTask));
	}

	@isTest
	static void accountFieldsUpdatedTest() {
		Account acc1 = TestDataFactory.getAccount(new Account());
		acc1.OpenedActivityDate__c = null;
		acc1.LastInteractionDate__c = null;
		Account acc2 = TestDataFactory.getAccount(new Account());
		acc2.OpenedActivityDate__c = Date.today().addDays(3);
		acc2.LastInteractionDate__c = Date.today().addDays(-5);

		insert new List<Account>{acc1, acc2};

		User u = TestDataFactory.getUser(new User());
		insert u;

		Task task1 = new Task(WhatId = acc1.Id, OwnerId = u.Id, Status = '1', ActivityDate = Date.today().addDays(1));
		Task task2 = new Task(WhatId = acc2.Id, OwnerId = u.Id, Status = '1', ActivityDate = Date.today().addDays(1));
		insert new List<Task>{task1, task2};

		Map<Id, Account> updatedAccounts = new Map<Id, Account>(
		[
			SELECT Id, OpenedActivityDate__c, LastInteractionDate__c
			FROM Account
			WHERE Id IN :(new List<Id>{acc1.Id, acc2.Id})
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

	@isTest
	static void createMailServiceNotificationsTest() {
		User user = TestDataFactory.getUser(new User(Email = 'invalid@testuser.cz'));
		insert user;

		Task newTask = TestDataFactory.getTask(
			new Task(
				Subject = 'Do something',
				OwnerId = user.Id,
				Category__c = '1',
				IsVisibleForNel__c = true,
				Status__c = '1'
			)
		);
		List<MailServiceNotification__c> notificationsBefore = [
			SELECT Id
			FROM MailServiceNotification__c
			WHERE ToEmailAddress__c = 'invalid@testuser.cz'
		];

		CalloutServiceMockImpl fakeSuccessResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns3:sendEmailResponse xmlns:ns3=\"http://service.cmss.cz/mail\" xmlns:ns2=\"http://service.cmss.cz/datamodel/mailservice/sendemail\" xmlns:ns4=\"http://service.cmss.cz/fault\"></ns3:sendEmailResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);

		Test.setMock(HttpCalloutMock.class, fakeSuccessResponse);
		Test.startTest();
		insert newTask;
		Test.stopTest();

		MailServiceNotification__c resultNotification = [
			SELECT Id, FromEmailAddress__c, ToEmailAddress__c, Body__c, Subject__c, SendAfter__c
			FROM MailServiceNotification__c
			WHERE ToEmailAddress__c = 'invalid@testuser.cz'
		][0];
		System.assertEquals(notificationsBefore.size(), 0);
		System.assertEquals(resultNotification.ToEmailAddress__c, 'invalid@testuser.cz');
		System.assert(resultNotification.Subject__c.endsWith('Do something'));
	}

	@isTest
	static void inactiveTaskOwnerTest() {
		User user = TestDataFactory.getUser(new User(IsActive = false));
		insert user;
		ContactInformation__c newCI = new ContactInformation__c(
			Area__c = '3',
			SubType__c = '3000001',
			User__c = user.Id,
			Email__c = 'testuser@test.com'
		);
		insert newCI;
		Task newTask = TestDataFactory.getTask(
			new Task(Subject = 'Do', OwnerId = user.Id, Category__c = '1', IsVisibleForNel__c = true, Status__c = '1')
		);
		CalloutServiceMockImpl fakeSuccessResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns3:sendEmailResponse xmlns:ns3=\"http://service.cmss.cz/mail\" xmlns:ns2=\"http://service.cmss.cz/datamodel/mailservice/sendemail\" xmlns:ns4=\"http://service.cmss.cz/fault\"></ns3:sendEmailResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);

		Test.setMock(HttpCalloutMock.class, fakeSuccessResponse);
		Test.startTest();
		insert newTask;
		Test.stopTest();
		List<MailServiceNotification__c> notification = [
			SELECT Id, ToEmailAddress__c
			FROM MailServiceNotification__c
			WHERE ToEmailAddress__c = 'testuser@test.com'
		];
		System.assertEquals(notification[0].ToEmailAddress__c, 'testuser@test.com');
	}

	@isTest
	static void createEventSyncsTest() {
		User user = TestDataFactory.getUser(new User(IsActive = false));
		insert user;

		UserCalendarSetting__c setting = new UserCalendarSetting__c();
		setting.SyncActive__c = true;
		setting.User__c = user.Id;
		insert setting;

		Account acc = TestDataFactory.getPersonAccount(new Account());
		insert acc;
		Task newTask = TestDataFactory.getTask(
			new Task(
				Subject = 'Do',
				OwnerId = user.Id,
				Category__c = '1',
				IsVisibleForNel__c = true,
				Status__c = '1',
				WhatId = acc.Id,
				GoogleId__c = '12345'
			)
		);
		Test.startTest();
		insert newTask;
		Test.stopTest();

		EventSync__c eventSync = [
			SELECT Id, GoogleEventId__c, ChangeFromGoogle__c, IsNew__c, IsDeleted__c
			FROM EventSync__c
			WHERE GoogleEventId__c = '12345'
		];
		System.assertNotEquals(null, eventSync, 'Sync should have been created.');
		System.assertEquals(newTask.GoogleId__c, eventSync.GoogleEventId__c, 'Google Id should be the same as in Task');
		System.assertEquals(false, eventSync.IsDeleted__c, 'IsDeleted__c should be false for a new Task.');
		System.assertEquals(false, eventSync.ChangeFromGoogle__c, 'ChangeFromGoogle__c should be false.');
	}

	@isTest
	static void createEventSyncsSyncExistsTest() {
		User user = TestDataFactory.getUser(new User(IsActive = false));
		insert user;
		Account acc = TestDataFactory.getPersonAccount(new Account());
		insert acc;
		Task newTask = TestDataFactory.getTask(
			new Task(
				Subject = 'Do',
				OwnerId = user.Id,
				Category__c = '1',
				IsVisibleForNel__c = true,
				Status__c = '1',
				WhatId = acc.Id,
				GoogleId__c = '12345'
			)
		);

		EventSync__c sync = new EventSync__c();
		sync.GoogleEventId__c = '12345';
		sync.ChangeFromGoogle__c = true;
		insert sync;

		Test.startTest();
		insert newTask;
		Test.stopTest();

		List<EventSync__c> eventSync = [
			SELECT Id, GoogleEventId__c, ChangeFromGoogle__c
			FROM EventSync__c
			WHERE Id = :sync.Id
		];
		System.assertEquals(0, eventSync.size(), 'Old sync should be deleted.');
	}
}
