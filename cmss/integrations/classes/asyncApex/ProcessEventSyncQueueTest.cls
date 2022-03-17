@isTest
class ProcessEventSyncQueueTest {
	@TestSetup
	static void makeData() {
		Event newEvent = new Event();
		newEvent.GoogleId__c = 'eventId3';
		newEvent.StartDateTime = system.today();
		newEvent.EndDateTime = system.today() + 5;

		Event eventToDelete = new Event();
		eventToDelete.GoogleId__c = 'eventId2';
		eventToDelete.StartDateTime = system.today();
		eventToDelete.EndDateTime = system.today() + 5;
		insert new List<Event>{ newEvent, eventToDelete };

		User testUser = TestDataFactory.getUser(new User());
		insert testUser;

		UserCalendarSetting__c setting = new UserCalendarSetting__c();
		setting.ResourceId__c = '12345';
		setting.UserCalendarID__c = 'user@calendar.id';
		setting.SyncActive__c = true;
		setting.SyncToken__c = '12345Token';
		setting.User__c = testUser.Id;
		insert setting;
	}

	@isTest
	static void changeInGoogleTest() {
		EventSync__c eventSyncChangeInGoogle = new EventSync__c();
		eventSyncChangeInGoogle.ChangeFromGoogle__c = true;
		eventSyncChangeInGoogle.ResourceId__c = '12345';
		insert eventSyncChangeInGoogle;

		GoogleCalendarSyncUtility.GoogleEventRespDTO respFromGoogle = new GoogleCalendarSyncUtility.GoogleEventRespDTO();
		respFromGoogle.nextSyncToken = 'synctoken1235';
		respFromGoogle.items = new List<GoogleCalendarSyncUtility.GoogleEventDTO>{
			createNewGoogleEvent(
				'2022-04-01T13:45:00+02:00',
				'2022-04-02T13:45:00+02:00',
				'Úplně nový eventík',
				'confirmed',
				'eventId1'
			),
			createNewGoogleEvent(
				'2022-04-01T13:45:00+02:00',
				'2022-04-02T13:45:00+02:00',
				'Odstraněný eventík',
				'cancelled',
				'eventId2'
			),
			createNewGoogleEvent(
				'2022-04-01T13:45:00+02:00',
				'2022-04-02T13:45:00+02:00',
				'Existující eventík',
				'confirmed',
				'eventId3'
			)
		};
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			GoogleCalendarSyncUtility.placeReserved(JSON.serialize(respFromGoogle), new List<string>{ 'start', 'end' }),
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		List<Event> eventsBefore = [SELECT Id, Subject FROM Event];
		Test.startTest();
		System.enqueueJob(new ProcessEventSyncQueue());
		Test.stopTest();

		List<Event> eventsAfter = [SELECT Id, Subject FROM Event];
		Event changedEvent = [SELECT Id, Subject FROM Event WHERE GoogleId__c = 'eventId3'];

		System.assertEquals(eventsBefore.size(), eventsAfter.size());
		System.assertEquals(changedEvent.Subject, 'Existující eventík');
	}

	@isTest
	static void deletedInSalesforceTest() {
		EventSync__c eventSyncDeletedInSF = new EventSync__c();
		eventSyncDeletedInSF.GoogleEventId__c = 'eventId2';
		eventSyncDeletedInSF.ResourceId__c = '12345';
		eventSyncDeletedInSF.IsDeleted__c = true;
		insert eventSyncDeletedInSF;
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(200, 'OK', '', null, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();
		System.enqueueJob(new ProcessEventSyncQueue());
		Test.stopTest();
	}

	@isTest
	static void updatedInSalesforceTest() {
		EventSync__c eventSyncUpdateInSF = new EventSync__c();
		eventSyncUpdateInSF.GoogleEventId__c = 'eventId3';
		eventSyncUpdateInSF.SFEventId__c = [SELECT Id FROM Event WHERE GoogleId__c = 'eventId3'].Id;
		eventSyncUpdateInSF.ResourceId__c = '12345';
		insert eventSyncUpdateInSF;

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(200, 'OK', '', null, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();
		System.enqueueJob(new ProcessEventSyncQueue());
		Test.stopTest();
	}

	@isTest
	static void newInSalesforceTest() {
		EventSync__c eventSyncNewInSF = new EventSync__c();
		eventSyncNewInSF.SFEventId__c = [SELECT Id FROM Event WHERE GoogleId__c = 'eventId3'].Id;
		eventSyncNewInSF.ResourceId__c = '12345';
		eventSyncNewInSF.IsNew__c = true;
		insert eventSyncNewInSF;
		GoogleCalendarSyncUtility.GoogleEventDTO respEvent = createNewGoogleEvent(
			'2022-04-01T13:45:00+02:00',
			'2022-04-02T13:45:00+02:00',
			'Nový event',
			'confirmed',
			'eventId4'
		);
		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			JSON.serialize(respEvent),
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();
		System.enqueueJob(new ProcessEventSyncQueue());
		Test.stopTest();
		Event event = [SELECT Id FROM Event WHERE GoogleId__c = 'eventId4' LIMIT 1];

		System.assertNotEquals(null, event);
	}

	@isTest
	static void coverApiErrors() {
		ProcessEventSyncQueue queue = new ProcessEventSyncQueue();
		UserCalendarSetting__c settings = [
			SELECT Id, User__c, ResourceId__c, UserCalendarID__c, SyncToken__c
			FROM UserCalendarSetting__c
			WHERE UserCalendarID__c = 'user@calendar.id'
		];
		GoogleCalendarSyncUtility.GoogleCalendarResponse response1 = new GoogleCalendarSyncUtility.GoogleCalendarResponse(
			200,
			''
		);
		GoogleCalendarSyncUtility.GoogleCalendarResponse response2 = new GoogleCalendarSyncUtility.GoogleCalendarResponse(
			401,
			''
		);
		GoogleCalendarSyncUtility.GoogleCalendarResponse response3 = new GoogleCalendarSyncUtility.GoogleCalendarResponse(
			403,
			''
		);
		GoogleCalendarSyncUtility.GoogleCalendarResponse response4 = new GoogleCalendarSyncUtility.GoogleCalendarResponse(
			404,
			''
		);
		GoogleCalendarSyncUtility.GoogleCalendarResponse response5 = new GoogleCalendarSyncUtility.GoogleCalendarResponse(
			410,
			''
		);
		GoogleCalendarSyncUtility.GoogleCalendarResponse response6 = new GoogleCalendarSyncUtility.GoogleCalendarResponse(
			500,
			''
		);
		queue.handleApiErrors(response1, settings);
		queue.handleApiErrors(response2, settings);
		queue.handleApiErrors(response3, settings);
		queue.handleApiErrors(response4, settings);
		queue.handleApiErrors(response5, settings);
		queue.handleApiErrors(response6, settings);
	}

	static GoogleCalendarSyncUtility.GoogleEventDTO createNewGoogleEvent(
		String startDateTime,
		String endDateTime,
		String summary,
		String status,
		String eventId
	) {
		GoogleCalendarSyncUtility.GoogleEventDTO googleEventDTO = new GoogleCalendarSyncUtility.GoogleEventDTO();
		googleEventDTO.eventType = 'default';
		googleEventDTO.start_x = new GoogleCalendarSyncUtility.GoogleDateDTO();
		googleEventDTO.start_x.dateTime_x = startDateTime;
		googleEventDTO.end_x = new GoogleCalendarSyncUtility.GoogleDateDTO();
		googleEventDTO.end_x.dateTime_x = endDateTime;
		googleEventDTO.summary = summary;
		googleEventDTO.created = '2022-04-01T10:29:58.000Z';
		googleEventDTO.status = status;
		googleEventDTO.id = eventId;
		return googleEventDTO;
	}
}
