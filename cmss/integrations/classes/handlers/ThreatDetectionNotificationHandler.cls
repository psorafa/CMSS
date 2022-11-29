public with sharing class ThreatDetectionNotificationHandler {

    private static String emailTemplateDevName = 'ThreatDetectionNotification';
    private String apiAnomalyReceiver;
    private String credentialStuffingReceiver;
    private String reportAnomalyReceiver;
    private String sessionHijackingReceiver;
    private String eventScoreThreshold;
    @TestVisible
    private Map<String, MailNotificationsHandler> emailHandlers;

    public ThreatDetectionNotificationHandler() {
        this.apiAnomalyReceiver = getConfigurationMetadataValue('APIAnomalyEventNotifReceiver');
        this.credentialStuffingReceiver = getConfigurationMetadataValue('CredentialStuffingEventNotifReceiver');
        this.reportAnomalyReceiver = getConfigurationMetadataValue('ReportAnomalyEventNotifReceiver');
        this.sessionHijackingReceiver = getConfigurationMetadataValue('SessionHijackingEventNotifReceiver');
        this.eventScoreThreshold = getConfigurationMetadataValue('ThreatDetectionNotifScoreThreshold');

        this.emailHandlers = new Map<String, MailNotificationsHandler>();
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
                        addNotificationToHandler(aes, 'API Anomaly Event', apiAnomalyReceiver);
                    }
                    when CredentialStuffingEventStore ces {
                        addNotificationToHandler(ces, 'Credential Stuffing Event', credentialStuffingReceiver);
                    }
                    when ReportAnomalyEventStore res {
                        addNotificationToHandler(res, 'Report Anomaly Event', reportAnomalyReceiver);
                    }
                    when SessionHijackingEventStore ses {
                        addNotificationToHandler(ses, 'Session Hijacking Event', sessionHijackingReceiver);
                    }
                }
            }
        }

        for (MailNotificationsHandler handler : emailHandlers.values()) {
            handler.handleInsertNotifications();
        }
    }



    private void addNotificationToHandler(sObject event, String eventName, String receivers) {
        if (!emailHandlers.containsKey(eventName)) {
            MailNotificationsHandler handler = new MailNotificationsHandler();
            handler.setEmailTemplate(new EmailTemplate())
                .setEmailTemplate(emailTemplateDevName)
                .setSpecialVariables(new Map<String, String>{ 
                    'eventName' => eventName, 
                    'eventLink' => URL.getSalesforceBaseUrl().toExternalForm()+ '/'+ event.get('Id') 
                })
                .setReceivers(receivers.split(','));
            emailHandlers.put(eventName, handler);
        }
        emailHandlers.get(eventName).generateNotifications(null, receivers.split(','));
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