@IsTest
public class AssetTriggerHandlerTest {

	@IsTest
	static void pairWithExistingOppTest() {
		Account acc = TestDataFactory.getAccount();
		insert acc;

		User owner = new User();
		owner.FirstName = 'Joe';
		owner.LastName = 'Tester';
		owner = TestDataFactory.getUser(owner);
		insert owner;

		Opportunity opp = new Opportunity();
		opp.Name = 'Test opp';
		opp.CloseDate = System.today().addDays(10);
		opp.AccountId = acc.Id;
		opp.OwnerId = owner.Id;
		opp.ProductType__c = '1';
		opp.StageName = '1';
		opp.ValidFrom__c = System.today().addDays(-10);
		opp.ValidTo__c = System.today().addDays(10);
		opp = TestDataFactory.getOpportunity(opp);
		insert opp;

		Asset asset = new Asset();
		asset.Name = 'Test asset';
		asset.AccountId = acc.Id;
		asset.ClosingAgentId__c = owner.Id;
		asset.ProductType__c = '1';
		asset.ProductCloseDate__c = System.today();
		asset = TestDataFactory.getAsset(asset);

		Test.startTest();
		insert asset;
		Test.stopTest();

		opp = [SELECT Id, StageName, Reason__c, Category__c, Probability FROM Opportunity WHERE Id = :opp.Id];

		System.assertEquals('7', opp.StageName);
		System.assertEquals('3', opp.Reason__c);
		System.assertEquals('2', opp.Category__c);
		System.assertEquals(100, opp.Probability);
	}

	@IsTest
	static void pairWithNewOppTest() {
		Account acc = TestDataFactory.getAccount();
		insert acc;

		User owner = new User();
		owner.FirstName = 'Joe';
		owner.LastName = 'Tester';
		owner = TestDataFactory.getUser(owner);
		insert owner;

		Asset asset = new Asset();
		asset.Name = 'Test asset';
		asset.AccountId = acc.Id;
		asset.ClosingAgentId__c = owner.Id;
		asset.ProductType__c = '1';
		asset.ProductCloseDate__c = System.today();
		asset = TestDataFactory.getAsset(asset);

		Test.startTest();
		insert asset;
		Test.stopTest();

		Opportunity opp = [SELECT Id, StageName, Reason__c, Category__c, Probability, Account.Id FROM Opportunity LIMIT 1];

		System.assertEquals('7', opp.StageName);
		System.assertEquals('3', opp.Reason__c);
		System.assertEquals('2', opp.Category__c);
		System.assertEquals(100, opp.Probability);
	}

	@IsTest
	static void pairWithNewOppUseHqUser() {
        System.debug('### starting pairWithNewOppUseHqUser');
        Account acc = TestDataFactory.getAccount();
		insert acc;

        List<User> cmssHeadQuarterUsers = [
            SELECT Id, CommissionAccountNr__c
            FROM User 
            WHERE CommissionAccountNr__c = '18002'
        ];

        User hqUser = new User();

        if (cmssHeadQuarterUsers.size() > 0){ //there can be one already in database, but doesn't have to be, so we will create it only if not there 
            hqUser = cmssHeadQuarterUsers[0];
        } else {
            hqUser.CommissionAccountNr__c = '18002';
            hqUser = TestDataFactory.getUser(hqUser);
            insert hqUser;
        }
        // User cmmsHeadQuartersUser = cmssHeadQuarterUsers.size() > 0 ? cmssHeadQuarterUsers[0] : null;

        // User hqUser = new User();
        // hqUser.CommissionAccountNr__c = '18002';
        // hqUser = TestDataFactory.getUser(hqUser);
        // insert hqUser;
        System.debug('### hqUser.Id' + hqUser.Id);

		Asset asset = new Asset();
		asset.Name = 'Test asset';
		asset.AccountId = acc.Id;
		asset.ProductType__c = '1';
		asset.ProductCloseDate__c = System.today();
		asset = TestDataFactory.getAsset(asset);

		Test.startTest();
		insert asset;
		Test.stopTest();

		Opportunity opp = [SELECT Id, OwnerId, StageName, Reason__c, Category__c, Probability from Opportunity LIMIT 1];

        System.debug('### pairWithNewOppUseHqUser asserts start');

		System.assertEquals('7', opp.StageName);
		System.assertEquals('3', opp.Reason__c);
		System.assertEquals('2', opp.Category__c);
		System.assertEquals(hqUser.Id, opp.OwnerId);
		System.assertEquals(100, opp.Probability);
        System.debug('### finishing pairWithNewOppUseHqUser');

	}

	@IsTest
	static void pairNewExistingOppUnsufficient() {
		Account acc = TestDataFactory.getAccount();
		insert acc;

		User owner = new User();
		owner.FirstName = 'Joe';
		owner.LastName = 'Tester';
		owner = TestDataFactory.getUser(owner);
		insert owner;

		Opportunity opp = new Opportunity();
		opp.Name = 'Test opp';
		opp.CloseDate = System.today().addDays(10);
		opp.AccountId = acc.Id;
		opp.OwnerId = owner.Id;
		opp.ProductType__c = '1';
		opp.StageName = '1';
		opp.Category__c = '6'; //category which should cause this opp will not be paired
		opp.ValidFrom__c = System.today().addDays(-10);
		opp.ValidTo__c = System.today().addDays(10);
		opp = TestDataFactory.getOpportunity(opp);
		insert opp;

		Asset asset = new Asset();
		asset.Name = 'Test asset';
		asset.AccountId = acc.Id;
		asset.ClosingAgentId__c = owner.Id;
		asset.ProductType__c = '1';
		asset.ProductCloseDate__c = System.today();
		asset = TestDataFactory.getAsset(asset);

		Test.startTest();
		insert asset;
		Test.stopTest();

		List<Opportunity> oppsWithAccountId = [SELECT Id, StageName, Reason__c, Category__c, Probability FROM Opportunity WHERE AccountId = :asset.AccountId];
		System.assertEquals(2, oppsWithAccountId.size());

		Opportunity pairedOpp = [SELECT Id, StageName, Reason__c, Category__c, Probability FROM Opportunity WHERE AccountId = :asset.AccountId AND Probability = 100 LIMIT 1];

		System.assertEquals('7', pairedOpp.StageName);
		System.assertEquals('3', pairedOpp.Reason__c);
		System.assertEquals('2', pairedOpp.Category__c);
	}

}