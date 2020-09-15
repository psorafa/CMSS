trigger Logger on LogEvent__e (after insert) {

	System.debug('platform event published: ' + Trigger.new);

	List<Log__c> logsToSave = new List<Log__c>();

	for (LogEvent__e logEvent : Trigger.new) {
		Log__c log = createLog(logEvent.Exception__c, logEvent.Level__c, logEvent.Payload__c, logEvent.Message__c);
		logsToSave.add(log);
		insertLogs(logsToSave);
	}

	private static Log__c createLog(String ex, String level, String payload, String message) {
		Log__c log = new Log__c();
		log.Exception__c = ex;
		log.Level__c = level;
		log.Payload__c = payload;
		log.Message__c = message;
		return log;
	}

	private static void insertLogs(List<Log__c> logsToSave) {
		List<Database.SaveResult> results = Database.insert(logsToSave);
		for (Database.SaveResult sr : results) {
			if (sr.isSuccess()) {
				System.debug('Successfully inserted log.');
			} else {
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