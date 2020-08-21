public class AQMessagePublisher {

	private List<SObject> messages;
	private String changeType;
	private String entityName;
	private SObjectType messageType;

	public AQMessagePublisher(String changeType, SObjectType entityType, SObjectType messageType) {
		this.changeType = changeType;
		this.entityName = '' + entityType;
		this.messages = new List<SObject>();
		this.messageType = messageType;
	}

	public void addMessage(Id recordId, Map<String, Object> changedFields) {
		SObject message = messageType.newSObject();
		message.put('EntityName__c', entityName);
		message.put('RecordId__c', recordId);
		message.put('ChangeType__c', changeType);
		message.put('NewValues__c', JSON.serialize(changedFields));
		if (changeType == 'UPDATE') {
			message.put('ChangedFields__c', JSON.serialize(changedFields.keySet()));
		}
		messages.add(message);
	}

	public void addMessage(Id recordId) {
		SObject message = messageType.newSObject();
		message.put('EntityName__c', entityName);
		message.put('RecordId__c', recordId);
		message.put('ChangeType__c', changeType);
	}

	public void publish() {
		EventBus.publish(messages);
	}
}