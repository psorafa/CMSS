public with sharing class GeneralConsentEnablement {
    
    @InvocableMethod
    public static List<String> enableGeneralConsents(List<SObject> consents) {
        Set<Id> accountIds = new Set<Id>();
        for (Consent__c c : (List<Consent__c>) consents) {
            Validation.requireAttribute(c.EntityConsent__c, 'EntityConsent__c');
            Validation.requireAttribute(c.GeneralConsentVersion__c, 'GeneralConsentVersion__c');
            Validation.requireAttribute(c.Account__c, 'Account__c');
            accountIds.add(c.Account__c);
            accountIds.add(c.SubstitutePerson__c);
        }

        Map<Id, Account> idsToAccounts = new Map<Id, Account>([
            SELECT GlobalId__c
            FROM Account 
            WHERE Id IN :accountIds
        ]);

        List<String> externalIds = new List<String>();
        CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
        ConsentCalloutService.ConsentServicePort stub = new ConsentCalloutService.ConsentServicePort();
        Integer index = 0;
        for (Consent__c c : (List<Consent__c>) consents) {
            if (index == 100) {
                break;
            }

            Account client = idsToAccounts.get(c.Account__c);
            Validation.requireAttribute(client, 'Account');
            Validation.requireAttribute(client.GlobalId__c, 'GlobalId__c');
            Account substitutePerson = idsToAccounts.get(c.SubstitutePerson__c);

            ConsentDataTypesService.EnableGeneralConsentRequestBodyType body = new ConsentDataTypesService.EnableGeneralConsentRequestBodyType();
            body.consentEntityId = c.EntityConsent__c;
            body.consentVersionId = c.GeneralConsentVersion__c;
            body.globalId = client.GlobalId__c;
            body.consentSourceId = '20';
            body.validFrom = Datetime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
            body.validFrom = body.validFrom.substring(0, body.validFrom.length() - 2) + ':00'; 
            body.agentCPU = c.AgentCPU__c;
            body.substitutePersonId = substitutePerson == null ? null : substitutePerson.GlobalId__c;
            body.substituteRoleId = c.SubstituteRole__c;
            ConsentDataTypesService.EnableGeneralConsentResponseBodyType response = stub.enableGeneralConsent_Http(header, body);
            if (response != null) {
                externalIds.add(response.consentGuid);
            }

            index++;
        }

        Logger.saveLogs();

        return externalIds;
    }
}
