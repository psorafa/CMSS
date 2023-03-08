public class MailNotificationsHandler {
	private SObject onObject;
	private EmailTemplate emailTemplate;
	private Map<String, String> specialVariableValues;
	private String senderEmail = 'noreply@csobstavebni.cz';
	private List<String> receiverEmails;
	private String emailSubject;
	private String emailBody;
	private String context = '';
	private Boolean disableMailSending = false;

	private List<MailServiceNotification__c> generatedNotifications;

	public MailNotificationsHandler() {
		this.receiverEmails = new List<String>();
		this.generatedNotifications = new List<MailServiceNotification__c>();
	}

	public MailNotificationsHandler setContext(String context) {
		this.context = context;
		setUpDisableMailSending();
		return this;
	}

	public MailNotificationsHandler setEmailTemplate(EmailTemplate emailTemplate) {
		this.emailTemplate = emailTemplate;
		return this;
	}

	public MailNotificationsHandler setEmailTemplate(String emailTemplateDevName) {
		this.emailTemplate = [SELECT HtmlValue, Subject FROM EmailTemplate WHERE DeveloperName = :emailTemplateDevName];
		return this;
	}

	public MailNotificationsHandler setSpecialVariables(Map<String, String> specialVariableValues) {
		this.specialVariableValues = specialVariableValues;
		return this;
	}

	public MailNotificationsHandler setSender(String senderEmail) {
		this.senderEmail = senderEmail;
		return this;
	}

	public MailNotificationsHandler setReceivers(List<String> receiverEmails) {
		this.receiverEmails = receiverEmails;
		return this;
	}

	public void handleInsertNotifications() {
		List<MailServiceNotification__c> notifications = retrieveGeneratedNotifications();
		System.debug(notifications);
		insert notifications;
	}

	public void generateNotifications(SObject sourceObject, List<String> receivers) {
		this.onObject = sourceObject;
		setUpEmail();
		for (String receiverEmail : receivers) {
			generatedNotifications.add(getOneNotification(receiverEmail));
		}
	}

	public List<MailServiceNotification__c> retrieveGeneratedNotifications() {
		return generatedNotifications;
	}

	private MailServiceNotification__c getOneNotification(String receiverEmail) {
		MailServiceNotification__c newNotification = new MailServiceNotification__c();
		newNotification.ToEmailAddress__c = receiverEmail;
		newNotification.FromEmailAddress__c = senderEmail;
		newNotification.Subject__c = emailSubject;
		newNotification.Body__c = emailBody;
		newNotification.SendAfter__c = System.today();
		newNotification.NotSentDueToError__c = disableMailSending;
		return newNotification;
	}

	@TestVisible
	private void setUpEmail() {
		emailBody = processTextation(emailTemplate.HtmlValue);
		emailSubject = processTextation(emailTemplate.Subject);
	}

	private void setUpDisableMailSending() {
		if (context == 'DIGIKZ') {
			KZNotificationSettings__c KZSettings = KZNotificationSettings__c.getOrgDefaults();
			disableMailSending = !KZSettings.SendNotifications__c;
		}
	}

	private String processTextation(String text) {
		if (specialVariableValues != null) {
			for (String specialFieldName : specialVariableValues.keySet()) {
				String mergeField = '{!' + specialFieldName + '}';
				String value = specialVariableValues.get(specialFieldName);
				text = text.replace(mergeField, value);
			}
		}
		if (onObject != null) {
			text = processStandardMergeFields(text);
		}
		return text;
	}

	private String processStandardMergeFields(String text) {
		for (Messaging.RenderEmailTemplateBodyResult result : Messaging.renderEmailTemplate(
			null,
			onObject.Id,
			new List<String>{ text }
		)) {
			if (result.getSuccess() == true) {
				return result.getMergedBody();
			} else {
				Logger.error(
					'Error when processing email template using standard merge fields',
					JSON.serialize(result)
				);
			}
		}
		return text;
	}
}
