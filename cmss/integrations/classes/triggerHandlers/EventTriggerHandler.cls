public class EventTriggerHandler extends TriggerHandler {
	public override void beforeInsert() {
		setAlias(Trigger.new);
	}

	public override void afterInsert() {
		handleUpdateAccountDateFields((List<Event>) Trigger.new);
		List<Event> newInSF = filterNewInSfEvents((List<Event>) Trigger.new);
		createEventSyncs(newInSF, true);
	}

	public override void beforeUpdate() {
		setNewAlias((Map<Id, Event>) Trigger.oldMap, (List<Event>) Trigger.new);
	}

	public override void afterUpdate() {
		setEventAfterUpdate((Map<Id, Event>) Trigger.newMap, (Map<Id, Event>) Trigger.oldMap);
		List<Event> changedEvents = filterUnchangedEvents((Map<Id, Event>) Trigger.oldMap, (List<Event>) Trigger.new);
		createEventSyncs(changedEvents, false);
	}

	public override void afterDelete() {
		createEventSyncs(Trigger.old, false, true);
	}

	private List<Event> filterNewInSfEvents(List<Event> newEvents) {
		List<Event> newInSF = new List<Event>();
		for (Event event : newEvents) {
			if (event.GoogleId__c == null) {
				newInSF.add(event);
			}
		}
		return newInSF;
	}

	private List<Event> filterUnchangedEvents(Map<Id, Event> oldEventsMap, List<Event> newEvents) {
		List<Event> changedEvents = new List<Event>();
		for (Event newEvent : newEvents) {
			if (GoogleCalendarSyncUtility.sfEventDiffersInFields(oldEventsMap.get(newEvent.Id), newEvent)) {
				changedEvents.add(newEvent);
			}
		}
		return changedEvents;
	}

	private void createEventSyncs(List<Event> events, Boolean isNew) {
		createEventSyncs(events, isNew, false);
	}

	@TestVisible
	private void setEventAfterUpdate(Map<Id, Event> newEventById, Map<Id, Event> oldEventById) {
		List<Event> events = new List<Event>();
		for (Event e : newEventById.values()) {
			if (
				e.ActivityDate != oldEventById.get(e.Id).ActivityDate ||
					e.EndDateTime != oldEventById.get(e.Id).EndDateTime
			) {
				events.add(e);
			}
		}
		if (events.size() > 0) {
			handleUpdateAccountDateFields(events);
		}
	}

	private void handleUpdateAccountDateFields(List<Event> events) {
		List<Account> accountsToUpdate = new List<Account>();
		Set<Id> eventIds = new Set<Id>();
		for (Event e : events) {
			eventIds.add(e.Id);
		}

		Map<Id, Event> eventWithAccount = new Map<Id, Event>(
		[
			SELECT AccountId, Account.LastInteractionDate__c, Account.OpenedActivityDate__c
			FROM Event
			WHERE Id IN :eventIds
		]
		);

		for (Event e : events) {
			Account actualAccount = eventWithAccount.get(e.Id)?.Account;
			if (actualAccount == null) {
				continue;
			}
			if (
				e.ActivityDate < actualAccount?.OpenedActivityDate__c && e.ActivityDate > Date.today() ||
					actualAccount?.OpenedActivityDate__c == null
			) {
				actualAccount.OpenedActivityDate__c = e?.ActivityDate;
				accountsToUpdate.add(actualAccount);
			}
			if (
				Date.valueOf(e?.EndDateTime) > actualAccount?.LastInteractionDate__c &&
					Date.valueOf(e?.EndDateTime) <= Date.today() || actualAccount?.LastInteractionDate__c == null
			) {
				actualAccount.LastInteractionDate__c = Date.valueOf(e?.EndDateTime);
				accountsToUpdate.add(actualAccount);
			}
		}
		update (new List<Account>(new Set<Account>(accountsToUpdate)));
	}

	private void createEventSyncs(List<Event> events, Boolean isNew, Boolean isDeleted) {
		List<EventSync__c> newEventSyncs = new List<EventSync__c>();
		List<Event> newEvents = new List<Event>();

		Map<String, Event> sfEventsToGoogleIdMap = new Map<String, Event>();
		Map<Id, UserCalendarSetting__c> eventOwnerSettingsMap = getEventOwnersSettingsMap(events);

		for (Event event : events) {
			if (event.GoogleId__c != null) {
				sfEventsToGoogleIdMap.put(event.GoogleId__c, event);
			} else {
				newEvents.add(event);
			}
		}
		List<EventSync__c> syncsToDelete = getSyncsToDelete(isDeleted, sfEventsToGoogleIdMap.keySet());
		for (EventSync__c sync : syncsToDelete) {
			sfEventsToGoogleIdMap.remove(sync.GoogleEventId__c);
		}
		newEvents.addAll(sfEventsToGoogleIdMap.values());
		for (Event eventToSync : newEvents) {
			EventSync__c newSync = new EventSync__c();
			newSync.GoogleEventId__c = isNew ? null : eventToSync.GoogleId__c;
			newSync.SFEventId__c = eventToSync.Id;
			newSync.ChangeFromGoogle__c = false;
			newSync.IsNew__c = isNew;
			newSync.IsDeleted__c = isDeleted;
			newSync.ResourceId__c = eventOwnerSettingsMap.get(eventToSync.OwnerId)?.ResourceId__c;
			newEventSyncs.add(newSync);
		}
		if (newEventSyncs.size() > 0) {
			insert newEventSyncs;
			GoogleCalendarSyncUtility.runQueableIfNotQueued();
		}
		delete syncsToDelete;
	}

	private List<EventSync__c> getSyncsToDelete(Boolean isDeleted, Set<String> googleIds) {
		String query =
			'SELECT Id, GoogleEventId__c FROM EventSync__c WHERE GoogleEventId__c IN :googleIds AND ' +
				(isDeleted ? 'IsDeleted__c = true' : 'ChangeFromGoogle__c = true');
		List<EventSync__c> syncsToDelete = Database.query(query);
		return syncsToDelete;
	}

	private Map<Id, UserCalendarSetting__c> getEventOwnersSettingsMap(List<Event> events) {
		List<Id> eventOwnerIds = new List<Id>();
		Map<Id, UserCalendarSetting__c> eventOwnerSettingsMap = new Map<Id, UserCalendarSetting__c>();
		for (Event event : events) {
			eventOwnerIds.add(event.OwnerId);
		}
		List<UserCalendarSetting__c> settings = [
			SELECT ResourceId__c, User__c
			FROM UserCalendarSetting__c
			WHERE User__c IN :eventOwnerIds
		];
		for (UserCalendarSetting__c setting : settings) {
			eventOwnerSettingsMap.put(setting.User__c, setting);
		}
		return eventOwnerSettingsMap;
	}

	private void setNewAlias(Map<Id, Event> oldEventsMap, List<Event> newEvents) {
		List<Event> eventsToResetAliasTo = new List<Event>();
		for (Event event : newEvents) {
			if (oldEventsMap.get(event.Id)?.WhoId != event.WhoId) {
				eventsToResetAliasTo.add(event);
			}
		}
		setAlias(eventsToResetAliasTo);
	}

	private void setAlias(List<Event> newEvents) {
		List<Id> contactIds = new List<Id>();
		for (Event event : newEvents) {
			if (event?.WhoId?.getSObjectType().getDescribe().getName() == 'Contact') {
				contactIds.add(event.WhoId);
			}
		}
		Map<Id, Contact> relatedContactsMap = new Map<Id, Contact>(
			[SELECT Account.FirstName, Account.LastName, Account.Birthdate__c FROM Contact WHERE Id IN :contactIds]
		);
		Contact actualContact;
		for (Event event : newEvents) {
			if (relatedContactsMap.containsKey(event.WhoId)) {
				actualContact = relatedContactsMap.get(event.WhoId);
				event.AccountAlias__c =
					actualContact.Account?.LastName?.left(3) +
						actualContact.Account?.FirstName?.left(3) +
						'_' +
						String.valueOf(actualContact.Account?.Birthdate__c?.year())?.right(2);
			} else {
				event.AccountAlias__c = '';
			}
		}
	}
}
