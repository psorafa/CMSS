public class CustomNotificationService {
     Public static void sendNotification(Id usrId, String notifType, String title, String body){
           List<CustomNotificationType> TemplateInfoDetail = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName=:notifType Limit 1];
			if(TemplateInfoDetail.size()>0){
                   Messaging.CustomNotification currNotification = new Messaging.CustomNotification();
                   currNotification.setTitle(title);
                   currNotification.setBody(body);
                   currNotification.setNotificationTypeId(TemplateInfoDetail[0].Id);
                   currNotification.setTargetId(usrId);
                   Set<String> usrIds = new Set<String>();
                   usrIds.add(usrId);
                   try {
                          currNotification.send(usrIds);
                   }
                   catch (Exception ex) {
                          System.debug('Notification Failed: ' + ex.getMessage());
                   }
            }
      }
}