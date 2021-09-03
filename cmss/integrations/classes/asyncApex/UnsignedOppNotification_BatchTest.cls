@isTest
public class UnsignedOppNotification_BatchTest {
	public class MailSOAPServiceHttpMock implements HttpCalloutMock {
		public HTTPResponse respond(HTTPRequest req) {
			HttpResponse res = new HttpResponse();
			res.setHeader('Content-Type', 'application/json');
			DOM.Document responseDoc = new DOM.Document();
			DOM.XmlNode envelope = responseDoc.createRootElement(
				'Envelope',
				'http://schemas.xmlsoap.org/soap/envelope/',
				's'
			);
			DOM.XmlNode bodyNode = envelope.addChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/', null);

			DOM.Document reqDoc = req.getBodyDocument();
			DOM.XmlNode rootNode = reqDoc.getRootElement();
			DOM.XmlNode reqBodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
			DOM.XmlNode[] methodNode = reqBodyNode.getChildElements();
			if (methodNode[0].getName() == 'sendEmail') {
				DOM.XmlNode ResponseNode = bodyNode.addChildElement(
					'sendEmailResponse',
					'http://service.cmss.cz/mail',
					null
				);
			} else if (methodNode[0].getName() == 'sendEmailWithAttachments') {
				DOM.XmlNode ResponseNode = bodyNode.addChildElement(
					'sendEmailWithAttachmentsResponse',
					'http://service.cmss.cz/mail',
					null
				);
			}
			res.setBody(responseDoc.toXmlString());
			res.setStatusCode(200);
			return res;
		}
	}

	@TestSetup
	static void makeDaprepareTestData() {
		RecordType personAccountRecordType = [
			SELECT Id
			FROM RecordType
			WHERE Name = 'Person Account' AND SObjectType = 'Account'
		];

		insert TestDataFactory.getIntegrationSettings();

		Account account1 = new Account();
		account1.RecordType = personAccountRecordType;
		account1.FirstName = 'Karel';
		account1.LastName = 'Novák';
		account1.PersonEmail = 'some@mail.com';
		insert account1;

		Opportunity opportunity = new Opportunity();
		opportunity.Category__c = '7';
		opportunity.StageName = '1';
		opportunity.AccountId = account1.Id;
		opportunity.Name = 'Test opportunity';
		opportunity.CloseDate = Date.valueOf(System.now().addDays(15));
		opportunity.CreatedDateTime__c = Date.valueOf(System.now().addDays(-3));
		insert opportunity;

		ClientZone__c clientZone = new ClientZone__c();
		clientZone.ContractNumber__c = '1234';
		clientZone.Account__c = account1.Id;
		insert clientZone;
	}

	@isTest
	static void testBatchRun() {
		Test.setMock(HttpCalloutMock.class, new MailSOAPServiceHttpMock());
		Test.startTest();
		UnsignedOpportunityNotification_Batch batch = new UnsignedOpportunityNotification_Batch();
		Id batchId = Database.executeBatch(batch);
		Test.stopTest();
	}
}
