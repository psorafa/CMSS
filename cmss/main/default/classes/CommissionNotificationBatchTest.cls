@IsTest
public with sharing class CommissionNotificationBatchTest {
	
    @testSetup
	private static void createTestData() {
		List<Commission__c> comm = new List<Commission__c>{
			new Commission__c(),
			new Commission__c()
		};
		insert comm;
	}

	@IsTest
	static void executeScheduleTest() {
		String CRON_EXP = '0 0 12 * * ?';        
		CommissionNotificationBatch batch = new CommissionNotificationBatch();
        Id jobId;
        Id cjdi;
		Test.startTest();  
        jobId = System.schedule('ScheduledApexTest', CRON_EXP, batch);
		cjdi = [SELECT Id FROM CronJobDetail Where Name = 'ScheduledApexTest' Limit 10][0].Id;                       
		Test.stopTest();
        System.assertEquals(CRON_EXP, [SELECT CronExpression FROM CronTrigger Where CronJobDetailId = :cjdi][0].CronExpression, 'Commission notification batch not scheduled as expected.');
	}    
    
	@IsTest
	static void executeBatchTest() {    
		CommissionNotificationBatch batch = new CommissionNotificationBatch();
        Id jobId;
		Test.startTest();       
		Database.executeBatch(batch);      
		jobId = [SELECT Id FROM AsyncApexJob][0].Id;         
		Test.stopTest();       
        System.assertEquals(0, [SELECT NumberOfErrors FROM AsyncApexJob WHERE Id = :jobId][0].NumberOfErrors, 'Commission notifications not created as expected.');
	}   
}