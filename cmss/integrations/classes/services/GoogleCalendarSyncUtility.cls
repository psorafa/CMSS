public class GoogleCalendarSyncUtility {
	public static Event getSFEventFromGoogleEvent(GoogleEventDTO googleEvent, Boolean isOriginGoogle) {
		Event sfEvent = new Event();
		sfEvent.Subject = googleEvent.summary;
		if (isOriginGoogle) {
			sfEvent.Description = googleEvent.description + ' - Google událost\nÚčastníci: \n';
			if (googleEvent.attendees != null) {
				for (GoogleAttendeeDTO attendee : googleEvent.attendees) {
					sfEvent.Description += attendee?.email + '\n';
				}
			}
			sfEvent.Description +=
				'Vytvořena dne: ' + getDateTimeFromGoogleFormat(googleEvent?.created)?.format('dd. MM. yyyy');
			if (googleEvent?.recurrence != null) {
				sfEvent.Description += '\n \n Pro opakující se událost nelze do CRM přenést všechny její výskyty';
			}
		}
		sfEvent.IsPrivate = googleEvent.visibility == 'public' ? false : true;
		sfEvent.Location = googleEvent.location;

		if (googleEvent.start_x?.dateTime_x != null) {
			sfEvent.IsAllDayEvent = false;
			sfEvent.StartDateTime = getDateTimeFromGoogleFormat(googleEvent.start_x?.dateTime_x);
			sfEvent.EndDateTime = getDateTimeFromGoogleFormat(googleEvent.end_x?.dateTime_x);
		} else {
			sfEvent.IsAllDayEvent = true;
			sfEvent.ActivityDate = googleEvent.start_x?.date_x;
			sfEvent.EndDateTime = googleEvent.end_x?.date_x?.addDays(-1);
		}
		sfEvent.ShowAs = googleEvent.transparency == 'opaque' ? 'Busy' : 'Free';
		sfEvent.GoogleId__c = googleEvent.id;
		sfEvent.IsFromGoogle__c = isOriginGoogle;

		return sfEvent;
	}

	public static GoogleEventDTO getGoogleEventFromSFEvent(Event sfEvent, Boolean isOriginGoogle, Boolean isNew) {
		GoogleEventDTO googleEvent = new GoogleEventDTO();
		googleEvent.summary = sfEvent.Subject;
		googleEvent.visibility = sfEvent.IsPrivate ? 'private' : 'public';
		googleEvent.location = sfEvent.Location;

		googleEvent.start_x = new GoogleDateDTO();
		googleEvent.end_x = new GoogleDateDTO();
		if (sfEvent.IsAllDayEvent) {
			googleEvent.start_x.date_x = sfEvent.ActivityDate;
			googleEvent.end_x.date_x = sfEvent.EndDate;
		} else {
			googleEvent.start_x.dateTime_x = sfEvent.StartDateTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
			googleEvent.end_x.dateTime_x = sfEvent.EndDateTime.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
		}
		googleEvent.eventType = sfEvent.ShowAs == 'OutOfOffice' ? 'outOfOffice' : 'default';
		googleEvent.transparency = sfEvent.ShowAs == 'Busy' ? 'opaque' : 'transparent';
		if (isNew && !isOriginGoogle) {
			String description =
				'Událost ze CRM Fénix ke klientovi/klientům ' +
				sfEvent.AccountAlias__c +
				' typ produktu ' +
				sfEvent.ProductType__c +
				' pro detail klikněte na odkaz: ' +
				sfEvent.ActivityLink__c;
			googleEvent.description = description;
			googleEvent.colorId = '4';
		}

		return googleEvent;
	}

	public static Task getSFTaskFromGoogleEvent(GoogleEventDTO googleEvent) {
		Task task = new Task();

		if (googleEvent.start_x?.dateTime_x != null && googleEvent.end_x?.dateTime_x != null) {
			task.PlannedFromDate__c = getDateTimeFromGoogleFormat(googleEvent.start_x.dateTime_x);
			task.PlannedToDate__c = getDateTimeFromGoogleFormat(googleEvent.end_x.dateTime_x);
		} else {
			task.ActivityDate = googleEvent.start_x.date_x;
		}

		task.Location__c = googleEvent.location;
		task.GoogleId__c = googleEvent.id;

		return task;
	}

	public static GoogleEventDTO getGoogleEventFromSFTask(Task task) {
		GoogleEventDto googleEvent = new GoogleEventDto();
		googleEvent.summary = task.IsClosedNegative__c || task.IsClosedPositive__c
			? 'Hotovo - Fénix: ' + task.Subject
			: task.Subject;
		googleEvent.start_x = new GoogleDateDTO();
		googleEvent.end_x = new GoogleDateDTO();
		if (task.PlannedFromDate__c != null || task.PlannedToDate__c != null) {
			if (task.PlannedFromDate__c == null) {
				task.PlannedFromDate__c = task.PlannedToDate__c;
			}
			if (task.PlannedToDate__c == null) {
				task.PlannedToDate__c = task.PlannedFromDate__c;
			}
			googleEvent.start_x.dateTime_x = task.PlannedFromDate__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
			googleEvent.end_x.dateTime_x = task.PlannedToDate__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
		} else {
			googleEvent.start_x.date_x = task.ActivityDate;
			googleEvent.end_x.date_x = task.ActivityDate;
		}

		googleEvent.description =
			'Aktivita typu: ' +
			task.Type +
			'\nKe klientovi/klientům: ' +
			task.AccountAlias__c +
			'\nKategorie: ' +
			task.Category__c +
			'\nTyp produktu: ' +
			task.ProductType__c +
			'\nPro detail klikněte na odkaz: ' +
			task.ActivityLink__c +
			'\nS aktivitou je potřeba pracovat v CRM Fénix, kde po jejím dokončení prosím zaznamejte i její výsledek.';

		googleEvent.colorId = '2';

		googleEvent.location = task.Location__c;
		googleEvent.id = task.GoogleId__c;

		return googleEvent;
	}

	public static Event updateSfEvent(Event sfEvent, GoogleEventDTO googleEvent) {
		List<Schema.FieldSetMember> fields = SObjectType.Event.FieldSets.CalendarSyncFields.getFields();
		Event updatedSfEvent = sfEvent;
		Event googleToSfEvent = getSFEventFromGoogleEvent(googleEvent, sfEvent.IsFromGoogle__c);
		for (Schema.FieldSetMember field : fields) {
			updatedSfEvent.put(field.getFieldPath(), googleToSfEvent.get(field.getFieldPath()));
		}
		if (!sfEvent.IsFromGoogle__c) {
			updatedSfEvent.Description = sfEvent.Description;
		}
		return updatedSfEvent;
	}

	public static Boolean googleEventDiffersInFields(
		Event sfEvent,
		GoogleCalendarSyncUtility.GoogleEventDTO googleEvent
	) {
		List<Schema.FieldSetMember> fields = SObjectType.Event.FieldSets.CalendarSyncFields.getFields();
		Event googleToSfEvent = getSFEventFromGoogleEvent(googleEvent, sfEvent.IsFromGoogle__c);
		for (Schema.FieldSetMember field : fields) {
			if (sfEvent.get(field.getFieldPath()) != googleToSfEvent.get(field.getFieldPath())) {
				return true;
			}
		}
		return false;
	}

	public static Boolean taskDiffersInFields(Task sfTask, GoogleCalendarSyncUtility.GoogleEventDTO googleEventTask) {
		List<Schema.FieldSetMember> fields = SObjectType.Task.FieldSets.CalendarSyncTaskFields.getFields();

		Task googleToSfTask = getSFTaskFromGoogleEvent(googleEventTask);
		googleToSfTask.OwnerId = sfTask.OwnerId;

		for (Schema.FieldSetMember field : fields) {
			if (sfTask.get(field.getFieldPath()) != googleToSfTask.get(field.getFieldPath())) {
				return true;
			}
		}
		return false;
	}

	public static Boolean taskDiffersInFieldsFromGoogle(
		Task sfTask,
		GoogleCalendarSyncUtility.GoogleEventDTO googleEventTask
	) {
		List<Schema.FieldSetMember> fields = SObjectType.Task.FieldSets.CalendarSyncTaskFields.getFields();

		Task googleToSfTask = getSFTaskFromGoogleEvent(googleEventTask);
		if (
			googleToSfTask.Location__c != sfTask.Location__c ||
			googleToSfTask.PlannedFromDate__c != sfTask.PlannedFromDate__c ||
			googleToSfTask.PlannedToDate__c != sfTask.PlannedToDate__c
		) {
			return true;
		}

		return false;
	}

	public static Boolean sfEventDiffersInFields(Event oldEvent, Event newEvent) {
		List<Schema.FieldSetMember> fields = SObjectType.Event.FieldSets.CalendarSyncFields.getFields();
		for (Schema.FieldSetMember field : fields) {
			if (oldEvent.get(field.getFieldPath()) != newEvent.get(field.getFieldPath())) {
				return true;
			}
		}
		return false;
	}

	public static string stripJsonNulls(string jsonString) {
		if (jsonString != null) {
			jsonString = jsonString.replaceAll('\"[^\"]*\":null', '');
			jsonString = jsonString.replaceAll(',{2,}', ',');
			jsonString = jsonString.replace('{,', '{');
			jsonString = jsonString.replace(',}', '}');
			jsonString = jsonString.replace('[,', '[');
			jsonString = jsonString.replace(',]', ']');
		}
		return jsonString;
	}

	public static DateTime getDateTimeFromGoogleFormat(String googleDateOrDateTime) {
		if (googleDateOrDateTime == null) {
			return null;
		}
		List<Integer> timeComponents = new List<integer>();
		timeComponents.addAll(getDateComponents(googleDateOrDateTime.split('T')[0]));
		if (googleDateOrDateTime.contains('T')) {
			String timezoneCharacter;
			if (googleDateOrDateTime.contains('+')) {
				timezoneCharacter = '+';
			} else if (googleDateOrDateTime.contains('.')) {
				timezoneCharacter = '.';
			} else {
				timezoneCharacter = 'Z';
			}
			timeComponents.addAll(getTimeComponents(googleDateOrDateTime.substringBetween('T', timezoneCharacter)));
		} else {
			timeComponents.add(0);
			timeComponents.add(0);
			timeComponents.add(0);
		}
		Datetime finalDateTime = Datetime.newInstance(
			timeComponents[0],
			timeComponents[1],
			timeComponents[2],
			timeComponents[3],
			timeComponents[4],
			timeComponents[5]
		);

		return finalDateTime;
	}

	public static List<Integer> getDateComponents(String googleDate) {
		List<String> googleDates = googleDate.split('-');
		return new List<Integer>{
			Integer.valueOf(googleDates[0]),
			Integer.valueOf(googleDates[1]),
			Integer.valueOf(googleDates[2])
		};
	}

	public static List<Integer> getTimeComponents(String googleTime) {
		List<String> googleTimess = googleTime.split(':');
		return new List<Integer>{
			Integer.valueOf(googleTimess[0]),
			Integer.valueOf(googleTimess[1]),
			Integer.valueOf(googleTimess[2])
		};
	}

	public static String replaceReserved(String responseBody, List<String> reservedKeywords) {
		String newBody = responseBody;
		for (String keyword : reservedKeywords) {
			newBody = newBody.replace('"' + keyword + '"', '"' + keyword + '_x"');
		}
		return newBody;
	}

	public static String placeReserved(String requestBody, List<String> reservedKeywords) {
		String newBody = requestBody;
		for (String keyword : reservedKeywords) {
			newBody = newBody.replace('' + keyword + '_x', '' + keyword + '');
		}
		return newBody;
	}

	public static void runQueableIfNotQueued() {
		if (!isQueableRunning()) {
			if (!Test.isRunningTest()) {
				System.enqueueJob(new ProcessEventSyncQueue());
			}
		}
	}

	public static Boolean isQueableRunning() {
		List<String> activeQueableStatuses = new List<String>{ 'Processing', 'Queued', 'Preparing', 'Holding' };
		Id apexClassId = [SELECT Id FROM ApexClass WHERE Name = 'ProcessEventSyncQueue' LIMIT 1].Id;
		return [
				SELECT Id, Status, ApexClassId
				FROM AsyncApexJob
				WHERE ApexClassId = :apexClassId AND Status IN :activeQueableStatuses
				LIMIT 1
			]
			.size() != 0;
	}

	public class GoogleEventRespDTO {
		public List<GoogleEventDTO> items;
		public String nextSyncToken;
		public String nextPageToken;
	}

	public class GoogleEventDTO {
		public String summary;
		public String description;
		public String visibility;
		public String location;
		public GoogleDateDTO start_x;
		public GoogleDateDTO end_x;
		public String eventType;
		public String transparency;
		public String colorId;
		public List<String> recurrence;

		public String created;
		public String htmlLink;
		public String id;
		public String status;
		public List<GoogleAttendeeDTO> attendees;
	}

	public class GoogleAttendeeDTO {
		public String email;
	}

	public class GoogleDateDTO {
		public String dateTime_x;
		public Date date_x;
	}

	public class GoogleOverridesDTO {
		public String method;
		public Integer minutes;
	}

	public class GoogleCalendarResponse {
		public GoogleCalendarResponse(Integer statusCode, String message) {
			this.statusCode = statusCode;
			this.message = message;
		}

		public GoogleCalendarResponse(
			Integer statusCode,
			String message,
			List<GoogleEventDTO> googleEvents,
			String nextSyncToken
		) {
			this.googleEvents = googleEvents;
			this.statusCode = statusCode;
			this.message = message;
			this.nextSyncToken = nextSyncToken;
		}

		public GoogleCalendarResponse(Integer statusCode, String message, Event event) {
			this.events = new List<Event>();
			if (event != null) {
				this.events.add(event);
			}
			this.statusCode = statusCode;
			this.message = message;
		}

		public GoogleCalendarResponse(Integer statusCode, String message, String eventId) {
			this.statusCode = statusCode;
			this.message = message;
			this.newEventId = eventId;
		}

		public Integer statusCode;
		public String userId;
		public String message;
		public List<Event> events;
		public List<GoogleEventDTO> googleEvents;
		public String newEventId;
		public String nextSyncToken;
		public String nextPageToken;
	}
}
