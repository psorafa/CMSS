@IsTest
private class ValidateSoqlServiceTest {
	@TestSetup
	static void beforeTest() {
		CustomSearchConfiguration__c myCustomSearchConfiguration = new CustomSearchConfiguration__c(
			FieldsetName__c = 'Search_Component',
			FilterCondition__c = 'City__c LIKE \'%demo%\'',
			ObjectType__c = 'Account',
			ProductType__c = 'PersonAccount'
		);
		insert myCustomSearchConfiguration;
	}

	@IsTest
	static void validateSoqlServiceTestfromCustomSearchCOnfOkFilter() {
		CustomSearchConfiguration__c myCustomSearchConfiguration2 = new CustomSearchConfiguration__c(
			FieldsetName__c = 'Search_Component',
			FilterCondition__c = 'City__c LIKE \'%s%\' ',
			ObjectType__c = 'Account'
		);

		Test.startTest();
		Database.SaveResult result = Database.insert(myCustomSearchConfiguration2, false);
		System.assert(result.isSuccess());
		System.assert(result.getErrors().size() == 0);

		Test.stopTest();
	}
}
