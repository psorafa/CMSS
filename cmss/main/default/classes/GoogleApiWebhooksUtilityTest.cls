@isTest
private class GoogleApiWebhooksUtilityTest {
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
		request.headers.put(TOKEN_HEADER, TOKEN);
		RestResponse response = new RestResponse();

		Test.startTest();
		GoogleApiWebhooksUtility.handleWebhookRequest(request, response);
		Test.stopTest();

		System.assertEquals(400, response.statusCode, 'Expected Bad Request without Calendar ID');
	}

	@isTest
	static void testNoToken() {
		RestRequest request = new RestRequest();
		request.headers.put(CALENDAR_ID_HEADER, CALENDAR_ID);
		RestResponse response = new RestResponse();

		Test.startTest();
		GoogleApiWebhooksUtility.handleWebhookRequest(request, response);
		Test.stopTest();

		System.assertEquals(400, response.statusCode, 'Expected Bad Request without Token');
	}

	@isTest
	static void testWrongCalendarId() {
		RestRequest request = new RestRequest();
		request.headers.put(CALENDAR_ID_HEADER, CALENDAR_ID + 'abc');
		request.headers.put(TOKEN_HEADER, TOKEN);
		RestResponse response = new RestResponse();

		Test.startTest();
		GoogleApiWebhooksUtility.handleWebhookRequest(request, response);
		Test.stopTest();

		System.assertEquals(404, response.statusCode, 'Expected to not find non existent Calendar Id');
	}

	@isTest
	static void testWrongToken() {
		RestRequest request = new RestRequest();
		request.headers.put(CALENDAR_ID_HEADER, CALENDAR_ID);
		request.headers.put(TOKEN_HEADER, TOKEN + 'abc');
		RestResponse response = new RestResponse();

		Test.startTest();
		GoogleApiWebhooksUtility.handleWebhookRequest(request, response);
		Test.stopTest();

		System.assertEquals(401, response.statusCode, 'Expected to not authorize with invalid Token');
	}

	@isTest
	static void testValidConfiguration() {
		RestRequest request = new RestRequest();
		request.headers.put(CALENDAR_ID_HEADER, CALENDAR_ID);
		request.headers.put(TOKEN_HEADER, TOKEN);
		RestResponse response = new RestResponse();

		Test.startTest();
		GoogleApiWebhooksUtility.handleWebhookRequest(request, response);
		Test.stopTest();

		System.assertEquals(200, response.statusCode, 'Expected OK status code');

		EventSync__c eventSync = [SELECT ChangeFromGoogle__c FROM EventSync__c WHERE ResourceId__c = :CALENDAR_ID];

		System.assertNotEquals(null, eventSync, 'Expected event to exist');
		System.assertEquals(true, eventSync.ChangeFromGoogle__c, 'Expected Change From Google to be true');
	}
}
