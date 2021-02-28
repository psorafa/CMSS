@IsTest
private class ActivateCZContractRelationsHandlerTest {

	@IsTest
	static void testBehavior() {
		Account account = TestDataFactory.getAccount(new Account());
		insert account;
		ClientZone__c clientZone = TestDataFactory.getClientZone(new ClientZone__c(
			Account__c = account.Id
		));
		insert clientZone;
		AccountRelation__c accountRelation1 = TestDataFactory.getAccountRelation(new AccountRelation__c(
			RelatedAccount__c = account.Id,
			AmendmentNumber__c = 5,
			RelationTypeNEL__c = '5',
			IsActive__c = true
		));
		AccountRelation__c accountRelation2 = TestDataFactory.getAccountRelation(new AccountRelation__c(
			RelatedAccount__c = account.Id,
			AmendmentNumber__c = 6,
			RelationTypeNEL__c = '5',
			IsActive__c = false
		));
		AccountRelation__c accountRelation3 = TestDataFactory.getAccountRelation(new AccountRelation__c(
			RelatedAccount__c = account.Id,
			AmendmentNumber__c = 6,
			IsActive__c = false
		));
		insert new List<AccountRelation__c>{
			accountRelation1, accountRelation2, accountRelation3
		};

		SF_PersonManagementSOAPService.ActivateCZContractRelationsRequestBody request = new SF_PersonManagementSOAPService.ActivateCZContractRelationsRequestBody();
		request.clientZoneId = clientZone.ExternalId__c;
		request.amendmentNumber = 6;

		Test.startTest();
		ClientZoneService.activateCZContractRelations(request);
		Test.stopTest();

		accountRelation1 = [SELECT Id, IsActive__c FROM AccountRelation__c WHERE Id = :accountRelation1.Id];
		System.assertEquals(false, accountRelation1.IsActive__c);
		accountRelation2 = [SELECT Id, IsActive__c FROM AccountRelation__c WHERE Id = :accountRelation2.Id];
		System.assertEquals(true, accountRelation2.IsActive__c);
		accountRelation3 = [SELECT Id, IsActive__c FROM AccountRelation__c WHERE Id = :accountRelation3.Id];
		System.assertEquals(false, accountRelation3.IsActive__c);
	}

	@IsTest
	static void testNullAmendment() {
		Account account = TestDataFactory.getAccount(new Account());
		insert account;
		ClientZone__c clientZone = TestDataFactory.getClientZone(new ClientZone__c(
			Account__c = account.Id
		));
		insert clientZone;
		AccountRelation__c accountRelation1 = TestDataFactory.getAccountRelation(new AccountRelation__c(
			RelatedAccount__c = account.Id,
			AmendmentNumber__c = 0,
			RelationTypeNEL__c = '5',
			IsActive__c = true
		));
		AccountRelation__c accountRelation2 = TestDataFactory.getAccountRelation(new AccountRelation__c(
			RelatedAccount__c = account.Id,
			AmendmentNumber__c = null,
			RelationTypeNEL__c = '5',
			IsActive__c = false
		));
		AccountRelation__c accountRelation3 = TestDataFactory.getAccountRelation(new AccountRelation__c(
			RelatedAccount__c = account.Id,
			AmendmentNumber__c = 1,
			RelationTypeNEL__c = '5',
			IsActive__c = false
		));
		insert new List<AccountRelation__c>{
			accountRelation1, accountRelation2, accountRelation3
		};

		SF_PersonManagementSOAPService.ActivateCZContractRelationsRequestBody request = new SF_PersonManagementSOAPService.ActivateCZContractRelationsRequestBody();
		request.clientZoneId = clientZone.ExternalId__c;
		request.amendmentNumber = null;

		Test.startTest();
		ClientZoneService.activateCZContractRelations(request);
		Test.stopTest();

		accountRelation1 = [SELECT Id, IsActive__c FROM AccountRelation__c WHERE Id = :accountRelation1.Id];
		System.assertEquals(true, accountRelation1.IsActive__c);
		accountRelation2 = [SELECT Id, IsActive__c FROM AccountRelation__c WHERE Id = :accountRelation2.Id];
		System.assertEquals(true, accountRelation2.IsActive__c);
		accountRelation3 = [SELECT Id, IsActive__c FROM AccountRelation__c WHERE Id = :accountRelation3.Id];
		System.assertEquals(false, accountRelation3.IsActive__c);
	}

	@IsTest
	static void testError() {
		Account account = TestDataFactory.getAccount(new Account());
		insert account;
		ClientZone__c clientZone = TestDataFactory.getClientZone(new ClientZone__c(
			Account__c = account.Id
		));
		insert clientZone;

		SF_PersonManagementSOAPService.ActivateCZContractRelationsRequestBody request = new SF_PersonManagementSOAPService.ActivateCZContractRelationsRequestBody();
		request.clientZoneId = clientZone.ExternalId__c;
		request.amendmentNumber = 1;

		Test.startTest();
		try {
			ClientZoneService.activateCZContractRelations(request);
		} catch (SOAPCommonTypes.BusinessException e) {
			System.assertEquals(204, e.getErrorNumber());
		}
		Test.stopTest();
	}
}