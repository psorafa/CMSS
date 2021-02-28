public class IntegrationUtility {

	public static void populateDefaultExternalId(List<SObject> data) {
		for (SObject record : data) {
			if (record.get('ExternalId__c') == null) {
				record.put('ExternalId__c', UUIDUtil.generateUUID());
			}
		}
	}
}