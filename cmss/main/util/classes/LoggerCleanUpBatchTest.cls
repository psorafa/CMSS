@IsTest
public class LoggerCleanUpBatchTest {
	@IsTest
	private static void deleteLogsTest() {
		Log__c logDebug = new Log__c(Message__c = 'debugTest', Level__c = 'debug');
		Log__c logError = new Log__c(Message__c = 'errorTest', Level__c = 'error');
		Log__c logWarn = new Log__c(Message__c = 'warnTest', Level__c = 'warn');
		Log__c logInfo = new Log__c(Message__c = 'infoTest', Level__c = 'info');
		List<Log__c> logs = new List<Log__c>{ logDebug, logError, logWarn, logInfo };
		insert logs;

		for (Log__c log : logs) {
			Test.setCreatedDate(log.Id, Date.Today() - 31);
		}

		Test.startTest();
		Database.executeBatch(new LoggerCleanUpBatch());
		Test.stopTest();

		logs = [SELECT Id FROM Log__c];
		System.assertEquals(0, logs.size());
	}
}
