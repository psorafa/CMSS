public with sharing class ValidateSoqlService {

	public static void validateCustomSearchConfiguration(List<CustomSearchConfiguration__c> inputList) {
		for (CustomSearchConfiguration__c csc : inputList) {
			String queryFields = '';
			FieldsetService service = new FieldsetService(csc.FieldsetName__c, csc.ObjectType__c);
			queryFields = CustomSoqlService.getQueryFieldsFromFieldSetService(service);
			if (queryFields.length() == 0) {
				csc.FieldsetName__c.addError(Label.FieldsetNameIsWrong);
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
				csc.FilterCondition__c.addError(Label.FilterConditionIsWrong);
			}
		}
	}

	public static void validateCustomSearchFilter(List<CustomSearchFilter__c> inputList) {
		for (CustomSearchFilter__c csf : inputList) {
			SObjectType sObjectType = Schema.getGlobalDescribe().get(csf.RelatedObject__c);
			if(sObjectType == null) {
				csf.RelatedObject__c.addError(Label.RelatedObjectIsWrong);
			}
			SObjectField sObjectField = sObjectType.getDescribe().fields.getMap().get(csf.FieldApiName__c);
			if(sObjectField == null) {
				csf.FieldApiName__c.addError(Label.FieldApiNameIsWrong);
			}
		}
	}
}
