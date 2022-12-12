public class CustomNotificationService {
	public static void sendNotification(User usr, String notifType, String title, String body) {
		List<CustomNotificationType> TemplateInfoDetail = [
			SELECT Id, DeveloperName
			FROM CustomNotificationType
			WHERE DeveloperName = :notifType
			LIMIT 1
		];
		if (TemplateInfoDetail.size() > 0) {
			Messaging.CustomNotification currNotification = new Messaging.CustomNotification();
			currNotification.setTitle(title);
			currNotification.setBody(body);
			currNotification.setNotificationTypeId(TemplateInfoDetail[0].Id);
			currNotification.setTargetId(usr.Id);
			Set<String> usrIds = new Set<String>();
			usrIds.add(usr.Id);
			try {
				currNotification.send(usrIds);
			} catch (Exception ex) {
				System.debug('Notification Failed: ' + ex.getMessage());
			}
		}
	}
}
