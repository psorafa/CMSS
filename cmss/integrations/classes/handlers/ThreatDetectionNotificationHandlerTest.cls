@isTest
public class ThreatDetectionNotificationHandlerTest {

    @IsTest
	static void sendThreatDetectionEmailNotificatonsTest() {

        Test.setMock(HttpCalloutMock.class, new SendNotificationHandlerTest.MailSOAPServiceHttpMock());
		insert TestDataFactory.getIntegrationSettings();

        String rawParams = '{"eventIdentifier":"123456789", "Score":"1"}';
        
        APIAnomalyEventStore apEventRecord = (APIAnomalyEventStore) JSON.deserialize(rawParams, APIAnomalyEventStore.class);
        CredentialStuffingEventStore csEventRecord = (CredentialStuffingEventStore) JSON.deserialize(rawParams, CredentialStuffingEventStore.class);
        ReportAnomalyEventStore raEventRecord = (ReportAnomalyEventStore) JSON.deserialize(rawParams, ReportAnomalyEventStore.class);
        SessionHijackingEventStore shEventRecord = (SessionHijackingEventStore) JSON.deserialize(rawParams, SessionHijackingEventStore.class);

        Test.startTest();
            ThreatDetectionNotificationHandler.sendThreatDetectionEmailNotificatons(new List<sObject> {apEventRecord, csEventRecord, raEventRecord, shEventRecord});
        Test.stopTest();
    }

    @IsTest
	static void handleTest() {

        Test.setMock(HttpCalloutMock.class, new SendNotificationHandlerTest.MailSOAPServiceHttpMock());
		insert TestDataFactory.getIntegrationSettings();

        String rawParams = '{"eventIdentifier":"123456789", "Score":"1"}';
        
        APIAnomalyEventStore apEventRecord = (APIAnomalyEventStore) JSON.deserialize(rawParams, APIAnomalyEventStore.class);
        CredentialStuffingEventStore csEventRecord = (CredentialStuffingEventStore) JSON.deserialize(rawParams, CredentialStuffingEventStore.class);
        ReportAnomalyEventStore raEventRecord = (ReportAnomalyEventStore) JSON.deserialize(rawParams, ReportAnomalyEventStore.class);
        SessionHijackingEventStore shEventRecord = (SessionHijackingEventStore) JSON.deserialize(rawParams, SessionHijackingEventStore.class);

        ThreatDetectionNotificationHandler handler = new ThreatDetectionNotificationHandler();
        Test.startTest();
            handler.handle(new List<sObject> {apEventRecord, csEventRecord, raEventRecord, shEventRecord});
        Test.stopTest();

        System.assert(!handler.notificationHandler.emailBody.contains('{!'));
        System.assert(handler.notificationHandler.emailBody.contains('Session Hijacking Event'));
    }

    @IsTest
	static void handleTresholdTest() {

        Test.setMock(HttpCalloutMock.class, new SendNotificationHandlerTest.MailSOAPServiceHttpMock());
		insert TestDataFactory.getIntegrationSettings();

        String rawParams = '{"eventIdentifier":"123456789", "Score":"-1"}';
        
        APIAnomalyEventStore apEventRecord = (APIAnomalyEventStore) JSON.deserialize(rawParams, APIAnomalyEventStore.class);
        CredentialStuffingEventStore csEventRecord = (CredentialStuffingEventStore) JSON.deserialize(rawParams, CredentialStuffingEventStore.class);
        ReportAnomalyEventStore raEventRecord = (ReportAnomalyEventStore) JSON.deserialize(rawParams, ReportAnomalyEventStore.class);
        SessionHijackingEventStore shEventRecord = (SessionHijackingEventStore) JSON.deserialize(rawParams, SessionHijackingEventStore.class);

        ThreatDetectionNotificationHandler handler = new ThreatDetectionNotificationHandler();
        Test.startTest();
            handler.handle(new List<sObject> {apEventRecord, csEventRecord, raEventRecord, shEventRecord});
        Test.stopTest();

        System.assert(handler.notificationHandler == null);
    }
}
