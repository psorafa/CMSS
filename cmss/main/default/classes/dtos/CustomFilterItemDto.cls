public class CustomFilterItemDto {
	@AuraEnabled
	public String productType { get; set; }
	@AuraEnabled
	public String productTypeLabel { get; set; }
	@AuraEnabled
	public String fieldName { get; set; }
	@AuraEnabled
	public String dataType { get; set; }
	@AuraEnabled
	public String relatedObject { get; set; }
	@AuraEnabled
	public List<SelectOption> availableFilterList { get; set; }
    @AuraEnabled
	public String objectTypeForLabel { get; set; }
    @AuraEnabled
	public String fieldNameForLabel { get; set; }
    @AuraEnabled
	public String fieldLabel { get; set; }    
}