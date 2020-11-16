@IsTest
private class SignCZContractRelationHandlerTest {

	@IsTest
	static void testBehavior() {
		Account account = TestDataFactory.getAccount(new Account());
		insert account;
		Account otherAccount = TestDataFactory.getAccount(new Account(
			GlobalId__c = 'G2'
		));
		insert otherAccount;
		ClientZone__c clientZone = TestDataFactory.getClientZone(new ClientZone__c(
			Account__c = account.Id
		));
		insert clientZone;
		AccountRelation__c accountRelation1 = TestDataFactory.getAccountRelation(new AccountRelation__c(
			RelatedAccount__c = account.Id,
			Account__c = otherAccount.Id,
			AmendmentNumber__c = 5,
			RelationTypeNEL__c = '5'
		));
		AccountRelation__c accountRelation2 = TestDataFactory.getAccountRelation(new AccountRelation__c(
			RelatedAccount__c = account.Id,
			Account__c = otherAccount.Id,
			AmendmentNumber__c = 6,
			RelationTypeNEL__c = '5'
		));
		insert new List<AccountRelation__c>{
			accountRelation1, accountRelation2
		};

		SF_PersonManagementSOAPService.SignCZContractRelationsRequestBody request = new SF_PersonManagementSOAPService.SignCZContractRelationsRequestBody();
		request.clientZoneId = clientZone.Id;
		request.amendmentNumber = 6;
		request.signDate = Date.today().addDays(-10);
		request.relatedClientGlobalId = otherAccount.GlobalId__c;

		Test.startTest();
		ClientZoneService.signCZContractRelations(request);
		Test.stopTest();

		accountRelation1 = [SELECT Id, AmendmentSignDate__c FROM AccountRelation__c WHERE Id = :accountRelation1.Id];
		accountRelation2 = [SELECT Id, AmendmentSignDate__c FROM AccountRelation__c WHERE Id = :accountRelation2.Id];
		System.assertEquals(null, accountRelation1.AmendmentSignDate__c);
		System.assertEquals(Date.today().addDays(-10), accountRelation2.AmendmentSignDate__c);
	}

	@IsTest
	static void testErrors() {
		Account account = TestDataFactory.getAccount(new Account());
		insert account;
		Account otherAccount = TestDataFactory.getAccount(new Account(
			GlobalId__c = 'G2'
		));
		insert otherAccount;
		ClientZone__c clientZone = TestDataFactory.getClientZone(new ClientZone__c(
			Account__c = account.Id
		));
		insert clientZone;

		SF_PersonManagementSOAPService.SignCZContractRelationsRequestBody request = new SF_PersonManagementSOAPService.SignCZContractRelationsRequestBody();
		request.clientZoneId = clientZone.Id;
		request.amendmentNumber = 6;
		request.signDate = Date.today().addDays(-10);
		request.relatedClientGlobalId = otherAccount.GlobalId__c;

		Test.startTest();
		try {
			ClientZoneService.signCZContractRelations(request);
		} catch (SOAPCommonTypes.BusinessException e) {
			System.assertEquals(205, e.getErrorNumber());
		}
		Test.stopTest();
	}
}