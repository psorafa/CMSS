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
		opp.ProductType__c = '0';
		opp.StageName = '1';
		opp.ValidFrom__c = System.today().addDays(-10);
		opp.ValidTo__c = System.today().addDays(10);
		opp = TestDataFactory.getOpportunity(opp);
		insert opp;

		Asset asset = new Asset();
		asset.Name = 'Test asset';
		asset.AccountId = acc.Id;
		asset.ProductCloseDate__c = System.today();
		asset.ClosingAgentId__c = owner.Id;
		asset.ProductType__c = '0';
		asset.Status__c = '10003';
		asset.RecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CreditCases').getRecordTypeId();
		asset = TestDataFactory.getAsset(asset);

		Test.startTest();
		insert asset;
		Test.stopTest();

		opp = [SELECT Id, StageName, Reason__c, Category__c, Probability FROM Opportunity WHERE Id = :opp.Id];

		System.assertEquals('7', opp.StageName);
		System.assertEquals('3', opp.Reason__c);
		//	System.assertEquals('2', opp.Category__c);
		System.assertEquals(100, opp.Probability);
	}

	@IsTest
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
		asset.ProductCloseDate__c = System.today();
		asset.ClosingAgentId__c = owner.Id;
		asset.ProductType__c = '0';
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

	@IsTest
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
		asset.ProductCloseDate__c = System.today();
		asset.ClosingAgentId__c = owner.Id;
		asset.ProductType__c = '0';
		asset.Status__c = '8001'; //incorrect status for credit cases
		asset.RecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CreditCases').getRecordTypeId();
		asset = TestDataFactory.getAsset(asset);

		Test.startTest();
		insert asset;
		Test.stopTest();

		List<Opportunity> opps = [SELECT Id, StageName, Reason__c, Category__c, Probability, Account.Id FROM Opportunity];

		System.assertEquals(0, opps.size());
	}

	@IsTest
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
		asset.ProductCloseDate__c = System.today();
		asset.ClosingAgentId__c = owner.Id;
		asset.ProductType__c = '0';
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

	@isTest
	static void accountFieldsUpdatedTest() {
		Account acc1 = TestDataFactory.getAccount(new Account());
		acc1.OpenedActivityDate__c = null;
		acc1.LastInteractionDate__c = null;
		insert acc1;

		Asset asset1 = TestDataFactory.getAsset(new Asset());
		asset1.AccountId = acc1.Id;
		asset1.ProductCloseDate__c = System.today().addDays(-5);

		insert asset1;

		Account updatedAccount = [SELECT Id, AssetLastCloseDate__c, LastInteractionDate__c FROM Account WHERE Id = :acc1.Id];

		System.assertEquals(asset1.ProductCloseDate__c, updatedAccount.AssetLastCloseDate__c);
		System.assertEquals(asset1.ProductCloseDate__c, updatedAccount.LastInteractionDate__c);

		asset1.ProductCloseDate__c = System.today().addDays(-3);
		update asset1;
		updatedAccount = [SELECT Id, AssetLastCloseDate__c, LastInteractionDate__c FROM Account WHERE Id = :acc1.Id];

		System.assertEquals(asset1.ProductCloseDate__c, updatedAccount.AssetLastCloseDate__c);
		System.assertEquals(asset1.ProductCloseDate__c, updatedAccount.LastInteractionDate__c);
	}

	@IsTest
	static void pairSpecialOptionOppTest() {
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
		asset.ProductCloseDate__c = System.today();
		asset.ClosingAgentId__c = owner.Id;
		asset.ProductType__c = '13';
		asset.Status__c = '0000';
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

	@IsTest
	static void newOpportunitiesCreatedTest() {
		Account acc = TestDataFactory.getAccount();
		insert acc;

		User owner = new User();
		owner.FirstName = 'Joe';
		owner.LastName = 'Tester';
		owner.CommissionAccountNr__c = '1234';
		owner = TestDataFactory.getUser(owner);
		insert owner;

		Asset asset1 = new Asset();
		asset1.Name = 'Test asset1';
		asset1.AccountId = acc.Id;
		asset1.ProductCloseDate__c = System.today();
		asset1.ClosingAgentId__c = owner.Id;
		asset1.ProductType__c = '13';
		asset1.Status__c = '0000';
		asset1.RecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CreditCases').getRecordTypeId();
		asset1 = TestDataFactory.getAsset(asset1);

		Asset asset2 = new Asset();
		asset2.Name = 'Test asset2';
		asset2.AccountId = acc.Id;
		asset2.ProductCloseDate__c = System.today();
		asset2.ClosingAgentId__c = owner.Id;
		asset2.ProductType__c = '13';
		asset2.Status__c = '0000';
		asset2.RecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CreditCases').getRecordTypeId();
		asset2 = TestDataFactory.getAsset(asset2);

		List<Opportunity> oppsBefore = [SELECT Id, Name FROM Opportunity];
		Test.startTest();
		insert new List<Asset>{asset1, asset2};
		Test.stopTest();
		List<Opportunity> oppsAfter = [SELECT Id, Name FROM Opportunity];

		System.assertEquals(oppsAfter.size(), oppsBefore.size() + 2);
	}
}
