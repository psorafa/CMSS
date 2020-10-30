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
				ValidFrom__c, CloseDate, ValidTo__c, Category__c, OriginalAsset__c, DelegatedDate__c
			FROM Opportunity
			WHERE Id = :response.responseBody.opportunityId
		];
	}
}