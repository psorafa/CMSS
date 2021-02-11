@IsTest
private class AccountRelatedListControllerTest {
    
    @IsTest
    static void testGetAccounts() {
        User u = TestDataFactory.getUser(new User());
        insert u;

        insert TestDataFactory.getAccount(new Account(PortfolioMngmtA__c = u.Id));
        AccountRelatedListController.AccountInfo ai = AccountRelatedListController.getAccounts(u.Id, 'A', null, null, 50, 0);
        System.assertEquals(1, ai.accountCount);
        System.assertEquals(1, ai.accounts.size());
        System.assertEquals(u.Id, ai.accounts[0].PortfolioMngmtA__c);

        ai = AccountRelatedListController.getAccounts(u.Id, 'A', 'Brno', null, 50, 0);
        System.assertEquals(0, ai.accountCount);
        System.assertEquals(0, ai.accounts.size());
    }
}
