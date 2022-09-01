public class SendNotificationHandler {
	private sObject onObject;
	private String emailTemplateDevName;

	private Boolean disableMailSending;
	private String senderEmail = 'noreply@csobstavebni.cz';
	private String receiverEmail;
	private String emailSubject;
	@testVisible
	private String emailBody;
	private Map<String, String> specialVariableValues;

	public SendNotificationHandler(
		sObject onObject,
		String emailTemplateDevName,
		String receiverEmail,
		Map<String, String> specialVariableValues
	) {
		this.onObject = onObject;
		this.emailTemplateDevName = emailTemplateDevName;
		this.receiverEmail = receiverEmail;
		this.specialVariableValues = specialVariableValues;
		KZNotificationSettings__c KZSettings = KZNotificationSettings__c.getOrgDefaults();
		this.disableMailSending = !KZSettings.SendNotifications__c;
	}

	public SendNotificationHandler(sObject onObject, String emailTemplateDevName, String receiverEmail) {
		this.onObject = onObject;
		this.emailTemplateDevName = emailTemplateDevName;
		this.receiverEmail = receiverEmail;
		KZNotificationSettings__c KZSettings = KZNotificationSettings__c.getOrgDefaults();
		this.disableMailSending = !KZSettings.SendNotifications__c;
	}

	public void handle() {
		setUpEmail();
		sendEmailNotificaton();
	}

	@TestVisible
	private void setUpEmail() {
		EmailTemplate template = [
			SELECT HtmlValue, Subject
			FROM EmailTemplate
			WHERE DeveloperName = :emailTemplateDevName
		];
		emailBody = processTextation(template.HtmlValue);
		emailSubject = processTextation(template.Subject);
	}

	private String processTextation(String text) {
		String finalText = text;

		while (finalText.contains('{!')) {
			String fieldName = finalText.substringBetween('{!', '}');
			if (this.specialVariableValues != null && this.specialVariableValues.keySet().contains(fieldName)) {
				finalText = finalText.replace('{!' + fieldName + '}', this.specialVariableValues.get(fieldName));
			} else {
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
			}
		}

		return finalText;
	}

	@TestVisible
	private void sendEmailNotificaton() {
		MailServiceNotification__c newNotification = new MailServiceNotification__c();
		newNotification.ToEmailAddress__c = receiverEmail;
		newNotification.FromEmailAddress__c = senderEmail;
		newNotification.Subject__c = emailSubject;
		newNotification.Body__c = emailBody;
		newNotification.SendAfter__c = System.today();
		newNotification.NotSentDueToError__c = this.disableMailSending;
		insert newNotification;
	}

	public static void sendEmailNotificaton(String receiverEmail, String senderEmail, String subject, String body) {
		MailSOAPService.MailServicePort mailServicePort = new MailSOAPService.MailServicePort();
		mailServicePort.sendEmail_Http(receiverEmail, senderEmail, subject, body);
	}

	public static String getTextationFromTemplate(
		SObject objectOfOrigin,
		String templateText,
		Map<String, String> specialVariablesMap
	) {
		String finalText = templateText;

		while (finalText.contains('{!')) {
			String fieldName = finalText.substringBetween('{!', '}');
			if (specialVariablesMap != null && specialVariablesMap.keySet().contains(fieldName)) {
				finalText = finalText.replace('{!' + fieldName + '}', specialVariablesMap.get(fieldName));
			} else {
				finalText = extractValueFromFieldInText(fieldName, objectOfOrigin, finalText);
			}
		}

		return finalText;
	}

	@testVisible
	private static String extractValueFromFieldInText(String fieldName, SObject objectOfOrigin, String text) {
		String finalText = text;
		List<String> fieldRelation = fieldName.split('\\.');
		SObject childObject = objectOfOrigin;
		while (fieldRelation.size() > 1) {
			String firstObj = fieldRelation.remove(0);
			childObject = childObject.getSobject(firstObj);
		}
		if (
			childObject.getSobjectType()
				.getDescribe()
				.fields.getMap()
				.keySet()
				.contains(fieldRelation?.get(0)?.toLowercase())
		) {
			return finalText.replace(
				'{!' +
				fieldName +
				'}',
				String.valueOf('' + childObject.get(fieldRelation.get(0)))
			);
		} else {
			return finalText.replace('{!' + fieldName + '}', '?');
		}
	}
}
