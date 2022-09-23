public with sharing class GeneralConsentEnablement {

	private static CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
	private static ConsentCalloutService.ConsentServicePort stub = new ConsentCalloutService.ConsentServicePort();

	@AuraEnabled
	public static String enableGeneralConsents(Consent__c c) {
		try {
			Set<Id> accountIds = new Set<Id>();
			accountIds.add(c.Account__c);
			if (String.isNotBlank(c.SubstitutePerson__c)) {
				accountIds.add(c.SubstitutePerson__c);
			}

			Map<Id, Account> idsToAccounts = new Map<Id, Account>([
				SELECT GlobalId__c
				FROM Account
				WHERE Id IN :accountIds
			]);

			ConsentDataTypesService.EnableGeneralConsentRequestBodyType body = ConsentService.getEnableGeneralWSDefinition(c, idsToAccounts);
			ConsentDataTypesService.EnableGeneralConsentResponseBodyType response = stub.enableGeneralConsent_Http(header, body);
			if (response != null) {
				if (response.consentGuid != null) {
					String finalResponse = 'OK';
					if (c.AllConsent__c == '2') {
						finalResponse = disableGeneralConsents(c, idsToAccounts, response.consentGuid);
					}

					c.ExternalId__c = response.consentGuid;
					upsert c ExternalId__c;

					return finalResponse;
				} else {
					return response.responseMessage;
				}
			}
			return null;
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			return e.getMessage();
		} finally {
			Logger.saveLogs();
		}
	}

	private static String disableGeneralConsents(Consent__c c, Map<Id, Account> idsToAccounts, String externalId) {
		ConsentDataTypesService.DisableGeneralConsentRequestBodyType body = ConsentService.getDisableGeneralWSDefinition(c, idsToAccounts, externalId);
		ConsentDataTypesService.DisableGeneralConsentResponseBodyType response = stub.disableGeneralConsent_Http(header, body);
		if (response != null) {
			if (response.success != null && response.success.Successful == true) {
				return 'OK';
			} else {
				return response.responseMessage;
			}
		}
		return null;
	}
}