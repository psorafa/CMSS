public with sharing class Logger {

	private static final String DEBUG_LEVEL = 'debug';
	private static final String INFO_LEVEL = 'info';
	private static final String WARN_LEVEL = 'warn';
	private static final String ERROR_LEVEL = 'error';

	private static List<LogEvent__e> logEventsToPublish = new List<LogEvent__e>();

	/*static {
		String logLevelPreferred = LoggingSetting__c.getOrgDefaults().Level__c;
		if (logLevelPreferred != null) {
			System.debug('logging level is: ' + logLevelPreferred);
			logLevel = logLevelPreferred;
		}
	}*/

	// debug level log methods
	public static void debug(String message, Exception ex, String payload) {
		LogEvent__e logEvent = createLogEvent(DEBUG_LEVEL, message, ex, payload);
		logEventsToPublish.add(logEvent);
	}

	public static void debug(String message, Exception ex) {
		debug(message, ex, '');
	}

	public static void debug(String message) {
		debug(message, null, '');
	}

	// info level log methods
	public static void info(String message, Exception ex, String payload) {
		LogEvent__e logEvent = createLogEvent(INFO_LEVEL, message, ex, payload);
		logEventsToPublish.add(logEvent);
	}

	public static void info(String message, Exception ex) {
		info(message, ex, '');
	}

	public static void info(String message) {
		info(message, null, '');
	}

	// warn level log methods
	public static void warn(String message, Exception ex, String payload) {
		LogEvent__e logEvent = createLogEvent(WARN_LEVEL, message, ex, payload);
		logEventsToPublish.add(logEvent);
	}

	public static void warn(String message, Exception ex) {
		warn(message, ex, '');
	}

	public static void warn(String message) {
		warn(message, null, '');
	}

	// error level log methods
	public static void error(String message, Exception ex, String payload) {
		LogEvent__e logEvent = createLogEvent(ERROR_LEVEL, message, ex, payload);
		logEventsToPublish.add(logEvent);
	}

	public static void error(String message, Exception ex) {
		error(message, ex, '');
	}

	public static void error(String message) {
		error(message, null, '');
	}

	public static LogEvent__e createLogEvent(String logLevel, String message, Exception ex, String payload) {
		LogEvent__e logEvent = new LogEvent__e();
		logEvent.Message__c = message;
		logEvent.Exception__c = ex.getMessage();
		logEvent.Level__c = logLevel;
		logEvent.Payload__c = payload;
		return logEvent;
	}

	public static void saveLogs() {
		System.debug('BEFORE LogEvents insert - logEventsToPublish size() ' + logEventsToPublish.size());
		System.debug('BEFORE LogEvents insert - logEventsToPublish: ' + logEventsToPublish);
		List<Database.SaveResult> results = EventBus.publish(logEventsToPublish);

		for (Database.SaveResult sr : results) {
			if (sr.isSuccess()) {
				System.debug('Successfully published event: sr:' + sr);
			} else {
				for(Database.Error err : sr.getErrors()) {
					System.debug('Error returned: ' +
							err.getStatusCode() +
							' - ' +
							err.getMessage());
				}
			}
		}
	}
}