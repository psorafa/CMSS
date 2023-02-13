public class ContentVersionTriggerHandler extends TriggerHandler {
	public override void beforeInsert() {
		List<String> allowedFileExtensionsList = Configuration__mdt.getInstance('AllowedFileExtensions')
			.Value__c.split(',');       
		for (sObject version : Trigger.new) {
			ContentVersion docVersion = (ContentVersion) version;
			String extension = docVersion.PathOnClient.substringAfterLast('.');
			if (!allowedFileExtensionsList.contains(extension)) {
				docVersion.addError(
					'Soubor nemá platnou koncovku - nahrajte prosím soubor typu: ' +
					allowedFileExtensionsList.toString()
				);
			}
		}
	}
}