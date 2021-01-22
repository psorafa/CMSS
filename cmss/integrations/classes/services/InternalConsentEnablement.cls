public with sharing class InternalConsentEnablement {
    
    @InvocableMethod
    public static Result[] enableInternalConsents(Request[] requests) {
        Result[] results = new Result[]{};

        if (requests[0].consentValue != '1') {
            return null;
        }
        
        InternalConsent__c c = new InternalConsent__c(
            InternalConsentType__c = requests[0].consentType,
            InternalConsentValue__c = requests[0].consentValue,
            ValidFrom__c = requests[0].validFrom,
            ValidTo__c = requests[0].validTo,
            Source__c = requests[0].source,
            Account__c = requests[0].accountId
        );

        Account[] accounts = [
            SELECT GlobalId__c
            FROM Account 
            WHERE Id = :requests[0].accountId
        ];
        if (accounts.size() == 0) {
            return null;
        }
        
        CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
        ConsentCalloutService.ConsentServicePort stub = new ConsentCalloutService.ConsentServicePort();

        ConsentDataTypesService.EnableInternalConsentRequestBodyType body = ConsentService.getEnableInternalConsentWSDefinition(c, accounts[0]);
        ConsentDataTypesService.EnableInternalConsentResponseBodyType response = stub.enableInternalConsent_Http(header, body);
        if (response != null) {
            results.add(new Result(response.consentGuid));
        }

        Logger.saveLogs();

        return results;
    }
     
    public class Request {
        @InvocableVariable(label='Consent Type' required=true)
        public String consentType;

        @InvocableVariable(label='Consent Value' required=true)
        public String consentValue;

        @InvocableVariable(label='Valid From' required=true)
        public Datetime validFrom;

        @InvocableVariable(label='Valid To' required=false)
        public Datetime validTo;

        @InvocableVariable(label='Source' required=true)
        public String source;

        @InvocableVariable(label='Account Id' required=true)
        public String accountId;
    }
    
    public class Result {
        public Result(String externalId) {
            this.externalId = externalId;
        }

        @InvocableVariable(label='External Id' required=true)
        public String externalId;
    }
}
