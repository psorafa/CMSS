@IsTest
private class LoggerTest {

	@IsTest
	static void debugTest() {
		insertLoggingCustomSettings('debug');
		// debug
		String debugMessage1st = '1st debug, exc, payload';
		String debugMessage2nd = '2nd debug, exc';
		String debugMessage3rd = '3rd debug';
		String debugPayload = 'payload of 1st debug log';
		// info
		String infoMessage1st = '1st info, exc, payload';
		String infoMessage2nd = '2nd info, exc';
		String infoMessage3rd = '3rd info';
		String infoPayload = 'payload of 1st info log';
		// warn
		String warnMessage1st = '1st warn, exc, payload';
		String warnMessage2nd = '2nd warn, exc';
		String warnMessage3rd = '3rd warn';
		String warnPayload = 'payload of 1st warn log';
		// error
		String errorMessage1st = '1st error, exc, payload';
		String errorMessage2nd = '2nd error, exc';
		String errorMessage3rd = '3rd error';
		String errorPayload = 'payload of 1st error log';

		Test.startTest();
		try {
			throw new DmlException('test exc');
		} catch (Exception exc) {
			Logger.debug(debugMessage1st, exc, debugPayload);
			Logger.debug(debugMessage2nd, exc);
			Logger.debug(debugMessage3rd);
			Logger.info(infoMessage1st, exc, infoPayload);
			Logger.info(infoMessage2nd, exc);
			Logger.info(infoMessage3rd);
			Logger.warn(warnMessage1st, exc, warnPayload);
			Logger.warn(warnMessage2nd, exc);
			Logger.warn(warnMessage3rd);
			Logger.error(errorMessage1st, exc, errorPayload);
			Logger.error(errorMessage2nd, exc);
			Logger.error(errorMessage3rd);
			Logger.saveLogs();
		}
		Test.getEventBus().deliver();
		Test.stopTest();
		System.assertEquals(12, [SELECT count() FROM Log__c]);

		List<Log__c> logs = [SELECT Id, Level__c, Exception__c, Message__c, Payload__c FROM Log__c ORDER BY Level__c];
		System.debug('inserted logs.size(): ' + logs.size());
		System.debug('inserted logs: ' + logs);
		for (Log__c log : logs) {
			// test root methods with all 3 params
			if (log.Message__c.equals(debugMessage1st)) {
				System.assertEquals('debug', log.Level__c);
				System.assertEquals(debugPayload, log.Payload__c);
			}
			if (log.Message__c.equals(infoMessage1st)) {
				System.assertEquals('info', log.Level__c);
				System.assertEquals(infoPayload, log.Payload__c);
			}
			if (log.Message__c.equals(warnMessage1st)) {
				System.assertEquals('warn', log.Level__c);
				System.assertEquals(warnPayload, log.Payload__c);
			}
			if (log.Message__c.equals(errorMessage1st)) {
				System.assertEquals('error', log.Level__c);
				System.assertEquals(errorPayload, log.Payload__c);
			}
			// test other methods
			if (log.Message__c.equals(debugMessage2nd)) {
				System.assertEquals('debug', log.Level__c);
			}
			if (log.Message__c.equals(infoMessage3rd)) {
				System.assertEquals('info', log.Level__c);
			}
			if (log.Message__c.equals(warnMessage2nd)) {
				System.assertEquals('warn', log.Level__c);
			}
			if (log.Message__c.equals(errorMessage3rd)) {
				System.assertEquals('error', log.Level__c);
			}
		}
	}

	@IsTest
	static void onlyInfoLevelTest() {
		insertLoggingCustomSettings('info');
		String debugMessage = 'debug message';
		String infoMessage = 'info message';
		String warnMessage = 'warn message';
		String errorMessage = 'error message';

		Test.startTest();
		Logger.debug(debugMessage);
		Logger.info(infoMessage);
		Logger.warn(warnMessage);
		Logger.error(errorMessage);
		Logger.saveLogs();
		Test.getEventBus().deliver();
		Test.stopTest();

		List<Log__c> logs = [SELECT Id, Level__c, Exception__c, Message__c, Payload__c FROM Log__c ORDER BY Level__c];
		System.assertEquals(3, logs.size());
		System.debug('inserted logs.size(): ' + logs.size());
		System.debug('inserted logs: ' + logs);
		for (Log__c log : logs) {
			System.assertNotEquals('debug', log.Level__c);
			System.assertNotEquals(debugMessage, log.Message__c);
		}
	}

	@IsTest
	static void onlyWarnLevelTest() {
		insertLoggingCustomSettings('warn');
		String debugMessage = 'debug message';
		String infoMessage = 'info message';
		String warnMessage = 'warn message';
		String errorMessage = 'error message';

		Test.startTest();
		Logger.debug(debugMessage);
		Logger.info(infoMessage);
		Logger.warn(warnMessage);
		Logger.error(errorMessage);
		Logger.saveLogs();
		Test.getEventBus().deliver();
		Test.stopTest();

		List<Log__c> logs = [SELECT Id, Level__c, Exception__c, Message__c, Payload__c FROM Log__c ORDER BY Level__c];
		System.assertEquals(2, logs.size());
		System.debug('inserted logs.size(): ' + logs.size());
		System.debug('inserted logs: ' + logs);
		for (Log__c log : logs) {
			System.assertNotEquals('debug', log.Level__c);
			System.assertNotEquals(debugMessage, log.Message__c);
			System.assertNotEquals('info', log.Level__c);
			System.assertNotEquals(infoMessage, log.Message__c);
		}
	}

	@IsTest
	static void onlyErrorLevelTest() {
		insertLoggingCustomSettings('error');
		String debugMessage = 'debug message';
		String infoMessage = 'info message';
		String warnMessage = 'warn message';
		String errorMessage = 'error message';

		Test.startTest();
		Logger.debug(debugMessage);
		Logger.info(infoMessage);
		Logger.warn(warnMessage);
		Logger.error(errorMessage);
		Logger.saveLogs();
		Test.getEventBus().deliver();
		Test.stopTest();

		List<Log__c> logs = [SELECT Id, Level__c, Exception__c, Message__c, Payload__c FROM Log__c ORDER BY Level__c];
		System.assertEquals(1, logs.size());
		System.debug('inserted logs.size(): ' + logs.size());
		System.debug('inserted logs: ' + logs);
		for (Log__c log : logs) {
			System.assertNotEquals('debug', log.Level__c);
			System.assertNotEquals(debugMessage, log.Message__c);
			System.assertNotEquals('info', log.Level__c);
			System.assertNotEquals(infoMessage, log.Message__c);
			System.assertNotEquals('warn', log.Level__c);
			System.assertNotEquals(warnMessage, log.Message__c);
		}
	}

	private static void insertLoggingCustomSettings(String level) {
		LoggingSetting__c loggingSetting = new LoggingSetting__c(Level__c = level);
		insert loggingSetting;
	}
}