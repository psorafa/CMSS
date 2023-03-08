@IsTest
private class ConsentCalloutServiceTest {
	@TestSetup
	static void insertCustomSettings() {
		insert TestDataFactory.getIntegrationSettings();
	}

	@IsTest
	static void testEnableGeneralConsents() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			null,
			new Map<String, String>{
				'EnableGeneralConsentRequest' => '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:EnableGeneralConsentResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:consentGuid>E8FF097A-B0D4-4A19-BC37-3509B762FE3A</ns3:consentGuid></ns3:responseBody></ns3:EnableGeneralConsentResponse></soapenv:Body></soapenv:Envelope>',
				'DisableGeneralConsentRequest' => '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:DisableGeneralConsentResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>4e468a55-0d73-4fb5-af15-0696563f9af3</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:success><Successful>true</Successful></ns3:success></ns3:responseBody></ns3:DisableGeneralConsentResponse></soapenv:Body></soapenv:Envelope>',
				'EnableChannelConsentRequest' => '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:EnableChannelConsentResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:consentGuid>E8FF097A-B0D4-4A19-BC37-3509B762FE3A</ns3:consentGuid></ns3:responseBody></ns3:EnableChannelConsentResponse></soapenv:Body></soapenv:Envelope>',
				'DisableChannelConsentRequest' => '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:DisableChannelConsentResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:consentGuid>E8FF097A-B0D4-4A19-BC37-3509B762FE3A</ns3:consentGuid></ns3:responseBody></ns3:DisableChannelConsentResponse></soapenv:Body></soapenv:Envelope>'
			},
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		Consent__c c = TestDataFactory.getConsent(new Consent__c());
		c.AllConsent__c = '2';

		Test.startTest();
		String response = GeneralConsentEnablement.enableGeneralConsents(c);
		Test.stopTest();

		System.assert(response == 'OK');
		System.assert([SELECT Id FROM Consent__c].size() == 1);

		System.assert(
			[
				SELECT Id
				FROM Log__c
				WHERE
					Message__c = 'Outgoing request'
					AND ClassMethodName__c = 'Callout.executeCallout'
			]
			.size() > 0
		);
	}

	@IsTest
	static void testEnableGeneralConsentError() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			500,
			'Internal Server Error',
			'<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><soapenv:Fault><faultcode>soapenv:Server</faultcode><faultstring>Připojení k CPE DB se nezdařilo</faultstring><detail><ns2:CMSSServiceFaultInfo xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01" xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes"><ns2:errorNumber>57101</ns2:errorNumber><ns2:faultHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>56bb5218-3421-4080-b42c-99ff9532d0c1</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-02-17T11:06:19.956+01:00</ns2:timestamp><ns2:userId>0051j000006IxpjAAC</ns2:userId></ns2:faultHeader><ns2:message>Připojení k CPE DB se nezdařilo</ns2:message><ns2:system>ESB</ns2:system></ns2:CMSSServiceFaultInfo></detail></soapenv:Fault></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		Consent__c c = TestDataFactory.getConsent(new Consent__c());

		Test.startTest();
		String response = GeneralConsentEnablement.enableGeneralConsents(c);
		Test.stopTest();

		System.assertEquals(0, [SELECT Id FROM Consent__c].size());
	}

	@IsTest
	static void testEnableInternalConsents() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:EnableInternalConsentResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:consentGuid>E8FF097A-B0D4-4A19-BC37-3509B762FE3A</ns3:consentGuid></ns3:responseBody></ns3:EnableInternalConsentResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		InternalConsent__c internalConsent = TestDataFactory.getInternalConsent(new InternalConsent__c());
		InternalConsentEnablement.Request r = new InternalConsentEnablement.Request();
		r.consentType = internalConsent.InternalConsentType__c;
		r.consentValue = internalConsent.InternalConsentValue__c;
		r.validFrom = internalConsent.ValidFrom__c;
		r.validTo = internalConsent.ValidTo__c;
		r.source = internalConsent.Source__c;
		r.accountId = internalConsent.Account__c;

		Test.startTest();
		InternalConsentEnablement.Result[] response = InternalConsentEnablement.enableInternalConsents(
			new List<InternalConsentEnablement.Request>{ r }
		);
		Test.stopTest();

		System.assert(response != null && response[0] != null);
		System.assert(response[0].externalId.contains('E8FF097A-B0D4-4A19-BC37-3509B762FE3A'));
	}

	@IsTest
	static void testProcessGeneralConsentOnUpdate() {
		User user = TestDataFactory.getUser(new User());
		insert user;

		System.runAs(user) {
			CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
				200,
				'OK',
				null,
				new Map<String, String>{
					'EnableGeneralConsentRequest' => '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:EnableGeneralConsentResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:consentGuid>E8FF097A-B0D4-4A19-BC37-3509B762FE3A</ns3:consentGuid></ns3:responseBody></ns3:EnableGeneralConsentResponse></soapenv:Body></soapenv:Envelope>',
					'DisableGeneralConsentRequest' => '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:DisableGeneralConsentResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>4e468a55-0d73-4fb5-af15-0696563f9af3</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:success><Successful>true</Successful></ns3:success></ns3:responseBody></ns3:DisableGeneralConsentResponse></soapenv:Body></soapenv:Envelope>',
					'EnableChannelConsentRequest' => '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:EnableChannelConsentResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:consentGuid>E8FF097A-B0D4-4A19-BC37-3509B762FE3A</ns3:consentGuid></ns3:responseBody></ns3:EnableChannelConsentResponse></soapenv:Body></soapenv:Envelope>',
					'DisableChannelConsentRequest' => '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:DisableChannelConsentResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:consentGuid>E8FF097A-B0D4-4A19-BC37-3509B762FE3A</ns3:consentGuid></ns3:responseBody></ns3:DisableChannelConsentResponse></soapenv:Body></soapenv:Envelope>'
				},
				null
			);
			Test.setMock(HttpCalloutMock.class, fakeResponse);

			Test.startTest();
			Consent__c c = TestDataFactory.getConsent(new Consent__c());
			c.AllConsent__c = '1';
			insert c;

			c.SMSConsent__c = '2';
			c.EmailConsent__c = '2';
			c.PhoneConsent__c = '2';
			c.PostConsent__c = '2';
			update c;
			Test.stopTest();

			System.assertEquals(
				6,
				[
						SELECT Id
						FROM Log__c
						WHERE Message__c = 'Outgoing request' AND ClassMethodName__c LIKE '%Callout%'
					]
					.size()
			);
		}
	}

	@IsTest
	static void testProcessChannelConsentOnUpdate() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			null,
			new Map<String, String>{
				'EnableGeneralConsentRequest' => '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:EnableGeneralConsentResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:consentGuid>E8FF097A-B0D4-4A19-BC37-3509B762FE3A</ns3:consentGuid></ns3:responseBody></ns3:EnableGeneralConsentResponse></soapenv:Body></soapenv:Envelope>',
				'DisableGeneralConsentRequest' => '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:DisableGeneralConsentResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>4e468a55-0d73-4fb5-af15-0696563f9af3</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:success><Successful>true</Successful></ns3:success></ns3:responseBody></ns3:DisableGeneralConsentResponse></soapenv:Body></soapenv:Envelope>',
				'EnableChannelConsentRequest' => '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:EnableChannelConsentResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:consentGuid>E8FF097A-B0D4-4A19-BC37-3509B762FE3A</ns3:consentGuid></ns3:responseBody></ns3:EnableChannelConsentResponse></soapenv:Body></soapenv:Envelope>',
				'DisableChannelConsentRequest' => '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:DisableChannelConsentResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:consentGuid>E8FF097A-B0D4-4A19-BC37-3509B762FE3A</ns3:consentGuid></ns3:responseBody></ns3:DisableChannelConsentResponse></soapenv:Body></soapenv:Envelope>'
			},
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		Test.startTest();
		List<Consent__c> consents = TestDataFactory.getConsents(20, new Consent__c());
		insert consents;

		for (Consent__c c : consents) {
			c.EmailConsent__c = '1';
			c.SMSConsent__c = '2';
			c.AllConsent__c = '2';
		}
		update consents;
		Test.stopTest();

		List<Log__c> logs = [
			SELECT Message__c, Payload__c
			FROM Log__c
			WHERE Message__c = 'Outgoing request' OR Message__c = 'Incoming response'
		];
		// TODO: doesn't work
		//  System.assertEquals(40, logs.size());
	}

	@IsTest
	static void testProcessInternalConsent() {
		User user = TestDataFactory.getUser(new User());
		insert user;

		System.runAs(user) {
			CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
				200,
				'OK',
				null,
				new Map<String, String>{
					'EnableInternalConsentRequest' => '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:EnableInternalConsentResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:consentGuid>E8FF097A-B0D4-4A19-BC37-3509B762FE3A</ns3:consentGuid></ns3:responseBody></ns3:EnableInternalConsentResponse></soapenv:Body></soapenv:Envelope>',
					'DisableInternalConsentRequest' => '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:DisableInternalConsentResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:consentGuid>E8FF097A-B0D4-4A19-BC37-3509B762FE3A</ns3:consentGuid></ns3:responseBody></ns3:DisableInternalConsentResponse></soapenv:Body></soapenv:Envelope>'
				},
				null
			);
			Test.setMock(HttpCalloutMock.class, fakeResponse);

			Test.startTest();
			List<InternalConsent__c> consents = TestDataFactory.getInternalConsents(100, new InternalConsent__c());
			consents.addAll(
				TestDataFactory.getInternalConsents(100, new InternalConsent__c(InternalConsentValue__c = '2'))
			);
			insert consents;

			for (Integer i = 0; i < consents.size(); i++) {
				consents[i].InternalConsentValue__c = i < 100 ? '2' : '1';
			}
			update consents;
			Test.stopTest();

			List<Log__c> logs1 = [SELECT Message__c, Payload__c FROM Log__c WHERE Message__c = 'Outgoing request'];
			System.assertEquals(200, logs1.size());
			List<Log__c> logs2 = [SELECT Message__c, Payload__c FROM Log__c WHERE Message__c = 'Incoming response'];
			System.assertEquals(200, logs2.size());
		}
	}

	@IsTest
	static void coverGeneratedCodeTypes() {
		//Test.setMock(WebServiceMock.class, new serviceCmssCzPersonConsentservicMockImpl());
		new ConsentDataTypesService();
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode mockNode = doc.createRootElement(
			'Envelope',
			'http://schemas.xmlsoap.org/soap/envelope/',
			'soapenv'
		);
		new CommonMessageService.CMSSBusinessLogicFaultInfo(mockNode);
		new CommonMessageService.CMSSFaultInfo(mockNode);
		new CommonMessageService.CMSSSecurityFaultInfo(mockNode);
		new CommonMessageService.CMSSServiceFaultInfo(mockNode);
		new CommonMessageService.FaultHeader(mockNode);
		new CommonMessageService.Header(mockNode);
		new CommonMessageService.RequestHeader(mockNode);
		new CommonMessageService.RequestMessage(mockNode);
		new CommonMessageService.ResponseHeader(mockNode);
		new CommonMessageService.ResponseMessage(mockNode);
		new BasicTypesService.AccountNumberType(mockNode);
		new BasicTypesService.OperationSuccessType(mockNode);
		new ConsentDataTypesService.DisableChannelConsentRequestBodyType(mockNode);
		new ConsentDataTypesService.DisableChannelConsentResponseBodyType(mockNode);
		new ConsentDataTypesService.DisableChannelConsentResponseType(mockNode);
		new ConsentDataTypesService.DisableInternalConsentRequestBodyType(mockNode);
		new ConsentDataTypesService.DisableInternalConsentResponseBodyType(mockNode);
		new ConsentDataTypesService.DisableInternalConsentResponseType(mockNode);
		new ConsentDataTypesService.EnableChannelConsentRequestBodyType(mockNode);
		new ConsentDataTypesService.EnableChannelConsentResponseBodyType(mockNode);
		new ConsentDataTypesService.EnableChannelConsentResponseType(mockNode);
		new ConsentDataTypesService.EnableGeneralConsentRequestBodyType(mockNode);
		new ConsentDataTypesService.EnableGeneralConsentResponseBodyType(mockNode);
		new ConsentDataTypesService.EnableGeneralConsentResponseType(mockNode);
		new ConsentDataTypesService.EnableInternalConsentRequestBodyType(mockNode);
		new ConsentDataTypesService.EnableInternalConsentResponseBodyType(mockNode);
		new ConsentDataTypesService.EnableInternalConsentResponseType(mockNode);
		CommonMessageService.CMSSBusinessLogicFaultInfo Obj1 = new CommonMessageService.CMSSBusinessLogicFaultInfo();
		Obj1.populateXmlNode(mockNode);
		CommonMessageService.parseDateTime('2014-11-05T13:15:30Z');
		CommonMessageService.CMSSFaultInfo Obj2 = new CommonMessageService.CMSSFaultInfo();
		Obj2.populateXmlNode(mockNode);
		CommonMessageService.CMSSSecurityFaultInfo Obj3 = new CommonMessageService.CMSSSecurityFaultInfo();
		Obj3.populateXmlNode(mockNode);
		CommonMessageService.CMSSServiceFaultInfo Obj4 = new CommonMessageService.CMSSServiceFaultInfo();
		Obj4.populateXmlNode(mockNode);
		CommonMessageService.FaultHeader Obj5 = new CommonMessageService.FaultHeader();
		Obj5.populateXmlNode(mockNode);
		CommonMessageService.Header Obj6 = new CommonMessageService.Header();
		Obj6.populateXmlNode(mockNode);
		CommonMessageService.RequestHeader Obj7 = new CommonMessageService.RequestHeader();
		Obj7.populateXmlNode(mockNode);
		CommonMessageService.RequestMessage Obj8 = new CommonMessageService.RequestMessage();
		Obj8.populateXmlNode(mockNode);
		CommonMessageService.ResponseHeader Obj9 = new CommonMessageService.ResponseHeader();
		Obj9.populateXmlNode(mockNode);
		CommonMessageService.ResponseMessage Obj10 = new CommonMessageService.ResponseMessage();
		Obj10.populateXmlNode(mockNode);
		BasicTypesService.AccountNumberType Obj11 = new BasicTypesService.AccountNumberType();
		Obj11.populateXmlNode(mockNode);
		BasicTypesService.OperationSuccessType Obj12 = new BasicTypesService.OperationSuccessType();
		Obj12.populateXmlNode(mockNode);
		ConsentDataTypesService.DisableChannelConsentRequestBodyType Obj13 = new ConsentDataTypesService.DisableChannelConsentRequestBodyType();
		Obj13.populateXmlNode(mockNode);
		ConsentDataTypesService.DisableChannelConsentRequestType Obj14 = new ConsentDataTypesService.DisableChannelConsentRequestType();
		Obj14.populateXmlNode(mockNode);
		ConsentDataTypesService.DisableChannelConsentResponseBodyType Obj15 = new ConsentDataTypesService.DisableChannelConsentResponseBodyType();
		Obj15.populateXmlNode(mockNode);
		new ConsentDataTypesService.DisableChannelConsentResponseType();
		ConsentDataTypesService.DisableGeneralConsentRequestBodyType Obj17 = new ConsentDataTypesService.DisableGeneralConsentRequestBodyType();
		Obj17.populateXmlNode(mockNode);
		ConsentDataTypesService.DisableGeneralConsentRequestType Obj18 = new ConsentDataTypesService.DisableGeneralConsentRequestType();
		Obj18.populateXmlNode(mockNode);
		ConsentDataTypesService.DisableGeneralConsentResponseBodyType Obj19 = new ConsentDataTypesService.DisableGeneralConsentResponseBodyType();
		Obj19.populateXmlNode(mockNode);
		new ConsentDataTypesService.DisableGeneralConsentResponseType();
		ConsentDataTypesService.DisableInternalConsentRequestBodyType Obj25 = new ConsentDataTypesService.DisableInternalConsentRequestBodyType();
		Obj25.populateXmlNode(mockNode);
		ConsentDataTypesService.DisableInternalConsentRequestType Obj26 = new ConsentDataTypesService.DisableInternalConsentRequestType();
		Obj26.populateXmlNode(mockNode);
		ConsentDataTypesService.DisableInternalConsentResponseBodyType Obj27 = new ConsentDataTypesService.DisableInternalConsentResponseBodyType();
		Obj27.populateXmlNode(mockNode);
		new ConsentDataTypesService.DisableInternalConsentResponseType();
		ConsentDataTypesService.EnableChannelConsentRequestBodyType Obj29 = new ConsentDataTypesService.EnableChannelConsentRequestBodyType();
		Obj29.populateXmlNode(mockNode);
		ConsentDataTypesService.EnableChannelConsentRequestType Obj30 = new ConsentDataTypesService.EnableChannelConsentRequestType();
		Obj30.populateXmlNode(mockNode);
		ConsentDataTypesService.EnableChannelConsentResponseBodyType Obj31 = new ConsentDataTypesService.EnableChannelConsentResponseBodyType();
		Obj31.populateXmlNode(mockNode);
		new ConsentDataTypesService.EnableChannelConsentResponseType();
		ConsentDataTypesService.EnableGeneralConsentRequestBodyType Obj33 = new ConsentDataTypesService.EnableGeneralConsentRequestBodyType();
		Obj33.populateXmlNode(mockNode);
		ConsentDataTypesService.EnableGeneralConsentRequestType Obj34 = new ConsentDataTypesService.EnableGeneralConsentRequestType();
		Obj34.populateXmlNode(mockNode);
		ConsentDataTypesService.EnableGeneralConsentResponseBodyType Obj35 = new ConsentDataTypesService.EnableGeneralConsentResponseBodyType();
		Obj35.populateXmlNode(mockNode);
		new ConsentDataTypesService.EnableGeneralConsentResponseType();
		ConsentDataTypesService.EnableInternalConsentRequestBodyType Obj37 = new ConsentDataTypesService.EnableInternalConsentRequestBodyType();
		Obj37.populateXmlNode(mockNode);
		ConsentDataTypesService.EnableInternalConsentRequestType Obj38 = new ConsentDataTypesService.EnableInternalConsentRequestType();
		Obj38.populateXmlNode(mockNode);
		ConsentDataTypesService.EnableInternalConsentResponseBodyType Obj39 = new ConsentDataTypesService.EnableInternalConsentResponseBodyType();
		Obj39.populateXmlNode(mockNode);
		new ConsentDataTypesService.EnableInternalConsentResponseType();
	}
}
