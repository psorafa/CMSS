@IsTest
public class MailServiceNotificationsQueueTest {
	@TestSetup
	static void prepareData() {
		insert TestDataFactory.getIntegrationSettings();
	}
	@IsTest
	static void testSuccessResult() {
		DateTime currentTime = System.now();
		MailServiceNotification__c mail1 = new MailServiceNotification__c();
		mail1.FromEmailAddress__c = 'noreply@csobstavebni.cz';
		mail1.ToEmailAddress__c = 'noreply@csobstavebni.cz';
		mail1.Subject__c = 'subject of mail1';
		mail1.Body__c = 'body of mail1';
		mail1.DateSent__c = null;
		mail1.SendAfter__c = Date.newInstance(2022, 1, 9);
		mail1.ErrorMessage__c = null;
		mail1.NotSentDueToError__c = false;
		insert mail1;

		CalloutServiceMockImpl fakeSuccessResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns3:sendEmailResponse xmlns:ns3=\"http://service.cmss.cz/mail\" xmlns:ns2=\"http://service.cmss.cz/datamodel/mailservice/sendemail\" xmlns:ns4=\"http://service.cmss.cz/fault\"></ns3:sendEmailResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeSuccessResponse);
		Test.startTest();
		System.enqueueJob(new MailServiceNotificationsQueue());
		Test.stopTest();
		MailServiceNotification__c newMail1 = [
			SELECT
				FromEmailAddress__c,
				ToEmailAddress__c,
				Subject__c,
				Body__c,
				DateSent__c,
				SendAfter__c,
				NotSentDueToError__c,
				ErrorMessage__c
			FROM MailServiceNotification__c
		];

		System.assertEquals(newMail1.DateSent__c, currentTime);
	}

	@IsTest
	static void testFailedResult() {
		MailServiceNotification__c mail2 = new MailServiceNotification__c();
		mail2.FromEmailAddress__c = 'nothing@csobstavebni.cz';
		mail2.ToEmailAddress__c = 'nothing@csobstavebni.cz';
		mail2.Subject__c = 'subject of mail2';
		mail2.Body__c = 'body of mail2';
		mail2.DateSent__c = null;
		mail2.SendAfter__c = Date.newInstance(2022, 1, 9);
		mail2.ErrorMessage__c = null;
		mail2.NotSentDueToError__c = false;
		insert mail2;

		CalloutServiceMockImpl fakeFailResponse = new CalloutServiceMockImpl(
			500,
			'Internal Server Error',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><soapenv:Fault xmlns:axis2ns227=\"http://schemas.xmlsoap.org/soap/envelope/\"><faultcode>axis2ns227:Server</faultcode><faultstring>Internal Error</faultstring><detail></detail></soapenv:Fault></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeFailResponse);
		Test.startTest();
		System.enqueueJob(new MailServiceNotificationsQueue());
		Test.stopTest();
		MailServiceNotification__c newMail2 = [
			SELECT
				FromEmailAddress__c,
				ToEmailAddress__c,
				Subject__c,
				Body__c,
				DateSent__c,
				SendAfter__c,
				NotSentDueToError__c,
				ErrorMessage__c
			FROM MailServiceNotification__c
		];
		System.assertEquals(newMail2.ErrorMessage__c, 'Internal Server Error');
		System.assertEquals(newMail2.NotSentDueToError__c, true);
	}
}
