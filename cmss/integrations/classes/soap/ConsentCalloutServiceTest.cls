@isTest
private class ConsentCalloutServiceTest {
    
    @isTest
    static void testEnableGeneralConsents() {
        CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
            200,
            'OK',
            '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:EnableGeneralConsentResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:consentGuid>E8FF097A-B0D4-4A19-BC37-3509B762FE3A</ns3:consentGuid></ns3:responseBody></ns3:EnableGeneralConsentResponse></soapenv:Body></soapenv:Envelope>',
            null,
            null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);

		List<Consent__c> consents = TestDataFactory.getConsents(200, new Consent__c());
		Test.startTest();
		List<String> externalIds = GeneralConsentEnablement.enableGeneralConsents(consents);
        Test.stopTest();
        
        System.assertEquals(100, externalIds.size());
        for (String externalId : externalIds) {
            System.assert(externalId.contains('E8FF097A-B0D4-4A19-BC37-3509B762FE3A'));
        }
    }

    @isTest
    static void testEnableInternalConsents() {
        CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
            200,
            'OK',
            '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:EnableInternalConsentResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:consentGuid>E8FF097A-B0D4-4A19-BC37-3509B762FE3A</ns3:consentGuid></ns3:responseBody></ns3:EnableInternalConsentResponse></soapenv:Body></soapenv:Envelope>',
            null,
            null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        
		List<InternalConsent__c> internalConsents = TestDataFactory.getInternalConsents(200, new InternalConsent__c());
		Test.startTest();
		List<String> externalIds = InternalConsentEnablement.enableInternalConsents(internalConsents);
        Test.stopTest();
        
        System.assertEquals(100, externalIds.size());
        for (String externalId : externalIds) {
            System.assert(externalId.contains('E8FF097A-B0D4-4A19-BC37-3509B762FE3A'));
        }
    }

    @isTest
    static void testProcessChannelConsent() {
        CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
            200,
            'OK',
            null,
            new Map<String, String>{
                'EnableChannelConsentRequest' => '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:EnableChannelConsentRequest xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:consentGuid>E8FF097A-B0D4-4A19-BC37-3509B762FE3A</ns3:consentGuid></ns3:responseBody></ns3:EnableChannelConsentRequest></soapenv:Body></soapenv:Envelope>',
                'DisableChannelConsentRequest' => '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:DisableChannelConsentRequest xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:consentGuid>E8FF097A-B0D4-4A19-BC37-3509B762FE3A</ns3:consentGuid></ns3:responseBody></ns3:DisableChannelConsentRequest></soapenv:Body></soapenv:Envelope>'
            },
            null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
		
        Test.startTest();
        List<Consent__c> consents = TestDataFactory.getConsents(200, new Consent__c());
        insert consents;
        
        for (Consent__c c : consents) {
            c.EmailConsent__c = '1';
            c.SMSConsent__c = '2';
        }
        update consents;
        Test.stopTest();
        
        List<Log__c> logs = [SELECT Message__c, Payload__c FROM Log__c WHERE Message__c = 'enableChannelConsent_Http response' OR Message__c = 'disableChannelConsent_Http response'];
        System.assertEquals(400, logs.size());
        for (Log__c l : logs) {
            if (l.Message__c == 'EnableChannelConsent response') {
                System.assert(((String) ((Map<String, Object>) JSON.deserializeUntyped(l.Payload__c)).get('consentGuid')).contains('3267wergjs'));
            } else if (l.Message__c == 'DisableChannelConsent response') {
                ConsentDataTypesService.DisableChannelConsentResponseBodyType resp = 
                    (ConsentDataTypesService.DisableChannelConsentResponseBodyType) JSON.deserialize(l.Payload__c, ConsentDataTypesService.DisableChannelConsentResponseBodyType.class);
                System.assert(resp.success.Successful);
            }
        }
    }

    @isTest
    static void testProcessInternalConsent() {
        CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
            200,
            'OK',
            null,
            new Map<String, String>{
                'EnableInternalConsentRequest' => '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:EnableInternalConsentResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:consentGuid>E8FF097A-B0D4-4A19-BC37-3509B762FE3A</ns3:consentGuid></ns3:responseBody></ns3:EnableInternalConsentResponse></soapenv:Body></soapenv:Envelope>',
                'DisableInternalConsentRequest' => '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:DisableInternalConsentResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:consentGuid>E8FF097A-B0D4-4A19-BC37-3509B762FE3A</ns3:consentGuid></ns3:responseBody></ns3:DisableInternalConsentResponse></soapenv:Body></soapenv:Envelope>'
            },
            null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
		
        Test.startTest();
        List<InternalConsent__c> consents = TestDataFactory.getInternalConsents(100, new InternalConsent__c());
        consents.addAll(TestDataFactory.getInternalConsents(100, new InternalConsent__c(InternalConsentValue__c = '2')));
        insert consents;
        
        for (Integer i = 0; i < consents.size(); i++) {
            consents[i].InternalConsentValue__c = i < 100 ? '2' : '1';
        }
        update consents;
        Test.stopTest();
        
        List<Log__c> logs1 = [SELECT Message__c, Payload__c FROM Log__c WHERE Message__c = 'disableInternalConsent_Http response'];
        System.assertEquals(100, logs1.size());
        List<Log__c> logs2 = [SELECT Message__c, Payload__c FROM Log__c WHERE Message__c = 'enableInternalConsent_Http response'];
        System.assertEquals(100, logs2.size());
        logs1.addAll(logs2);
        for (Log__c l : logs1) {
            if (l.Message__c == 'EnableInternalConsent response') {
                System.assert(((String) ((Map<String, Object>) JSON.deserializeUntyped(l.Payload__c)).get('consentGuid')).contains('kdslfn450'));
            } else if (l.Message__c == 'DisableInternalConsent response') {
                ConsentDataTypesService.DisableInternalConsentResponseBodyType resp = 
                    (ConsentDataTypesService.DisableInternalConsentResponseBodyType) JSON.deserialize(l.Payload__c, ConsentDataTypesService.DisableInternalConsentResponseBodyType.class);
                System.assert(resp.success.Successful);
            }
        }
    }
}
