@IsTest
public class MailNotificationsHandlerTest {
	@TestSetup
	static void makeData() {
		RecordType personAccountRecordType = [
			SELECT Id
			FROM RecordType
			WHERE Name = 'Person Account' AND SObjectType = 'Account'
		];

		Account account = new Account();
		account.RecordType = personAccountRecordType;
		account.FirstName = 'Karel';
		account.LastName = 'Novák';
		account.Alias__c = 'KaNov1234';
		insert account;

		ClientZone__c clientZone = new clientZone__c();
		clientZone.ContractNumber__c = '1234';
		clientZone.Account__c = account.Id;
		insert clientZone;
	}

	@IsTest
	static void testHandler() {
		Test.setMock(HttpCalloutMock.class, new MailSOAPServiceHttpMock());
		insert TestDataFactory.getIntegrationSettings();
		Account testAccount = [SELECT FirstName, LastName FROM Account WHERE Alias__c = 'KaNov1234'];

		Opportunity opportunity = new Opportunity();
		opportunity.Name = 'Test Opportunity';
		opportunity.StageName = 'New';
		opportunity.CloseDate = Date.valueOf(System.now().addDays(5));
		opportunity.AccountId = testAccount.Id;
		insert opportunity;

		MailNotificationsHandler testHandler = new MailNotificationsHandler();
		testHandler.setEmailTemplate(new EmailTemplate())
			.setEmailTemplate('UnfinishedContractNotification')
			.setSpecialVariables(new Map<String, String>{ 'DateOfCreation__c' => 'NOW', 'ORG_URL' => 'some url' })
			.setSender('test@sender.invalid')
			.setReceivers(new List<String>{ 'notthismail1@test.com' })
			.setContext('DIGIKZ');

		Test.startTest();
		testHandler.generateNotifications(opportunity, new List<String>{ 'tomail1@test.com', 'tomail2@test.com' });
		testHandler.handleInsertNotifications();
		Test.stopTest();
		List<MailServiceNotification__c> createdNotifications = [
			SELECT Body__c, Subject__c, ToEmailAddress__c, FromEmailAddress__c, NotSentDueToError__c
			FROM MailServiceNotification__c
		];

		System.assertEquals(2, createdNotifications.size());
		System.assert(createdNotifications[0].Subject__c.contains('Novák Karel'), createdNotifications[0].Subject__c);
		System.assertEquals('test@sender.invalid', createdNotifications[0].FromEmailAddress__c);
		System.assert(
			createdNotifications[0].ToEmailAddress__c == 'tomail1@test.com' &&
			createdNotifications[1].ToEmailAddress__c == 'tomail2@test.com'
		);
		System.assertEquals(true, createdNotifications[0].NotSentDueToError__c);
	}
}
