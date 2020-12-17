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
        for (Integer i = 0; i < newConsents.size(); i++) {
            SObject oldConsent = oldIdsToConsents.get((Id) newConsents[i].get('Id'));

            if (newConsents[i].get('EntityConsent__c') != null) {
                for (String fieldName : CHANNEL_FIELD_NAMES) {
                    if (newConsents[i].get(fieldName) != oldConsent.get(fieldName) && newConsents[i].get(fieldName) == '1') {
                        // ADD METADATA!
                        listOfEnableChannelRequestLists[i/50].add(getEnableChannelWSDefinition((Consent__c) newConsents[i], 'myEmailConsentId'));
                    } else if (newConsents[i].get(fieldName) != oldConsent.get(fieldName) && newConsents[i].get(fieldName) == '2') {
                        // ADD METADATA!
                        listOfDisableChannelRequestLists[i/50].add(getDisableChannelWSDefinition((Consent__c) newConsents[i], 'mySMSConsentId'));
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

        ConsentWebServiceDataTypes.RequestHeader header = new ConsentWebServiceDataTypes.RequestHeader();
        header.timestamp = System.now();
        header.messageId = MockServicesUtil.generateUUID();
        header.sourceSystem = 'SalesForce';
        header.physicalSource = Url.getSalesforceBaseUrl().toExternalForm();
        header.userId = UserInfo.getUserId();

        ConsentWebService.ConsentServicePort stub = new ConsentWebService.ConsentServicePort();
        for (ConsentWebServiceDataTypes.EnableChannelConsentRequestBodyType body : enableConsentRequests) {
            ConsentWebServiceDataTypes.EnableChannelConsentResponseBodyType response = stub.enableChannelConsent(body, header);
            if (response != null) {
                Logger.debug('EnableChannelConsent response', JSON.serialize(response));
            }
        }
        for (ConsentWebServiceDataTypes.DisableChannelConsentRequestBodyType body : disableConsentRequests) {
            ConsentWebServiceDataTypes.DisableChannelConsentResponseBodyType response = stub.disableChannelConsent(body, header);
            if (response != null) {
                Logger.debug('DisableChannelConsent response', JSON.serialize(response));
            }
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

    public static void processGeneralConsent(List<Consent__c> newConsents) {
        List<List<Id>> listOfconsentIdLists = new List<List<Id>>{
            new List<Id>(), new List<Id>(), new List<Id>(), new List<Id>()
        };
        for (Integer i = 0; i < newConsents.size(); i++) {
            if (newConsents[i].EntityConsent__c != null && newConsents[i].GeneralConsentVersion__c != null && newConsents[i].Account__c != null) {
                listOfconsentIdLists[i/50].add(newConsents[i].Id);
            }
        }

        for (List<Id> consentIds : listOfconsentIdLists) {
            if (consentIds.size() > 0) {
                makeGeneralConsentCallout(consentIds);
            }
        }
    }

    @future(callout=true)
    private static void makeGeneralConsentCallout(List<Id> consentIds) {
        List<Consent__c> consents = [
            SELECT EntityConsent__c, GeneralConsentVersion__c, Account__r.GlobalId__c, AgentCPU__c, SubstitutePerson__r.GlobalId__c, SubstituteRole__c 
            FROM Consent__c 
            WHERE Id IN :consentIds
        ];

        ConsentWebServiceDataTypes.RequestHeader header = new ConsentWebServiceDataTypes.RequestHeader();
        header.timestamp = System.now();
        header.messageId = MockServicesUtil.generateUUID();
        header.sourceSystem = 'SalesForce';
        header.physicalSource = Url.getSalesforceBaseUrl().toExternalForm();
        header.userId = UserInfo.getUserId();

        List<Consent__c> consentsToUpdate = new List<Consent__c>();
        ConsentWebService.ConsentServicePort stub = new ConsentWebService.ConsentServicePort();
        for (Consent__c c : consents) {
            ConsentWebServiceDataTypes.EnableGeneralConsentRequestBodyType body = new ConsentWebServiceDataTypes.EnableGeneralConsentRequestBodyType();
            body.consentEntityId = c.EntityConsent__c;
            body.consentVersionId = c.GeneralConsentVersion__c;
            body.globalId = c.Account__r.GlobalId__c;
            body.consentSourceId = 'SalesForce';
            body.validFrom = String.valueOfGmt(Datetime.now());
            body.agentCPU = c.AgentCPU__c;
            body.substitutePersonId = c.SubstitutePerson__r.GlobalId__c;
            body.substituteRoleId = c.SubstituteRole__c;
            ConsentWebServiceDataTypes.EnableGeneralConsentResponseBodyType response = stub.enableGeneralConsent(body, header);
            if (response != null) {
                consentsToUpdate.add(new Consent__c(Id = c.Id, ExternalId__c = response.consentGuid));
            }
        }

        update consentsToUpdate;
    }
}
