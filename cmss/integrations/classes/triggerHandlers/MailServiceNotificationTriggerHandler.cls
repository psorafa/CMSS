public class MailServiceNotificationTriggerHandler extends TriggerHandler {
	public override void afterInsert() {
		ApexClass queueClass = [SELECT Id FROM ApexClass WHERE Name = 'MailServiceNotificationsQueue'];

		Integer enqueuedJobsCount = [
			SELECT COUNT()
			FROM AsyncApexJob
			WHERE ApexClassId = :queueClass.Id AND Status IN ('Processing', 'Preparing', 'Queued')
		];
		if (enqueuedJobsCount == 0) {
			System.enqueueJob(new MailServiceNotificationsQueue());
		}
	}
}
