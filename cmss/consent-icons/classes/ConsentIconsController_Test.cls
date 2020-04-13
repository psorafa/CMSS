/**
 * Created by a.kovacova on 4/8/2020.
 */

@IsTest
private class ConsentIconsController_Test {
	static Account accWithConsent;
	static Account accNoConsent;
	static Consent__c consent1;
	static Consent__c consent2;

	static void testSetup() {
		accWithConsent = new Account(FirstName = 'Filip', LastName = 'Fiala',
                RecordTypeId = RecordTypeUtils.getRecordTypeIdByDeveloperName('PersonAccount', 'Account'),
                AccountStatus__c = '1');
		accNoConsent = new Account(Name = 'Testujem s.r.o.',
                RecordTypeId = RecordTypeUtils.getRecordTypeIdByDeveloperName('Business_Account', 'Account'),
                AccountStatus__c = '1');
		insert new List<Account>{
				accNoConsent, accWithConsent
		};
		consent1 = new Consent__c(GeneralConsent__c = '1', GeneralConsentVersion__c = '3', Account__c = accWithConsent.Id, EmailConsent__c = '1',
				EntityConsent__c = '8', SMSConsent__c = '2', PortalConsent__c = '2', PhoneConsent__c = '2', PostConsent__c = '2');
		consent2 = new Consent__c(GeneralConsent__c = '1', GeneralConsentVersion__c = '3', Account__c = accWithConsent.Id, EmailConsent__c = '1',
				EntityConsent__c = '999', SMSConsent__c = '1', PortalConsent__c = '1', PhoneConsent__c = '1', PostConsent__c = '1');
		insert new List<Consent__c>{
				consent1, consent2
		};
	}

	@IsTest
	static void testFindConsentNoConsent() {
		testSetup();
		Consent__c foundConsent;
		Test.startTest();
		foundConsent = ConsentIconsController.findConsent(accNoConsent.Id);
		Test.stopTest();
		System.assertEquals(null, foundConsent, 'The result of findConsent should be null.');
	}

    @IsTest
	static void testFindConsentWithResult1() {
		testSetup();
		Consent__c foundConsent;
        Test.setCreatedDate(consent1.Id, Datetime.now());
        Test.setCreatedDate(consent2.Id, Datetime.now().addDays(-5));
		Test.startTest();
		foundConsent = ConsentIconsController.findConsent(accWithConsent.Id);
		Test.stopTest();
		System.assertEquals(consent1.Id, foundConsent.Id, 'The result of findConsent should be consent1.');
	}

    @IsTest
	static void testFindConsentWithResult2() {
		testSetup();
		Consent__c foundConsent;
        Test.setCreatedDate(consent1.Id, Datetime.now().addDays(-5));
        Test.setCreatedDate(consent2.Id, Datetime.now());
		Test.startTest();
		foundConsent = ConsentIconsController.findConsent(accWithConsent.Id);
		Test.stopTest();
		System.assertEquals(consent2.Id, foundConsent.Id, 'The result of findConsent should be consent2.');
	}

    @IsTest
	static void testFindConsentInvalidInput() {
		testSetup();
		Consent__c foundConsent;
		Test.startTest();
		foundConsent = ConsentIconsController.findConsent(null);
		Test.stopTest();
		System.assertEquals(null, foundConsent, 'The result of findConsent should be null.');
	}
}