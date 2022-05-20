public with sharing class CustomFilterDto {
	@AuraEnabled
	public String key { get; set; }
	@AuraEnabled
	public String label { get; set; }
	@AuraEnabled
	public List<CustomFilterItemDto> values { get; set; }
}
