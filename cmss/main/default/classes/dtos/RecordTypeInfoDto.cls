public with sharing class RecordTypeInfoDto {
	@AuraEnabled
	public String label { get; set; }
	@AuraEnabled
	public String value { get; set; }
	@AuraEnabled
	public String objectType { get; set; }
}
