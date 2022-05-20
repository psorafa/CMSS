@IsTest
private class CalendarSyncStatusControllerTest {
	@IsTest
	static void getUserCalendarSettingTest() {
		UserCalendarSetting__c setting = new UserCalendarSetting__c();
		setting.ResourceId__c = '1234';
		setting.SyncActive__c = true;
		setting.SyncToken__c = '1234';
		setting.User__c = UserInfo.getUserId();
		setting.UserCalendarID__c = '1234@kalendar.com';
		setting.WatchId__c = '1234';
		insert setting;

		Test.startTest();
		UserCalendarSetting__c actualUserSetting = CalendarSyncStatusController.getUserCalendarSetting();
		Test.stopTest();

		System.assertNotEquals(null, actualUserSetting);
		System.assertEquals('1234', actualUserSetting.ResourceId__c);
		System.assertEquals(true, actualUserSetting.SyncActive__c);
		System.assertEquals('1234@kalendar.com', actualUserSetting.UserCalendarID__c);
	}

	@IsTest
	static void validateCalendarConnectionTest() {
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(200, 'OK', '', null, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		Test.startTest();
		Boolean resp = CalendarSyncStatusController.validateCalendarConnection('calendar@id.com');
		Test.stopTest();

		System.assertEquals(true, resp);
	}

	@IsTest
	static void createWatchTest() {
		UserCalendarSetting__c setting = new UserCalendarSetting__c();
		setting.ResourceId__c = '1234';
		setting.SyncActive__c = true;
		setting.SyncToken__c = '1234';
		setting.User__c = UserInfo.getUserId();
		setting.UserCalendarID__c = '1234@kalendar.com';
		setting.WatchId__c = '1234';
		insert setting;

		GoogleCalendarSyncService.WatchResponse watchResp = new GoogleCalendarSyncService.WatchResponse();
		watchResp.expiration = 123456789;
		watchResp.id = '12345';
		watchResp.resourceId = 'ResourceId';
		watchResp.token = '12345';

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			JSON.serialize(watchResp),
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();
		CalendarSyncStatusController.createWatch(setting.Id);
		Test.stopTest();

		UserCalendarSetting__c updatedSetting = [
			SELECT WatchId__c, ResourceId__c
			FROM UserCalendarSetting__c
			WHERE Id = :setting.Id
		];
		System.assertEquals('12345', updatedSetting.WatchId__c);
		System.assertEquals('ResourceId', updatedSetting.ResourceId__c);
	}
}
