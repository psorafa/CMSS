@isTest
public class LoggerCleanUpScheduleTest {
	@isTest
	static void testExecute() {
		String CRON_EXP = '0 0 0 3 9 ? ' + String.valueOf(Date.today().year() + 5);
		Test.startTest();
		String jobId = System.schedule('LoggerCleanUpScheduleTest', CRON_EXP, new LoggerCleanUpSchedule());
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
		System.assertEquals(0, ct.TimesTriggered);
		System.assert(String.valueOf(ct.NextFireTime).contains('-09-03 00:00:00'));
		Test.stopTest();
	}

	@isTest
	static void testScheduleMe() {
		Test.startTest();
		String jobId = LoggerCleanUpSchedule.scheduleMe();
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
		System.assertEquals(0, ct.TimesTriggered);
		Test.stopTest();
	}

	@isTest
	static void testScheduleMeWithNullParam() {
		Test.startTest();
		String jobId = LoggerCleanUpSchedule.scheduleMe(null);
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
		System.assertEquals(0, ct.TimesTriggered);
		Test.stopTest();
	}
}
