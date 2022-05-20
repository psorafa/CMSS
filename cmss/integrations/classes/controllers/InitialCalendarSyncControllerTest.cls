@isTest
public class InitialCalendarSyncControllerTest {
	public final static String SYNC_TOKEN = 'someSyncToken';
	final static String GOOGLE_CALENDAR_ID = 'someCalendarId';
	final static String GOOGLE_EVENT_ID1 = 'someGoogleEventId1';
	final static String GOOGLE_EVENT_ID2 = 'someGoogleEventId2';

	final static Date ACTIVITY_DATE = Date.today().addDays(-(InitialCalendarSyncController.EVENT_DAY_OFFSET - 1));
	final static Date NEW_ACTIVITY_DATE = Date.today().addDays(-(InitialCalendarSyncController.EVENT_DAY_OFFSET - 2));
	final static Date OLD_ACTIVITY_DATE = Date.today().addDays(-(InitialCalendarSyncController.EVENT_DAY_OFFSET + 1));
	final static DateTime ACTIVITY_DATE_TIME = DateTime.newInstance(
		ACTIVITY_DATE.year(),
		ACTIVITY_DATE.month(),
		ACTIVITY_DATE.day()
	);
	final static DateTime OLD_ACTIVITY_DATE_TIME = DateTime.newInstance(
		OLD_ACTIVITY_DATE.year(),
		OLD_ACTIVITY_DATE.month(),
		OLD_ACTIVITY_DATE.day()
	);
	final static DateTime DATE_TIME_NOW = DateTime.now();
	final static String ACTIVITY_DATE_TIME_STRING = ACTIVITY_DATE_TIME.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
	final static String OLD_ACTIVITY_DATE_TIME_STRING = OLD_ACTIVITY_DATE_TIME.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
	final static String DATE_TIME_NOW_STRING = DATE_TIME_NOW.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');

	// tests whether new events from google are as event syncs and ignores an old event
	@isTest
	static void syncNewEventsFromGoogleTest() {
		User u = TestDataFactory.getUser(new User());
		insert u;
		UserCalendarSetting__c setting = makeCalendarSetting(u.Id);
		UserCalendarSettingTriggerHandler.shouldNotRunAfterInsertTrigger();
		insert setting;
		UserCalendarSettingTriggerHandler.shouldRunAfterInsertTrigger();

		GoogleCalendarSyncUtility.GoogleEventRespDTO respFromGoogle = new GoogleCalendarSyncUtility.GoogleEventRespDTO();
		respFromGoogle.nextSyncToken = SYNC_TOKEN;
		GoogleCalendarSyncUtility.GoogleEventDTO event1 = new GoogleCalendarSyncUtility.GoogleEventDTO();
		event1.eventType = 'default';
		event1.start_x = new GoogleCalendarSyncUtility.GoogleDateDTO();
		event1.start_x.dateTime_x = ACTIVITY_DATE_TIME_STRING;
		event1.end_x = new GoogleCalendarSyncUtility.GoogleDateDTO();
		event1.end_x.dateTime_x = ACTIVITY_DATE_TIME_STRING;
		event1.summary = 'Úplněnovýeventík';
		event1.created = ACTIVITY_DATE_TIME_STRING;
		event1.status = 'confirmed';
		event1.id = GOOGLE_EVENT_ID1;
		GoogleCalendarSyncUtility.GoogleEventDTO event2 = new GoogleCalendarSyncUtility.GoogleEventDTO();
		event2.eventType = 'default';
		event2.start_x = new GoogleCalendarSyncUtility.GoogleDateDTO();
		event2.start_x.dateTime_x = OLD_ACTIVITY_DATE_TIME_STRING;
		event2.end_x = new GoogleCalendarSyncUtility.GoogleDateDTO();
		event2.end_x.dateTime_x = OLD_ACTIVITY_DATE_TIME_STRING;
		event2.summary = 'Úplněnovýeventík';
		event2.created = OLD_ACTIVITY_DATE_TIME_STRING;
		event2.status = 'confirmed';
		event2.id = GOOGLE_EVENT_ID2;
		respFromGoogle.items = new List<GoogleCalendarSyncUtility.GoogleEventDTO>{ event1, event2 };

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			GoogleCalendarSyncUtility.placeReserved(JSON.serialize(respFromGoogle), new List<string>{ 'start', 'end' }),
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		Test.startTest();
		InitialCalendarSyncController.sync(setting);
		Test.stopTest();

		List<Event> events = [SELECT ID, GoogleId__c, StartDateTime FROM EVENT ORDER BY GoogleId__c];
		System.assertEquals(1, events.size(), 'only 1 event should be inserted, the other one is outdated');
		System.assertEquals(GOOGLE_EVENT_ID1, events.get(0).GoogleId__c);
		System.assertEquals(ACTIVITY_DATE_TIME, events.get(0).StartDateTime);
	}

	// tests whether Events from Google are handled correctly when there is no change or Google has an update
	// todo check if activityDate and EndDate should be part of field set and be updated
	@isTest
	static void syncSyncedEventsFromGoogleTest() {
		User u = TestDataFactory.getUser(new User());
		insert u;
		UserCalendarSetting__c setting = makeCalendarSetting(u.Id);
		UserCalendarSettingTriggerHandler.shouldNotRunAfterInsertTrigger();
		insert setting;
		UserCalendarSettingTriggerHandler.shouldRunAfterInsertTrigger();

		List<Event> events = makeSyncedEvents(u.Id);
		insert events;

		GoogleCalendarSyncUtility.GoogleEventRespDTO respFromGoogle = new GoogleCalendarSyncUtility.GoogleEventRespDTO();
		respFromGoogle.nextSyncToken = SYNC_TOKEN;
		GoogleCalendarSyncUtility.GoogleEventDTO event1 = new GoogleCalendarSyncUtility.GoogleEventDTO();
		event1.eventType = 'default';
		event1.start_x = new GoogleCalendarSyncUtility.GoogleDateDTO();
		event1.start_x.dateTime_x = ACTIVITY_DATE_TIME_STRING;
		event1.end_x = new GoogleCalendarSyncUtility.GoogleDateDTO();
		event1.end_x.dateTime_x = ACTIVITY_DATE_TIME_STRING;
		event1.summary = 'Úplněnovýeventík';
		event1.created = ACTIVITY_DATE_TIME_STRING;
		event1.status = 'confirmed';
		event1.id = GOOGLE_EVENT_ID1;
		GoogleCalendarSyncUtility.GoogleEventDTO event2 = new GoogleCalendarSyncUtility.GoogleEventDTO();
		event2.eventType = 'default';
		event2.start_x = new GoogleCalendarSyncUtility.GoogleDateDTO();
		event2.start_x.dateTime_x = ACTIVITY_DATE_TIME_STRING;
		event2.end_x = new GoogleCalendarSyncUtility.GoogleDateDTO();
		event2.end_x.dateTime_x = ACTIVITY_DATE_TIME_STRING;
		event2.summary = 'Úplněnovýeventík';
		event2.created = ACTIVITY_DATE_TIME_STRING;
		event2.status = 'confirmed';
		event2.id = GOOGLE_EVENT_ID2;
		respFromGoogle.items = new List<GoogleCalendarSyncUtility.GoogleEventDTO>{ event1, event2 };

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			GoogleCalendarSyncUtility.placeReserved(
				JSON.serialize(respFromGoogle),
				new List<string>{ 'start', 'end', 'date', 'dateTime' }
			),
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		Test.startTest();
		InitialCalendarSyncController.sync(setting);
		Test.stopTest();

		events = [SELECT ID, GoogleId__c, StartDateTime, ActivityDate, IsAllDayEvent FROM EVENT ORDER BY GoogleId__c];
		System.assertEquals(2, events.size(), 'no event should be added or removed');
		System.assertEquals(GOOGLE_EVENT_ID1, events.get(0).GoogleId__c);
		System.assertEquals(false, events.get(0).IsAllDayEvent);
		System.assertEquals(ACTIVITY_DATE_TIME, events.get(0).StartDateTime);
		System.assertEquals(GOOGLE_EVENT_ID2, events.get(1).GoogleId__c);
		System.assertEquals(false, events.get(1).IsAllDayEvent);
		System.assertEquals(ACTIVITY_DATE_TIME, events.get(1).StartDateTime);
	}

	// tests whether sync token and sync active is updated
	@isTest
	static void syncUpdatesSyncTokenTest() {
		User u = TestDataFactory.getUser(new User());
		insert u;
		UserCalendarSetting__c setting = makeCalendarSetting(u.Id);
		UserCalendarSettingTriggerHandler.shouldNotRunAfterInsertTrigger();
		insert setting;
		UserCalendarSettingTriggerHandler.shouldRunAfterInsertTrigger();

		GoogleCalendarSyncUtility.GoogleEventRespDTO respFromGoogle = new GoogleCalendarSyncUtility.GoogleEventRespDTO();
		respFromGoogle.nextSyncToken = SYNC_TOKEN;
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
		InitialCalendarSyncController.sync(setting);
		Test.stopTest();

		setting = [SELECT Id, SyncToken__c, SyncActive__c FROM UserCalendarSetting__c WHERE Id = :setting.Id];
		System.assertEquals(SYNC_TOKEN, setting.SyncToken__c);
		System.assertEquals(true, setting.SyncActive__c);
	}

	// tests whether new event syncs are created for events that are not returned by Google
	@isTest
	static void syncUnsyncedEventsTest() {
		User u = TestDataFactory.getUser(new User());
		insert u;
		UserCalendarSetting__c setting = makeCalendarSetting(u.Id);
		UserCalendarSettingTriggerHandler.shouldNotRunAfterInsertTrigger();
		insert setting;
		UserCalendarSettingTriggerHandler.shouldRunAfterInsertTrigger();

		List<Event> events = makeUnsyncedEvents(u.Id);
		for (Event e : events) {
			e.IsFromGoogle__c = true;
		}
		insert events;

		GoogleCalendarSyncUtility.GoogleEventRespDTO respFromGoogle = new GoogleCalendarSyncUtility.GoogleEventRespDTO();
		respFromGoogle.nextSyncToken = SYNC_TOKEN;
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
		InitialCalendarSyncController.sync(setting);
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
	static void testMultipagedSyncFromGoogle() {
		User u = TestDataFactory.getUser(new User());
		insert u;
		UserCalendarSetting__c setting = makeCalendarSetting(u.Id);
		UserCalendarSettingTriggerHandler.shouldNotRunAfterInsertTrigger();
		insert setting;
		UserCalendarSettingTriggerHandler.shouldRunAfterInsertTrigger();

		GoogleCalendarSyncUtility.GoogleEventRespDTO respFromGoogle = new GoogleCalendarSyncUtility.GoogleEventRespDTO();
		respFromGoogle.nextPageToken = SYNC_TOKEN;
		respFromGoogle.items = new List<GoogleCalendarSyncUtility.GoogleEventDTO>{};
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			404,
			'Not found',
			GoogleCalendarSyncUtility.placeReserved(JSON.serialize(respFromGoogle), new List<string>{ 'start', 'end' }),
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();
		try {
			InitialCalendarSyncController.sync(setting);
		} catch (Exception calloutsLimitException) {
			System.assertNotEquals(
				null,
				calloutsLimitException,
				'GetGoogleEvents should be called repetively if the nextPageToken is filled'
			);
		}
		Test.stopTest();
	}

	@isTest
	static void insertNewSyncsTest() {
		User u = TestDataFactory.getUser(new User());
		insert u;
		List<Event> events = makeUnsyncedEvents(u.Id);
		List<Task> tasks = new List<Task>();
		tasks.add(new Task(OwnerId = u.Id, Subject = 'New task'));

		Test.startTest();
		InitialCalendarSyncController.insertNewSyncs(events, tasks);
		Test.stopTest();

		List<EventSync__c> syncs = [SELECT Id FROM EventSync__c];
		System.assertEquals(3, syncs.size());
	}

	public static UserCalendarSetting__c makeCalendarSetting(Id userId) {
		UserCalendarSetting__c setting = new UserCalendarSetting__c();

		setting.UserCalendarId__c = GOOGLE_CALENDAR_ID;
		setting.OwnerId = userId;
		setting.User__c = userId;

		return setting;
	}

	public static List<Event> makeSyncedEvents(Id userId) {
		Event e1 = new Event();
		e1.OwnerId = userId;
		e1.IsAllDayEvent = true;
		e1.DurationInMinutes = 60;
		e1.ActivityDate = ACTIVITY_DATE;
		e1.ActivityDateTime = ACTIVITY_DATE_TIME;
		e1.GoogleId__c = GOOGLE_EVENT_ID1;

		Event e2 = new Event();
		e2.OwnerId = userId;
		e1.IsAllDayEvent = false;
		e2.DurationInMinutes = 60;
		e2.StartDateTime = ACTIVITY_DATE_TIME;
		e2.GoogleId__c = GOOGLE_EVENT_ID2;

		return new List<Event>{ e1, e2 };
	}

	public static List<Event> makeUnsyncedEvents(Id userId) {
		Event e1 = new Event();
		e1.OwnerId = userId;
		e1.IsAllDayEvent = true;
		e1.DurationInMinutes = 60;
		e1.ActivityDate = ACTIVITY_DATE;
		e1.ActivityDateTime = ACTIVITY_DATE_TIME;

		Event e2 = new Event();
		e2.OwnerId = userId;
		e1.IsAllDayEvent = false;
		e2.DurationInMinutes = 60;
		e2.StartDateTime = ACTIVITY_DATE_TIME;

		return new List<Event>{ e1, e2 };
	}
}
