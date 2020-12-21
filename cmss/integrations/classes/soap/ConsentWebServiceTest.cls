@isTest
private class ConsentWebServiceTest {
    
    @isTest
    static void testEnableGeneralConsents() {
        Test.setMock(WebServiceMock.class, new ConsentWebServiceMock.GeneralConsentMock());
        
		List<Consent__c> consents = TestDataFactory.getConsents(200, new Consent__c());
		Test.startTest();
		List<String> externalIds = GeneralConsentEnablement.enableGeneralConsents(consents);
        Test.stopTest();
        
        System.assertEquals(100, externalIds.size());
        for (String externalId : externalIds) {
            System.assert(externalId.contains('3267wergjs'));
        }
    }

    @isTest
    static void testEnableInternalConsents() {
        Test.setMock(WebServiceMock.class, new ConsentWebServiceMock.InternalConsentMock());
        
		List<InternalConsent__c> internalConsents = TestDataFactory.getInternalConsents(200, new InternalConsent__c());
		Test.startTest();
		List<String> externalIds = InternalConsentEnablement.enableInternalConsents(internalConsents);
        Test.stopTest();
        
        System.assertEquals(100, externalIds.size());
        for (String externalId : externalIds) {
            System.assert(externalId.contains('kdslfn450'));
        }
    }

    @isTest
    static void testProcessChannelConsent() {
        Test.setMock(WebServiceMock.class, new ConsentWebServiceMock.ChannelConsentMock());
		
        Test.startTest();
        List<Consent__c> consents = TestDataFactory.getConsents(200, new Consent__c());
        insert consents;
        
        for (Consent__c c : consents) {
            c.EmailConsent__c = '1';
            c.SMSConsent__c = '2';
        }
        update consents;
        Test.stopTest();
        
        List<Log__c> logs = [SELECT Message__c, Payload__c FROM Log__c WHERE Message__c = 'EnableChannelConsent response' OR Message__c = 'DisableChannelConsent response'];
        System.assertEquals(400, logs.size());
        for (Log__c l : logs) {
            if (l.Message__c == 'EnableChannelConsent response') {
                System.assert(((String) ((Map<String, Object>) JSON.deserializeUntyped(l.Payload__c)).get('consentGuid')).contains('3267wergjs'));
            } else if (l.Message__c == 'DisableChannelConsent response') {
                ConsentWebServiceDataTypes.DisableChannelConsentResponseBodyType resp = 
                    (ConsentWebServiceDataTypes.DisableChannelConsentResponseBodyType) JSON.deserialize(l.Payload__c, ConsentWebServiceDataTypes.DisableChannelConsentResponseBodyType.class);
                System.assert(resp.success.Successful);
            }
        }
    }
}
