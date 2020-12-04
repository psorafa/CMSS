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
		User defaultOwner = TestDataFactory.getUser(new User());
		User portfolioManager = TestDataFactory.getUser(new User());
		insert new List<User> {
			defaultOwner, portfolioManager
		};
		CommonSetting__c setting = CommonSetting__c.getOrgDefaults();
		setting.AccountDefaultOwner__c = defaultOwner.Id;
		insert setting;
		Account a1 = TestDataFactory.getAccount(new Account());
		insert a1;
		Account a2 = TestDataFactory.getAccount(new Account());
		Account a3 = TestDataFactory.getAccount(new Account());

		Test.startTest();
		a1.PortfolioMngmtA__c = portfolioManager.Id;
		a2.PortfolioMngmtA__c = portfolioManager.Id;
		AccountTriggerHandler.setOwner(new List<Account>{ a1, a2, a3 });
		Test.stopTest();

		System.assertEquals(portfolioManager.Id, a1.OwnerId);
		System.assertEquals(portfolioManager.Id, a2.OwnerId);
		System.assertEquals(defaultOwner.Id, a3.OwnerId);
	}

	@IsTest
	static void inavlidateAccountTest() {
		Datetime myDateTime = Datetime.newInstance(2006, 3, 16, 12, 6, 13);
		Account a1 = TestDataFactory.getAccount(new Account(DateOfDeletion__c = myDateTime));
		Account a2 = TestDataFactory.getAccount(new Account(AccountStatus__c = '4'));
		Account a3 = TestDataFactory.getAccount(new Account(AccountStatus__c = '5'));
		Account a4 = TestDataFactory.getAccount(new Account());

		Test.startTest();
		AccountTriggerHandler.invalidateAccount(new List<Account>{ a1, a2, a3, a4 });
		Test.stopTest();

		System.assertEquals(true, a1.IsInvalid__c);
		System.assertEquals(true, a2.IsInvalid__c);
		System.assertEquals(true, a3.IsInvalid__c);
		System.assertEquals(false, a4.IsInvalid__c);
	}
}
