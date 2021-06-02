@IsTest
public class AssetTriggerHandlerTest {

	@IsTest
	static void pairWithExistingOppTest() {
		Account acc = TestDataFactory.getAccount();
		insert acc;

		User owner = new User();
		owner.FirstName = 'Joe';
		owner.LastName = 'Tester';
        owner.CommissionAccountNr__c = '123';
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
        asset.ClosingAgentId__c = owner.Id; 
        asset.productType__c = '0';
        asset.Status__c = '10003';
        asset.RecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CreditCases').getRecordTypeId();
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


    static void pairWithNewOppTest() {
		Account acc = TestDataFactory.getAccount();
		insert acc;

		User owner = new User();
		owner.FirstName = 'Joe';
		owner.LastName = 'Tester';
        owner.CommissionAccountNr__c = '123';
		owner = TestDataFactory.getUser(owner);
		insert owner;

		Asset asset = new Asset();
		asset.Name = 'Test asset';
		asset.AccountId = acc.Id;
		asset.ClosingAgentId__c = owner.Id;
		asset.ProductType__c = '1';
		asset.ProductCloseDate__c = System.today();
        asset.ClosingAgentId__c = owner.Id; 
        asset.productType__c = '0';
        asset.Status__c = '10003';
        asset.RecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CreditCases').getRecordTypeId();
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

        static void doNotpairWrongStatusTest() {
		Account acc = TestDataFactory.getAccount();
		insert acc;

		User owner = new User();
		owner.FirstName = 'Joe';
		owner.LastName = 'Tester';
        owner.CommissionAccountNr__c = '123';
		owner = TestDataFactory.getUser(owner);
		insert owner;

		Asset asset = new Asset();
		asset.Name = 'Test asset';
		asset.AccountId = acc.Id;
		asset.ClosingAgentId__c = owner.Id;
		asset.ProductType__c = '1';
		asset.ProductCloseDate__c = System.today();
        asset.ClosingAgentId__c = owner.Id; 
        asset.productType__c = '0';
        asset.Status__c = '8001'; //incorrect status for credit cases
        asset.RecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CreditCases').getRecordTypeId();
		asset = TestDataFactory.getAsset(asset);

		Test.startTest();
		insert asset;
		Test.stopTest();

		List<Opportunity> opps = [SELECT Id, StageName, Reason__c, Category__c, Probability, Account.Id FROM Opportunity];

		System.assertEquals(0, opps.size());
	}

    static void testAfterUpdate() {
		Account acc = TestDataFactory.getAccount();
		insert acc;

		User owner = new User();
		owner.FirstName = 'Joe';
		owner.LastName = 'Tester';
        owner.CommissionAccountNr__c = '123';
		owner = TestDataFactory.getUser(owner);
		insert owner;

		Asset asset = new Asset();
		asset.Name = 'Test asset';
		asset.AccountId = acc.Id;
		asset.ClosingAgentId__c = owner.Id;
		asset.ProductType__c = '1';
		asset.ProductCloseDate__c = System.today();
        asset.ClosingAgentId__c = owner.Id; 
        asset.productType__c = '0';
        asset.Status__c = '8001'; //incorrect status for credit cases, firstly won't be paired
        asset.RecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CreditCases').getRecordTypeId();
		asset = TestDataFactory.getAsset(asset);
        insert asset;

        List<Opportunity> opps = [SELECT Id, StageName, Reason__c, Category__c, Probability, Account.Id FROM Opportunity];
		System.assertEquals(0, opps.size());
        
		Test.startTest();
        asset.Status__c = '10003'; //now putting here correct status
        update asset;
		Test.stopTest();

        Opportunity opp = [SELECT Id, StageName, Reason__c, Category__c, Probability, Account.Id FROM Opportunity LIMIT 1];

		System.assertEquals('7', opp.StageName);
		System.assertEquals('3', opp.Reason__c);
		System.assertEquals('2', opp.Category__c);
		System.assertEquals(100, opp.Probability);
	}

}