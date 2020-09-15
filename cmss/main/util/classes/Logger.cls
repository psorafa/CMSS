public with sharing class Logger {

	private static String logLevel = 'debug';
	private static List<LogEvent__e> logEventsToPublish = new List<LogEvent__e>();

	private Logger() {
		String logLevelPreferred = LoggingSetting__c.getOrgDefaults().Level__c;
		if (logLevelPreferred != null) {
			System.debug('logging level is: ' + logLevelPreferred);
			logLevel = logLevelPreferred;
		}
	}

	public static void log(String level, String message, String ex, String payload) {
		LogEvent__e logEvent = createLogEvent(level, message, ex, payload);
		logEventsToPublish.add(logEvent);
	}

	public static void log(String level, String message, String ex) {
		log(message, ex, '');
	}

	public static void log(String level, String message) {
		log(message, '', '');
	}

	public static LogEvent__e createLogEvent(String logLevel, String message, String ex, String payload) {
		LogEvent__e logEvent = new LogEvent__e();
		logEvent.Message__c = message;
		logEvent.Exception__c = ex;
		logEvent.Level__c = logLevel;
		logEvent.Payload__c = payload;
		return logEvent;
	}

	public static void saveLogs() {
		List<Database.SaveResult> results = EventBus.publish(logEventsToPublish);

		for (Database.SaveResult sr : results) {
			if (sr.isSuccess()) {
				System.debug('Successfully published event.');
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