@IsTest
public class SendNotificationHandlerTest {
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

	@IsTest
	static void testHandler() {
		Test.setMock(HttpCalloutMock.class, new MailSOAPServiceHttpMock());
		insert TestDataFactory.getIntegrationSettings();

		RecordType personAccountRecordType = [
			SELECT Id
			FROM RecordType
			WHERE Name = 'Person Account' AND SObjectType = 'Account'
		];

		Account account = new Account();
		account.RecordType = personAccountRecordType;
		account.FirstName = 'Karel';
		account.LastName = 'Novák';
		insert account;

		Opportunity opportunity = new Opportunity();
		opportunity.Name = 'Test Opportunity';
		opportunity.StageName = 'New';
		opportunity.CloseDate = Date.valueOf(System.now().addDays(5));
		opportunity.Account = account;
		insert opportunity;

		ClientZone__c clientZone = new clientZone__c();
		clientZone.ContractNumber__c = '1234';
		clientZone.Account__c = account.Id;
		insert clientZone;

		SendNotificationHandler handlerWithSpecialVars = new SendNotificationHandler(
			opportunity,
			'UnfinishedContractNotification',
			'mail@test.com',
			new Map<String, String>{
				'DateOfCreation__c' => 'NOW',
				'ORG_URL' => 'some url',
				'ContractNumber__c' => '1234'
			}
		);

		SendNotificationHandler handler = new SendNotificationHandler(
			clientZone,
			'UnsignedContractNotification',
			'mail@test.com'
		);

		Test.startTest();
		handlerWithSpecialVars.handle();
		handler.handle();
		Test.stopTest();

		System.assert(!handlerWithSpecialVars.emailBody.contains('{!'));
		System.assert(handlerWithSpecialVars.emailBody.contains('Karel'));
		System.assert(handlerWithSpecialVars.emailBody.contains('Novák'));
	}

	@IsTest
	static void getTextationTest() {
		User manager = TestDataFactory.getUser(new User(Email = 'managers@email.com'));
		insert manager;

		Account account = TestDataFactory.getPersonAccount(
			new Account(
				PersonEmail = 'karel@something.cz',
				FirstName = 'Pišta',
				LastName = 'Hufnágl',
				PortfolioMngmtA__c = manager.Id
			)
		);
		insert Account;

		account = [
			SELECT FirstName, LastName, PortfolioMngmtA__r.Email
			FROM Account
			WHERE PersonEmail = 'karel@something.cz'
		];

		String textTemplate = 'Proč jen si mě nešťastnou nevzal raději {!FirstName} {!LastName}?!? Managerův email je {!PortfolioMngmtA__r.Email}, to jen tak...';

		String oneRelationVariableResult = SendNotificationHandler.extractValueFromFieldInText(
			'PortfolioMngmtA__r.Email',
			account,
			textTemplate
		);
		String oneVariableResult = SendNotificationHandler.extractValueFromFieldInText(
			'LastName',
			account,
			textTemplate
		);
		String fullResult = SendNotificationHandler.getTextationFromTemplate(
			account,
			textTemplate,
			new Map<String, String>{ 'FirstName' => 'Franta' }
		);

		System.assertEquals(
			'Proč jen si mě nešťastnou nevzal raději {!FirstName} {!LastName}?!? Managerův email je managers@email.com, to jen tak...',
			oneRelationVariableResult
		);
		System.assertEquals(
			'Proč jen si mě nešťastnou nevzal raději {!FirstName} Hufnágl?!? Managerův email je {!PortfolioMngmtA__r.Email}, to jen tak...',
			oneVariableResult
		);
		System.assertEquals(
			'Proč jen si mě nešťastnou nevzal raději Franta Hufnágl?!? Managerův email je managers@email.com, to jen tak...',
			fullResult
		);
	}
}
