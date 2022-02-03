public class MailServiceNotificationsQueue implements Queueable, Finalizer, Database.AllowsCallouts {
	private MailSOAPService.MailServicePort mailService;
	DateTime currentTime = System.now();
	public void execute(QueueableContext context) {
		String jobId = '' + context.getJobId();
		List<MailServiceNotification__c> mailServiceNotificationsToUpdate = new List<MailServiceNotification__c>();
		try {
			Finalizer finalizer = new MailServiceNotificationsQueue();
			System.attachFinalizer(finalizer);
			this.mailService = new MailSOAPService.MailServicePort();
			for (MailServiceNotification__c mailServiceNotification : [
				SELECT FromEmailAddress__c, ToEmailAddress__c, Subject__c, Body__c
				FROM MailServiceNotification__c
				WHERE DateSent__c = NULL AND SendAfter__c <= :currentTime AND NotSentDueToError__c = FALSE
				ORDER BY SendAfter__c
				LIMIT 50
			]) {
				HttpResponse response = mailService.sendEmail_Http(
					mailServiceNotification.ToEmailAddress__c,
					mailServiceNotification.FromEmailAddress__c,
					mailServiceNotification.Subject__c,
					mailServiceNotification.Body__c
				);
				if (response.getStatusCode() == 200) {
					mailServiceNotification.DateSent__c = currentTime;
				} else {
					Logger.error('MailSOAPService callout failed');
					mailServiceNotification.ErrorMessage__c = response.getStatus();
					mailServiceNotification.NotSentDueToError__c = true;
				}
				mailServiceNotificationsToUpdate.add(mailServiceNotification);
			}
		} catch (Exception e) {
			Logger.error('Error executing the job [' + jobId + ']: ' + e.getMessage());
			throw e;
		} finally {
			if (mailServiceNotificationsToUpdate.size() > 0) {
				System.debug('Updating ' + mailServiceNotificationsToUpdate.size() + ' mailServiceNotifications.');
				update mailServiceNotificationsToUpdate;
			}
			Logger.debug('Completed: execution of queueable job: ' + jobId);
			Logger.saveLogs();
		}
	}
	public void execute(FinalizerContext context) {
		String parentJobId = '' + context.getAsyncApexJobId();
		System.debug('Begin: executing finalizer attached to queueable job: ' + parentJobId);
		List<MailServiceNotification__c> mailServiceNotifications = [
			SELECT FromEmailAddress__c, ToEmailAddress__c, Subject__c, Body__c
			FROM MailServiceNotification__c
			WHERE DateSent__c = NULL AND SendAfter__c <= :currentTime AND NotSentDueToError__c = FALSE
		];
		if (mailServiceNotifications.size() > 0) {
			System.enqueueJob(new MailServiceNotificationsQueue());
		}
	}
}
