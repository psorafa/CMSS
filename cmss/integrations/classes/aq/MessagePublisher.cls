public class MessagePublisher {

	private String channel;

	public MessagePublisher(String channel) {
		this.channel = channel;
	}

	public void publishMessage(AQMessage message) {
		// endpoint:
		String endpoint = Url.getSalesforceBaseUrl().toExternalForm() + '/services/data/v49.0/sobjects/StreamingChannel' + channel + '/push';
		HttpRequest request = new HttpRequest();
		request.setEndpoint(endpoint);
		request.setHeader('Content-Type', 'application/json');
		request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId()); // TODO connected app - to umozni i volani z asynchro
		request.setMethod('POST');

		// body:
		String body = JSON.serialize(new EventRequest(message));
		request.setBody(body);
		System.debug(body);

		HttpResponse response = new Http().send(request);
		System.debug('response: ' + response);
		System.debug('response: ' + response.getBody());
	}

	public class EventRequest {
		public List<PushEvent> pushEvents;

		public EventRequest(AQMessage message) {
			pushEvents = new List<MessagePublisher.PushEvent>();
			PushEvent event = new PushEvent();
			event.payload = JSON.serialize(message);
			pushEvents.add(event);
		}
	}

	public class PushEvent {
		public String payload;
		public List<Id> userIds = new List<Id>();
	}
}