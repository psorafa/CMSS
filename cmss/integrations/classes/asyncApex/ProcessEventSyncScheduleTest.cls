@isTest
public class ProcessEventSyncScheduleTest {
	@isTest
	static void testExecute() {
		Test.startTest();
		ProcessEventSyncSchedule emptyConstructor = new ProcessEventSyncSchedule();
		ProcessEventSyncSchedule scheduleProcessSyncs = new ProcessEventSyncSchedule(true);
		String cronExpression = '0 0 0 1 * ?';
		System.schedule('Test', cronExpression, scheduleProcessSyncs);
		Test.stopTest();
	}
}
