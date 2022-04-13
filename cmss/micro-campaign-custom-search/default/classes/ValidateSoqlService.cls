public with sharing class ValidateSoqlService {
	public static final String ERROR_FILTER = 'Filter Condition is Wrong';
	public static final String ERROR_FIELDSET = 'Fieldset name is wrong';

	public static void validateCustomSearchConfiguration(
		List<CustomSearchConfiguration__c> CustomSearchConfigurationListToValidate
	) {
		for (CustomSearchConfiguration__c csc : CustomSearchConfigurationListToValidate) {
			String queryFields = '';
			FieldsetService service = new FieldsetService(csc.FieldsetName__c, csc.ObjectType__c);
			queryFields = CustomSoqlService.getQueryFieldsFromFieldSetService(service);
			if (queryFields.length() == 0) {
				csc.FieldsetName__c.addError(ERROR_FIELDSET);
			}
			String query =
				'SELECT ' +
				queryFields +
				' FROM ' +
				csc.ObjectType__c +
				' WHERE ' +
				csc.FilterCondition__c +
				' LIMIT 0';
			try {
				Database.query(query);
			} catch (System.QueryException e) {
				csc.FilterCondition__c.addError(ERROR_FILTER);
			}
		}
	}
}
