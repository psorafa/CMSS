public with sharing class FieldsetInfoDto {
	@AuraEnabled
	public String label { get; set; }
	@AuraEnabled
	public String fieldName { get; set; }
	@AuraEnabled
	public String type { get; set; }
	@AuraEnabled
	public Boolean sortable { get; set; }

	public FieldsetInfoDto(String fieldApiName, String fieldLabel, String type, Boolean sortable) {
		this.fieldName = fieldApiName;
		this.label = fieldLabel;
		this.type = type;
		this.sortable = sortable;
	}
}
