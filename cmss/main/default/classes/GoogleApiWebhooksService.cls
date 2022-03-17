@RestResource(urlMapping='/api/webhooks/google/*')
global with sharing class GoogleApiWebhooksService {
	@HttpPost
	global static void handleNotification() {
		RestRequest request = RestContext.request;
		RestResponse response = RestContext.response;
		try {
			Logger.debug('Google Calendar Webhook Notification: ' + request);
			GoogleApiWebhooksUtility.handleWebhookRequest(request, response);
		} catch (Exception e) {
			response.statusCode = 500;
			Logger.error('Exception during notification handling: ' + e.getMessage());
		} finally {
			Logger.saveLogs();
		}
	}
}
