public with sharing class GeneralConsentEnablement {
    
    @InvocableMethod
    public static List<String> enableGeneralConsents(List<SObject> consents) {
        Set<Id> accountIds = new Set<Id>();
        for (Consent__c c : (List<Consent__c>) consents) {
            accountIds.add(c.Account__c);
            accountIds.add(c.SubstitutePerson__c);
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
        for (Consent__c c : (List<Consent__c>) consents) {
            if (index == 100) {
                break;
            }

            Account client = idsToAccounts.get(c.Account__c);
            Account substitutePerson = idsToAccounts.get(c.SubstitutePerson__c);

            ConsentWebServiceDataTypes.EnableGeneralConsentRequestBodyType body = new ConsentWebServiceDataTypes.EnableGeneralConsentRequestBodyType();
            body.consentEntityId = c.EntityConsent__c;
            body.consentVersionId = c.GeneralConsentVersion__c;
            body.globalId = client == null ? null : client.GlobalId__c;
            body.consentSourceId = 'SalesForce';
            body.validFrom = String.valueOfGmt(Datetime.now());
            body.agentCPU = c.AgentCPU__c;
            body.substitutePersonId = substitutePerson == null ? null : substitutePerson.GlobalId__c;
            body.substituteRoleId = c.SubstituteRole__c;
            ConsentWebServiceDataTypes.EnableGeneralConsentResponseBodyType response = stub.enableGeneralConsent(body, header);
            Logger.debug('EnableGeneralConsent response', JSON.serialize(response));
            if (response != null) {
                externalIds.add(response.consentGuid);
            }

            index++;
        }

        Logger.saveLogs();

        return externalIds;
    }
}
