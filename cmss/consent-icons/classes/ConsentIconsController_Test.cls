/**
 * Created by a.olexova on 4/8/2020.
 */

@IsTest
private class ConsentIconsController_Test {
	static Account accWithConsent;
	static Account accNoConsent;
	static Consent__c consent1;
	static Consent__c consent2;

	static void testSetup() {
        CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
            200,
            'OK',
            '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:EnableGeneralConsentResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:consentGuid>E8FF097A-B0D4-4A19-BC37-3509B762FE3A</ns3:consentGuid></ns3:responseBody></ns3:EnableGeneralConsentResponse></soapenv:Body></soapenv:Envelope>',
            null,
            null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);

		accWithConsent = TestDataFactory.getPersonAccount(new Account(
			FirstName = 'Filip',
			LastName = 'Fiala',
			RecordTypeId = RecordTypeUtils.getRecordTypeIdByDeveloperName('PersonAccount', 'Account'),
			AccountStatus__c = '1'
		));
		accNoConsent = TestDataFactory.getAccount(new Account(
			Name = 'Testujem s.r.o.',
			RecordTypeId = RecordTypeUtils.getRecordTypeIdByDeveloperName('Business_Account', 'Account'),
			AccountStatus__c = '1'
		));
        insert new List<Account>{ accNoConsent, accWithConsent };
        
		consent1 = TestDataFactory.getConsent(new Consent__c(
			GeneralConsent__c = '1',
			GeneralConsentVersion__c = '3',
			Account__c = accWithConsent.Id,
			EmailConsent__c = '1',
			EntityConsent__c = '8',
			SMSConsent__c = '2',
			PortalConsent__c = '2',
			PhoneConsent__c = '2',
			PostConsent__c = '2'
		));
		consent2 = TestDataFactory.getConsent(new Consent__c(
			GeneralConsent__c = '1',
			GeneralConsentVersion__c = '3',
			Account__c = accWithConsent.Id,
			EmailConsent__c = '1',
			EntityConsent__c = '999',
			SMSConsent__c = '1',
			PortalConsent__c = '1',
			PhoneConsent__c = '1',
			PostConsent__c = '1'
		));
		insert new List<Consent__c>{ consent1, consent2 };
	}

	@IsTest
	static void testGetConsentForAccountNoConsent() {
		testSetup();
		Consent__c foundConsent;
		Test.startTest();
		foundConsent = ConsentIconsController.getConsentForAccount(accNoConsent.Id);
		Test.stopTest();
		System.assertEquals(
			new Consent__c(),
			foundConsent,
			'The result of getConsentForAccount should be empty Consent__c.'
		);
	}

	@IsTest
	static void testGetConsentForAccountWithResult1() {
		testSetup();
		Consent__c foundConsent;
		Test.setCreatedDate(consent1.Id, Datetime.now());
		Test.setCreatedDate(consent2.Id, Datetime.now().addDays(-5));
		Test.startTest();
		foundConsent = ConsentIconsController.getConsentForAccount(accWithConsent.Id);
		Test.stopTest();
		System.assertEquals(consent1.Id, foundConsent.Id, 'The result of getConsentForAccount should be consent1.');
	}

	@IsTest
	static void testGetConsentForAccountWithResult2() {
		testSetup();
		Consent__c foundConsent;
		Test.setCreatedDate(consent1.Id, Datetime.now().addDays(-5));
		Test.setCreatedDate(consent2.Id, Datetime.now());
		Test.startTest();
		foundConsent = ConsentIconsController.getConsentForAccount(accWithConsent.Id);
		Test.stopTest();
		System.assertEquals(consent2.Id, foundConsent.Id, 'The result of getConsentForAccount should be consent2.');
	}

	@IsTest
	static void testGetConsentForAccountNullInput() {
		testSetup();
		Consent__c foundConsent;
		String message;
		String errorType;
		Test.startTest();
		try {
			foundConsent = ConsentIconsController.getConsentForAccount(null);
		} catch (Exception e) {
			message = e.getMessage();
			errorType = e.getTypeName();
		} finally {
			System.assert(String.isNotBlank(message), 'Error message should not be blank.');
			System.assert(String.isNotBlank(errorType), 'Error type should not be blank.');
			System.assertEquals('Missing parameter: accountId.', message, 'Error Message not as expected.');
			System.assertEquals('System.AuraHandledException', errorType, 'Error Type not as expected.');
		}
		Test.stopTest();
	}

	@IsTest
	static void testGetConsentForAccountInvalidInput() {
		testSetup();
		Consent__c foundConsent;
		Test.startTest();
		foundConsent = ConsentIconsController.getConsentForAccount(consent1.Id);
		Test.stopTest();
		System.assertEquals(
			new Consent__c(),
			foundConsent,
			'The result of getConsentForAccount should be empty Consent__c.'
		);
	}

	@IsTest
	static void testGetConsentForAccountQueryException() {
		testSetup();
		Profile standardUserProfile = [
			SELECT Id
			FROM Profile
			WHERE Name = 'Standard User' OR Name = 'Standardní uživatel'
			LIMIT 1
		];
		User uNoAccessToQueriedObject = new User(
			FirstName = 'Uzivatel',
			LastName = 'Testovaci',
			ProfileId = standardUserProfile.Id,
			Email = 'test@user.test',
			Username = 'test@user.test.consentIconController',
			Alias = 'UTest',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'cs_CZ',
			TimeZoneSidKey = 'Europe/Prague',
			EmailEncodingKey = 'UTF-8'
		);
		insert uNoAccessToQueriedObject;
		System.runAs(uNoAccessToQueriedObject) {
			Consent__c foundConsent;
			String message;
			String errorType;
			Test.startTest();
			try {
				foundConsent = ConsentIconsController.getConsentForAccount(accWithConsent.Id);
			} catch (Exception e) {
				message = e.getMessage();
				errorType = e.getTypeName();
			} finally {
				System.assert(String.isNotBlank(message), 'Error message should not be blank.');
				System.assert(String.isNotBlank(errorType), 'Error type should not be blank.');
                System.assert(message.startsWithIgnoreCase('System.QueryException:'), 'Error Message not as expected: ' + message);
                System.assertEquals('System.AuraHandledException', errorType, 'Error Type not as expected.');

			}
			Test.stopTest();
		}
	}
}
