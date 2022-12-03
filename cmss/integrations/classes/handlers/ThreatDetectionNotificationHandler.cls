public with sharing class ThreatDetectionNotificationHandler {
	private final String emailTemplateDevName = 'ThreatDetectionNotification';
	private Map<String, Configuration__mdt> metadataConfig;
	@TestVisible
	private Map<String, MailNotificationsHandler> emailHandlers;

	public ThreatDetectionNotificationHandler() {
		metadataConfig = new Map<String, Configuration__mdt>();
		this.emailHandlers = new Map<String, MailNotificationsHandler>();

		if (Test.isRunningTest()) {
			setTestMetadata();
		}
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
			if (
				(Decimal) event.get('Score') >=
				Decimal.valueOf(getConfigurationMetadataValue('ThreatDetectionNotifScoreThreshold'))
			) {
				switch on event {
					when APIAnomalyEventStore aes {
						addNotificationToHandler(
							aes,
							'API Anomaly Event',
							getConfigurationMetadataValue('APIAnomalyEventNotifReceiver')
						);
					}
					when CredentialStuffingEventStore ces {
						addNotificationToHandler(
							ces,
							'Credential Stuffing Event',
							getConfigurationMetadataValue('CredentialStuffingEventNotifReceiver')
						);
					}
					when ReportAnomalyEventStore res {
						addNotificationToHandler(
							res,
							'Report Anomaly Event',
							getConfigurationMetadataValue('ReportAnomalyEventNotifReceiver')
						);
					}
					when SessionHijackingEventStore ses {
						addNotificationToHandler(
							ses,
							'Session Hijacking Event',
							getConfigurationMetadataValue('SessionHijackingEventNotifReceiver')
						);
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
				.setSpecialVariables(
					new Map<String, String>{
						'eventName' => eventName,
						'eventLink' => URL.getSalesforceBaseUrl().toExternalForm() +
						'/' +
						event.get('Id')
					}
				)
				.setReceivers(receivers.split(','));
			emailHandlers.put(eventName, handler);
		}
		emailHandlers.get(eventName).generateNotifications(null, receivers.split(','));
	}

	private String getConfigurationMetadataValue(String developerName) {
		if (!metadataConfig.containsKey(developerName)) {
			metadataConfig.put(developerName, (Configuration__mdt) Configuration__mdt.getInstance(developerName));
		}
		return metadataConfig.get(developerName).Value__c != null ? metadataConfig.get(developerName).Value__c : '';
	}

	private void setTestMetadata() {
		String jsonMetadataString =
			'{' +
			'"ThreatDetectionNotifScoreThreshold":{"DeveloperName": "ThreatDetectionNotifScoreThreshold", "Value__c" : "0"},' +
			'"APIAnomalyEventNotifReceiver":{"DeveloperName": "APIAnomalyEventNotifReceiver", "Value__c" : "test@test.com"},' +
			'"CredentialStuffingEventNotifReceiver":{"DeveloperName": "CredentialStuffingEventNotifReceiver", "Value__c" : "test@test.com"},' +
			'"ReportAnomalyEventNotifReceiver":{"DeveloperName": "ReportAnomalyEventNotifReceiver", "Value__c" : "test@test.com"},' +
			'"SessionHijackingEventNotifReceiver":{"DeveloperName": "SessionHijackingEventNotifReceiver", "Value__c" : "test@test.com"}' +
			'}';

		this.metadataConfig = (Map<String, Configuration__mdt>) JSON.deserialize(
			jsonMetadataString,
			Map<String, Configuration__mdt>.class
		);
	}
}
