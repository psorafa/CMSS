public with sharing class Logger {

	private static String defaultLogLevel = 'debug';
	private static Integer defaultLogLevelNumber = 4;
	private static final String DEBUG_LEVEL = 'debug';
	private static final String INFO_LEVEL = 'info';
	private static final String WARN_LEVEL = 'warn';
	private static final String ERROR_LEVEL = 'error';
	private static final Map<String, Integer> logLevelNumberMap = new Map<String, Integer>{
			DEBUG_LEVEL => 4, INFO_LEVEL => 3, WARN_LEVEL => 2, ERROR_LEVEL => 1
	};

	private static List<LogEvent__e> logEventsToPublish = new List<LogEvent__e>();

	static {
		String logLevelPreferred = LoggingSetting__c.getOrgDefaults().Level__c;
		if (logLevelPreferred != null) {
			defaultLogLevel = logLevelPreferred;
		}
		defaultLogLevelNumber = logLevelNumberMap.get(defaultLogLevel);
	}

	// debug level log methods
	public static void debug(String message, Exception ex, String payload) {
		if (defaultLogLevelNumber >= 4) {
			LogEvent__e logEvent = createLogEvent(DEBUG_LEVEL, message, ex, payload);
			logEventsToPublish.add(logEvent);
		}
	}

	public static void debug(String message, Exception ex) {
		debug(message, ex, null);
	}

	public static void debug(String message) {
		debug(message, null, null);
	}

	// info level log methods
	public static void info(String message, Exception ex, String payload) {
		if (defaultLogLevelNumber >= 3) {
			LogEvent__e logEvent = createLogEvent(INFO_LEVEL, message, ex, payload);
			logEventsToPublish.add(logEvent);
		}
	}

	public static void info(String message, Exception ex) {
		info(message, ex, null);
	}

	public static void info(String message) {
		info(message, null, null);
	}

	// warn level log methods
	public static void warn(String message, Exception ex, String payload) {
		if (defaultLogLevelNumber >= 2) {
			LogEvent__e logEvent = createLogEvent(WARN_LEVEL, message, ex, payload);
			logEventsToPublish.add(logEvent);
		}
	}

	public static void warn(String message, Exception ex) {
		warn(message, ex, null);
	}

	public static void warn(String message) {
		warn(message, null, null);
	}

	// error level log methods
	public static void error(String message, Exception ex, String payload) {
		if (defaultLogLevelNumber >= 1) {
			LogEvent__e logEvent = createLogEvent(ERROR_LEVEL, message, ex, payload);
			logEventsToPublish.add(logEvent);
		}
	}

	public static void error(String message, Exception ex) {
		error(message, ex, null);
	}

	public static void error(String message) {
		error(message, null, null);
	}

	public static LogEvent__e createLogEvent(String logLevel, String message, Exception ex, String payload) {
		LogEvent__e logEvent = new LogEvent__e();
		logEvent.Message__c = message;
		if (ex != null) {
			logEvent.Exception__c = ex.getMessage();
		}
		if (payload != null) {
			logEvent.Payload__c = payload;
		}
		try {
			throw new DmlException('log exception');
		} catch (DmlException exc) {
			String stack = exc.getStackTraceString().substringAfter('\n');
			while (stack.startsWith('Class.Logger.')) {
				stack = stack.substringAfter('\n');
			}
			stack = stack.substringBetween('Class.', ':');
			logEvent.ClassMethodName__c = stack;
		}
		logEvent.Level__c = logLevel;
		return logEvent;
	}

	public static void saveLogs() {
		List<Database.SaveResult> results = EventBus.publish(logEventsToPublish);

		for (Database.SaveResult sr : results) {
			if (sr.isSuccess()) {
				System.debug('Successfully published event: sr:' + sr);
			} else {
				for (Database.Error err : sr.getErrors()) {
					System.debug('Error returned: ' +
							err.getStatusCode() +
							' - ' +
							err.getMessage());
				}
			}
		}
	}
}