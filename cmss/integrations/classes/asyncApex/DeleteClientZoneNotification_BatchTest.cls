@IsTest
public class DeleteClientZoneNotification_BatchTest {
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
	static void prepareTestData() {
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

		Account account2 = new Account();
		account2.RecordType = personAccountRecordType;
		account2.FirstName = 'Mirek';
		account2.LastName = 'Novák';
		insert new List<Account>{ account1, account2 };

		account1.GlobalId__c = account1.GlobalId__c;
		account2.GlobalId__c = account2.GlobalId__c;

		update new List<Account>{ account1, account2 };

		ClientZone__c clientZone1 = new ClientZone__c();
		clientZone1.ClosedBy__c = null;
		clientZone1.Role__c = '7';
		clientZone1.Status__c = '1';
		clientZone1.Account__c = account1.Id;
		clientZone1.CancelationNotificationSentDate__c = null;

		ClientZone__c clientZone2 = new ClientZone__c();
		clientZone2.ClosedBy__c = null;
		clientZone2.Role__c = '7';
		clientZone2.Status__c = '1';
		clientZone2.Account__c = account2.Id;
		clientZone2.CancelationNotificationSentDate__c = System.now().addDays(-35);

		insert new List<ClientZone__c>{ clientZone1, clientZone2 };

		Test.setCreatedDate(clientZone1.ID, System.now().addDays(-16));
		Test.setCreatedDate(clientZone2.ID, System.now().addDays(-50));

		AccountRelation__c accountRelation = new AccountRelation__c();
		accountRelation.AccountRole__c = '1501';
		accountRelation.Account__c = account1.Id;
		accountRelation.RelatedAccount__c = account2.Id;
		insert accountRelation;
	}

	@isTest
	static void testBatchRun() {
		Test.setMock(HttpCalloutMock.class, new MailSOAPServiceHttpMock());
		Test.startTest();
		DeleteClientZoneNotification_Batch batch = new DeleteClientZoneNotification_Batch();
		Id batchId = Database.executeBatch(batch);
		Test.stopTest();
	}
}