public with sharing class GeneralConsentEnablement {

	@AuraEnabled
	public static Boolean checkAgentCPU(String agentCPU) {
		List<User> u = [
			SELECT Id 
			FROM User 
			WHERE CommissionAccountBase__c =: agentCPU];
		return true ? u.size() > 0 : false;
	}

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

			Account client = idsToAccounts.get(c.Account__c);
			Validation.requireAttribute(client, 'Account');
			Validation.requireAttribute(client.GlobalId__c, 'GlobalId__c');
			Account substitutePerson;
            if (String.isNotBlank(c.SubstitutePerson__c)) {
                substitutePerson = idsToAccounts.get(c.SubstitutePerson__c);
            }

			CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
			ConsentCalloutService.ConsentServicePort stub = new ConsentCalloutService.ConsentServicePort();
			ConsentDataTypesService.EnableGeneralConsentRequestBodyType body = new ConsentDataTypesService.EnableGeneralConsentRequestBodyType();
			body.consentEntityId = c.EntityConsent__c;
			body.consentVersionId = c.GeneralConsentVersion__c;
			body.globalId = client.GlobalId__c;
			body.consentSourceId = '20';
			body.validFrom = Datetime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
			body.validFrom = body.validFrom.substring(0, body.validFrom.length() - 2) + ':00';
			body.agentCPU = c.AgentCPU__c;
			if (substitutePerson != null) {
				body.substitutePersonId = substitutePerson.GlobalId__c;
			}
			body.substituteRoleId = c.SubstituteRole__c;
			ConsentDataTypesService.EnableGeneralConsentResponseBodyType response = stub.enableGeneralConsent_Http(header, body);
			if (response != null) {
                if (response.consentGuid != null) {
                    c.ExternalId__c = response.consentGuid;
                    insert c;
                    return 'OK';
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
}