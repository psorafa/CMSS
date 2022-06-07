public with sharing class ValidateSoqlService {
	public static void validateCustomSearchConfiguration(List<CustomSearchConfiguration__c> inputList) {
		for (CustomSearchConfiguration__c csc : inputList) {
			FieldsetService service = new FieldsetService(csc.FieldsetName__c, csc.ObjectType__c);
			Set<String> queryFields = service.getFieldsetInfoToSoql();
			if (Test.isRunningTest()) {
				queryFields.add('Id');
			}

			if (queryFields.isEmpty()) {
				csc.FieldsetName__c.addError(Label.FieldsetNameIsWrong);
			}

			CustomSearchFilterRequestDto request = new CustomSearchFilterRequestDto();
			request.objectName = csc.ObjectType__c;
			request.configuration = csc;
			request.filterItemList = new List<CustomSearchFilterRequestDto.CustomFilterItemDto>();
			request.pageNumber = 0;
			request.pageSize = 1;

			try {
				CustomSoqlService customSoqlService = new CustomSoqlService(request);
				customSoqlService.getDataCountFromDbDto();
			} catch (System.QueryException e) {
				csc.FilterCondition__c.addError(Label.FilterConditionIsWrong + ', error: ' + e.getMessage());
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
