@isTest
private class GoogleCalendarSyncTest {
	@isTest
	static void getAllEventsSuccessTest() {
		GoogleCalendarSyncService service = new GoogleCalendarSyncService();

		GoogleCalendarSyncUtility.GoogleEventRespDTO respFromGoogle = new GoogleCalendarSyncUtility.GoogleEventRespDTO();
		respFromGoogle.nextSyncToken = 'synctoken1235';
		GoogleCalendarSyncUtility.GoogleEventDTO event = new GoogleCalendarSyncUtility.GoogleEventDTO();
		event.eventType = 'default';
		event.start_x = new GoogleCalendarSyncUtility.GoogleDateDTO();
		event.start_x.dateTime_x = '2022-04-01T13:45:00+02:00';
		event.end_x = new GoogleCalendarSyncUtility.GoogleDateDTO();
		event.end_x.dateTime_x = '2022-04-02T13:45:00+02:00';
		event.summary = 'Úplněnovýeventík';
		event.created = '2022-04-01T10:29:58.000Z';
		event.status = 'confirmed';
		event.id = '697d2bkb35ei0m5hj53tg56d5v';
		respFromGoogle.items = new List<GoogleCalendarSyncUtility.GoogleEventDTO>{ event };

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			GoogleCalendarSyncUtility.placeReserved(JSON.serialize(respFromGoogle), new List<string>{ 'start', 'end' }),
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		GoogleCalendarSyncUtility.GoogleCalendarResponse resp = service.getAllEvents(
			'google@calendar.id',
			'randomsynctoken'
		);

		System.assertEquals(resp.googleEvents.size(), 1);
		System.assertEquals(resp.nextSyncToken, 'synctoken1235');
		System.assertEquals(resp.statusCode, 200);
	}

	@isTest
	static void getAllEventsNotFoundTest() {
		GoogleCalendarSyncService service = new GoogleCalendarSyncService();

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			404,
			'Not found',
			'"Body" : "null"',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		Test.startTest();
		GoogleCalendarSyncUtility.GoogleCalendarResponse resp = service.getAllEvents(
			'google@calendar.id',
			'randomsynctoken'
		);
		Test.stopTest();
		System.assertEquals(null, resp.events);
		System.assertEquals(404, resp.statusCode);
		System.assertEquals('Not found', resp.message);
	}

	@isTest
	static void getAllEventsErrorTest() {
		GoogleCalendarSyncService service = new GoogleCalendarSyncService();

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(200, 'OK', 'Weird body', null, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		Test.startTest();
		try {
			GoogleCalendarSyncUtility.GoogleCalendarResponse resp = service.getAllEvents(
				'google@calendar.id',
				'randomsynctoken'
			);
		} catch (Exception e) {
		}

		Test.stopTest();
	}

	@isTest
	static void getEventTest() {
		GoogleCalendarSyncService service = new GoogleCalendarSyncService();

		GoogleCalendarSyncUtility.GoogleEventRespDTO respFromGoogle = new GoogleCalendarSyncUtility.GoogleEventRespDTO();
		respFromGoogle.nextSyncToken = 'synctoken1235';
		GoogleCalendarSyncUtility.GoogleEventDTO event = new GoogleCalendarSyncUtility.GoogleEventDTO();
		event.eventType = 'default';
		event.start_x = new GoogleCalendarSyncUtility.GoogleDateDTO();
		event.start_x.dateTime_x = '2022-04-01T13:45:00+02:00';
		event.end_x = new GoogleCalendarSyncUtility.GoogleDateDTO();
		event.end_x.dateTime_x = '2022-04-02T13:45:00+02:00';
		event.summary = 'Úplněnovýeventík';
		event.created = '2022-04-01T10:29:58.000Z';
		event.status = 'confirmed';
		event.id = '697d2bkb35ei0m5hj53tg56d5v';
		respFromGoogle.items = new List<GoogleCalendarSyncUtility.GoogleEventDTO>{ event };

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			GoogleCalendarSyncUtility.placeReserved(JSON.serialize(respFromGoogle), new List<string>{ 'start', 'end' }),
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		GoogleCalendarSyncUtility.GoogleCalendarResponse resp = service.getEvent(
			'google@calendar.id',
			'697d2bkb35ei0m5hj53tg56d5v'
		);

		System.assertEquals(resp.events.size(), 1);
		System.assertEquals(resp.statusCode, 200);
		System.assertEquals(resp.message, 'OK');
	}

	@isTest
	static void createEventTest() {
		GoogleCalendarSyncService service = new GoogleCalendarSyncService();

		Event sfEvent = new Event();
		sfEvent.Subject = 'Vytvářenýeventík';
		sfEvent.IsPrivate = false;
		sfEvent.IsAllDayEvent = true;

		GoogleCalendarSyncUtility.GoogleEventDTO event = new GoogleCalendarSyncUtility.GoogleEventDTO();
		event.id = '123456';

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(200, 'OK', JSON.serialize(event), null, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		GoogleCalendarSyncUtility.GoogleCalendarResponse resp = service.createEvent('google@calendar.id', sfEvent);

		System.assertEquals(resp.statusCode, 200);
		System.assertEquals(resp.message, 'OK');
		System.assertEquals(resp.newEventId, '123456');
	}

	@isTest
	static void updateEventTest() {
		GoogleCalendarSyncService service = new GoogleCalendarSyncService();

		Event sfEvent = new Event();
		sfEvent.Subject = 'Updatovanýeventík';
		sfEvent.IsPrivate = false;
		sfEvent.IsAllDayEvent = true;

		GoogleCalendarSyncUtility.GoogleEventDTO event = new GoogleCalendarSyncUtility.GoogleEventDTO();

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			GoogleCalendarSyncUtility.placeReserved(JSON.serialize(event), new List<string>{ 'start', 'end' }),
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		GoogleCalendarSyncUtility.GoogleCalendarResponse resp = service.updateEvent(
			'google@calendar.id',
			sfEvent,
			'697d2bkb35ei0m5hj53tg56d5v'
		);

		System.assertEquals(resp.statusCode, 200);
		System.assertEquals(resp.message, 'OK');
	}

	@isTest
	static void deleteEventTest() {
		GoogleCalendarSyncService service = new GoogleCalendarSyncService();

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(200, 'OK', null, null, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		GoogleCalendarSyncUtility.GoogleCalendarResponse resp = service.deleteEvent(
			'google@calendar.id',
			'697d2bkb35ei0m5hj53tg56d5v'
		);

		System.assertEquals(resp.statusCode, 200);
		System.assertEquals(resp.message, 'OK');
	}

	@isTest
	static void hasAccessToCalendarTest() {
		GoogleCalendarSyncService service = new GoogleCalendarSyncService();

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(200, 'OK', null, null, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		Boolean resp = service.hasAccessToCalendar('google@calendar.id');

		System.assertEquals(resp, true);
	}

	@isTest
	static void hasNoAccessToCalendarTest() {
		GoogleCalendarSyncService service = new GoogleCalendarSyncService();

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(404, 'Not found', null, null, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		Boolean resp = service.hasAccessToCalendar('google@calendar.id');

		System.assertEquals(resp, false);
	}

	@isTest
	static void createWatchTest() {
		GoogleCalendarSyncService service = new GoogleCalendarSyncService();

		GoogleCalendarSyncService.WatchResponse mockResponse = new GoogleCalendarSyncService.WatchResponse();
		mockResponse.id = '12345';
		mockResponse.resourceId = '123456';
		mockResponse.token = '1234567';

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			JSON.serialize(mockResponse),
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		GoogleCalendarSyncService.WatchResponse resp = service.createWatch(
			'google@calendar.id',
			637889,
			'https://www.testaddress.com/'
		);

		System.assertEquals(resp.id, '12345');
		System.assertEquals(resp.resourceId, '123456');
		System.assertEquals(resp.token, '1234567');
	}

	@isTest
	static void stopWatchTest() {
		GoogleCalendarSyncService service = new GoogleCalendarSyncService();
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(200, 'OK', null, null, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		GoogleCalendarSyncUtility.GoogleCalendarResponse resp = service.stopWatch('google@calendar.id', 'resourceId');

		System.assertEquals(resp.statusCode, 200);
	}
}
