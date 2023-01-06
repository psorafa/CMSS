@isTest
public class PMRequestRetryCalloutScheduleTest {
	@isTest
	static void testExecute() {
        String CRON_EXP = '0 0 0 3 9 ? 2030';
        Test.startTest();
            String jobId = System.schedule('PMRRetryTest', CRON_EXP, new PMRequestRetryCalloutSchedule(new Set<Id>(), 'batchId', 0));
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
            System.assertEquals(0, ct.TimesTriggered); 
            System.assertEquals('2030-09-03 00:00:00', String.valueOf(ct.NextFireTime));   
        Test.stopTest();                 
	}
}
