@IsTest
public class UpdateUserCalendarSettings_BatchTest {
	@testSetup
	static void setup() {
		// Create test data
		List<UserCalendarSetting__c> testUcs = new List<UserCalendarSetting__c>();
		User user = TestDataFactory.getUser(new User(AgentId__c = 'UA18439'));

		for (Integer i = 0; i < 2; i++) {
			testUcs.add(
				new UserCalendarSetting__c(
					SyncActive__c = true,
					User__c = user.Id,
					UserCalendarID__c = '123456',
					WatchExpirationDateTime__c = Date.valueOf('2022-04-10'),
					WatchId__c = '12345'
				)
			);
		}
		insert testUcs;
	}

	@IsTest
	private static void updateUserCalendarSettings() {
		UpdateUserCalendarSettings_Batch batch = new UpdateUserCalendarSettings_Batch();

		Test.startTest();
		GoogleCalendarSyncService.WatchResponse mockResponse = new GoogleCalendarSyncService.WatchResponse();
		mockResponse.id = '12345';
		mockResponse.resourceId = '123456';
		mockResponse.token = '1234567';
		mockResponse.expiration = ((Long) ((Datetime) System.Today().addMonths(1)).getTime());

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			JSON.serialize(mockResponse),
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Database.executeBatch(batch);
		Test.stopTest();

		UserCalendarSetting__c ucs = [
			SELECT WatchId__c, WatchExpirationDateTime__c
			FROM UserCalendarSetting__c
			WHERE UserCalendarID__c = '123456'
			LIMIT 1
		];

		System.assertEquals('12345', ucs.WatchId__c, 'Not expected WatchId__c found');
		System.assertEquals(
			System.Today().addMonths(1),
			ucs.WatchExpirationDateTime__c,
			'Not expected WatchExpirationDateTime__c found'
		);
	}

	@IsTest
	static void getPushNotificationsSiteUrlTest() {
		Test.startTest();
		String pushNotificationsSiteUrl = UpdateUserCalendarSettings_Batch.getPushNotificationsSiteUrl();
		Test.stopTest();

		System.assertEquals('', pushNotificationsSiteUrl);
	}
}
