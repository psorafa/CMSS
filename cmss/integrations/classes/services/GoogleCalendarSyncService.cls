public class GoogleCalendarSyncService {
	private String baseEndpoint = 'callout:GoogleCalendar/calendars';
	private List<String> reservedKeywords = new List<String>{ 'date', 'start', 'end', 'dateTime' };

	public GoogleCalendarSyncUtility.GoogleCalendarResponse getAllEvents(String googleCalendarId, String syncToken) {
		HttpRequest req = new HttpRequest();
		String fullRoute =
			baseEndpoint +
			'/' +
			googleCalendarId +
			'/events' +
			(syncToken == null ? '' : '?syncToken=' + syncToken);
		req.setEndpoint(fullRoute);
		req.setMethod('GET');
		Logger.debug('Outgoing request', Logger.serializeHttpRequest(req));
		Http http = new Http();
		HTTPResponse res = http.send(req);
		return processGetAllResponse(res);
	}

	public GoogleCalendarSyncUtility.GoogleCalendarResponse getAllEventsNextPage(
		String googleCalendarId,
		String nextPageToken
	) {
		HttpRequest req = new HttpRequest();
		String fullRoute =
			baseEndpoint +
			'/' +
			googleCalendarId +
			'/events' +
			(nextPageToken == null ? '' : '?pageToken=' + nextPageToken);
		req.setEndpoint(fullRoute);
		req.setMethod('GET');
		Logger.debug('Outgoing request', Logger.serializeHttpRequest(req));
		Http http = new Http();
		HTTPResponse res = http.send(req);
		return processGetAllResponse(res);
	}

	public Boolean isCalendarConnected(String googleCalendarId) {
		HttpRequest req = new HttpRequest();
		String fullRoute = baseEndpoint + '/' + googleCalendarId;
		req.setEndpoint(fullRoute);
		req.setMethod('GET');
		Logger.debug('Outgoing request', Logger.serializeHttpRequest(req));
		Http http = new Http();
		HTTPResponse res = http.send(req);
		Logger.debug('Incomming response', Logger.serializeHttpResponse(res));
		if (res.getStatusCode() == 200) {
			return true;
		}
		return false;
	}

	private GoogleCalendarSyncUtility.GoogleCalendarResponse processGetAllResponse(HTTPResponse res) {
		GoogleCalendarSyncUtility.GoogleEventRespDTO serializedResp = new GoogleCalendarSyncUtility.GoogleEventRespDTO();
		try {
			if (res.getStatusCode() == 200) {
				serializedResp = (GoogleCalendarSyncUtility.GoogleEventRespDTO) JSON.deserialize(
					GoogleCalendarSyncUtility.replaceReserved(res.getBody(), reservedKeywords),
					GoogleCalendarSyncUtility.GoogleEventRespDTO.class
				);
			}
		} catch (Exception e) {
			Logger.error('Unable to deserialize response', e);
		} finally {
			Logger.debug(
				'Incoming response',
				Logger.serializeHttpResponse(res) +
				'\n' +
				JSON.serialize(serializedResp)
			);
			Logger.saveLogs();
		}

		GoogleCalendarSyncUtility.GoogleCalendarResponse response = new GoogleCalendarSyncUtility.GoogleCalendarResponse(
			res.getStatusCode(),
			res.getStatus(),
			serializedResp.items,
			serializedResp?.nextSyncToken
		);
		response.nextPageToken = serializedResp?.nextPageToken;
		return response;
	}

	public GoogleCalendarSyncUtility.GoogleCalendarResponse getEvent(String googleCalendarId, String eventId) {
		HttpRequest req = new HttpRequest();
		String fullRoute = baseEndpoint + '/' + googleCalendarId + '/events/' + eventId;
		req.setEndpoint(fullRoute);
		req.setMethod('GET');
		Logger.debug('Outgoing request', Logger.serializeHttpRequest(req));
		Http http = new Http();
		HTTPResponse res = http.send(req);
		return processGetResponse(res);
	}

	private GoogleCalendarSyncUtility.GoogleCalendarResponse processGetResponse(HTTPResponse res) {
		Event retrievedEvent;
		try {
			GoogleCalendarSyncUtility.GoogleEventDTO serializedResp = (GoogleCalendarSyncUtility.GoogleEventDTO) JSON.deserialize(
				GoogleCalendarSyncUtility.replaceReserved(res.getBody(), reservedKeywords),
				GoogleCalendarSyncUtility.GoogleEventDTO.class
			);
			retrievedEvent = GoogleCalendarSyncUtility.getSFEventFromGoogleEvent(serializedResp, false);
			Logger.debug('Incoming response serialized', JSON.serialize(res.getBody()) + '\n\n' + retrievedEvent);
		} catch (Exception e) {
			Logger.error('Unable to deserialize response', e);
		} finally {
			Logger.saveLogs();
		}
		return new GoogleCalendarSyncUtility.GoogleCalendarResponse(
			res.getStatusCode(),
			res.getStatus(),
			retrievedEvent
		);
	}

	public Boolean hasAccessToCalendar(String googleCalendarId) {
		HttpRequest req = new HttpRequest();
		String fullRoute = baseEndpoint + '/' + googleCalendarId;
		req.setEndpoint(fullRoute);
		req.setMethod('GET');
		Logger.debug('Outgoing request', Logger.serializeHttpRequest(req));
		Http http = new Http();
		HTTPResponse res = http.send(req);
		Logger.debug('Incoming response serialized', Logger.serializeHttpResponse(res));
		Logger.saveLogs();

		Integer responseStatusCode = res.getStatusCode();
		if (responseStatusCode == 200) {
			return true;
		}
		return false;
	}

	public GoogleCalendarSyncUtility.GoogleCalendarResponse createEvent(String googleCalendarId, Event sfEvent) {
		HttpRequest req = new HttpRequest();
		String fullRoute = baseEndpoint + '/' + googleCalendarId + '/events';
		req.setEndpoint(fullRoute);
		req.setBody(getGoogleEventToSendJSON(sfEvent, true));
		req.setMethod('POST');
		Logger.debug('Outgoing request', Logger.serializeHttpRequest(req));
		Http http = new Http();
		HTTPResponse res = http.send(req);

		Logger.debug('Incoming response', Logger.serializeHttpResponse(res));
		Logger.saveLogs();

		String newEventId = ((GoogleCalendarSyncUtility.GoogleEventDTO) JSON.deserialize(
				GoogleCalendarSyncUtility.replaceReserved(res.getBody(), reservedKeywords),
				GoogleCalendarSyncUtility.GoogleEventDTO.class
			))
			.id;
		return new GoogleCalendarSyncUtility.GoogleCalendarResponse(res.getStatusCode(), res.getStatus(), newEventId);
	}

	public GoogleCalendarSyncUtility.GoogleCalendarResponse updateEvent(
		String googleCalendarId,
		Event sfEvent,
		String googleEventId
	) {
		HttpRequest req = new HttpRequest();
		String fullRoute = baseEndpoint + '/' + googleCalendarId + '/events/' + googleEventId;
		req.setEndpoint(fullRoute);
		req.setBody(getGoogleEventToSendJson(sfEvent, false));
		req.setMethod('PATCH');
		Logger.debug('Outgoing request', Logger.serializeHttpRequest(req));
		Http http = new Http();
		HTTPResponse res = http.send(req);

		Logger.debug('Incoming response', Logger.serializeHttpResponse(res));
		Logger.saveLogs();
		return new GoogleCalendarSyncUtility.GoogleCalendarResponse(res.getStatusCode(), res.getStatus());
	}

	public GoogleCalendarSyncUtility.GoogleCalendarResponse patchGoogleEvent(
		String googleCalendarId,
		GoogleCalendarSyncUtility.GoogleEventDTO googleEvent,
		String googleEventId
	) {
		HttpRequest req = new HttpRequest();
		String fullRoute = baseEndpoint + '/' + googleCalendarId + '/events/' + googleEventId;
		req.setEndpoint(fullRoute);
		req.setBody(
			GoogleCalendarSyncUtility.stripJsonNulls(
				GoogleCalendarSyncUtility.placeReserved(JSON.serialize(googleEvent), reservedKeywords)
			)
		);
		req.setMethod('PATCH');
		Logger.debug('Outgoing request', Logger.serializeHttpRequest(req));
		Http http = new Http();
		HTTPResponse res = http.send(req);

		Logger.debug('Incoming response', Logger.serializeHttpResponse(res));
		Logger.saveLogs();
		return new GoogleCalendarSyncUtility.GoogleCalendarResponse(res.getStatusCode(), res.getStatus());
	}

	private String getGoogleEventToSendJSON(Event sfEvent, Boolean isNew) {
		GoogleCalendarSyncUtility.GoogleEventDTO eventToGoogle = GoogleCalendarSyncUtility.getGoogleEventFromSFEvent(
			sfEvent,
			sfEvent.IsFromGoogle__c,
			isNew
		);
		return GoogleCalendarSyncUtility.stripJsonNulls(
			GoogleCalendarSyncUtility.placeReserved(JSON.serialize(eventToGoogle), reservedKeywords)
		);
	}

	public GoogleCalendarSyncUtility.GoogleCalendarResponse deleteEvent(String googleCalendarId, String googleEventId) {
		HttpRequest req = new HttpRequest();
		String fullRoute = baseEndpoint + '/' + googleCalendarId + '/events/' + googleEventId;
		req.setEndpoint(fullRoute);
		req.setMethod('DELETE');
		Logger.debug('Outgoing request', Logger.serializeHttpRequest(req));
		Http http = new Http();
		HTTPResponse res = http.send(req);
		Logger.debug('Incoming response', Logger.serializeHttpResponse(res));
		Logger.saveLogs();
		return new GoogleCalendarSyncUtility.GoogleCalendarResponse(res.getStatusCode(), res.getStatus());
	}

	public WatchResponse createWatch(String googleCalendarId, Long expirationInMs, String callbackAddress) {
		HttpRequest req = new HttpRequest();
		String fullRoute = baseEndpoint + '/' + googleCalendarId + '/events/watch';
		req.setEndpoint(fullRoute);
		WatchRequest body = new WatchRequest(expirationInMs);
		body.address = callbackAddress;
		req.setBody(JSON.serialize(body));
		req.setMethod('POST');
		Logger.debug('Outgoing request', Logger.serializeHttpRequest(req));
		Http http = new Http();
		HTTPResponse res = http.send(req);
		WatchResponse response = (WatchResponse) JSON.deserialize(res.getBody(), WatchResponse.class);
		Logger.debug('Incoming response', Logger.serializeHttpResponse(res) + '\n\n' + response);
		Logger.saveLogs();
		return response;
	}

	public GoogleCalendarSyncUtility.GoogleCalendarResponse stopWatch(String watchId, String resourceId) {
		HttpRequest req = new HttpRequest();
		String fullRoute = 'callout:GoogleCalendar/channels/stop';
		req.setEndpoint(fullRoute);
		StopWatchRequest body = new StopWatchRequest(watchId, resourceId);
		req.setBody(JSON.serialize(body));
		req.setMethod('POST');
		Logger.debug('Outgoing request', Logger.serializeHttpRequest(req));
		Http http = new Http();
		HTTPResponse res = http.send(req);
		Logger.debug('Incoming response', Logger.serializeHttpResponse(res));
		Logger.saveLogs();
		return new GoogleCalendarSyncUtility.GoogleCalendarResponse(res.getStatusCode(), res.getStatus());
	}

	public class WatchRequest {
		public WatchRequest(Long expirationInMilisec) {
			this.type = 'webhook';
			String uuid = UUIDUtil.generateUUID();
			this.id = uuid;
			this.token = uuid;
			this.expiration = expirationInMilisec;
		}
		public String id;
		public String address;
		public String token;
		public string type;
		public Long expiration;
	}

	public class WatchResponse {
		public String kind;
		public String id;
		public String resourceId;
		public String resourceUri;
		public String token;
		public Long expiration;
	}

	public class StopWatchRequest {
		public StopWatchRequest(String id, String resourceId) {
			this.id = id;
			this.resourceId = resourceId;
		}
		public String id;
		public String resourceId;
	}

	public class GoogleCalendarServiceException extends Exception {
	}
}
