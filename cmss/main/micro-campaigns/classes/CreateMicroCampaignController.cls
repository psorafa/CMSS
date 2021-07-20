public with sharing class CreateMicroCampaignController {

	public class PicklistEntry {
		@AuraEnabled public String value;
		@AuraEnabled public String label;
	}

	@AuraEnabled(Cacheable=true)
	public static List<PicklistEntry> getPicklistValues(String objectName, String fieldName) {
		Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectName);
		Schema.DescribeSObjectResult res = convertToObj.getDescribe();
		Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(fieldName).getDescribe();
		List<PicklistEntry> pickListValuesList = new List<PicklistEntry>();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			PicklistEntry entry = new PicklistEntry();
			entry.label = pickListVal.getLabel();
			entry.value = pickListVal.getValue();
			pickListValuesList.add(entry);
		}
		return pickListValuesList;
	}
}