@isTest
public class UnsignedOppNotification_BatchTest {
	@TestSetup
	static void makeData() {
		RecordType personAccountRecordType = [
			SELECT Id
			FROM RecordType
			WHERE Name = 'Person Account' AND SObjectType = 'Account'
		];

		insert TestDataFactory.getIntegrationSettings();

		User user = TestDataFactory.getUser(new User());
		user.Email = 'user@invalid.test2';
		user.CooperationPartnerType__c = '4';
		insert user;

		Account account1 = new Account();
		account1.RecordType = personAccountRecordType;
		account1.FirstName = 'Karel';
		account1.LastName = 'Novák';
		account1.PersonEmail = 'some@mail.com';
		account1.PortfolioMngmtC__c = null;
		insert account1;

		Opportunity opportunity = new Opportunity();
		opportunity.Category__c = '7';
		opportunity.StageName = '1';
		opportunity.AccountId = account1.Id;
		opportunity.Name = 'Test opportunity';
		opportunity.Owner = user;
		opportunity.OwnerId = user.Id;
		opportunity.CloseDate = Date.valueOf(System.now().addDays(15));
		opportunity.CreatedDateTime__c = System.today().addDays(-2);
		insert opportunity;

		ClientZone__c clientZone = new ClientZone__c();
		clientZone.ContractNumber__c = '1234';
		clientZone.Account__c = account1.Id;
		insert clientZone;

		KZNotificationSettings__c settings = new KZNotificationSettings__c();
		settings.DaysFromOppCreationOZ__c = 2;
		settings.DaysFromOppCreation__c = '2';
		insert settings;
	}

	@isTest
	static void testBatchRun() {
		Test.setMock(HttpCalloutMock.class, new MailSOAPServiceHttpMock());
		Test.startTest();
		UnsignedOpportunityNotification_Batch batch = new UnsignedOpportunityNotification_Batch();
		Id batchId = Database.executeBatch(batch);
		Test.stopTest();
	}
}
