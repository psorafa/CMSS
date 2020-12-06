@IsTest
private class AccountConsolidationUtilityTest {

	@IsTest
	static void consolidationMergeTest() {
		Account a1 = TestDataFactory.getAccount(new Account(
			GlobalId__c = 'G1'
		));
		Account a2 = TestDataFactory.getAccount(new Account(
			GlobalId__c = 'G2'
		));
		insert new List<Account>{
			a1, a2
		};
		Case c1 = TestDataFactory.getCase(new Case(
			Subject = 'Case1',
			AccountId = a1.Id
		));
		Case c2 = TestDataFactory.getCase(new Case(
			Subject = 'Case2',
			AccountId = a2.Id
		));
		insert new List<Case>{
			c1, c2
		};
		ClientZone__c cz1 = TestDataFactory.getClientZone(new ClientZone__c(
			Account__c = a1.Id
		));
		insert cz1;
		Task t1 = TestDataFactory.getTask(new Task(
			WhatId = a1.Id
		));
		Task t2 = TestDataFactory.getTask(new Task(
			WhatId = a2.Id
		));
		insert new List<Task>{
			t1, t2
		};
		Opportunity o1 = TestDataFactory.getOpportunity(new Opportunity(
			AccountId = a1.Id
		));
		Opportunity o2 = TestDataFactory.getOpportunity(new Opportunity(
			AccountId = a2.Id
		));
		insert new List<Opportunity>{
			o1, o2
		};

		List<ConsolidationResult__c> cons = new List<ConsolidationResult__c>{
			new ConsolidationResult__c(
				OldGlobalID__c = 'G1',
				NewGlobalID__c = 'G2',
				ActionType__c = AccountConsolidationUtility.MERGE_ACTION_TYPE
			)
		};
		Test.startTest();
		AccountConsolidationUtility consolidationUtility = new AccountConsolidationUtility(cons);
		consolidationUtility.process();
		Test.stopTest();

		Account oldAccount = [
			SELECT Id, (SELECT Id FROM Cases), (SELECT Id FROM Opportunities), (SELECT Id FROM Tasks), (SELECT Id FROM ClientZones__r)
			FROM Account
			WHERE Id = :a1.Id
		];
		Account newAccount = [
			SELECT Id, (SELECT Id FROM Cases), (SELECT Id FROM Opportunities), (SELECT Id FROM Tasks), (SELECT Id FROM ClientZones__r)
			FROM Account
			WHERE Id = :a2.Id
		];

		System.assert(oldAccount.Cases.isEmpty());
		System.assert(oldAccount.Opportunities.isEmpty());
		System.assert(oldAccount.Tasks.isEmpty());
		System.assert(oldAccount.ClientZones__r.isEmpty());

		System.assertEquals(2, newAccount.Cases.size());
		System.assertEquals(2, newAccount.Opportunities.size());
		System.assertEquals(2, newAccount.Tasks.size());
		System.assertEquals(1, newAccount.ClientZones__r.size());
	}

	@IsTest
	static void consolidationWithClientZonesMergeTest() {
		Account a1 = TestDataFactory.getAccount(new Account(
			GlobalId__c = 'G1'
		));
		Account a2 = TestDataFactory.getAccount(new Account(
			GlobalId__c = 'G2'
		));
		insert new List<Account>{
			a1, a2
		};
		ClientZone__c cz1 = TestDataFactory.getClientZone(new ClientZone__c(
			Account__c = a1.Id
		));
		ClientZone__c cz2 = TestDataFactory.getClientZone(new ClientZone__c(
			Account__c = a2.Id
		));
		insert new List<ClientZone__c>{
			cz1, cz2
		};

		List<ConsolidationResult__c> cons = new List<ConsolidationResult__c>{
			new ConsolidationResult__c(
				OldGlobalID__c = 'G1',
				NewGlobalID__c = 'G2',
				ActionType__c = AccountConsolidationUtility.MERGE_ACTION_TYPE
			)
		};
		Test.startTest();
		AccountConsolidationUtility consolidationUtility = new AccountConsolidationUtility(cons);
		consolidationUtility.process();
		Test.stopTest();

		Case c = [SELECT Id, RecordTypeId, Subject, AccountId, ConsolidationResult__c FROM Case];
		System.assertEquals('Manual client consolidation', c.Subject);
		System.assertEquals(AccountConsolidationUtility.CLIENT_CONSOLIDATION_RT, c.RecordTypeId);
		System.assertEquals(a1.Id, c.AccountId);
		System.assertEquals(cons.get(0).Id, c.ConsolidationResult__c);
	}

	@IsTest
	private static void testSplitConsolidation() {
		Account a1 = TestDataFactory.getAccount(new Account(
			GlobalId__c = 'G1'
		));
		insert a1;
		List<ConsolidationResult__c> cons = new List<ConsolidationResult__c>{
			new ConsolidationResult__c(
				OldGlobalID__c = 'G1',
				NewGlobalID__c = 'G2',
				ActionType__c = AccountConsolidationUtility.SPLIT_ACTION_TYPE
			)
		};
		Test.startTest();
		AccountConsolidationUtility consolidationUtility = new AccountConsolidationUtility(cons);
		consolidationUtility.process();
		Test.stopTest();

		Case c = [SELECT Id, RecordTypeId, Subject, AccountId, ConsolidationResult__c FROM Case];
		System.assertEquals('Manual client consolidation', c.Subject);
		System.assertEquals(AccountConsolidationUtility.CLIENT_CONSOLIDATION_RT, c.RecordTypeId);
		System.assertEquals(a1.Id, c.AccountId);
		System.assertEquals(cons.get(0).Id, c.ConsolidationResult__c);
	}

	@IsTest
	private static void testEmptyOldGlobalId() {

		Account a1 = TestDataFactory.getAccount(new Account(
			GlobalId__c = 'G1'
		));
		insert a1;
		List<ConsolidationResult__c> cr = new List<ConsolidationResult__c>{
			new ConsolidationResult__c(
				OldGlobalID__c = null,
				NewGlobalID__c = 'G2',
				ActionType__c = 'other'
			)
		};
		Test.startTest();
		insert cr;
		Test.stopTest();
		// nothing to assert, consolidationResult is supposed to be ignored
	}

}