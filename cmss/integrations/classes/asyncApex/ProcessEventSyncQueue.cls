public without sharing class ProcessEventSyncQueue implements Queueable, Database.AllowsCallouts, Finalizer {
	private List<Event> eventsToCreate;
	private Map<Id, Event> eventsToUpdate;
	private Map<Id, Event> eventsToDelete;
	private Map<Id, UserCalendarSetting__c> calendarSettingsToUpdate;

	public ProcessEventSyncQueue() {
		this.eventsToCreate = new List<Event>();
		this.eventsToUpdate = new Map<Id, Event>();
		this.eventsToDelete = new Map<Id, Event>();
		this.calendarSettingsToUpdate = new Map<Id, UserCalendarSetting__c>();
	}

	public void execute(System.FinalizerContext fc) {
		if ([SELECT Id FROM EventSync__c LIMIT 1].size() > 0) {
			ProcessEventSyncSchedule scheduleNext = new ProcessEventSyncSchedule(true);
			Datetime TimeInTwoMinutes = System.now().addMinutes(2);
			String cronExpression =
				'0 ' +
				String.valueOf(TimeInTwoMinutes.minute()) +
				' ' +
				String.valueOf(TimeInTwoMinutes.hour()) +
				' ' +
				String.valueOf(TimeInTwoMinutes.day()) +
				' ' +
				String.valueOf(TimeInTwoMinutes.month()) +
				' ?';
			if (!GoogleCalendarSyncUtility.isQueableRunning()) {
				System.schedule('ProcessEventSyncQueue - aditional queue', cronExpression, scheduleNext);
			}
		}
	}

	public void execute(QueueableContext context) {
		List<EventSync__c> syncs;
		try {
			ProcessEventSyncQueue finalizer = new ProcessEventSyncQueue();
			System.attachFinalizer(finalizer);

			syncs = [
				SELECT Id, ChangeFromGoogle__c, GoogleEventId__c, SFEventId__c, IsDeleted__c, IsNew__c, ResourceId__c
				FROM EventSync__c
				LIMIT 50
			];
			Map<String, UserCalendarSetting__c> relatedSettings = getRelatedSettings(syncs);
			Map<String, UserCalendarSetting__c> relatedSettingsBySFEventIds = getRelatedSettingsBySFEventIds(syncs);

			GoogleCalendarSyncService port = new GoogleCalendarSyncService();
			UserCalendarSetting__c actualSetting;
			for (EventSync__c eventSync : syncs) {
				actualSetting = eventSync.ResourceId__c == null
					? relatedSettingsBySFEventIds.get(eventSync.SFEventId__c)
					: relatedSettings.get(eventSync.ResourceId__c);

				if (actualSetting == null) {
					Logger.error(
						'UserCalendarSetting does not exist for sync with params: ' +
						eventSync +
						' with actual setting: ' +
						actualSetting
					);
					continue;
				}
				if (eventSync.ChangeFromGoogle__c) {
					processGoogleSideChange(eventSync, actualSetting, port);
				} else if (!eventSync.ChangeFromGoogle__c && eventSync.IsDeleted__c) {
					processDeleteInSalesforce(eventSync, actualSetting, port);
				} else if (!eventSync.ChangeFromGoogle__c && eventSync.IsNew__c) {
					processNewInSalesforce(eventSync, actualSetting, port);
				} else if (!eventSync.ChangeFromGoogle__c && !eventSync.IsNew__c) {
					processChangeInSalesforce(eventSync, actualSetting, port);
				}
			}
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();

			Database.delete(syncs, false);
			insert eventsToCreate;
			update eventsToUpdate.values();
			delete eventsToDelete.values();
			update calendarSettingsToUpdate.values();
		}
	}

	private Map<String, UserCalendarSetting__c> getRelatedSettings(List<EventSync__c> syncs) {
		List<String> resourceIds = new List<String>();
		for (EventSync__c sync : syncs) {
			resourceIds.add(sync.ResourceId__c);
		}
		List<UserCalendarSetting__c> settings = [
			SELECT Id, User__c, ResourceId__c, UserCalendarID__c, SyncToken__c
			FROM UserCalendarSetting__c
			WHERE ResourceId__c IN :resourceIds
		];
		Map<String, UserCalendarSetting__c> settingsByResourceId = new Map<String, UserCalendarSetting__c>();
		for (UserCalendarSetting__c setting : settings) {
			settingsByResourceId.put(setting.ResourceId__c, setting);
		}
		return settingsByResourceId;
	}

	private Map<String, UserCalendarSetting__c> getRelatedSettingsBySFEventIds(List<EventSync__c> syncs) {
		List<String> eventsToSyncWithoutResourceId = new List<String>();
		for (EventSync__c sync : syncs) {
			if (sync.ResourceId__c == null && sync.SFEventId__c != null) {
				eventsToSyncWithoutResourceId.add(sync.SFEventId__c);
			}
		}
		List<Event> relatedSFEvents = new List<Event>(
			[SELECT Id, OwnerId FROM Event WHERE Id IN :eventsToSyncWithoutResourceId]
		);
		Set<Id> ownerIds = new Set<Id>();

		for (Event SFEvent : relatedSFEvents) {
			ownerIds.add(SFEvent.OwnerId);
		}
		List<UserCalendarSetting__c> settings = [
			SELECT Id, User__c, ResourceId__c, UserCalendarID__c, SyncToken__c
			FROM UserCalendarSetting__c
			WHERE User__c IN :ownerIds
		];
		Map<String, UserCalendarSetting__c> settingsByUsers = new Map<String, UserCalendarSetting__c>();
		for (UserCalendarSetting__c setting : settings) {
			settingsByUsers.put(setting.User__c, setting);
		}
		Map<String, UserCalendarSetting__c> settingsBySFEventId = new Map<String, UserCalendarSetting__c>();
		for (Event event : relatedSFEvents) {
			settingsBySFEventId.put(event.Id, settingsByUsers.get(event.OwnerId));
		}
		return settingsBySFEventId;
	}

	private void processGoogleSideChange(
		EventSync__c eventSync,
		UserCalendarSetting__c calendarSetting,
		GoogleCalendarSyncService port
	) {
		GoogleCalendarSyncUtility.GoogleCalendarResponse changedEventsResponse = port.getAllEvents(
			calendarSetting.UserCalendarID__c,
			calendarSetting.SyncToken__c
		);
		handleApiErrors(changedEventsResponse, calendarSetting);
		if (changedEventsResponse.statusCode == 200) {
			Map<String, Event> relatedEventsMap = getRelatedEventsMap(changedEventsResponse.googleEvents);
			assortEventsFromGoogle(relatedEventsMap, changedEventsResponse.googleEvents, calendarSetting);

			calendarSetting.SyncToken__c = changedEventsResponse.nextSyncToken;
			this.calendarSettingsToUpdate.put(calendarSetting.Id, calendarSetting);
		}
	}

	private void assortEventsFromGoogle(
		Map<String, Event> relatedEventsMap,
		List<GoogleCalendarSyncUtility.GoogleEventDTO> googleEvents,
		UserCalendarSetting__c relatedSetting
	) {
		for (GoogleCalendarSyncUtility.GoogleEventDTO googleChangedEvent : googleEvents) {
			if (isTooOld(googleChangedEvent)) {
				continue;
			}
			if (googleChangedEvent.status == 'cancelled') {
				if (relatedEventsMap.get(googleChangedEvent.id) != null) {
					Event relatedEvent = relatedEventsMap.get(googleChangedEvent.id);
					this.eventsToDelete.put(relatedEvent.Id, relatedEvent);
				}
			} else if (relatedEventsMap.get(googleChangedEvent.id) == null) {
				Event newEvent = GoogleCalendarSyncUtility.getSFEventFromGoogleEvent(googleChangedEvent, true);
				newEvent.OwnerId = relatedSetting.User__c;
				this.eventsToCreate.add(newEvent);
			} else if (
				GoogleCalendarSyncUtility.googleEventDiffersInFields(
					relatedEventsMap.get(googleChangedEvent.id),
					googleChangedEvent
				)
			) {
				Event updatedEvent = GoogleCalendarSyncUtility.updateSfEvent(
					relatedEventsMap.get(googleChangedEvent.id),
					googleChangedEvent
				);
				this.eventsToUpdate.put(updatedEvent.Id, updatedEvent);
			}
		}
	}

	private Map<String, Event> getRelatedEventsMap(List<GoogleCalendarSyncUtility.GoogleEventDTO> googleEvents) {
		List<String> eventGoogleIds = new List<String>();
		for (GoogleCalendarSyncUtility.GoogleEventDTO event : googleEvents) {
			eventGoogleIds.add(event.id);
		}
		List<Event> relatedEvents = [
			SELECT
				Id,
				Subject,
				Description,
				IsPrivate,
				Location,
				IsAllDayEvent,
				StartDateTime,
				ActivityDate,
				EndDateTime,
				EndDate,
				ShowAs,
				GoogleId__c,
				IsFromGoogle__c,
				AccountAlias__c,
				ProductType__c,
				ActivityLink__c
			FROM Event
			WHERE GoogleId__c IN :eventGoogleIds
		];

		Map<String, Event> relatedEventsMap = new Map<String, Event>();
		for (Event event : relatedEvents) {
			relatedEventsMap.put(event.GoogleId__c, event);
		}
		return relatedEventsMap;
	}

	private void processDeleteInSalesforce(
		EventSync__c eventSync,
		UserCalendarSetting__c calendarSetting,
		GoogleCalendarSyncService port
	) {
		if (eventSync.GoogleEventId__c != null) {
			GoogleCalendarSyncUtility.GoogleEventDTO googleEvent = new GoogleCalendarSyncUtility.GoogleEventDTO();
			googleEvent.id = eventSync.GoogleEventId__c;
			googleEvent.status = 'cancelled';

			GoogleCalendarSyncUtility.GoogleCalendarResponse response = port.patchGoogleEvent(
				calendarSetting.UserCalendarID__c,
				googleEvent,
				eventSync.GoogleEventId__c
			);
			handleApiErrors(response, calendarSetting);
		}
	}

	private Boolean isTooOld(Event sfEvent) {
		if (sfEvent.StartDateTime < System.now().addDays(-90) || sfEvent.ActivityDate < System.today().addDays(-90)) {
			return true;
		}
		return false;
	}

	private Boolean isTooOld(GoogleCalendarSyncUtility.GoogleEventDTO googleEvent) {
		if (
			GoogleCalendarSyncUtility.getDateTimeFromGoogleFormat(googleEvent.start_x?.dateTime_x) <
			System.now().addDays(-90) ||
			googleEvent.start_x?.date_x < System.today().addDays(-90)
		) {
			return true;
		}
		return false;
	}

	private void processNewInSalesforce(
		EventSync__c eventSync,
		UserCalendarSetting__c calendarSetting,
		GoogleCalendarSyncService port
	) {
		Event sfEvent = getEvent(eventSync.SFEventId__c);
		if (isTooOld(sfEvent)) {
			return;
		}
		GoogleCalendarSyncUtility.GoogleCalendarResponse response = port.createEvent(
			calendarSetting.UserCalendarID__c,
			sfEvent
		);
		sfEvent.GoogleId__c = response.newEventId;
		this.eventsToUpdate.put(sfEvent.Id, sfEvent);
		handleApiErrors(response, calendarSetting);
	}

	private void processChangeInSalesforce(
		EventSync__c eventSync,
		UserCalendarSetting__c calendarSetting,
		GoogleCalendarSyncService port
	) {
		Event sfEvent = getEvent(eventSync.SFEventId__c);
		if (isTooOld(sfEvent)) {
			return;
		}
		GoogleCalendarSyncUtility.GoogleCalendarResponse response = port.updateEvent(
			calendarSetting.UserCalendarID__c,
			sfEvent,
			sfEvent.GoogleId__c
		);
		handleApiErrors(response, calendarSetting);
	}

	private Event getEvent(String sfEventId) {
		return [
			SELECT
				Id,
				Subject,
				Description,
				IsPrivate,
				Location,
				IsAllDayEvent,
				StartDateTime,
				ActivityDate,
				EndDateTime,
				EndDate,
				ShowAs,
				GoogleId__c,
				IsFromGoogle__c,
				AccountAlias__c,
				ProductType__c,
				ActivityLink__c
			FROM Event
			WHERE Id = :sfEventId
			LIMIT 1
		];
	}

	@TestVisible
	private void handleApiErrors(
		GoogleCalendarSyncUtility.GoogleCalendarResponse responseFromService,
		UserCalendarSetting__c calendarSetting
	) {
		if (responseFromService.statusCode == 200 || responseFromService.statusCode == 201) {
			//OK
			return;
		}
		if (responseFromService.statusCode == 401) {
			//Invalid credentials
			Logger.error(
				'Access token to the Google Calendar Api has expired. Go to the named credentials page and reconnect the technical account'
			);
			return;
		}
		if (responseFromService.statusCode == 403 || responseFromService.statusCode == 429) {
			//Usage limits exceeded
			Logger.error('Usage limits of the Google Calendar API has been exceeded.');
			return;
		}
		if (responseFromService.statusCode == 404) {
			//Calendar not found - has no access to user's calendar
			Logger.error(
				'User calendar couldn\'t be reached by the technical User; user probably disconnected his calendar' +
				' on Google Calendar side or changed Calendar Id - disconnecting calendar for user with Id: ' +
				calendarSetting.User__c
			);
			calendarSetting.SyncActive__c = false;
			calendarSettingsToUpdate.put(calendarSetting.Id, calendarSetting);
			return;
		}
		if (responseFromService.statusCode == 410) {
			//Sync token is invalid
			Logger.error('Invalid Sync Token for user with Id ' + calendarSetting.User__c);
			return;
		}
		if (responseFromService.statusCode > 400) {
			Logger.error(
				'Unknown error code returned from Google API: ' +
				responseFromService.statusCode +
				' for request from User with Id ' +
				calendarSetting.User__c
			);
		}
	}
}
