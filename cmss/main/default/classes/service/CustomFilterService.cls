public with sharing class CustomFilterService {
	private String objectType;
	private String productType;
	private Map<String, String> valueLabelMap = new Map<String, String>();

	public CustomFilterService(String objectType, String productType) {
		this.objectType = objectType;
		this.productType = productType;
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
		for (CustomSearchFilter__c csf : customFilterList) {
			CustomFilterItemDto dtoItem = new CustomFilterItemDto();
			dtoItem.productType = csf.ProductType__c;
			dtoItem.productTypeLabel = customFilterLabelMap.get(csf.Id).ProductType__c;
			dtoItem.fieldName = csf.FieldApiName__c;
			dtoItem.dataType = csf.RecordType.DeveloperName;
			dtoItem.relatedObject = csf.RelatedObject__c;
			dtoItem.availableFilterList = getAvailableFilterList(csf.Filter__c);
			if (dtoItem.fieldName.indexOf('.') > -1) {
				String relR = csf.FieldApiName__c.substringBefore('.');
				String relC = relR.replace('__r', '__c');
				SObjectType sObjectTypeL2 = Schema.getGlobalDescribe().get(dtoItem.relatedObject);
				List<Schema.sObjectType> parents = sObjectTypeL2.getDescribe()
					.fields.getMap()
					.get(relC)
					.getDescribe()
					.getReferenceTo();
				dtoItem.objectTypeForLabel = String.valueOf(parents[0]);
				dtoItem.fieldNameForLabel = csf.FieldApiName__c.substringAfter('.');
				dtoItem.fieldLabel = csf.Name;
			} else {
				dtoItem.objectTypeForLabel = dtoItem.relatedObject;
				dtoItem.fieldNameForLabel = dtoItem.fieldName;
				dtoItem.fieldLabel = Schema.getGlobalDescribe()
					.get(dtoItem.relatedObject)
					.getDescribe()
					.fields.getMap()
					.get(dtoItem.fieldName)
					.getDescribe()
					.getLabel();
			}
			System.debug('FIELD: ' + csf.FieldApiName__c);
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
