@IsTest
public class UpdateLastLoginDateOnUser_BatchTest {
@IsTest
    static void UpdateUser() {
        User user = TestDataFactory.getUser(new User(
            LastName = 'Testovic',
			ProfileId =  [SELECT Id FROM Profile WHERE Name = 'SuperAdmin'].Id,
            LastLoginDate__c = Datetime.now().addDays(-3)
		));
        insert user;
        UpdateLastLoginDateOnUser_Batch batch = new UpdateLastLoginDateOnUser_Batch();
        
        Test.startTest();
		Database.executeBatch(batch);
		Test.stopTest();
        
        User users = [SELECT Id,LastLoginDate__c,LastLoginDate FROM User WHERE LastName = 'Testovic' LIMIT 1];
		System.assertEquals(users.LastLoginDate, users.LastLoginDate__c);
    }
}