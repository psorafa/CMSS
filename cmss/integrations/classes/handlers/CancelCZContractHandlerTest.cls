@IsTest
public class CancelCZContractHandlerTest {
	@IsTest
	static void testClientZoneUpdate() {
		Account account = TestDataFactory.getAccount(new Account());
		insert account;
		ClientZone__c clientZone = TestDataFactory.getClientZone(new ClientZone__c(Account__c = account.Id));
		insert clientZone;

		CancelCZContractHandler handler = new CancelCZContractHandler(clientZone);

		Test.startTest();
		handler.handle();
		Test.stopTest();

		ClientZone__c updatedClientZone = [
			SELECT Id, Role__c, Status__c
			FROM ClientZone__c
			WHERE Account__c = :account.Id
		];
		System.assertEquals('8', updatedClientZone.Role__c);
		System.assertEquals('2', updatedClientZone.Status__c);
	}
}
