public with sharing class ValidateSoqlService {
	public static void validateCustomSearchConfiguration(List<CustomSearchConfiguration__c> inputList) {
		for (CustomSearchConfiguration__c csc : inputList) {
			FieldsetService service = new FieldsetService(csc.FieldsetName__c, csc.ObjectType__c);
			String queryFields = CustomSoqlService.getQueryFieldsFromFieldSetService(service);
			if (queryFields.length() == 0) {
				csc.FieldsetName__c.addError(Label.FieldsetNameIsWrong);
			}

			CustomSearchFilterRequestDto request = new CustomSearchFilterRequestDto();
			request.objectName = csc.ObjectType__c;
			request.configuration = csc;
			request.filterItemList = prepareRecordtypeFilter(csc.ObjectType__c, csc.ProductType__c);
			request.pageNumber = 0;
			request.pageSize = 1;

			CustomSoqlService customSoqlService = new CustomSoqlService(request);
			try {
				customSoqlService.validateQuery();
			} catch (Exception e) {
				csc.FilterCondition__c.addError(Label.FilterConditionIsWrong + ', error: ' + e.getMessage());
				System.debug('FilterConditionIsWrong: ' + e.getMessage());
				System.debug(e.getStackTraceString());
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

	private static List<CustomSearchFilterRequestDto.CustomFilterItemDto> prepareRecordtypeFilter(String objectName, String product) {
		CustomSearchFilterRequestDto.FilterOptionDto filterOption = new CustomSearchFilterRequestDto.FilterOptionDto();
		filterOption.type = '=';
		filterOption.value = product;

		CustomSearchFilterRequestDto.CustomFilterItemDto item = new CustomSearchFilterRequestDto.CustomFilterItemDto();
		item.fieldName = 'RecordType.Name';
		item.filters = new List<CustomSearchFilterRequestDto.FilterOptionDto>{filterOption};
		item.dataType = 'Text';
		item.objectName = objectName;
		return new List<CustomSearchFilterRequestDto.CustomFilterItemDto>{item};
	}
}
