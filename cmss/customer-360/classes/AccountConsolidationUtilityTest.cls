@IsTest
private class AccountConsolidationUtilityTest {

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
		AccountConsolidationUtility.changeOwnerOfInvalidatedAccounts(new List<Account>{
			a1, a2, a3
		});
		Test.stopTest();

		System.assertEquals(u.Id, a1.OwnerId);
		System.assertEquals(u.Id, a2.OwnerId);
		System.assertNotEquals(u.Id, a3.OwnerId);
	}
}