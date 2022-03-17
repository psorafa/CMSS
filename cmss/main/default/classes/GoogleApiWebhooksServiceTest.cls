@isTest
private class GoogleApiWebhooksServiceTest {
	private static final String TOKEN = 'someToken';
	private static final String CALENDAR_ID = 'someCalendarId';

	private static final String CALENDAR_ID_HEADER = 'X-Goog-Resource-ID';
	private static final String TOKEN_HEADER = 'X-Goog-Channel-Token';

	@TestSetup
	static void makeData() {
		UserCalendarSetting__c setting = new UserCalendarSetting__c();
		setting.WatchId__c = TOKEN;
		setting.ResourceId__c = CALENDAR_ID;

		insert setting;
	}

	@isTest
	static void testNoCalendarId() {
		RestRequest request = new RestRequest();
		request.httpMethod = 'POST';
		request.requestURI = '/googleApiWebhooks/services/apexrest/api/webhooks/google/';
		request.headers.put(TOKEN_HEADER, TOKEN);

		RestResponse response = new RestResponse();

		RestContext.request = request;
		RestContext.response = response;

		Test.startTest();
		GoogleApiWebhooksService.handleNotification();
		Test.stopTest();

		System.assertEquals(400, RestContext.response.statusCode, 'Expected Bad Request without Calendar ID');
	}

	@isTest
	static void testNoToken() {
		RestRequest request = new RestRequest();
		request.httpMethod = 'POST';
		request.requestURI = '/googleApiWebhooks/services/apexrest/api/webhooks/google/';
		request.headers.put(CALENDAR_ID_HEADER, CALENDAR_ID);

		RestResponse response = new RestResponse();

		RestContext.request = request;
		RestContext.response = response;

		Test.startTest();
		GoogleApiWebhooksService.handleNotification();
		Test.stopTest();

		System.assertEquals(400, RestContext.response.statusCode, 'Expected Bad Request without Token');
	}

	@isTest
	static void testWrongCalendarId() {
		RestRequest request = new RestRequest();
		request.httpMethod = 'POST';
		request.requestURI = '/googleApiWebhooks/services/apexrest/api/webhooks/google/';
		request.headers.put(CALENDAR_ID_HEADER, CALENDAR_ID + 'abc');
		request.headers.put(TOKEN_HEADER, TOKEN);

		RestResponse response = new RestResponse();

		RestContext.request = request;
		RestContext.response = response;

		Test.startTest();
		GoogleApiWebhooksService.handleNotification();
		Test.stopTest();

		System.assertEquals(404, RestContext.response.statusCode, 'Expected to not find non existent Calendar Id');
	}

	@isTest
	static void testWrongToken() {
		RestRequest request = new RestRequest();
		request.httpMethod = 'POST';
		request.requestURI = '/googleApiWebhooks/services/apexrest/api/webhooks/google/';
		request.headers.put(CALENDAR_ID_HEADER, CALENDAR_ID);
		request.headers.put(TOKEN_HEADER, TOKEN + 'abc');

		RestResponse response = new RestResponse();

		RestContext.request = request;
		RestContext.response = response;

		Test.startTest();
		GoogleApiWebhooksService.handleNotification();
		Test.stopTest();

		System.assertEquals(401, RestContext.response.statusCode, 'Expected to not authorize with invalid Token');
	}

	@isTest
	static void testHandleValidNotification() {
		RestRequest request = new RestRequest();
		request.httpMethod = 'POST';
		request.requestURI = '/googleApiWebhooks/services/apexrest/api/webhooks/google/';
		request.headers.put(CALENDAR_ID_HEADER, CALENDAR_ID);
		request.headers.put(TOKEN_HEADER, TOKEN);

		RestResponse response = new RestResponse();

		RestContext.request = request;
		RestContext.response = response;

		Test.startTest();
		GoogleApiWebhooksService.handleNotification();
		Test.stopTest();

		System.assertEquals(200, RestContext.response.statusCode, 'Expected OK response status code');

		EventSync__c eventSync = [SELECT ChangeFromGoogle__c FROM EventSync__c WHERE ResourceId__c = :CALENDAR_ID];

		System.assertNotEquals(null, eventSync, 'Expected event to exist');
		System.assertEquals(true, eventSync.ChangeFromGoogle__c, 'Expected Change From Google to be true');
	}

	@isTest
	static void testErrorResponse() {
		RestResponse response = new RestResponse();

		RestContext.request = null;
		RestContext.response = response;

		Test.startTest();
		GoogleApiWebhooksService.handleNotification();
		Test.stopTest();

		System.assertEquals(500, RestContext.response.statusCode, 'Expected server error response status code');
	}
}
