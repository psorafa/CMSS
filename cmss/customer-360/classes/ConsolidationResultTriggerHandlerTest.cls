@IsTest
private class ConsolidationResultTriggerHandlerTest {

	@IsTest
	static void testBehavior() {
		// logic itself is tested in AccountConsolidationUtilityTest
		Account a1 = TestDataFactory.getAccount(new Account(
			GlobalId__c = 'G1'
		));
		Account a2 = TestDataFactory.getAccount(new Account(
			GlobalId__c = 'G2'
		));
		insert new List<Account>{
			a1, a2
		};
		Test.startTest();
		insert new ConsolidationResult__c(
			ActionType__c = '2',
			OldGlobalID__c = 'G1',
			NewGlobalID__c = 'G2'
		);
		Test.stopTest();
	}

}