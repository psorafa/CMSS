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

	public void addMessage(Id recordId, String externalId, Map<String, Object> changedFields) {
		if (changedFields.isEmpty()) {
			return;
		}
		SObject message = messageType.newSObject();
		message.put('EntityName__c', entityName);
		message.put('RecordId__c', recordId);
		message.put('ChangeType__c', changeType);
		message.put('NewValues__c', JSON.serialize(changedFields));
		message.put('ExternalId__c', externalId);
		if (changeType == 'UPDATE') {
			message.put('ChangedFields__c', JSON.serialize(changedFields.keySet()));
		}
		messages.add(message);
	}

	public void addMessage(Id recordId, String externalId) {
		SObject message = messageType.newSObject();
		message.put('EntityName__c', entityName);
		message.put('RecordId__c', recordId);
		message.put('ChangeType__c', changeType);
		message.put('ExternalId__c', externalId);
	}

	public void publish() {
		EventBus.publish(messages);
	}
}
