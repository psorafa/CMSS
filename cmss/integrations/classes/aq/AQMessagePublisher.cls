public class AQMessagePublisher {

	private List<AQMessage__e> messages;
	private String changeType;
	private String entityName;

	public AQMessagePublisher(String changeType, String entityName) {
		this.changeType = changeType;
		this.entityName = entityName;
		this.messages = new List<AQMessage__e>();
	}

	public void addMessage(Id recordId, Map<String, Object> changedFields) {
		AQMessage__e message = new AQMessage__e(
			EntityName__c = entityName,
			RecordId__c = recordId,
			ChangeType__c = changeType,
			NewValues__c = JSON.serialize(changedFields)
		);
		if (changeType == 'UPDATE') {
			message.ChangedFields__c = JSON.serialize(changedFields.keySet());
		}
		messages.add(message);
	}

	public void addMessage(Id recordId) {
		messages.add(new AQMessage__e(
			EntityName__c = entityName,
			RecordId__c = recordId,
			ChangeType__c = changeType
		));
	}

	public void publish() {
		EventBus.publish(messages);
	}
}