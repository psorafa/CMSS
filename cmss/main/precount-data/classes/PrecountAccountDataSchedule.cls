global class PrecountAccountDataSchedule implements Schedulable {
	global void execute(System.SchedulableContext context) {
		Database.executeBatch(new PrecountAccountDataFromAssetBatch());
	}
}
