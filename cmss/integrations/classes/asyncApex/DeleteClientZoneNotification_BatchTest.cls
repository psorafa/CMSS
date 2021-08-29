@IsTest
public class DeleteClientZoneNotification_BatchTest {
	@TestSetup
	static void prepareTestData() {
		RecordType personAccountRecordType = [
			SELECT Id
			FROM RecordType
			WHERE Name = 'Person Account' AND SObjectType = 'Account'
		];

		Account account1 = new Account();
		account1.RecordType = personAccountRecordType;
		account1.FirstName = 'Karel';
		account1.LastName = 'Novák';

		Account account2 = new Account();
		account2.RecordType = personAccountRecordType;
		account2.FirstName = 'Mirek';
		account2.LastName = 'Novák';
		insert new List<Account>{ account1, account2 };

		account1.GlobalId__c = account1.Id;
		account2.GlobalId__c = account2.Id;

		update new List<Account>{ account1, account2 };

		ClientZone__c clientZone1 = new ClientZone__c();
		clientZone1.ClosedBy__c = null;
		clientZone1.Role__c = '7';
		clientZone1.Status__c = '1';
		clientZone1.Account__c = account1.Id;
		clientZone1.CreatedDate__c = System.now().addDays(-16);
		clientZone1.CancelationNotificationSentDate__c = null;

		ClientZone__c clientZone2 = new ClientZone__c();
		clientZone2.ClosedBy__c = null;
		clientZone2.Role__c = '7';
		clientZone2.Status__c = '1';
		clientZone2.Account__c = account2.Id;
		clientZone2.CreatedDate__c = System.now().addDays(-50);
		clientZone2.CancelationNotificationSentDate__c = System.now().addDays(-35);

		insert new List<ClientZone__c>{ clientZone1, clientZone2 };

		AccountRelation__c accountRelation = new AccountRelation__c();
		accountRelation.RelationTypeNEL__c = '1';
		accountRelation.Account__c = account1.Id;
		accountRelation.RelatedAccount__c = account2.Id;
		insert accountRelation;
	}

	@isTest
	static void testBatchRun() {
		Test.startTest();
		DeleteClientZoneNotification_Batch batch = new DeleteClientZoneNotification_Batch();
		Id batchId = Database.executeBatch(batch);
		Test.stopTest();
	}
}
