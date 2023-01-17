global class LoggerCleanUpSchedule implements Schedulable {
	public static String defaultCron = '0 00 00 * * ?'; //Every Day at Midnight

	global static String scheduleMe() {
		return scheduleMe(defaultCron);
	}

	global static String scheduleMe(String cron) {
		if (cron == null) {
			cron = defaultCron;
		}
		LoggerCleanUpSchedule schedule = new LoggerCleanUpSchedule();
		return System.schedule('LoggerCleanUpBatch', cron, schedule);
	}

	global void execute(SchedulableContext sc) {
		LoggerCleanUpBatch batch = new LoggerCleanUpBatch();
		Database.executeBatch(batch);
	}
}
