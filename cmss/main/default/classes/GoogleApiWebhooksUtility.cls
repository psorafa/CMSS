public without sharing class GoogleApiWebhooksUtility {
	public static void handleWebhookRequest(RestRequest request, RestResponse response) {
		String token = request.headers.get('X-Goog-Channel-Token');
		String calendarId = request.headers.get('X-Goog-Resource-ID');

		if (calendarId == null || token == null) {
			System.debug(LoggingLevel.DEBUG, 'Malformed request, Calendar ID or Token missing');
			response.statusCode = 400;
			return;
		}

		List<UserCalendarSetting__c> settings = [
			SELECT WatchId__c
			FROM UserCalendarSetting__c
			WHERE ResourceId__c = :calendarId
		];

		if (settings == null || settings.isEmpty()) {
			System.debug(LoggingLevel.DEBUG, 'Corresponding User Settings not found');
			response.statusCode = 404;
			return;
		}

		UserCalendarSetting__c setting = settings.get(0);

		if (!token.equals(setting.WatchId__c)) {
			System.debug(
				LoggingLevel.DEBUG,
				'Request Token does not correspond to User Settings Token. Token in request: ' +
				token +
				', token in setting: ' +
				setting.WatchId__c
			);
			response.statusCode = 401;
			return;
		}

		List<EventSync__c> existingSyncForResource = [
			SELECT ResourceId__c, ChangeFromGoogle__c
			FROM EventSync__c
			WHERE ResourceId__c = :calendarId AND ChangeFromGoogle__c = TRUE
		];

		if (existingSyncForResource.size() == 0) {
			EventSync__c eventSync = new EventSync__c();
			eventSync.ResourceId__c = calendarId;
			eventSync.ChangeFromGoogle__c = true;
			insert eventSync;
		}

		response.statusCode = 200;
	}
}
