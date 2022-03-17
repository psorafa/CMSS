public with sharing class InitialCalendarSyncController {
	public static final Integer EVENT_DAY_OFFSET = 90;
	private static final GoogleCalendarSyncService syncService = new GoogleCalendarSyncService();

	public static void sync(UserCalendarSetting__c calendarSetting) {
		List<Event> unsyncedEvents = new List<Event>();
		Map<String, Event> syncedEventsByGoogleId = new Map<String, Event>();

		Date cutoffDate = Date.today().addDays(-EVENT_DAY_OFFSET);
		DateTime cutoffDateTime = DateTime.newInstance(cutoffDate.year(), cutoffDate.month(), cutoffDate.day());

		List<Event> events = queryEvents(calendarSetting.OwnerId, cutoffDate, cutoffDateTime);
		for (Event event : events) {
			if (event.GoogleId__c != null) {
				syncedEventsByGoogleId.put(event.GoogleId__c, event);
			} else {
				unsyncedEvents.add(event);
			}
		}

		GoogleCalendarSyncUtility.GoogleCalendarResponse response = syncService.getAllEvents(
			calendarSetting.UserCalendarId__c,
			null
		);
		List<GoogleCalendarSyncUtility.GoogleEventDTO> eventsFromGoogle = filterEventsAccordingToCutoffDateTime(
			response.googleEvents,
			cutoffDateTime
		);
		List<GoogleCalendarSyncUtility.GoogleEventDTO> newCutoffedEvents;
		String nextPageToken = response?.nextPageToken;
		while (response?.nextSyncToken == null && nextPageToken != null) {
			response = syncService.getAllEventsNextPage(calendarSetting.UserCalendarId__c, nextPageToken);
			nextPageToken = response?.nextPageToken;
			if (response.statusCode == 404) {
				calendarSetting.SyncActive__c = false;
				update calendarSetting;
				return;
			}
			newCutoffedEvents = filterEventsAccordingToCutoffDateTime(response.googleEvents, cutoffDateTime);
			if (newCutoffedEvents.size() + eventsFromGoogle.size() < 10000) {
				eventsFromGoogle.addAll(newCutoffedEvents);
			}
		}

		processInitialSyncEvents(eventsFromGoogle, syncedEventsByGoogleId, calendarSetting);

		calendarSetting.SyncToken__c = response.nextSyncToken;
		calendarSetting.SyncActive__c = true;
		update calendarSetting;
		unsyncedEvents.addAll(syncedEventsByGoogleId.values());
		createEventSyncForEvents(unsyncedEvents);
	}

	private static void createEventSyncForEvents(List<Event> events) {
		List<EventSync__c> eventSyncs = new List<EventSync__c>();

		for (Event event : events) {
			EventSync__c eventSync = new EventSync__c();
			eventSync.GoogleEventId__c = null;
			eventSync.SFEventId__c = event.Id;
			eventSync.ChangeFromGoogle__c = false;
			eventSync.IsNew__c = true;
			eventSyncs.add(eventSync);
		}

		insert eventSyncs;
	}

	private static DateTime createCurrentCutoffDateTime() {
		Date cutoffDate = Date.today().addDays(-EVENT_DAY_OFFSET);
		return DateTime.newInstance(cutoffDate.year(), cutoffDate.month(), cutoffDate.day());
	}

	private static List<GoogleCalendarSyncUtility.GoogleEventDTO> filterEventsAccordingToCutoffDateTime(
		List<GoogleCalendarSyncUtility.GoogleEventDTO> googleEvents,
		DateTime cutoffDateTime
	) {
		List<GoogleCalendarSyncUtility.GoogleEventDTO> filtered = new List<GoogleCalendarSyncUtility.GoogleEventDTO>();
		if (googleEvents == null) {
			return filtered;
		}
		for (GoogleCalendarSyncUtility.GoogleEventDTO event : googleEvents) {
			if (
				event.start_x?.date_x > cutoffDateTime ||
				GoogleCalendarSyncUtility.getDateTimeFromGoogleFormat(event.start_x?.dateTime_x) > cutoffDateTime
			) {
				filtered.add(event);
			}
		}
		return filtered;
	}

	private static void processInitialSyncEvents(
		List<GoogleCalendarSyncUtility.GoogleEventDTO> eventsFromGoogle,
		Map<String, Event> syncedEventsByGoogleId,
		UserCalendarSetting__c calendarSetting
	) {
		List<Event> newEventsFromGoogle = new List<Event>();
		List<Event> updatedEventsFromGoogle = new List<Event>();
		List<EventSync__c> updateSyncs = new List<EventSync__c>();

		for (GoogleCalendarSyncUtility.GoogleEventDTO googleEvent : eventsFromGoogle) {
			if (!syncedEventsByGoogleId.containsKey(googleEvent.id)) {
				Event newEventFromGoogle = GoogleCalendarSyncUtility.getSFEventFromGoogleEvent(googleEvent, true);
				newEventFromGoogle.OwnerId = calendarSetting.User__c;
				newEventsFromGoogle.add(newEventFromGoogle);
			} else {
				Event sfEvent = syncedEventsByGoogleId.get(googleEvent.id);
				syncedEventsByGoogleId.remove(googleEvent.id);
				if (sfEvent.IsFromGoogle__c) {
					if (
						compareAndUpdateEvent(
							GoogleCalendarSyncUtility.getSFEventFromGoogleEvent(googleEvent, true),
							sfEvent
						)
					) {
						updatedEventsFromGoogle.add(sfEvent);
					}
				} else if (
					compareAndUpdateEvent(
						sfEvent,
						GoogleCalendarSyncUtility.getSFEventFromGoogleEvent(googleEvent, false)
					)
				) {
					updateSyncs.add(createEventSyncToUpdateEventInGoogle(sfEvent));
				}
			}
		}

		insert updateSyncs;
		insert newEventsFromGoogle;
		update updatedEventsFromGoogle;
	}

	private static EventSync__c createEventSyncToUpdateEventInGoogle(Event sfEvent) {
		EventSync__c eventSync = new EventSync__c();
		eventSync.GoogleEventId__c = sfEvent.GoogleId__c == null ? null : sfEvent.GoogleId__c;
		eventSync.SFEventId__c = sfEvent.Id;
		eventSync.ChangeFromGoogle__c = false;
		return eventSync;
	}

	private static boolean compareAndUpdateEvent(Event source, Event dest) {
		List<FieldSetMember> fieldsToCheck = Schema.SobjectType.Event.fieldSets.CalendarSyncFields.getFields();
		boolean changed = false;

		for (FieldSetMember fieldSetMember : fieldsToCheck) {
			SObjectField field = fieldSetMember.getSObjectField();
			if (source.get(field) != dest.get(field)) {
				changed = true;
				dest.put(field, source.get(field));
			}
		}

		return changed;
	}

	private static List<Event> queryEvents(Id ownerId, Date cutoffDate, DateTime cutoffDateTime) {
		List<FieldSetMember> fieldsToQuery = Schema.SobjectType.Event.fieldSets.CalendarSyncFields.getFields();
		String query = 'SELECT ';
		for (FieldSetMember f : fieldsToQuery) {
			query += f.getFieldPath() + ', ';
		}
		query +=
			'Id, GoogleId__c, IsFromGoogle__c, ActivityLink__c ' +
			'FROM EVENT ' +
			'WHERE OwnerId = :ownerId ' +
			'AND (ActivityDate > :cutoffDate OR StartDateTime > :cutoffDateTime) ORDER BY ActivityDate DESC LIMIT 50000';

		System.debug(query);
		return Database.query(query);
	}
}
