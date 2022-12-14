public class CustomNotificationService {
	public static void sendNotification(Id usrId, Id notifTypeId, String title, String body) {
		Messaging.CustomNotification currNotification = new Messaging.CustomNotification();
		currNotification.setTitle(title);
		currNotification.setBody(body);
		currNotification.setNotificationTypeId(notifTypeId);
		currNotification.setTargetId(usrId);
		Set<String> usrIds = new Set<String>();
		usrIds.add(usrId);
		try {
			currNotification.send(usrIds);
		} catch (Exception ex) {
			Logger.error('An exception thrown', ex);
		} finally {
			Logger.saveLogs();
		}
	}
}
