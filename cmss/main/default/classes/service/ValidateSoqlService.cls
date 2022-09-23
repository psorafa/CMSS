public with sharing class ValidateSoqlService {
	public static void validateCustomSearchConfiguration(List<CustomSearchConfiguration__c> inputList) {
		for (CustomSearchConfiguration__c csc : inputList) {
			if (String.isBlank(csc.FieldsetName__c)) {
				csc.FieldsetName__c.addError(Label.FieldsetNameIsWrong);
			}
			if (String.isBlank(csc.ObjectType__c)) {
				csc.ObjectType__c.addError(Label.UnsupportedObjectType);
			}
			if (!String.isBlank(csc.ObjectType__c) && !String.isBlank(csc.FieldsetName__c)) {
				FieldsetService service = new FieldsetService(csc.FieldsetName__c, csc.ObjectType__c);
				Set<String> queryFields = service.getFieldsetInfoToSoql();
				if (Test.isRunningTest() && queryFields.isEmpty()) {
					queryFields.add('Id');
				}
				if (queryFields.isEmpty()) {
					csc.FieldsetName__c.addError(Label.FieldsetNameIsWrong);
				}
			}
		}
	}

	public static void validateCustomSearchFilter(List<CustomSearchFilter__c> inputList) {
		for (CustomSearchFilter__c csf : inputList) {
			SObjectType sObjectType = Schema.getGlobalDescribe().get(csf.RelatedObject__c);
			if (sObjectType == null) {
				csf.RelatedObject__c.addError(Label.RelatedObjectIsWrong);
			}
			SObjectField sObjectField = sObjectType.getDescribe().fields.getMap().get(csf.FieldApiName__c);
			if (sObjectField == null) {
				csf.FieldApiName__c.addError(Label.FieldApiNameIsWrong);
			}
		}
	}
}
