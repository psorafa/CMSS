@isTest
class ExceededLogsNotificationScheduleTest {
	@TestSetup
	static void makeData() {
		insert TestDataFactory.getIntegrationSettings();

		User testUser1 = TestDataFactory.getUser(new User(LastName = 'Testovič'));
		User testUser2 = TestDataFactory.getUser(new User(LastName = 'Netestil'));
		insert new List<User>{ testUser1, testUser2 };

		Account testAccount = TestDataFactory.getAccount();
		insert testAccount;

		Access_Log__c log1 = new Access_Log__c();
		log1.RequestedBy__c = testUser1.Id;
		log1.AccessTo__c = testAccount.Id;

		Access_Log__c log2 = new Access_Log__c();
		log2.RequestedBy__c = testUser1.Id;
		log2.AccessTo__c = testAccount.Id;

		Access_Log__c log3 = new Access_Log__c();
		log3.RequestedBy__c = testUser2.Id;
		log3.AccessTo__c = testAccount.Id;

		insert new List<Access_Log__c>{ log1, log2, log3 };
		Integer month = System.today().month() == 1 ? 12 : System.today().month() - 1;
		Integer year = month == 12 ? System.today().year() - 1 : System.today().year();
		DateTime newDateTime = DateTime.newInstance(Date.newInstance(year, month, 15), Time.newInstance(12, 0, 0, 0));
		Test.setCreatedDate(log1.Id, newDateTime);
		Test.setCreatedDate(log2.Id, newDateTime);
		Test.setCreatedDate(log3.Id, newDateTime);
	}

	@isTest
	static void correctNotificationsCreatedTest() {
		EmailTemplate template = [
			SELECT Subject, HtmlValue
			FROM EmailTemplate
			WHERE DeveloperName = 'LogsAccessLimitExceeded'
		];

		Integer logsLimit = 1;
		List<String> receivers = new List<string>{ 'first@email.invalid', 'second@mail.invalid' };
		String reportURL = 'reportURL';

		Test.setMock(HttpCalloutMock.class, new MailSOAPServiceHttpMock());
		Test.startTest();
		ExceededLogsNotificationSchedule schedule = new ExceededLogsNotificationSchedule(
			logsLimit,
			receivers,
			reportURL
		);
		schedule.execute(null);
		Test.stopTest();
		List<MailServiceNotification__c> notifications = [SELECT Subject__c, Body__c FROM MailServiceNotification__c];

		System.assertEquals(2, notifications.size());
		System.assertEquals(template.Subject, notifications[0].Subject__c);
		System.assertEquals(true, notifications[0].Body__c.contains('Testovič'));
		System.assertEquals(false, notifications[0].Body__c.contains('Netestil'));
	}
}
