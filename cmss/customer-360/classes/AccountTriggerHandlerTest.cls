@IsTest
private class AccountTriggerHandlerTest {
	@IsTest
	static void changeOwnerOfInvalidatedAccountsTest() {
		User u = TestDataFactory.getUser(new User());
		insert u;
		CommonSetting__c setting = CommonSetting__c.getOrgDefaults();
		setting.OwnerForHiddenRecords__c = u.Id;
		insert setting;
		Account a1 = TestDataFactory.getAccount(new Account());
		insert a1;
		Account a2 = TestDataFactory.getAccount(new Account());
		Account a3 = TestDataFactory.getAccount(new Account());

		Test.startTest();
		a1.IsInvalid__c = true;
		a2.IsInvalid__c = true;
		AccountTriggerHandler.setOwner(new List<Account>{ a1, a2, a3 });
		Test.stopTest();

		System.assertEquals(u.Id, a1.OwnerId);
		System.assertEquals(u.Id, a2.OwnerId);
		System.assertNotEquals(u.Id, a3.OwnerId);
	}

	@IsTest
	static void setOwnerTest() {
		Id communityRecordType = [
			SELECT Id
			FROM RecordType
			WHERE SobjectType = 'Account' AND Name = 'Community Account'
		]
		.Id;
		User defaultOwner = TestDataFactory.getUser(new User());
		User portfolioManager = TestDataFactory.getUser(new User());
		insert new List<User>{ defaultOwner, portfolioManager };
		CommonSetting__c setting = CommonSetting__c.getOrgDefaults();
		setting.AccountDefaultOwner__c = defaultOwner.Id;
		insert setting;
		Account a1 = TestDataFactory.getAccount(new Account());
		insert a1;
		Account a2 = TestDataFactory.getAccount(new Account());
		Account a3 = TestDataFactory.getAccount(new Account());
		Account a4 = TestDataFactory.getAccount(new Account(recordTypeId = communityRecordType));

		Test.startTest();
		a1.PortfolioMngmtA__c = portfolioManager.Id;
		a2.PortfolioMngmtA__c = portfolioManager.Id;
		AccountTriggerHandler.setOwner(new List<Account>{ a1, a2, a3, a4 });
		Test.stopTest();

		System.assertEquals(portfolioManager.Id, a1.OwnerId);
		System.assertEquals(portfolioManager.Id, a2.OwnerId);
		System.assertEquals(defaultOwner.Id, a3.OwnerId);
		System.assertEquals(null, a4.OwnerId);
	}

	@IsTest
	static void setLastPortfolioManagerTest() {
		User testPm1 = TestDataFactory.getUser(new User());
		User testPm2 = TestDataFactory.getUser(new User());
		insert new List<User>{ testPm1, testPm2 };

		Account testAccount1 = TestDataFactory.getPersonAccount(new Account(PortfolioMngmtA__c = testPm1.Id));
		Account testAccount2 = TestDataFactory.getPersonAccount(new Account(PortfolioMngmtA__c = testPm1.Id));
		insert new List<Account>{ testAccount1, testAccount2 };

		Account testAccount2Modified = testAccount2.clone(true, true, true, true);
		testAccount2Modified.PortfolioMngmtA__c = testPm2.Id;

		Map<Id, Account> oldAccountsMap = new Map<Id, Account>(new List<Account>{ testAccount1, testAccount2 });
		List<Account> newAccounts = new List<Account>{ testAccount1, testAccount2Modified };
		AccountTriggerHandler.setLastPortfolioManager(oldAccountsMap, newAccounts);

		System.assertEquals(null, testAccount1.LastPortfolioManagerA__c);
		System.assertEquals(null, testAccount1.LastPtfManAChangeDate__c);
		System.assertEquals(testPm1.Id, testAccount2Modified.LastPortfolioManagerA__c);
		System.assertEquals(System.today(), testAccount2Modified.LastPtfManAChangeDate__c);
	}

	@IsTest
	static void invalidateAccountTest() {
		Datetime myDateTime = Datetime.newInstance(2006, 3, 16, 12, 6, 13);
		Account a1 = TestDataFactory.getAccount(new Account(DateOfDeletion__c = myDateTime));
		Account a2 = TestDataFactory.getAccount(new Account(AccountStatus__c = '4'));
		Account a3 = TestDataFactory.getAccount(new Account(AccountStatus__c = '5'));
		Account a4 = TestDataFactory.getAccount(new Account());

		Test.startTest();
		AccountTriggerHandler.invalidateAccount(new List<Account>{ a1, a2, a3, a4 });
		Test.stopTest();

		System.assertEquals(true, a1.IsInvalid__c);
		System.assertEquals(false, a2.IsInvalid__c);
		System.assertEquals(true, a3.IsInvalid__c);
		System.assertEquals(false, a4.IsInvalid__c);
	}

	@IsTest
	static void validateAccountTest() {
		Datetime myDateTime = Datetime.newInstance(2006, 3, 16, 12, 6, 13);
		Account a1 = TestDataFactory.getAccount(
			new Account(DateOfDeletion__c = myDateTime, IsInvalid__c = true, AccountStatus__c = '5')
		);
		Account a2 = TestDataFactory.getAccount(new Account(AccountStatus__c = '3', IsInvalid__c = true));
		Account a3 = TestDataFactory.getAccount(new Account(AccountStatus__c = '5', IsInvalid__c = true));

		Test.startTest();
		AccountTriggerHandler.validateAccount(new List<Account>{ a1, a2, a3 });
		Test.stopTest();

		System.assertEquals(true, a1.IsInvalid__c);
		System.assertEquals(false, a2.IsInvalid__c);
		System.assertEquals(true, a3.IsInvalid__c);
	}
}
