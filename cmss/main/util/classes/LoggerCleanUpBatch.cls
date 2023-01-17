global class LoggerCleanUpBatch implements Database.Batchable<sObject> {
	public static String ERROR_LEVEL = 'error';
	public static String WARN_LEVEL = 'warn';
	public static String INFO_LEVEL = 'info';
	public static String DEBUG_LEVEL = 'debug';

	global Database.QueryLocator start(Database.BatchableContext bc) {
		Datetime errorTresholdDate = getLogDeleteTreshold('Logger_ErrorLevelDeleteTreshold');
		Datetime warnTresholdDate = getLogDeleteTreshold('Logger_WarnLevelDeleteTreshold');
		Datetime infoTresholdDate = getLogDeleteTreshold('Logger_InfoLevelDeleteTreshold');
		Datetime debugTresholdDate = getLogDeleteTreshold('Logger_DebugLevelDeleteTreshold');

		return Database.getQueryLocator(
			[
				SELECT Id, Level__c, CreatedDate
				FROM Log__c
				WHERE
					(CreatedDate < :errorTresholdDate
					AND Level__c = :ERROR_LEVEL)
					OR (CreatedDate < :warnTresholdDate
					AND Level__c = :WARN_LEVEL)
					OR (CreatedDate < :infoTresholdDate
					AND Level__c = :INFO_LEVEL)
					OR (CreatedDate < :debugTresholdDate
					AND Level__c = :DEBUG_LEVEL)
			]
		);
	}

	public Void execute(Database.BatchableContext jobId, List<Log__c> logList) {
		try {
			if (!logList.isEmpty()) {
				System.debug('Deleting ' + logList.size() + ' Log records.');
				List<Database.DeleteResult> results = Database.delete(logList, false);
				for (Database.DeleteResult result : results) {
					if (!result.isSuccess()) {
						for (Database.Error err : result.getErrors()) {
							Logger.error('Erorr message: ' + err.getMessage() + ' Fields:' + err.getFields());
						}
					}
				}
			}
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	public void finish(Database.BatchableContext jobId) {
		System.debug('Execution of LoggerCleanUpBatch finished');
	}

	private Datetime getLogDeleteTreshold(String instanceName) {
		Configuration__mdt treshold = (Configuration__mdt) Configuration__mdt.getInstance(instanceName);
		if (treshold != null && treshold.Value__c != null) {
			return Datetime.now() - Integer.valueOf(treshold.Value__c);
		} else {
			return Datetime.now() - 30;
		}
	}
}
