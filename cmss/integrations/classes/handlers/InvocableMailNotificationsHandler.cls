public class InvocableMailNotificationsHandler {
	@InvocableMethod(label='Create mail service notifications')
	public static List<MailServiceNotification__c> createMailServiceNotifications(
		List<GenerateNotificationRequest> requests
	) {
		List<MailServiceNotification__c> notifications = new List<MailServiceNotification__c>();
		try {
			MailNotificationsHandler notificationsHandler = new MailNotificationsHandler();
			for (GenerateNotificationRequest request : requests) {
				notificationsHandler.setEmailTemplate(request.emailTemplate)
					.setSender(request.senderEmail)
					.generateNotifications(request.sourceRecord, new List<String>{ request.receiverEmail });
			}
			notifications = notificationsHandler.retrieveGeneratedNotifications();
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
		return notifications;
	}

	public class GenerateNotificationRequest {
		@InvocableVariable(label='Source record' description='Record to fill the template with' required=false)
		public SObject sourceRecord;
		@InvocableVariable(label='Email template' description='Email template' required=true)
		public EmailTemplate emailTemplate;
		@InvocableVariable(label='Sender' description='Sender email address' required=false)
		public String senderEmail = 'noreply@csobstavebni.cz';
		@InvocableVariable(label='Receiver' description='Receiver email' required=true)
		public String receiverEmail;
	}
}
