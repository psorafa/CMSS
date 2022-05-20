@IsTest
private class ValidateSoqlServiceTest {
	@TestSetup
	static void beforeTest() {
		CustomSearchConfiguration__c myCustomSearchConfiguration = new CustomSearchConfiguration__c(
			FieldsetName__c = 'Search_Component',
			FilterCondition__c = 'Name LIKE \'%s%\' ',
			ObjectType__c = 'Account'
		);
		insert myCustomSearchConfiguration;
	}
	@IsTest
	static void validateSoqlServiceTestfromCustomSearchCOnfINsert() {
		CustomSearchConfiguration__c myCustomSearchConfiguration1 = new CustomSearchConfiguration__c(
			FieldsetName__c = 'Search_Component',
			FilterCondition__c = 'Name LIKE \'%s%\' qqq',
			ObjectType__c = 'Account'
		);

		Test.startTest();
		Database.SaveResult result = Database.insert(myCustomSearchConfiguration1, false);
		Test.stopTest();

		System.assert(!result.isSuccess());
		System.assert(result.getErrors().size() > 0);
		System.assertEquals(Label.FilterConditionIsWrong, result.getErrors()[0].getMessage());

	}
	@IsTest
	static void validateSoqlServiceTestfromCustomSearchCOnfOkFilter() {
		CustomSearchConfiguration__c myCustomSearchConfiguration2 = new CustomSearchConfiguration__c(
			FieldsetName__c = 'Search_Component',
			FilterCondition__c = 'Name LIKE \'%s%\' ',
			ObjectType__c = 'Account'
		);

		Test.startTest();
		Database.SaveResult result = Database.insert(myCustomSearchConfiguration2, false);
		System.assert(result.isSuccess());
		System.assert(result.getErrors().size() == 0);

		Test.stopTest();
	}

	@IsTest
	static void validateSoqlServiceTestFromCustomSearchOnUpdate() {
		List<CustomSearchConfiguration__c> customSearchConfigurationList = [
			SELECT FieldsetName__c, FilterCondition__c, ObjectType__c
			FROM CustomSearchConfiguration__c
			LIMIT 1
		];
		customSearchConfigurationList[0].FilterCondition__c = 'Name LIKE \'%s%\' qqq';
		Test.startTest();

		List<Database.SaveResult> results = Database.update(customSearchConfigurationList, false);
		System.assert(!results[0].isSuccess());
		System.assert(results[0].getErrors().size() > 0);
		System.assertEquals(Label.FilterConditionIsWrong, results[0].getErrors()[0].getMessage());

		Test.stopTest();
	}
}
