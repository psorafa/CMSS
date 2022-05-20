@isTest
class UserCalendarSettingTriggerHandlerTest {
	// tests whether sync token and sync active is updated
	@isTest
	static void testAfterInsertSyncTokenUpdate() {
		User u = TestDataFactory.getUser(new User());
		insert u;
		UserCalendarSetting__c setting = InitialCalendarSyncControllerTest.makeCalendarSetting(u.Id);
		UserCalendarSettingTriggerHandler.shouldNotRunAfterInsertTrigger();
		insert setting;
		UserCalendarSettingTriggerHandler.shouldRunAfterInsertTrigger();

		GoogleCalendarSyncUtility.GoogleEventRespDTO respFromGoogle = new GoogleCalendarSyncUtility.GoogleEventRespDTO();
		respFromGoogle.nextSyncToken = InitialCalendarSyncControllerTest.SYNC_TOKEN;
		respFromGoogle.items = new List<GoogleCalendarSyncUtility.GoogleEventDTO>{};
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			GoogleCalendarSyncUtility.placeReserved(JSON.serialize(respFromGoogle), new List<string>{ 'start', 'end' }),
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();
		UserCalendarSettingTriggerHandler.initialEventSync(new List<UserCalendarSetting__c>{ setting });
		Test.stopTest();

		setting = [SELECT Id, SyncToken__c, SyncActive__c FROM UserCalendarSetting__c WHERE Id = :setting.Id];
		System.assertEquals(InitialCalendarSyncControllerTest.SYNC_TOKEN, setting.SyncToken__c);
		System.assertEquals(true, setting.SyncActive__c);
	}
	// tests whether new event syncs are created for events that are not returned by Google
	@isTest
	static void testAfterInsertUnsynced() {
		User u = TestDataFactory.getUser(new User());
		insert u;
		UserCalendarSetting__c setting = InitialCalendarSyncControllerTest.makeCalendarSetting(u.Id);
		UserCalendarSettingTriggerHandler.shouldNotRunAfterInsertTrigger();
		insert setting;
		UserCalendarSettingTriggerHandler.shouldRunAfterInsertTrigger();

		List<Event> events = InitialCalendarSyncControllerTest.makeUnsyncedEvents(u.Id);
		insert events;

		GoogleCalendarSyncUtility.GoogleEventRespDTO respFromGoogle = new GoogleCalendarSyncUtility.GoogleEventRespDTO();
		respFromGoogle.nextSyncToken = InitialCalendarSyncControllerTest.SYNC_TOKEN;
		respFromGoogle.items = new List<GoogleCalendarSyncUtility.GoogleEventDTO>{};
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			GoogleCalendarSyncUtility.placeReserved(JSON.serialize(respFromGoogle), new List<string>{ 'start', 'end' }),
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		List<EventSync__c> eventSyncsBefore = [
			SELECT Id, GoogleEventId__c, SFEventID__c, ChangeFromGoogle__c, IsNew__c
			FROM EventSync__c
		];
		delete eventSyncsBefore;
		Test.startTest();
		UserCalendarSettingTriggerHandler.initialEventSync(new List<UserCalendarSetting__c>{ setting });
		Test.stopTest();

		List<EventSync__c> eventSyncs = [
			SELECT Id, GoogleEventId__c, SFEventID__c, ChangeFromGoogle__c, IsNew__c
			FROM EventSync__c
		];

		System.assertEquals(2, eventSyncs.size(), '2 unsynced events were inserted, expected 2 event syncs');
		System.assert(eventSyncs.get(0).SFEventID__c != eventSyncs.get(1).SFEventID__c);
		for (EventSync__c event : eventSyncs) {
			System.assertEquals(null, event.GoogleEventId__C);
			System.assertEquals(false, event.ChangeFromGoogle__c);
			System.assertEquals(true, event.IsNew__c);
		}
	}

	@isTest
	static void testBeforeUpdate() {
		UserCalendarSetting__c setting = new UserCalendarSetting__c();
		setting.SyncActive__c = true;
		setting.WatchId__c = 'abc';
		setting.ResourceId__c = 'def';
		setting.WatchExpirationDateTime__c = DateTime.newInstance(2022, 4, 15);

		List<UserCalendarSetting__c> oldSettings = new List<UserCalendarSetting__c>();
		oldSettings.add(setting);

		Map<Id, UserCalendarSetting__c> newSettingsMap = new Map<Id, UserCalendarSetting__c>();
		UserCalendarSetting__c newSetting = setting.clone(true, true);
		newSetting.SyncActive__c = false;
		newSettingsMap.put(newSetting.Id, newSetting);

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(200, 'OK', null, null, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		Test.startTest();
		UserCalendarSettingTriggerHandler.stopWatchingUpdate(oldSettings, newSettingsMap);
		Test.stopTest();

		System.assertEquals(null, newSetting.WatchId__c, 'Watch Id should be removed when stopping watching');
		System.assertEquals(
			null,
			newSetting.WatchExpirationDateTime__c,
			'Watch Expiration should be removed when stopping watching'
		);
	}

	@isTest
	static void testInitialEventSync() {
	}
}
