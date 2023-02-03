@IsTest
public class AccountMassUpdateBatchTest {
    @IsTest
    public static void runTest() {
        Account acc1 = TestDataFactory.getPersonAccount(new Account(Alias__c = 'test1', Phone = '123456789', PersonEmail = 'test@test.com'));
        Account acc2 = TestDataFactory.getPersonAccount(new Account(Alias__c = 'test2', Phone = '123456789', PersonEmail = 'test@test.com'));
        List<Account> accountList = new List<Account>{acc1, acc2};
        insert accountList;
        AccountMassUpdateBatch batch = new AccountMassUpdateBatch();
        Test.startTest();
            Id batchId = Database.executeBatch(batch);
            System.assert(batchId != null);
        Test.stopTest();
    }
    @IsTest
    public static void executeTest() {
        Account acc1 = TestDataFactory.getPersonAccount(new Account(Alias__c = 'test1', Phone = '123456789', PersonEmail = 'test@test.com'));
        Account acc2 = TestDataFactory.getPersonAccount(new Account(Alias__c = 'test2', Phone = '123456789', PersonEmail = 'test@test.com'));
        List<Account> accountList = new List<Account>{acc1, acc2};
        insert accountList; 

        accountList[0].HasEmail__c = null;
        accountList[1].HasEmail__c = null;
        accountList[0].HasPhone__c = null;
        accountList[1].HasPhone__c = null;

        AccountMassUpdateBatch batch = new AccountMassUpdateBatch();
        Test.startTest();
            batch.execute(null, accountList);
        Test.stopTest();

        accountList = [SELECT Id, HasPhone__c, HasEmail__c FROM Account];
        System.assert(accountList[0].HasPhone__c != null);
        System.assert(accountList[0].HasEmail__c != null);
        System.assert(accountList[1].HasPhone__c != null);
        System.assert(accountList[1].HasEmail__c != null);
    }    
}