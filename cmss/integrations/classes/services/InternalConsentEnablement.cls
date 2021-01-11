public with sharing class InternalConsentEnablement {
    
    @InvocableMethod
    public static List<String> enableInternalConsents(List<SObject> consents) {
        Set<Id> accountIds = new Set<Id>();
        for (InternalConsent__c c : (List<InternalConsent__c>) consents) {
            Validation.requireAttribute(c.InternalConsentType__c, 'InternalConsentType__c');
            accountIds.add(c.Account__c);
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
        for (InternalConsent__c c : (List<InternalConsent__c>) consents) {
            if (index == 100) {
                break;
            } else if (c.InternalConsentValue__c != '1') {
                continue;
            }

            ConsentDataTypesService.EnableInternalConsentRequestBodyType body = ConsentService.getEnableInternalConsentWSDefinition(c, idsToAccounts.get(c.Account__c));
            ConsentDataTypesService.EnableInternalConsentResponseBodyType response = stub.enableInternalConsent_Http(header, body);
            if (response != null) {
                externalIds.add(response.consentGuid);
            }

            index++;
        }

        Logger.saveLogs();

        return externalIds;
    }
}
