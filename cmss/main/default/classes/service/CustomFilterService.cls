public with sharing class CustomFilterService {
	private String objectType;
	private String productType;
	private Map<String, String> valueLabelMap = new Map<String, String>();

	public CustomFilterService(String objectType, String productType) {
		this.objectType = objectType;
		this.productType = productType;
	}

	private CustomFilterItemDto getDtoItem(
		CustomSearchFilter__c csf,
		Map<Id, CustomSearchFilter__c> customFilterLabelMap
	) {
		CustomFilterItemDto dtoItem = new CustomFilterItemDto();
		dtoItem.productType = csf.ProductType__c;
		dtoItem.productTypeLabel = customFilterLabelMap.get(csf.Id).ProductType__c;
		dtoItem.fieldName = csf.FieldApiName__c;
		dtoItem.dataType = csf.RecordType.DeveloperName;
		dtoItem.relatedObject = csf.RelatedObject__c;
		if (dtoItem.dataType == 'Picklist') {
			dtoItem.availableFilterList = getPicklistOptions(dtoItem.fieldName, dtoItem.relatedObject);
		} else {
			dtoItem.availableFilterList = getAvailableFilterList(csf.Filter__c);
		}
		dtoItem.objectTypeForLabel = dtoItem.relatedObject;
		dtoItem.fieldNameForLabel = dtoItem.fieldName;
		if (dtoItem.fieldName.indexOf('.') > -1) {
			dtoItem.fieldLabel = csf.Name;
		} else {
			dtoItem.fieldLabel = Schema.getGlobalDescribe()
				.get(dtoItem.relatedObject)
				.getDescribe()
				.fields.getMap()
				.get(dtoItem.fieldName)
				.getDescribe()
				.getLabel();
		}
		return dtoItem;
	}

	public List<CustomFilterItemDto> getCustomFilterMap() {
		List<CustomSearchFilter__c> customFilterList = [
			SELECT
				ProductType__c,
				FieldApiName__c,
				RecordType.DeveloperName,
				RelatedObject__c,
				Filter__c,
				DisplayOrder__c,
				Name
			FROM CustomSearchFilter__c
			WHERE RelatedObject__c = :objectType AND ProductType__c = :productType
			ORDER BY DisplayOrder__c ASC NULLS LAST
		];

		Map<Id, CustomSearchFilter__c> customFilterLabelMap = new Map<Id, CustomSearchFilter__c>(
			[
				SELECT Id, toLabel(ProductType__c)
				FROM CustomSearchFilter__c
				WHERE RelatedObject__c = :objectType AND ProductType__c = :productType
			]
		);

		List<CustomFilterItemDto> dtoItemList = new List<CustomFilterItemDto>();
		createLabelValueMapFromFilter();
		for (CustomSearchFilter__c customSearchFilter : customFilterList) {
			CustomFilterItemDto dtoItem = getDtoItem(customSearchFilter, customFilterLabelMap);
			dtoItemList.add(dtoItem);
		}

		return dtoItemList;
	}

	private void createLabelValueMapFromFilter() {
		Schema.DescribeFieldResult describeFilter = CustomSearchFilter__c.Filter__c.getDescribe();
		List<Schema.PicklistEntry> picklistValList = describeFilter.getPicklistValues();
		for (Schema.PicklistEntry en : picklistValList) {
			valueLabelMap.put(en.getValue(), en.getLabel());
		}
	}

	public List<SelectOption> getPicklistOptions(String fieldString, String relatedObject) {
		List<SelectOption> labelValueList = new List<SelectOption>();

		Integer dotsCount = fieldString.countMatches('.');
		Integer dotsCounter = 0;
		Integer i = 0;
		String targetField = dotsCount > 0 ? fieldString.substringAfterLast('.') : fieldString;
		SObjectType targetObject = Schema.getGlobalDescribe().get(relatedObject);
		do {
			if (dotsCounter < dotsCount) {
				String relR = fieldString.substringBefore('.');
				String relC = relR.replace('__r', '__c');
				relC = relC == 'Account' ? 'AccountId' : relC;
				relC = relC == 'Contact' ? 'ContactId' : relC;
				SObjectField sObjectFieldRel = targetObject.getDescribe().fields.getMap().get(relC);
				List<Schema.sObjectType> parents = targetObject.getDescribe()
					.fields.getMap()
					.get(relC)
					.getDescribe()
					.getReferenceTo();
				if (parents.size() > 0) {
					targetObject = parents[0];
				}

				fieldString = fieldString.substringAfter('.');
				dotsCounter++;
			}

			if (i == dotsCount) {
				SObjectField targetSObjectField = targetObject.getDescribe().fields.getMap().get(targetField);
				Schema.DescribeFieldResult targetFieldResult = targetSObjectField.getDescribe();
				List<Schema.PicklistEntry> picklistEntries = targetFieldResult.getPicklistValues();
				for (Schema.PicklistEntry pickListVal : picklistEntries) {
					String itemLabel = pickListVal.getLabel();
					String itemValue = pickListVal.getValue();
					SelectOption option = new SelectOption(itemValue, itemLabel);
					labelValueList.add(option);
				}
			}
			i++;
		} while (i < dotsCount + 1);
		return labelValueList;
	}

	private List<SelectOption> getAvailableFilterList(String savedFiltersString) {
		if (String.isBlank(savedFiltersString)) {
			return new List<SelectOption>();
		}
		List<String> savedFilters = savedFiltersString.split(';');
		List<SelectOption> labelValueList = new List<SelectOption>();
		for (String val : savedFilters) {
			SelectOption labelValue = new SelectOption(valueLabelMap.get(val), val);
			labelValueList.add(labelValue);
		}
		return labelValueList;
	}
}
