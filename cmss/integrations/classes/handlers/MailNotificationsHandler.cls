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
		String finalText = text;

		while (finalText.contains('{!')) {
			String fieldName = finalText.substringBetween('{!', '}');
			if (this.specialVariableValues != null && this.specialVariableValues.keySet().contains(fieldName)) {
				finalText = finalText.replace('{!' + fieldName + '}', this.specialVariableValues.get(fieldName));
			} else {
				finalText = replaceFirstVarWithFieldValue(finalText, fieldName);
			}
		}
		return finalText;
	}

	private String replaceFirstVarWithFieldValue(String text, String fieldName) {
		String finalText = text;
		List<String> fieldRelation = fieldName.split('\\.');
		SObject childObject = onObject;

		while (fieldRelation.size() > 1) {
			String firstObj = fieldRelation.remove(0);
			childObject = childObject.getSobject(firstObj);
		}
		if (childObject?.get(fieldRelation?.get(0)) != null) {
			finalText = finalText.replace(
				'{!' +
				fieldName +
				'}',
				String.valueOf(childObject.get(fieldRelation.get(0)))
			);
		} else {
			finalText = finalText.replace('{!' + fieldName + '}', '?');
		}
		return finalText;
	}
}
