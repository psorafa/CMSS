public class LogEventTriggerHandler {

	public static void afterInsert(List<LogEvent__e> newEvents) {
		List<Log__c> logsToSave = new List<Log__c>();

		for (LogEvent__e logEvent : newEvents) {
			Log__c log = createLog(logEvent);
			logsToSave.add(log);
		}
		insertLogs(logsToSave);
	}

	private static Log__c createLog(LogEvent__e logEvent) {
		Log__c log = new Log__c();
        log.TransactionId__c = logEvent.TransactionId__c;
		log.ClassMethodName__c = logEvent.ClassMethodName__c;
		log.Exception__c = logEvent.Exception__c;
		log.Level__c = logEvent.Level__c;
		log.Payload__c = logEvent.Payload__c;
		log.Message__c = logEvent.Message__c;
		return log;
	}

	private static void insertLogs(List<Log__c> logsToSave) {
		List<Database.SaveResult> results = Database.insert(logsToSave);
		for (Database.SaveResult sr : results) {
			if (!sr.isSuccess()) {
				for (Database.Error err : sr.getErrors()) {
					System.debug('Error while saving log returned: ' +
							err.getStatusCode() +
							' - ' +
							err.getMessage());
				}
			}
		}
	}
}