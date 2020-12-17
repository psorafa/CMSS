@isTest
private class ConsentWebServiceTest {
    
    @isTest
    static void testProcessGeneralConsent() {
        Test.setMock(WebServiceMock.class, new ConsentWebServiceMock.GeneralChannelConsentMock());
        
		List<Consent__c> consents = TestDataFactory.getConsents(200, new Consent__c());
		Test.startTest();
		insert consents;
        Test.stopTest();
        
        List<Consent__c> queriedConsents = [SELECT ExternalId__c FROM Consent__c];
        System.assertEquals(200, queriedConsents.size());
        for (Consent__c c : queriedConsents) {
            System.assert(c.ExternalId__c.contains('3267wergjs'));
        }
    }

    @isTest
    static void testProcessChannelConsent() {
        Test.setMock(WebServiceMock.class, new ConsentWebServiceMock.GeneralChannelConsentMock());
		
        Test.startTest();
        List<Consent__c> consents = TestDataFactory.getConsents(200, new Consent__c());
        insert consents;
        
        consents[0].EmailConsent__c = '1';
        consents[1].SMSConsent__c = '2';
        update consents;
        Test.stopTest();
        
        List<Consent__c> queriedConsents = [SELECT ExternalId__c FROM Consent__c];
        System.assertEquals(200, queriedConsents.size());
        for (Consent__c c : queriedConsents) {
            System.assert(c.ExternalId__c.contains('3267wergjs'));
        }
    }
}
