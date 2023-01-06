@IsTest
public class InvocableMailNotificationsHandlerTest {
	@TestSetup
	static void makeData() {
		insert TestDataFactory.getIntegrationSettings();
		Account testAccount = TestDataFactory.getPersonAccount(
			new Account(FirstName = 'Karel', LastName = 'Novák', Alias__c = 'KaNov1234')
		);
		insert testAccount;
		testAccount = [SELECT PersonContactId FROM Account WHERE Alias__c = 'KaNov1234'];
		Task testTask = TestDataFactory.getTask(new Task(WhoId = testAccount.PersonContactId, LetterType__c = 'A003'));
		insert testTask;
	}

	@IsTest
	static void testCreateMailServiceNotifications() {
		Test.setMock(HttpCalloutMock.class, new MailSOAPServiceHttpMock());

		Task testTask = [SELECT WhoId, Who.Name, LetterType__c, ActivityLink__c FROM Task WHERE LetterType__c = 'A003'];
		EmailTemplate emailTemplate = [
			SELECT HtmlValue, Subject
			FROM EmailTemplate
			WHERE DeveloperName = 'NewLetterTask'
		];
		InvocableMailNotificationsHandler.GenerateNotificationRequest request = new InvocableMailNotificationsHandler.GenerateNotificationRequest();
		request.receiverEmail = 'tomail1@test.com';
		request.senderEmail = 'frommail1@test.com';
		request.emailTemplate = emailTemplate;
		request.sourceRecord = testTask;

		Test.startTest();
		insert InvocableMailNotificationsHandler.createMailServiceNotifications(
			new List<InvocableMailNotificationsHandler.GenerateNotificationRequest>{ request }
		);
		Test.stopTest();

		List<MailServiceNotification__c> createdNotifications = [
			SELECT Body__c, Subject__c, ToEmailAddress__c, FromEmailAddress__c, NotSentDueToError__c
			FROM MailServiceNotification__c
		];

		System.debug(createdNotifications);
		System.assertEquals(1, createdNotifications.size());
		System.assertEquals('frommail1@test.com', createdNotifications[0].FromEmailAddress__c);
		System.assertEquals('tomail1@test.com', createdNotifications[0].ToEmailAddress__c);
		System.assert(createdNotifications[0].Subject__c.contains('A003'));
		System.assert(createdNotifications[0].Body__c.contains('A003'));
		System.assertEquals(false, createdNotifications[0].NotSentDueToError__c);
	}
}
