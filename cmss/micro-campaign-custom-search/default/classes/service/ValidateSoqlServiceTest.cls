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
	static void validateSoqlServiceTestfromCustomSearchCOnfINsert() {
		CustomSearchConfiguration__c myCustomSearchConfiguration1 = new CustomSearchConfiguration__c(
			FieldsetName__c = 'Search_Component',
			FilterCondition__c = 'City__c LIKE \'%s%\' qqq',
			ObjectType__c = 'Account',
			ProductType__c = 'PersonAccount'
		);

		Test.startTest();
		Database.SaveResult result = Database.insert(myCustomSearchConfiguration1, false);
		Test.stopTest();

		System.assert(!result.isSuccess());
		System.assert(result.getErrors().size() > 0);
		String errorMessage = result.getErrors()[0].getMessage();
		System.assert(errorMessage.startsWith(Label.FilterConditionIsWrong), 'Error start with defined label');
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

	@IsTest
	static void validateSoqlServiceTestFromCustomSearchOnUpdate() {
		List<CustomSearchConfiguration__c> customSearchConfigurationList = [
			SELECT FieldsetName__c, FilterCondition__c, ObjectType__c
			FROM CustomSearchConfiguration__c
			LIMIT 1
		];
		customSearchConfigurationList[0].FilterCondition__c = 'City__c LIKE \'%s%\' qqq';
		Test.startTest();

		List<Database.SaveResult> results = Database.update(customSearchConfigurationList, false);
		System.assert(!results[0].isSuccess());
		System.assert(results[0].getErrors().size() > 0);
		String errorMessage = results[0].getErrors()[0].getMessage();
		System.assert(errorMessage.startsWith(Label.FilterConditionIsWrong), 'Error start with defined label');

		Test.stopTest();
	}
}
