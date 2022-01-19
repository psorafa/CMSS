@IsTest
public class UpdateClientZoneOnAccount_BatchTest {
	@IsTest
	private static void UpdateClientZoneOnAccount() {
		Account account = TestDataFactory.getAccount(new Account());
		insert account;
		ClientZone__c clientZone1 = TestDataFactory.getClientZone(
			new ClientZone__c(
				AgreementDate__c = Date.Today().addDays(-10),
				Account__c = account.Id,
				Role__c = 'Omezený přístup'
			)
		);
		insert clientZone1;
		ClientZone__c clientZone2 = TestDataFactory.getClientZone(
			new ClientZone__c(AgreementDate__c = Date.Today(), Account__c = account.Id, Role__c = 'Bez přístupu')
		);
		insert clientZone2;
		UpdateClientZoneOnAccount_Batch batch = new UpdateClientZoneOnAccount_Batch();

		Test.startTest();
		Database.executeBatch(batch);
		Test.stopTest();

		Account acc = [SELECT Id, ClientZonewithLatestAgreementDate__c, ClientZoneAccess__c FROM Account];
		System.assertEquals(acc.ClientZoneAccess__c, clientZone2.Role__c);
	}
}
