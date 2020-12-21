public with sharing class ConsentService {

    private static final List<String> CHANNEL_FIELD_NAMES = new List<String>{
        'EmailConsent__c', 'PhoneConsent__c', 'PortalConsent__c', 'PostConsent__c', 'SMSConsent__c'
    };

    public static void processChannelConsent(List<SObject> newConsents, Map<Id, SObject> oldIdsToConsents) {
        List<List<ConsentWebServiceDataTypes.EnableChannelConsentRequestBodyType>> listOfEnableChannelRequestLists = 
            new List<List<ConsentWebServiceDataTypes.EnableChannelConsentRequestBodyType>>
        {
            new List<ConsentWebServiceDataTypes.EnableChannelConsentRequestBodyType>(),
            new List<ConsentWebServiceDataTypes.EnableChannelConsentRequestBodyType>(),
            new List<ConsentWebServiceDataTypes.EnableChannelConsentRequestBodyType>(),
            new List<ConsentWebServiceDataTypes.EnableChannelConsentRequestBodyType>()
        };
        List<List<ConsentWebServiceDataTypes.DisableChannelConsentRequestBodyType>> listOfDisableChannelRequestLists = 
            new List<List<ConsentWebServiceDataTypes.DisableChannelConsentRequestBodyType>>
        {
            new List<ConsentWebServiceDataTypes.DisableChannelConsentRequestBodyType>(),
            new List<ConsentWebServiceDataTypes.DisableChannelConsentRequestBodyType>(),
            new List<ConsentWebServiceDataTypes.DisableChannelConsentRequestBodyType>(),
            new List<ConsentWebServiceDataTypes.DisableChannelConsentRequestBodyType>()
        };

        Map<String, String> fieldNamesToConsentChannelIds = new Map<String, String>();
        ConsentChannelIdsMapping__mdt[] consentChannelIdsMapping = [
            SELECT FieldName__c, ConsentChannelId__c 
            FROM ConsentChannelIdsMapping__mdt
            WHERE ForTestingOnly__c = :Test.isRunningTest()
        ];
        for (ConsentChannelIdsMapping__mdt ccim : consentChannelIdsMapping) {
            fieldNamesToConsentChannelIds.put(ccim.FieldName__c, ccim.ConsentChannelId__c);
        }

        for (Integer i = 0; i < newConsents.size(); i++) {
            SObject oldConsent = oldIdsToConsents.get((Id) newConsents[i].get('Id'));

            if (newConsents[i].get('EntityConsent__c') != null) {
                for (String fieldName : CHANNEL_FIELD_NAMES) {
                    String consentChannelId = fieldNamesToConsentChannelIds.get(fieldName);
                    if (newConsents[i].get(fieldName) != oldConsent.get(fieldName) && newConsents[i].get(fieldName) == '1') {
                        listOfEnableChannelRequestLists[i/50].add(getEnableChannelWSDefinition((Consent__c) newConsents[i], consentChannelId));
                    } else if (newConsents[i].get(fieldName) != oldConsent.get(fieldName) && newConsents[i].get(fieldName) == '2') {
                        listOfDisableChannelRequestLists[i/50].add(getDisableChannelWSDefinition((Consent__c) newConsents[i], consentChannelId));
                    }
                }
            }
        }

        for (Integer i = 0; i < 4; i++) {
            if (listOfEnableChannelRequestLists[i].size() > 0 || listOfDisableChannelRequestLists[i].size() > 0) {
                makeChannelConsentCallout(
                    JSON.serialize(listOfEnableChannelRequestLists[i]), JSON.serialize(listOfDisableChannelRequestLists[i])
                );
            }
        }
    }

    @future(callout=true)
    private static void makeChannelConsentCallout(String enableConsentRequestsJSON, String disableConsentRequestsJSON) {

        List<ConsentWebServiceDataTypes.EnableChannelConsentRequestBodyType> enableConsentRequests = 
            (List<ConsentWebServiceDataTypes.EnableChannelConsentRequestBodyType>) JSON.deserialize(
                enableConsentRequestsJSON, List<ConsentWebServiceDataTypes.EnableChannelConsentRequestBodyType>.class
        );
        List<ConsentWebServiceDataTypes.DisableChannelConsentRequestBodyType> disableConsentRequests = 
            (List<ConsentWebServiceDataTypes.DisableChannelConsentRequestBodyType>) JSON.deserialize(
                disableConsentRequestsJSON, List<ConsentWebServiceDataTypes.DisableChannelConsentRequestBodyType>.class
        );

        SOAPCommonTypes.OutboundRequestHeader header = new SOAPCommonTypes.OutboundRequestHeader();
        ConsentWebService.ConsentServicePort stub = new ConsentWebService.ConsentServicePort();
        for (ConsentWebServiceDataTypes.EnableChannelConsentRequestBodyType body : enableConsentRequests) {
            ConsentWebServiceDataTypes.EnableChannelConsentResponseBodyType response = stub.enableChannelConsent(body, header);
            Logger.debug('EnableChannelConsent response', JSON.serialize(response));
        }
        for (ConsentWebServiceDataTypes.DisableChannelConsentRequestBodyType body : disableConsentRequests) {
            ConsentWebServiceDataTypes.DisableChannelConsentResponseBodyType response = stub.disableChannelConsent(body, header);
            Logger.debug('DisableChannelConsent response', JSON.serialize(response));
        }

        Logger.saveLogs();
    }

    private static ConsentWebServiceDataTypes.EnableChannelConsentRequestBodyType getEnableChannelWSDefinition(Consent__c c, String consentChannelId) {
        ConsentWebServiceDataTypes.EnableChannelConsentRequestBodyType body = new ConsentWebServiceDataTypes.EnableChannelConsentRequestBodyType();
        body.consentEntityId = c.EntityConsent__c;
        body.consentChannelId = consentChannelId;
        body.globalId = c.Account__r.GlobalId__c;
        body.consentSourceId = 'SalesForce';
        body.validFrom = String.valueOfGmt(Datetime.now());
        body.agentCPU = c.AgentCPU__c;
        return body;
    }
    
    private static ConsentWebServiceDataTypes.DisableChannelConsentRequestBodyType getDisableChannelWSDefinition(Consent__c c, String consentChannelId) {
        ConsentWebServiceDataTypes.DisableChannelConsentRequestBodyType body = new ConsentWebServiceDataTypes.DisableChannelConsentRequestBodyType();
        body.consentEntityId = c.EntityConsent__c;
        body.consentChannelId = consentChannelId;
        body.globalId = c.Account__r.GlobalId__c;
        body.consentSourceId = 'SalesForce';
        body.validFrom = String.valueOfGmt(Datetime.now());
        body.agentCPU = c.AgentCPU__c;
        return body;
    }
}
