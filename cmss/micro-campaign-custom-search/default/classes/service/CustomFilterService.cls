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
			SELECT ProductType__c, FieldApiName__c, RecordType.DeveloperName, RelatedObject__c, Filter__c
			FROM CustomSearchFilter__c
			WHERE RelatedObject__c = :objectType AND ProductType__c = :productType
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
