@IsTest
public class ClientZoneTriggerHandlerTest {
	@IsTest
	static void setClientZoneTest() {
		Account account = TestDataFactory.getAccount(new Account());
		insert account;
		ClientZone__c clientZone1 = TestDataFactory.getClientZone(
			new ClientZone__c(
				AgreementDate__c = Date.Today().addDays(-10),
				Account__c = account.Id,
				Role__c = 'Limited'
			)
		);
		insert clientZone1;

		ClientZone__c clientZone2 = TestDataFactory.getClientZone(
			new ClientZone__c(AgreementDate__c = Date.Today(), Account__c = account.Id, Role__c = 'No Access')
		);

		Test.startTest();
		insert clientZone2;
		Test.stopTest();
		Account acc = [SELECT Id, ClientZonewithLatestAgreementDate__c, ClientZoneAccess__c FROM Account];
		System.assertEquals(acc.ClientZonewithLatestAgreementDate__c, clientZone2.Id);
		System.assertEquals(acc.ClientZoneAccess__c, clientZone2.Role__c);
	}

	@IsTest
	static void setClientZoneAfterUpdateTest() {
		Account account = TestDataFactory.getAccount(new Account());
		insert account;
		ClientZone__c clientZone1 = TestDataFactory.getClientZone(
			new ClientZone__c(
				AgreementDate__c = Date.Today().addDays(-10),
				Account__c = account.Id,
				Role__c = 'Limited'
			)
		);
		insert clientZone1;

		ClientZone__c clientZone2 = TestDataFactory.getClientZone(
			new ClientZone__c(AgreementDate__c = Date.Today(), Account__c = account.Id, Role__c = 'No Access')
		);
		insert clientZone2;

		Test.startTest();
		clientZone2.AgreementDate__c = Date.Today().addDays(-15);
		update clientZone2;
		Test.stopTest();
		Account acc = [SELECT Id, ClientZonewithLatestAgreementDate__c, ClientZoneAccess__c FROM Account];
		System.assertEquals(acc.ClientZonewithLatestAgreementDate__c, clientZone1.Id);
		System.assertEquals(acc.ClientZoneAccess__c, clientZone1.Role__c);
	}

	@IsTest
	static void deleteClientZoneTest() {
		Account account = TestDataFactory.getAccount(new Account());
		insert account;
		ClientZone__c clientZone1 = TestDataFactory.getClientZone(
			new ClientZone__c(
				AgreementDate__c = Date.Today().addDays(-10),
				Account__c = account.Id,
				Role__c = 'Limited'
			)
		);
		insert clientZone1;

		ClientZone__c clientZone2 = TestDataFactory.getClientZone(
			new ClientZone__c(AgreementDate__c = Date.Today(), Account__c = account.Id, Role__c = 'No Access')
		);
		insert clientZone2;

		Test.startTest();
		delete clientZone2;
		Test.stopTest();
		Account acc = [SELECT Id, ClientZonewithLatestAgreementDate__c, ClientZoneAccess__c FROM Account];
		System.assertEquals(acc.ClientZonewithLatestAgreementDate__c, clientZone1.Id);
		System.assertEquals(acc.ClientZoneAccess__c, clientZone1.Role__c);
	}
	@IsTest
	static void deleteAllClientZonesTest() {
		Account account = TestDataFactory.getAccount(new Account());
		insert account;
		ClientZone__c clientZone1 = TestDataFactory.getClientZone(
			new ClientZone__c(
				AgreementDate__c = Date.Today().addDays(-10),
				Account__c = account.Id,
				Role__c = 'Limited'
			)
		);
		insert clientZone1;

		ClientZone__c clientZone2 = TestDataFactory.getClientZone(
			new ClientZone__c(AgreementDate__c = Date.Today(), Account__c = account.Id, Role__c = 'No Access')
		);
		insert clientZone2;

		Test.startTest();
		delete clientZone1;
		delete clientZone2;
		Test.stopTest();
		Account acc = [SELECT Id, ClientZonewithLatestAgreementDate__c, ClientZoneAccess__c FROM Account];
		System.assertEquals(acc.ClientZonewithLatestAgreementDate__c, null);
		System.assertEquals(acc.ClientZoneAccess__c, null);
	}
}
