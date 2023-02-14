public class ContentVersionTriggerHandler extends TriggerHandler {
	public override void beforeInsert() {
		List<String> allowedFileExtensionsList = Configuration__mdt.getInstance('AllowedFileExtensions')
			.Value__c.toUpperCase().split(',');
		for (sObject version : Trigger.new) {
			ContentVersion docVersion = (ContentVersion) version;
			String extension = docVersion.PathOnClient.substringAfterLast('.').toUpperCase();
			if (!allowedFileExtensionsList.contains(extension)) {
				docVersion.addError(
					'Soubor nemá platnou koncovku - nahrajte prosím soubor typu: ' +
					allowedFileExtensionsList.toString()
				);
			}
		}
	}
    
	public override void afterInsert() {
		for (sObject version : Trigger.new) {
			ContentVersion docVersion = (ContentVersion) version;
            ContentVersion thisDBVersion = [Select Id, VersionData, PathOnClient from ContentVersion Where Id = :docVersion.Id Limit 1];
			String fileContent = EncodingUtil.base64Encode(thisDBVersion.VersionData);
System.debug('fileContent: ' + fileContent);
System.debug('path: ' + thisDBVersion.PathOnClient);
System.debug('hex: ' + EncodingUtil.convertToHex(thisDBVersion.VersionData));            
		}
	}    
}