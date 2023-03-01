public class ContentVersionTriggerHandler extends TriggerHandler {
	public override void beforeInsert() {
		checkExtension(Trigger.new);
	}

	public override void afterInsert() {
		checkSignature(Trigger.new);
	}

	private void checkExtension(List<ContentVersion> contentVersion) {
		List<String> allowedFileExtensionsList = Configuration__mdt.getInstance('AllowedFileExtensions')
			.Value__c.toUpperCase()
			.split(',');
		for (ContentVersion version : contentVersion) {
			String extension = version.PathOnClient.substringAfterLast('.').toUpperCase();
			if (!allowedFileExtensionsList.contains(extension)) {
				version.addError(
					'Soubor nemá platnou koncovku - nahrajte prosím soubor typu: ' +
					allowedFileExtensionsList.toString()
				);
			}
		}
	}

	private void checkSignature(List<ContentVersion> contentVersion) {
		List<ContentVersion> thisDBVersionList = [
			SELECT Id, VersionData, PathOnClient
			FROM ContentVersion
			WHERE Id IN :contentVersion
		];

		Map<String, ValidFileHeaders__mdt> validSignaturesMap = ValidFileHeaders__mdt.getAll();

		for (ContentVersion version : thisDBVersionList) {
			String fileSignature = EncodingUtil.convertToHex(version.VersionData).Substring(0, 30).toLowerCase();
			String fileExtension = version.PathOnClient.substringAfterLast('.').toLowerCase();
			Boolean signatureNok = true;
			if (validSignaturesMap.containsKey(fileExtension)) {
				List<String> hexaList = validSignaturesMap.get(fileExtension)
					.Hex_Signature__c.deleteWhitespace()
					.toLowerCase()
					.split(',');
				for (String hexa : hexaList) {
					if (fileSignature.contains(hexa)) {
						signatureNok = false;
					}
				}
			} else {
				Trigger.newMap
					.get(version.Id)
					.addError('Zvolený typ souboru nebylo možné ověřit, kontaktujte správce systému');
			}

			if (signatureNok) {
				Trigger.newMap.get(version.Id).addError('Obsah souboru je neplatný');
			}
		}
	}
}
