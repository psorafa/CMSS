@isTest
public class UnsignedOppNotification_BatchTest {
	@TestSetup
	static void makeDaprepareTestData() {
		RecordType personAccountRecordType = [
			SELECT Id
			FROM RecordType
			WHERE Name = 'Person Account' AND SObjectType = 'Account'
		];

		Account account1 = new Account();
		account1.RecordType = personAccountRecordType;
		account1.FirstName = 'Karel';
		account1.LastName = 'Novák';
		account1.PersonEmail = 'some@mail.com';
		insert account1;

		Opportunity opportunity = new Opportunity();
		opportunity.Category__c = '7';
		opportunity.StageName = '1';
		opportunity.AccountId = account1.Id;
		opportunity.Name = 'Test opportunity';
		opportunity.CloseDate = Date.valueOf(System.now().addDays(15));
		opportunity.CreatedDateTime__c = Date.valueOf(System.now().addDays(-3));
		insert opportunity;
	}

	@isTest
	static void testBatchRun() {
		Test.startTest();
		UnsignedOpportunityNotification_Batch batch = new UnsignedOpportunityNotification_Batch();
		Id batchId = Database.executeBatch(batch);
		Test.stopTest();
	}
}
