@IsTest
public class DeleteClientZoneNotification_BatchTest {
	@TestSetup
	static void prepareTestData() {
		RecordType personAccountRecordType = [
			SELECT Id
			FROM RecordType
			WHERE Name = 'Person Account' AND SObjectType = 'Account'
		];

		insert TestDataFactory.getIntegrationSettings();

		Account account1 = new Account();
		account1.RecordType = personAccountRecordType;
		account1.FirstName = 'Karel';
		account1.LastName = 'Novák';
		account1.GlobalId__c = '12345';

		Account account2 = new Account();
		account2.RecordType = personAccountRecordType;
		account2.FirstName = 'Mirek';
		account2.LastName = 'Novák';
		account2.GlobalId__c = '54321';

		Account account3 = new Account();
		account3.RecordType = personAccountRecordType;
		account3.FirstName = 'František';
		account3.LastName = 'Novák';
		account3.GlobalId__c = '87654';

		insert new List<Account>{ account1, account2, account3 };

		account1.GlobalId__c = account1.GlobalId__c;
		account2.GlobalId__c = account2.GlobalId__c;

		update new List<Account>{ account1, account2 };

		ClientZone__c clientZone1 = new ClientZone__c();
		clientZone1.ClosedBy__c = null;
		clientZone1.Role__c = '7';
		clientZone1.Status__c = '1';
		clientZone1.Email__c = 'email@invalid.test';
		clientZone1.Account__c = account1.Id;
		clientZone1.ModifiedDate__c = System.now().addDays(-2);
		clientZone1.CancelationNotificationSentDate__c = null;

		ClientZone__c clientZone2 = new ClientZone__c();
		clientZone2.ClosedBy__c = null;
		clientZone2.Role__c = '7';
		clientZone2.Status__c = '1';
		clientZone2.Email__c = 'email@invalid.test';
		clientZone2.Account__c = account2.Id;
		clientZone2.ModifiedDate__c = System.now().addDays(-2);
		clientZone2.CancelationNotificationSentDate__c = null;

		ClientZone__c clientZone3 = new ClientZone__c();
		clientZone3.ClosedBy__c = null;
		clientZone3.Role__c = '7';
		clientZone3.Status__c = '1';
		clientZone3.Account__c = account3.Id;
		clientZone3.ModifiedDate__c = System.now().addDays(-2);
		clientZone3.CancelationNotificationSentDate__c = System.now().addDays(-35);

		insert new List<ClientZone__c>{ clientZone1, clientZone2, clientZone3 };

		Test.setCreatedDate(clientZone1.ID, System.now().addDays(-16));
		Test.setCreatedDate(clientZone2.ID, System.now().addDays(-50));

		AccountRelation__c accountRelation = new AccountRelation__c();
		accountRelation.AccountRole__c = '1501';
		accountRelation.Account__c = account2.Id;
		accountRelation.RelatedAccount__c = account2.Id;
		insert accountRelation;

		KZNotificationSettings__c settings = new KZNotificationSettings__c();
		settings.DaysFromKZCreation__c = 1;
		settings.DaysBetweenNotificationAndDeletion__c = 2;
		insert settings;
	}

	@isTest
	static void testBatchRun() {
		Test.setMock(HttpCalloutMock.class, new MailSOAPServiceHttpMock());
		Test.startTest();
		DeleteClientZoneNotification_Batch batch = new DeleteClientZoneNotification_Batch();
		Id batchId = Database.executeBatch(batch);
		Test.stopTest();
		MailServiceNotification__c notification = [
			SELECT Subject__c, NotSentDueToError__c
			FROM MailServiceNotification__c
		][0];
		System.assertEquals('Upozornění na možné zrušení Klientské zóny', notification.Subject__c);
		System.assertEquals(true, notification.NotSentDueToError__c);
	}
}
