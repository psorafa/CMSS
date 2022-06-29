public class CustomSearchFilterRequestDto {
	@AuraEnabled
	public List<CustomFilterItemDto> filterItemList { get; set; }
	@AuraEnabled
	public CustomSearchConfiguration__c configuration { get; set; }
	@AuraEnabled
	public String objectName { get; set; }
	@AuraEnabled
	public Integer pageNumber { get; set; }
	@AuraEnabled
	public Integer pageSize { get; set; }
	@AuraEnabled
	public String sortBy { get; set; }
	@AuraEnabled
	public String sortDirection { get; set; }

	public class CustomFilterItemDto {
		@AuraEnabled
		public String objectName { get; set; }
		@AuraEnabled
		public String fieldName { get; set; }
		@AuraEnabled
		public String dataType { get; set; }
		@AuraEnabled
		public List<FilterOptionDto> filters { get; set; }
	}
	public class FilterOptionDto {
		@AuraEnabled
		public String type { get; set; }
		@AuraEnabled
		public String value { get; set; }
	}
}
