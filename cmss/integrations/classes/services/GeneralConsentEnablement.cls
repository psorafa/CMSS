public with sharing class GeneralConsentEnablement {
    
    @InvocableMethod
    public static Result[] enableGeneralConsents(Request[] requests) {
        Result[] results = new Result[]{};

        Set<Id> accountIds = new Set<Id>();
        accountIds.add(requests[0].accountId);
        accountIds.add(requests[0].substitutePersonId);

        Map<Id, Account> idsToAccounts = new Map<Id, Account>([
            SELECT GlobalId__c
            FROM Account 
            WHERE Id IN :accountIds
        ]);

        Account client = idsToAccounts.get(requests[0].accountId);
        Validation.requireAttribute(client, 'Account');
        Validation.requireAttribute(client.GlobalId__c, 'GlobalId__c');
        Account substitutePerson = idsToAccounts.get(requests[0].substitutePersonId);

        CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
        ConsentCalloutService.ConsentServicePort stub = new ConsentCalloutService.ConsentServicePort();
        ConsentDataTypesService.EnableGeneralConsentRequestBodyType body = new ConsentDataTypesService.EnableGeneralConsentRequestBodyType();
        body.consentEntityId = requests[0].consentEntityId;
        body.consentVersionId = requests[0].consentVersionId;
        body.globalId = client.GlobalId__c;
        body.consentSourceId = '20';
        body.validFrom = Datetime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
        body.validFrom = body.validFrom.substring(0, body.validFrom.length() - 2) + ':00'; 
        body.agentCPU = requests[0].agentCPU;
        if (substitutePerson != null) {
            body.substitutePersonId = substitutePerson.GlobalId__c;
        }
        body.substituteRoleId = requests[0].substituteRoleId;
        ConsentDataTypesService.EnableGeneralConsentResponseBodyType response = stub.enableGeneralConsent_Http(header, body);
        if (response != null) {
            results.add(new Result(response.consentGuid));
        }

        Logger.saveLogs();

        return results;
    }

    public class Request {
        @InvocableVariable(label='Consent Entity Id' required=true)
        public String consentEntityId;

        @InvocableVariable(label='Consent Version Id' required=true)
        public String consentVersionId;

        @InvocableVariable(label='Agent CPU' required=false)
        public String agentCPU;

        @InvocableVariable(label='Account Id' required=true)
        public String accountId;

        @InvocableVariable(label='Substitute Person Id' required=false)
        public String substitutePersonId;

        @InvocableVariable(label='Substitute Role Id' required=false)
        public String substituteRoleId;
    }
    
    public class Result {
        public Result(String externalId) {
            this.externalId = externalId;
        }

        @InvocableVariable(label='External Id' required=true)
        public String externalId;
    }
}
