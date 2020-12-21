public with sharing class InternalConsentEnablement {
    
    @InvocableMethod
    public static List<String> enableInternalConsents(List<SObject> consents) {
        Set<Id> accountIds = new Set<Id>();
        for (InternalConsent__c c : (List<InternalConsent__c>) consents) {
            accountIds.add(c.Account__c);
        }

        Map<Id, Account> idsToAccounts = new Map<Id, Account>([
            SELECT GlobalId__c
            FROM Account 
            WHERE Id IN :accountIds
        ]);

        List<String> externalIds = new List<String>();
        SOAPCommonTypes.OutboundRequestHeader header = new SOAPCommonTypes.OutboundRequestHeader();
        ConsentWebService.ConsentServicePort stub = new ConsentWebService.ConsentServicePort();
        Integer index = 0;
        for (InternalConsent__c c : (List<InternalConsent__c>) consents) {
            if (index == 100) {
                break;
            } else if (c.InternalConsentValue__c != '1') {
                continue;
            }

            Account client = idsToAccounts.get(c.Account__c);

            ConsentWebServiceDataTypes.EnableInternalConsentRequestBodyType body = new ConsentWebServiceDataTypes.EnableInternalConsentRequestBodyType();
            body.globalId = client == null ? null : client.GlobalId__c;
            body.consentKind = c.InternalConsentType__c;
            body.consentValidFrom = String.valueOfGmt(Datetime.now());
            body.consentSourceId = 'SalesForce';
            ConsentWebServiceDataTypes.EnableInternalConsentResponseBodyType response = stub.enableInternalConsent(body, header);
            Logger.debug('EnableInternalConsent response', JSON.serialize(response));
            if (response != null) {
                externalIds.add(response.consentGuid);
            }

            index++;
        }

        Logger.saveLogs();

        return externalIds;
    }
}
