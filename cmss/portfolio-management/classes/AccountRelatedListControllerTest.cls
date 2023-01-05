@IsTest
private class AccountRelatedListControllerTest {
	@TestSetup
	static void insertCustomSettings() {
		insert TestDataFactory.getIntegrationSettings();
	}

	@IsTest
	static void testGetAccounts() {
		User u = TestDataFactory.getUser(new User());
		insert u;

		insert TestDataFactory.getAccount(
			new Account(PortfolioMngmtA__c = u.Id, City__c = 'Praha', BillingPostalCode = '12345')
		);
		AccountRelatedListController.AccountInfo ai = AccountRelatedListController.getAccounts(
			u.Id,
			'A',
			'Praha',
			'%34%',
			50,
			0
		);
		System.assertEquals(1, ai.accountCount);
		System.assertEquals(1, ai.accounts.size());
		System.assertEquals('Praha', ai.accounts[0].City__c);
		System.assertEquals('12345', ai.accounts[0].BillingPostalCode);

		ai = AccountRelatedListController.getAccounts(u.Id, 'A', '%Brno%', null, 50, 0);
		System.assertEquals(0, ai.accountCount);
		System.assertEquals(0, ai.accounts.size());
	}

	@IsTest
	static void testGetUserId() {
		User u = TestDataFactory.getUser(new User(CommissionAccountBase__c = 'CommAccNr1'));
		insert u;

		System.assertEquals(u.Id, AccountRelatedListController.getUserId('CommAccNr1'));
		System.assertNotEquals(u.Id, AccountRelatedListController.getUserId(null));
	}

	@IsTest
	static void testCreatePortManRequests() {
		User u = TestDataFactory.getUser(new User(CommissionAccountBase__c = 'CommAccNr1', IsAgentActive__c = true));
		User u2 = TestDataFactory.getUser(new User(CommissionAccountBase__c = 'CommAccNr2', IsAgentActive__c = true));
		insert new List<User>{ u, u2 };

		Account[] accs = new List<Account>{
			TestDataFactory.getAccount(new Account(PortfolioMngmtA__c = u.Id)),
			TestDataFactory.getAccount(new Account(PortfolioMngmtA__c = u2.Id))
		};
		insert accs;

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns3:ChangeCPEClientStateResponse xmlns:ns3="http://service.cmss.cz/person/ConsentService/v01/datatypes" xmlns:ns2="http://service.cmss.cz/common/CommonMessage/v01"><ns2:responseHeader><ns2:conversationIdName></ns2:conversationIdName><ns2:conversationIdValue></ns2:conversationIdValue><ns2:correlationId></ns2:correlationId><ns2:messageId>db8f5bd1-a149-4971-bf1f-57aa87715431</ns2:messageId><ns2:physicalSource>WASTestCell</ns2:physicalSource><ns2:sourceSystem>ESB</ns2:sourceSystem><ns2:targetSystem>20</ns2:targetSystem><ns2:timestamp>2021-01-07T20:54:36.229+01:00</ns2:timestamp><ns2:userId>0053N00000452gpQAA</ns2:userId></ns2:responseHeader><ns3:responseBody><ns3:emptyElement></ns3:emptyElement></ns3:responseBody></ns3:ChangeCPEClientStateResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		Test.startTest();
		PortfolioManagementRequest__c pmr = TestDataFactory.getPortfolioManagementRequest(
			new PortfolioManagementRequest__c(
				PortfolioManagerCPU__c = 'CommAccNr1',
				PortfolioManager__c = u.Id,
				ValidFrom__c = System.now().addDays(1)
			)
		);
		AccountRelatedListController.createPortManRequestsForUsersClients(pmr, u2.Id, 'A');

		PortfolioManagementRequest__c[] pmrs = [SELECT PortfolioManager__c FROM PortfolioManagementRequest__c];
		System.assertEquals(1, pmrs.size());

		PortfolioManagementRequest__c pmr2 = TestDataFactory.getPortfolioManagementRequest(
			new PortfolioManagementRequest__c(
				PortfolioManagerCPU__c = 'CommAccNr2',
				PortfolioManager__c = u2.Id,
				ValidFrom__c = System.now().addDays(1)
			)
		);
		AccountRelatedListController.createPortManRequests(pmr2, new List<String>{ accs[0].Id, accs[1].Id });

		pmrs = [
			SELECT PortfolioManager__c
			FROM PortfolioManagementRequest__c
			WHERE PortfolioManagerCPU__c = 'CommAccNr2'
		];
		System.assertEquals(2, pmrs.size());
		Test.stopTest();
	}
}
