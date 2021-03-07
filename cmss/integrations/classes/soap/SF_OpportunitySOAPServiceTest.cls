@IsTest
private class SF_OpportunitySOAPServiceTest {

	private static Datetime dtPast = Datetime.now().addDays(-2);
	private static Date dNow = Date.today();
	private static Datetime dtFuture = Datetime.now().addDays(2);

	@IsTest
	static void createOpportunityTest() {
		User user = TestDataFactory.getUser(new User(CommissionAccountNr__c = 'CPU111'));
		insert user;
		Account account = TestDataFactory.getAccount(new Account(GlobalId__c = 'G111'));
		insert account;
		Asset asset = TestDataFactory.getAsset(new Asset(AccountId = account.Id, Name = 'A111'));
		insert asset;

		SF_OpportunitySOAPService.OpportunityRequestType request = new SF_OpportunitySOAPService.OpportunityRequestType();
		SF_OpportunitySOAPService.OpportunityType oppType = new SF_OpportunitySOAPService.OpportunityType();
		oppType.customerGlobalId = 'G111';
		oppType.description = 'description';
		oppType.subject = 'subject';
		oppType.stateReason = '2';
		oppType.result = '2';
		oppType.author = 'author';
		oppType.statusManagerCPU = 'CPU111';
		oppType.validFrom = dtPast;
		oppType.validTo = dtFuture;
		oppType.category = '1';
		oppType.contractNumber = 'A111';
		oppType.delegatedDate = dNow;
		request.requestBody = oppType;

		Test.startTest();
		SF_OpportunitySOAPService.OpportunityResponseType response = SF_OpportunitySOAPService.createOpportunity(request);
		Test.stopTest();

		System.assert(response.isFault == false, JSON.serializePretty(response.fault));
		Opportunity opp = [
			SELECT
				Id, AccountId, Description, Name, StageName, Reason__c, Author__c, OwnerId, CreatedDateTime__c,
				ValidFrom__c, CloseDate, ValidTo__c, Category__c, OriginalAsset__c, DelegatedDate__c, DueDate__c
			FROM Opportunity
			WHERE ExternalId__c = :response.responseBody.opportunityId
		];

		System.assertEquals(account.Id, opp.AccountId);
		System.assertEquals(oppType.description, opp.Description);
		System.assertEquals(oppType.stateReason, opp.StageName);
		System.assertEquals(oppType.result, opp.Reason__c);
		System.assertEquals(oppType.author, opp.Author__c);
		System.assertEquals(user.Id, opp.OwnerId);
		System.assertEquals(oppType.validFrom, opp.CreatedDateTime__c);
		System.assertEquals(oppType.validFrom, opp.ValidFrom__c);
		System.assertEquals(oppType.validTo.date(), opp.CloseDate);
		System.assertEquals(oppType.validTo, opp.ValidTo__c);
		System.assertEquals(oppType.category, opp.Category__c);
		System.assertEquals(asset.Id, opp.OriginalAsset__c);
		System.assertEquals(oppType.delegatedDate, opp.DelegatedDate__c);
		System.assertEquals(dNow.addDays(90), opp.DueDate__c);
	}

	@IsTest
	static void createOpportunity_DefaultValuesTest() {
		User user = TestDataFactory.getUser(new User(CommissionAccountNr__c = 'CPU111'));
		insert user;
		Account account = TestDataFactory.getAccount(new Account(GlobalId__c = 'G111'));
		insert account;
		Asset asset = TestDataFactory.getAsset(new Asset(AccountId = account.Id, Name = 'A111'));
		insert asset;

		SF_OpportunitySOAPService.OpportunityRequestType request = new SF_OpportunitySOAPService.OpportunityRequestType();
		SF_OpportunitySOAPService.OpportunityType oppType = new SF_OpportunitySOAPService.OpportunityType();
		oppType.customerGlobalId = 'G111';
		oppType.description = 'description';
		oppType.subject = 'subject';
		oppType.result = '2';
		oppType.author = 'author';
		oppType.statusManagerCPU = 'CPU111';
		oppType.category = '1';
		oppType.contractNumber = 'A111';
		oppType.delegatedDate = dNow;
		request.requestBody = oppType;

		Test.startTest();
		SF_OpportunitySOAPService.OpportunityResponseType response = SF_OpportunitySOAPService.createOpportunity(request);
		Test.stopTest();

		System.assert(response.isFault == false, JSON.serializePretty(response.fault));
		Opportunity opp = [
			SELECT
				Id, AccountId, Description, Name, StageName, Reason__c, Author__c, OwnerId, CreatedDateTime__c,
				ValidFrom__c, CloseDate, ValidTo__c, Category__c, OriginalAsset__c, DelegatedDate__c, DueDate__c
			FROM Opportunity
			WHERE ExternalId__c = :response.responseBody.opportunityId
		];

		System.assertEquals('1', opp.StageName);
		System.assertEquals(dNow, opp.CreatedDateTime__c.date());
		System.assertEquals(dNow, opp.ValidFrom__c.date());
		System.assertEquals(dNow.addDays(90), opp.CloseDate);
		System.assertEquals(dNow.addDays(90), opp.DueDate__c);
	}
}