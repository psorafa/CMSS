@IsTest
public class SendNotificationHandlerTest {
	public class MailServiceMockImpl implements WebServiceMock {
		public void doInvoke(
			Object stub,
			Object request,
			Map<String, Object> response,
			String endpoint,
			String soapAction,
			String requestName,
			String responseNS,
			String responseName,
			String responseType
		) {
			if (request instanceof MailSOAPService.SendEmailType) {
				response.put('response_x', new MailSOAPService.sendEmailResponse_element());
			}
		}
	}

	@IsTest
	static void testHandler() {
		Test.setMock(WebServiceMock.class, new MailServiceMockImpl());
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

		SendNotificationHandler handler = new SendNotificationHandler(
			opportunity,
			'UnfinishedContractNotification',
			'mail@test.com'
		);

		Test.startTest();
		handler.handle();
		Test.stopTest();

		System.assert(!handler.emailBody.contains('{!'));
		System.assert(handler.emailBody.contains('Karel'));
		System.assert(handler.emailBody.contains('Novák'));
	}
}
