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
        insert opp;

        Asset asset = new Asset();
        asset.name = 'Test asset';
        asset.AccountID = acc.Id;
        asset.ClosingAgentId__c = owner.Id;
        asset.ProductType__c = '1';
        asset.ProductCloseDate__c = System.today();

        Test.startTest();
        insert asset;
        Test.stopTest();

        opp = [SELECT Id, StageName, Reason__c, Category__c from Opportunity WHERE Id = : opp.Id];

        System.assertEquals('7', opp.StageName);
        System.assertEquals('3', opp.Reason__c);
        System.assertEquals('2', opp.Category__c);
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
        asset.name = 'Test asset';
        asset.AccountID = acc.Id;
        asset.ClosingAgentId__c = owner.Id;
        asset.ProductType__c = '1';
        asset.ProductCloseDate__c = System.today();

        Test.startTest();
        insert asset;
        Test.stopTest();

        Opportunity opp = [SELECT Id, StageName, Reason__c, Category__c, Probability, Account.Id from Opportunity LIMIT 1];

        System.assertEquals('7', opp.StageName);
        System.assertEquals('3', opp.Reason__c);
        System.assertEquals('2', opp.Category__c);
        System.assertEquals(100, opp.Probability);
	}
}