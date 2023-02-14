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
        List<ContentVersion> thisDBVersionList = [Select Id, VersionData, PathOnClient from ContentVersion Where Id IN :Trigger.new];
        Map<String, ValidFileHeaders__mdt> validSignaturesMap = ValidFileHeaders__mdt.getAll();
        
		for (ContentVersion version : thisDBVersionList) {
            String fileSignature = EncodingUtil.convertToHex(version.VersionData).Substring(0,30).toLowerCase();
            String fileExtension = version.PathOnClient.substringAfterLast('.').toLowerCase();
            Boolean signatureNok = True;
            if (validSignaturesMap.containsKey(fileExtension)) {
                List<String> hexaList = validSignaturesMap.get(fileExtension).Hex_Signature__c.deleteWhitespace().toLowerCase().split(',');
                for(String hexa : hexaList) {
                    if(fileSignature.contains(hexa)) {
                        signatureNok = False;
                    }
System.debug('hexa/fileSignature: ' + hexa + ' / ' + fileSignature);                    
                }
            }
            else{
                Trigger.newMap.get(version.Id).addError(
					'Soubor nemá platnou koncovku - nahrajte prosím soubor typu: ' +
					validSignaturesMap.keySet()
				);
System.debug('No Key.');                  
            }
            
            if(signatureNok) {
                Trigger.newMap.get(version.Id).addError(
					'Soubor nemá platnou koncovku - nahrajte prosím soubor typu: ' +
					validSignaturesMap.keySet()
				);
System.debug('Wrong signature');                 
            }                  
		}
	}
}