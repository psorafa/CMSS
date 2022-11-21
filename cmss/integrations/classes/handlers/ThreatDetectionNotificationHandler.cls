public with sharing class ThreatDetectionNotificationHandler {

    private static String emailTemplateDevName = 'ThreatDetectionNotification';
    private String apiAnomalyReceiver;
    private String credentialStuffingReceiver;
    private String reportAnomalyReceiver;
    private String sessionHijackingReceiver;
    private String eventScoreThreshold;
    @TestVisible
    private SendNotificationHandler notificationHandler;

    public ThreatDetectionNotificationHandler() {
        this.apiAnomalyReceiver = getConfigurationMetadataValue('APIAnomalyEventNotifReceiver');
        this.credentialStuffingReceiver = getConfigurationMetadataValue('CredentialStuffingEventNotifReceiver');
        this.reportAnomalyReceiver = getConfigurationMetadataValue('ReportAnomalyEventNotifReceiver');
        this.sessionHijackingReceiver = getConfigurationMetadataValue('SessionHijackingEventNotifReceiver');
        this.eventScoreThreshold = getConfigurationMetadataValue('ThreatDetectionNotifScoreThreshold');
    }

    @InvocableMethod(label='Send ThreatDetection Email Notifications')
    public static void sendThreatDetectionEmailNotificatons(List<sObject> events) {
        Logger.debug('ThreatDetection Events detected: ' + events);
        try {
            ThreatDetectionNotificationHandler handler = new ThreatDetectionNotificationHandler();
            handler.handle(events);
            Logger.debug('ThreatDetection Notification sent');
        } catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
        } finally {
            Logger.saveLogs();
        }
    }    

    @TestVisible
    private void handle(List<sObject> events) {
        for (sObject event : events) {
            if ((Decimal) event.get('Score') >= Decimal.valueOf(this.eventScoreThreshold)) {
                switch on event {
                    when APIAnomalyEventStore aes {
                        sendThreatDetectionEmailForEvent(aes, 'API Anomaly Event', apiAnomalyReceiver);
                    }
                    when CredentialStuffingEventStore ces {
                        sendThreatDetectionEmailForEvent(ces, 'Credential Stuffing Event', credentialStuffingReceiver);
                    }
                    when ReportAnomalyEventStore res {
                        sendThreatDetectionEmailForEvent(res, 'Report Anomaly Event', reportAnomalyReceiver);
                    }
                    when SessionHijackingEventStore ses {
                        sendThreatDetectionEmailForEvent(ses, 'Session Hijacking Event', sessionHijackingReceiver);
                    }
                }
            }
        }
    }

    private void sendThreatDetectionEmailForEvent(sObject event, String eventName, String receivers) {
        notificationHandler = new SendNotificationHandler(
            null,
            emailTemplateDevName,
            receivers.split(','),
            new Map<String, String>{
                'eventName' => eventName,
                'eventLink' => URL.getSalesforceBaseUrl().toExternalForm()+ '/'+ event.get('Id')
            },
            null
        );
        notificationHandler.handleInsertNotifications();
    }

    private String getConfigurationMetadataValue(String developerName) {
        Configuration__mdt config = Configuration__mdt.getInstance(developerName);
        if (config != null) {
            return config.Value__c;
        } else {
            return '';
        }
    }
}