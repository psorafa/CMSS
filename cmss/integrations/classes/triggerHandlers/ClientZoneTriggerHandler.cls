public class ClientZoneTriggerHandler extends TriggerHandler {
	public override void beforeInsert() {
		IntegrationUtility.populateDefaultExternalId(Trigger.new);
	}

	public override void beforeUpdate() {
		IntegrationUtility.populateDefaultExternalId(Trigger.new);
	}

	public override void beforeDelete() {
		AQMessageService.handleDelete(Trigger.old, ClientZone__c.SObjectType);
	}

	public override void afterInsert() {
		AQMessageService.handleInsert(Trigger.new, ClientZone__c.SObjectType);
	}

	public override void afterUndelete() {
		AQMessageService.handleInsert(Trigger.new, ClientZone__c.SObjectType);
	}

	public override void afterUpdate() {
		AQMessageService.handleUpdate(Trigger.new, Trigger.oldMap, ClientZone__c.SObjectType);
	}
}