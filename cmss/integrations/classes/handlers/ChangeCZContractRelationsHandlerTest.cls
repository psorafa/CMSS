@IsTest
private class ChangeCZContractRelationsHandlerTest {

	@IsTest
	static void testBehavior() {
		User user = TestDataFactory.getUser(new User(
			CommissionAccountNr__c = 'CPU1'
		));
		insert user;
		Account account = TestDataFactory.getAccount(new Account());
		insert account;
		ClientZone__c clientZone = TestDataFactory.getClientZone(new ClientZone__c(
			NumberOfAnnexes__c = 5,
			Account__c = account.Id
		));
		insert clientZone;
		AccountRelation__c accountRelation = TestDataFactory.getAccountRelation(new AccountRelation__c(
			RelatedAccount__c = account.Id,
			ExternalId__c = 'ABCD1'
		));
		insert accountRelation;

		Account anotherAccount1 = TestDataFactory.getAccount(new Account());
		Account anotherAccount2 = TestDataFactory.getAccount(new Account());
		insert new List<Account>{
			anotherAccount1, anotherAccount2
		};

		SF_PersonManagementSOAPService.ChangeCZContractRelationsRequestBody request = new SF_PersonManagementSOAPService.ChangeCZContractRelationsRequestBody();
		request.clientZoneId = clientZone.ExternalId__c;
		request.closedByCPU = user.CommissionAccountNr__c;
		request.amendmentNumber = 6;
		SF_PersonManagementSOAPService.ClientRelationType relation1 = new SF_PersonManagementSOAPService.ClientRelationType();
		relation1.validTo = Date.today().addDays(10);
		relation1.externalId = 'ABCD1';
		relation1.role = 'R1';
		SF_PersonManagementSOAPService.ClientRelationType relation2 = new SF_PersonManagementSOAPService.ClientRelationType();
		relation2.relatedClientId = anotherAccount2.GlobalId__c;
		relation2.validTo = Date.today().addDays(10);
		relation2.externalId = 'ABCD2';
		request.relations = new List<SF_PersonManagementSOAPService.ClientRelationType>{
			relation1, relation2
		};

		Test.startTest();
		ClientZoneService.changeCZContractRelations(request);
		Test.stopTest();

		clientZone = [SELECT Id, ClosedBy__c, NumberOfAnnexes__c FROM ClientZone__c WHERE Id = :clientZone.Id];
		System.assertEquals(user.Id, clientZone.ClosedBy__c);
		System.assertEquals(6, clientZone.NumberOfAnnexes__c);

		accountRelation = [SELECT Id, Account__c, AccountRole__c, RelatedAccount__c, RelatedAccountRole__c, AmendmentNumber__c, ValidFrom__c, ValidTo__c FROM AccountRelation__c WHERE ExternalId__c = 'ABCD1'];
		System.assertEquals(account.Id, accountRelation.RelatedAccount__c);
		System.assertEquals('1502', accountRelation.RelatedAccountRole__c);
		System.assertEquals('1501', accountRelation.AccountRole__c);
		System.assertEquals(6, accountRelation.AmendmentNumber__c);
		System.assertEquals(Date.today(), accountRelation.ValidFrom__c);
		System.assertEquals(Date.today().addDays(10), accountRelation.ValidTo__c);

		accountRelation = [SELECT Id, Account__c, AccountRole__c, RelatedAccount__c, RelatedAccountRole__c, AmendmentNumber__c, ValidFrom__c, ValidTo__c FROM AccountRelation__c WHERE ExternalId__c = 'ABCD2'];
		System.assertEquals(account.Id, accountRelation.RelatedAccount__c);
		System.assertEquals('1502', accountRelation.RelatedAccountRole__c);
		System.assertEquals(anotherAccount2.Id, accountRelation.Account__c);
		System.assertEquals('1501', accountRelation.AccountRole__c);
		System.assertEquals(6, accountRelation.AmendmentNumber__c);
		System.assertEquals(Date.today(), accountRelation.ValidFrom__c);
		System.assertEquals(Date.today().addDays(10), accountRelation.ValidTo__c);
	}

	@IsTest
	static void testErrors() {
		User user = TestDataFactory.getUser(new User(
			CommissionAccountNr__c = 'CPU1'
		));
		insert user;
		Account account = TestDataFactory.getAccount(new Account());
		insert account;
		ClientZone__c clientZone = TestDataFactory.getClientZone(new ClientZone__c(
			NumberOfAnnexes__c = 5,
			Account__c = account.Id
		));
		insert clientZone;
		AccountRelation__c accountRelation = TestDataFactory.getAccountRelation(new AccountRelation__c(
			RelatedAccount__c = account.Id,
			ExternalId__c = 'ABCD1'
		));
		insert accountRelation;

		Account anotherAccount1 = TestDataFactory.getAccount(new Account());
		insert anotherAccount1;

		SF_PersonManagementSOAPService.ChangeCZContractRelationsRequestBody request = new SF_PersonManagementSOAPService.ChangeCZContractRelationsRequestBody();
		request.clientZoneId = clientZone.Id;
		request.closedByCPU = user.CommissionAccountNr__c;
		request.amendmentNumber = 6;
		SF_PersonManagementSOAPService.ClientRelationType relation1 = new SF_PersonManagementSOAPService.ClientRelationType();
		relation1.relatedClientId = anotherAccount1.GlobalId__c;
		relation1.validTo = Date.today().addDays(10);
		relation1.externalId = 'ABCD1';
		relation1.role = 'R1';
		request.relations = new List<SF_PersonManagementSOAPService.ClientRelationType>{
			relation1
		};

		try {
			request.clientZoneId = account.Id;
			ClientZoneService.changeCZContractRelations(request);
		} catch (SOAPCommonTypes.BusinessException e) {
			System.assertEquals(201, e.getErrorNumber());
			request.clientZoneId = clientZone.Id;
		}
		try {
			request.closedByCPU = 'invalidCPU';
			ClientZoneService.changeCZContractRelations(request);
		} catch (SOAPCommonTypes.BusinessException e) {
			System.assertEquals(201, e.getErrorNumber());
			request.closedByCPU = user.CommissionAccountNr__c;
		}
		try {
			relation1.relatedClientId = 'invalidGlobalID';
			ClientZoneService.changeCZContractRelations(request);
		} catch (SOAPCommonTypes.BusinessException e) {
			System.assertEquals(201, e.getErrorNumber());
			relation1.relatedClientId = anotherAccount1.GlobalId__c;
		}

		try {
			request.clientZoneId = null;
			ClientZoneService.changeCZContractRelations(request);
		} catch (SOAPCommonTypes.BusinessException e) {
			System.assertEquals(101, e.getErrorNumber());
			request.clientZoneId = clientZone.Id;
		}
		try {
			request.amendmentNumber = null;
			ClientZoneService.changeCZContractRelations(request);
		} catch (SOAPCommonTypes.BusinessException e) {
			System.assertEquals(101, e.getErrorNumber());
			request.amendmentNumber = 6;
		}
	}

}