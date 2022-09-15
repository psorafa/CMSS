public with sharing class InitialCalendarSyncController {
	public static final Integer EVENT_DAY_OFFSET = 90;
	public static final Integer MAX_GOOGLE_EVENTS = 5000;
	private static final GoogleCalendarSyncService syncService = new GoogleCalendarSyncService();

	public static void sync(UserCalendarSetting__c calendarSetting) {
		List<Event> unsyncedEvents = new List<Event>();
		Map<String, Event> syncedEventsByGoogleId = new Map<String, Event>();

		List<Task> unsyncedTasks = new List<Task>();
		Map<String, Task> syncedTasksByGoogleId = new Map<String, Task>();

		Date cutoffDate = Date.today().addDays(-EVENT_DAY_OFFSET);
		DateTime cutoffDateTime = DateTime.newInstance(cutoffDate.year(), cutoffDate.month(), cutoffDate.day());

		List<Event> events = queryEvents(calendarSetting.User__c, cutoffDate, cutoffDateTime);
		for (Event event : events) {
			if (event.GoogleId__c != null) {
				syncedEventsByGoogleId.put(event.GoogleId__c, event);
			} else {
				unsyncedEvents.add(event);
			}
		}
		List<Task> tasks = queryTasks(calendarSetting.User__c, cutoffDate, cutoffDateTime);
		for (Task task : tasks) {
			if (task.GoogleId__c != null) {
				syncedTasksByGoogleId.put(task.GoogleId__c, task);
			} else {
				unsyncedTasks.add(task);
			}
		}
		List<GoogleCalendarSyncUtility.GoogleEventDTO> eventsFromGoogle = getEventsFromGoogle(
			calendarSetting,
			cutoffDateTime
		);
		processInitialSyncEvents(eventsFromGoogle, syncedEventsByGoogleId, syncedTasksByGoogleId, calendarSetting);
		unsyncedEvents.addAll(syncedEventsByGoogleId.values());
		insertNewSyncs(unsyncedEvents, unsyncedTasks);
	}

	private static List<GoogleCalendarSyncUtility.GoogleEventDTO> getEventsFromGoogle(
		UserCalendarSetting__c calendarSetting,
		DateTime cutoffDateTime
	) {
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
				return null;
			}
			newCutoffedEvents = filterEventsAccordingToCutoffDateTime(response.googleEvents, cutoffDateTime);
			if (newCutoffedEvents.size() + eventsFromGoogle.size() < 100000) {
				eventsFromGoogle.addAll(newCutoffedEvents);
			}
		}
		eventsFromGoogle.sort(); //sorts DESC by event start date
		List<GoogleCalendarSyncUtility.GoogleEventDTO> slicedEvents = new List<GoogleCalendarSyncUtility.GoogleEventDTO>();
		for (Integer i = 0; i < eventsFromGoogle.size(); i++) {
			if (i > MAX_GOOGLE_EVENTS) {
				continue;
			}
			slicedEvents.add(eventsFromGoogle[i]);
		}
		calendarSetting.SyncToken__c = response.nextSyncToken;
		calendarSetting.SyncActive__c = true;
		update calendarSetting;

		return slicedEvents;
	}

	@TestVisible
	private static void insertNewSyncs(List<Event> unsyncedEvents, List<Task> unsyncedTasks) {
		List<EventSync__c> newSyncs = new List<EventSync__c>();
		newSyncs.addAll(createEventSyncForEvents(unsyncedEvents));
		newSyncs.addAll(createEventSyncForTasks(unsyncedTasks));
		insert newSyncs;
	}

	private static List<EventSync__c> createEventSyncForEvents(List<Event> events) {
		List<EventSync__c> eventSyncs = new List<EventSync__c>();

		for (Event event : events) {
			EventSync__c eventSync = new EventSync__c();
			eventSync.GoogleEventId__c = null;
			eventSync.SFEventId__c = event.Id;
			eventSync.ChangeFromGoogle__c = false;
			eventSync.IsNew__c = true;
			eventSyncs.add(eventSync);
		}

		return eventSyncs;
	}

	private static List<EventSync__c> createEventSyncForTasks(List<Task> tasks) {
		List<EventSync__c> eventSyncs = new List<EventSync__c>();

		for (Task task : tasks) {
			eventSyncs.add(createEventSyncToCreateTaskInGoogle(task));
		}

		return eventSyncs;
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
		Map<String, Task> syncedTasksByGoogleId,
		UserCalendarSetting__c calendarSetting
	) {
		List<Event> newEventsFromGoogle = new List<Event>();
		List<Event> updatedEventsFromGoogle = new List<Event>();
		List<EventSync__c> updateSyncs = new List<EventSync__c>();

		for (GoogleCalendarSyncUtility.GoogleEventDTO googleEvent : eventsFromGoogle) {
			if (
				!syncedEventsByGoogleId.containsKey(googleEvent.id) &&
				!syncedTasksByGoogleId.containsKey(googleEvent.id)
			) {
				Event newEventFromGoogle = GoogleCalendarSyncUtility.getSFEventFromGoogleEvent(googleEvent, true);
				newEventFromGoogle.OwnerId = calendarSetting.User__c;
				newEventsFromGoogle.add(newEventFromGoogle);
			} else {
				if (syncedTasksByGoogleId.containsKey(googleEvent.id)) {
					Task sfTask = syncedTasksByGoogleId.get(googleEvent.id);
					updateSyncs.add(createEventSyncToUpdateTaskInGoogle(sfTask));
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

	private static EventSync__c createEventSyncToCreateTaskInGoogle(Task sfTask) {
		EventSync__c eventSync = new EventSync__c();
		eventSync.IsTask__c = true;
		eventSync.GoogleEventId__c = null;
		eventSync.SFTaskId__c = sfTask.Id;
		eventSync.ChangeFromGoogle__c = false;
		eventSync.IsNew__c = true;
		return eventSync;
	}

	private static EventSync__c createEventSyncToUpdateTaskInGoogle(Task sfTask) {
		EventSync__c eventSync = new EventSync__c();
		eventSync.IsTask__c = true;
		eventSync.GoogleEventId__c = sfTask.GoogleId__c;
		eventSync.SFTaskId__c = sfTask.Id;
		eventSync.ChangeFromGoogle__c = false;
		eventSync.IsNew__c = false;
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

	private static List<Task> queryTasks(Id ownerId, Date cutoffDate, DateTime cutoffDateTime) {
		List<FieldSetMember> fieldsToQuery = Schema.SobjectType.Task.fieldSets.CalendarSyncTaskFields.getFields();
		String query = 'SELECT ';
		for (FieldSetMember f : fieldsToQuery) {
			query += f.getFieldPath() + ', ';
		}
		query +=
			'Id, GoogleId__c, IsFromGoogle__c, ActivityLink__c ' +
			'FROM Task ' +
			'WHERE OwnerId = :ownerId ' +
			'AND ActivityDate > :cutoffDate ORDER BY ActivityDate DESC LIMIT 20000';

		return Database.query(query);
	}
	private static List<Event> queryEvents(Id ownerId, Date cutoffDate, DateTime cutoffDateTime) {
		List<FieldSetMember> fieldsToQuery = Schema.SobjectType.Event.fieldSets.CalendarSyncFields.getFields();
		String query = 'SELECT ';
		for (FieldSetMember f : fieldsToQuery) {
			query += f.getFieldPath() + ', ';
		}
		query +=
			'Id, GoogleId__c, IsFromGoogle__c, ActivityLink__c ' +
			'FROM Event ' +
			'WHERE OwnerId = :ownerId ' +
			'AND (ActivityDate > :cutoffDate OR StartDateTime > :cutoffDateTime) ORDER BY ActivityDate DESC LIMIT 20000';

		return Database.query(query);
	}
}
