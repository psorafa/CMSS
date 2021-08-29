public class SendNotificationHandler {
	private sObject onObject;
	private String emailTemplateDevName;
	private MailSOAPService.MailServicePort mailService;

	private String senderEmail = 'someEmail@whatShouldItBe.com';
	private String receiverEmail;
	private String emailSubject;
	@testVisible
	private String emailBody;

	public SendNotificationHandler(sObject onObject, String emailTemplateDevName, String receiverEmail) {
		this.onObject = onObject;
		this.emailTemplateDevName = emailTemplateDevName;
		this.receiverEmail = receiverEmail;
		this.mailService = new MailSOAPService.MailServicePort();
	}

	public void handle() {
		setUpEmail();
		sendEmailNotificaton();
	}

	@TestVisible
	private void setUpEmail() {
		EmailTemplate template = [SELECT Body, Subject FROM EmailTemplate WHERE DeveloperName = :emailTemplateDevName];
		emailBody = processTextation(template.Body);
		emailSubject = processTextation(template.Subject);
	}

	private String processTextation(String text) {
		String finalText = text;

		while (finalText.contains('{!')) {
			String fieldName = finalText.substringBetween('{!', '}');
			if (fieldName == 'ORG_URL') {
				finalText = finalText.replace('{!' + fieldName + '}', URL.getSalesforceBaseUrl().toExternalForm());
			} else {
				List<String> fieldRelation = fieldName.split('\\.');
				SObject childObject = onObject;

				while (fieldRelation.size() > 1) {
					String firstObj = fieldRelation.remove(0);
					if (firstObj.contains('__r')) {
						firstObj = firstObj.replace('__r', '__c');
					}
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
		try {
			mailService.sendEmail(receiverEmail, senderEmail, emailSubject, emailBody);
		} catch (Exception e) {
		}
	}
}
