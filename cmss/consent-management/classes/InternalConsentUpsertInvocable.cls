public with sharing class InternalConsentUpsertInvocable {
    
    @InvocableMethod
    public static List<Results> execute (List<Request> requestList) {
        List<Results> responseWrapper = new List<Results>();
        for (Request curRequest : requestList) {
            InternalConsent__c inputRecord = curRequest.inputRecord;

            if ( inputRecord != null) {
                InternalConsent__c tempInputRecord = new InternalConsent__c ();
                // Picklist values needs to be casted to the String, known issue.
                tempInputRecord.InternalConsentType__c = String.valueOf(inputRecord.InternalConsentType__c);
                tempInputRecord.Source__c = String.valueOf(inputRecord.Source__c);
                tempInputRecord.InternalConsentValue__c = String.valueOf(inputRecord.InternalConsentValue__c);
                tempInputRecord.ValidFrom__c = inputRecord.ValidFrom__c;
                tempInputRecord.ValidTo__c = inputRecord.ValidTo__c;
                tempInputRecord.Account__c = inputRecord.Account__c;
                tempInputRecord.ExternalId__c = inputRecord.ExternalId__c;
                Upsert tempInputRecord ExternalId__c;
            }
            
            Results response = new Results();

            responseWrapper.add(response);
        }     
        
        return responseWrapper;
    
    }

    public class Request {
        @InvocableVariable
        public InternalConsent__c inputRecord;
    }
    
    public class Results {
        @InvocableVariable
        public String placeholder; // Will not work without this.
    }

    public class InvocableActionException extends Exception {}
}
