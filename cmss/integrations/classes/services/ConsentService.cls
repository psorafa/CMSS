public with sharing class ConsentService {

    private static final List<String> CHANNEL_FIELD_NAMES = new List<String>{
        'EmailConsent__c', 'PhoneConsent__c', 'PortalConsent__c', 'PostConsent__c', 'SMSConsent__c'
    };

    public static void processChannelConsent(List<SObject> newConsents, Map<Id, SObject> oldIdsToConsents) {
        List<List<ConsentDataTypesService.EnableChannelConsentRequestBodyType>> listOfEnableChannelRequestLists = 
            new List<List<ConsentDataTypesService.EnableChannelConsentRequestBodyType>>
        {
            new List<ConsentDataTypesService.EnableChannelConsentRequestBodyType>(),
            new List<ConsentDataTypesService.EnableChannelConsentRequestBodyType>(),
            new List<ConsentDataTypesService.EnableChannelConsentRequestBodyType>(),
            new List<ConsentDataTypesService.EnableChannelConsentRequestBodyType>()
        };
        List<List<ConsentDataTypesService.DisableChannelConsentRequestBodyType>> listOfDisableChannelRequestLists = 
            new List<List<ConsentDataTypesService.DisableChannelConsentRequestBodyType>>
        {
            new List<ConsentDataTypesService.DisableChannelConsentRequestBodyType>(),
            new List<ConsentDataTypesService.DisableChannelConsentRequestBodyType>(),
            new List<ConsentDataTypesService.DisableChannelConsentRequestBodyType>(),
            new List<ConsentDataTypesService.DisableChannelConsentRequestBodyType>()
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

        Set<Id> accountIds = new Set<Id>();
        for (Consent__c c : (List<Consent__c>) newConsents) {
            Validation.requireAttribute(c.Account__c, 'Account__c');
            accountIds.add(c.Account__c);
        }
        Map<Id, Account> idsToAccounts = new Map<Id, Account>([
            SELECT GlobalId__c
            FROM Account 
            WHERE Id IN :accountIds
        ]);

        if (oldIdsToConsents != null) {
            for (Integer i = 0; i < newConsents.size(); i++) {
                SObject oldConsent = oldIdsToConsents.get((Id) newConsents[i].get('Id'));

                Validation.requireAttribute(newConsents[i].get('EntityConsent__c'), 'EntityConsent__c');
                Account acc = idsToAccounts.get((Id) newConsents[i].get('Account__c'));
                Validation.requireAttribute(acc, 'Account');
                Validation.requireAttribute(acc.GlobalId__c, 'GlobalId__c');

                for (String fieldName : CHANNEL_FIELD_NAMES) {
                    String consentChannelId = fieldNamesToConsentChannelIds.get(fieldName);
                    
                    if (newConsents[i].get(fieldName) != oldConsent.get(fieldName) && newConsents[i].get(fieldName) == '1') {
                        listOfEnableChannelRequestLists[i/50].add(getEnableChannelWSDefinition((Consent__c) newConsents[i], consentChannelId, acc.GlobalId__c));
                    } else if (newConsents[i].get(fieldName) != oldConsent.get(fieldName) && newConsents[i].get(fieldName) == '2') {
                        listOfDisableChannelRequestLists[i/50].add(getDisableChannelWSDefinition((Consent__c) newConsents[i], consentChannelId, acc.GlobalId__c));
                    }
                }
            }
        } else {
            for (Integer i = 0; i < newConsents.size(); i++) {
                Validation.requireAttribute(newConsents[i].get('EntityConsent__c'), 'EntityConsent__c');
                Account acc = idsToAccounts.get((Id) newConsents[i].get('Account__c'));
                Validation.requireAttribute(acc, 'Account');
                Validation.requireAttribute(acc.GlobalId__c, 'GlobalId__c');

                for (String fieldName : CHANNEL_FIELD_NAMES) {
                    String consentChannelId = fieldNamesToConsentChannelIds.get(fieldName);
                    
                    if (newConsents[i].get(fieldName) == '1') {
                        listOfEnableChannelRequestLists[i/50].add(getEnableChannelWSDefinition((Consent__c) newConsents[i], consentChannelId, acc.GlobalId__c));
                    } else if (newConsents[i].get(fieldName) == '2') {
                        listOfDisableChannelRequestLists[i/50].add(getDisableChannelWSDefinition((Consent__c) newConsents[i], consentChannelId, acc.GlobalId__c));
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

    public static void processInternalConsent(List<InternalConsent__c> newConsents, Map<Id, InternalConsent__c> oldIdsToConsents) {
        List<List<ConsentDataTypesService.EnableInternalConsentRequestBodyType>> listOfEnableConsentRequestLists = 
            new List<List<ConsentDataTypesService.EnableInternalConsentRequestBodyType>>
        {
            new List<ConsentDataTypesService.EnableInternalConsentRequestBodyType>(),
            new List<ConsentDataTypesService.EnableInternalConsentRequestBodyType>(),
            new List<ConsentDataTypesService.EnableInternalConsentRequestBodyType>(),
            new List<ConsentDataTypesService.EnableInternalConsentRequestBodyType>()
        };
        List<List<ConsentDataTypesService.DisableInternalConsentRequestBodyType>> listOfDisableConsentRequestLists = 
            new List<List<ConsentDataTypesService.DisableInternalConsentRequestBodyType>>
        {
            new List<ConsentDataTypesService.DisableInternalConsentRequestBodyType>(),
            new List<ConsentDataTypesService.DisableInternalConsentRequestBodyType>(),
            new List<ConsentDataTypesService.DisableInternalConsentRequestBodyType>(),
            new List<ConsentDataTypesService.DisableInternalConsentRequestBodyType>()
        };

        Set<Id> accountIds = new Set<Id>();
        for (InternalConsent__c c : newConsents) {
            accountIds.add(c.Account__c);
        }

        Map<Id, Account> idsToAccounts = new Map<Id, Account>([
            SELECT GlobalId__c
            FROM Account 
            WHERE Id IN :accountIds
        ]);

        for (Integer i = 0; i < newConsents.size(); i++) {
            InternalConsent__c oldConsent = oldIdsToConsents.get(newConsents[i].Id);

            if (newConsents[i].InternalConsentValue__c != oldConsent.InternalConsentValue__c && newConsents[i].InternalConsentValue__c == '1') {
                Validation.requireAttribute(newConsents[i].InternalConsentType__c, 'InternalConsentType__c');
                listOfEnableConsentRequestLists[i/50].add(getEnableInternalConsentWSDefinition(newConsents[i], idsToAccounts.get(newConsents[i].Account__c)));
            } else if (newConsents[i].InternalConsentValue__c != oldConsent.InternalConsentValue__c && newConsents[i].InternalConsentValue__c == '2') {
                Validation.requireAttribute(newConsents[i].ExternalId__c, 'ExternalId__c');
                listOfDisableConsentRequestLists[i/50].add(getDisableInternalConsentWSDefinition(newConsents[i]));
            }
        }

        for (Integer i = 0; i < 4; i++) {
            if (listOfEnableConsentRequestLists[i].size() > 0 || listOfDisableConsentRequestLists[i].size() > 0) {
                makeInternalConsentCallout(
                    JSON.serialize(listOfEnableConsentRequestLists[i]), JSON.serialize(listOfDisableConsentRequestLists[i])
                );
            }
        }
    }

    @future(callout=true)
    private static void makeChannelConsentCallout(String enableConsentRequestsJSON, String disableConsentRequestsJSON) {

        List<ConsentDataTypesService.EnableChannelConsentRequestBodyType> enableConsentRequests = 
            (List<ConsentDataTypesService.EnableChannelConsentRequestBodyType>) JSON.deserialize(
                enableConsentRequestsJSON, List<ConsentDataTypesService.EnableChannelConsentRequestBodyType>.class
        );
        List<ConsentDataTypesService.DisableChannelConsentRequestBodyType> disableConsentRequests = 
            (List<ConsentDataTypesService.DisableChannelConsentRequestBodyType>) JSON.deserialize(
                disableConsentRequestsJSON, List<ConsentDataTypesService.DisableChannelConsentRequestBodyType>.class
        );

        CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
        ConsentCalloutService.ConsentServicePort stub = new ConsentCalloutService.ConsentServicePort();
        for (ConsentDataTypesService.EnableChannelConsentRequestBodyType body : enableConsentRequests) {
            ConsentDataTypesService.EnableChannelConsentResponseBodyType response = stub.enableChannelConsent_Http(header, body);
        }
        for (ConsentDataTypesService.DisableChannelConsentRequestBodyType body : disableConsentRequests) {
            ConsentDataTypesService.DisableChannelConsentResponseBodyType response = stub.disableChannelConsent_Http(header, body);
        }

        Logger.saveLogs();
    }

    @future(callout=true)
    private static void makeInternalConsentCallout(String enableConsentRequestsJSON, String disableConsentRequestsJSON) {

        List<ConsentDataTypesService.EnableInternalConsentRequestBodyType> enableConsentRequests = 
            (List<ConsentDataTypesService.EnableInternalConsentRequestBodyType>) JSON.deserialize(
                enableConsentRequestsJSON, List<ConsentDataTypesService.EnableInternalConsentRequestBodyType>.class
        );
        List<ConsentDataTypesService.DisableInternalConsentRequestBodyType> disableConsentRequests = 
            (List<ConsentDataTypesService.DisableInternalConsentRequestBodyType>) JSON.deserialize(
                disableConsentRequestsJSON, List<ConsentDataTypesService.DisableInternalConsentRequestBodyType>.class
        );

        CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
        ConsentCalloutService.ConsentServicePort stub = new ConsentCalloutService.ConsentServicePort();
        for (ConsentDataTypesService.EnableInternalConsentRequestBodyType body : enableConsentRequests) {
            ConsentDataTypesService.EnableInternalConsentResponseBodyType response = stub.enableInternalConsent_Http(header, body);
        }
        for (ConsentDataTypesService.DisableInternalConsentRequestBodyType body : disableConsentRequests) {
            ConsentDataTypesService.DisableInternalConsentResponseBodyType response = stub.disableInternalConsent_Http(header, body);
        }

        Logger.saveLogs();
    }

    private static ConsentDataTypesService.EnableChannelConsentRequestBodyType getEnableChannelWSDefinition(Consent__c c, String consentChannelId, String clientId) {
        ConsentDataTypesService.EnableChannelConsentRequestBodyType body = new ConsentDataTypesService.EnableChannelConsentRequestBodyType();
        body.consentEntityId = c.EntityConsent__c;
        body.consentChannelId = consentChannelId;
        body.globalId = clientId;
        body.consentSourceId = '20';
        body.validFrom = Datetime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
        body.validFrom = body.validFrom.substring(0, body.validFrom.length() - 2) + ':00'; 
        body.agentCPU = c.AgentCPU__c;
        return body;
    }
    
    private static ConsentDataTypesService.DisableChannelConsentRequestBodyType getDisableChannelWSDefinition(Consent__c c, String consentChannelId, String clientId) {
        ConsentDataTypesService.DisableChannelConsentRequestBodyType body = new ConsentDataTypesService.DisableChannelConsentRequestBodyType();
        body.consentEntityId = c.EntityConsent__c;
        body.consentChannelId = consentChannelId;
        body.globalId = clientId;
        body.consentSourceId = '20';
        body.validFrom = Datetime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
        body.validFrom = body.validFrom.substring(0, body.validFrom.length() - 2) + ':00'; 
        body.agentCPU = c.AgentCPU__c;
        return body;
    }

    public static ConsentDataTypesService.EnableInternalConsentRequestBodyType getEnableInternalConsentWSDefinition(InternalConsent__c c, Account client) {
        ConsentDataTypesService.EnableInternalConsentRequestBodyType body = new ConsentDataTypesService.EnableInternalConsentRequestBodyType();
        if (client != null) {
            body.globalId = client.GlobalId__c;
        }
        body.consentKind = c.InternalConsentType__c;
        body.consentValidFrom = Datetime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
        body.consentValidFrom = body.consentValidFrom.substring(0, body.consentValidFrom.length() - 2) + ':00'; 
        body.consentSourceId = '20';
        return body;
    }
    
    private static ConsentDataTypesService.DisableInternalConsentRequestBodyType getDisableInternalConsentWSDefinition(InternalConsent__c c) {
        ConsentDataTypesService.DisableInternalConsentRequestBodyType body = new ConsentDataTypesService.DisableInternalConsentRequestBodyType();
        body.consentCrmGuid = c.ExternalId__c;
        body.consentSourceId = '20';
        return body;
    }
}
