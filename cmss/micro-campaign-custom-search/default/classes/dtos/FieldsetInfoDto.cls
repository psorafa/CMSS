public with sharing class FieldsetInfoDto {
	@AuraEnabled
	public String label { get; set; }
	@AuraEnabled
	public String fieldName { get; set; }
	@AuraEnabled
	public String type { get; set; }

	public FieldsetInfoDto(String fieldApiName, String fieldLabel, String type) {
		this.fieldName = fieldApiName;
		this.label = fieldLabel;
		this.type = type;
	}
}
