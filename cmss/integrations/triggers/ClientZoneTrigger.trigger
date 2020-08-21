trigger ClientZoneTrigger on ClientZone__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

	if (Trigger.isAfter) {
		if (Trigger.isInsert || Trigger.isUndelete) {
			AQMessageService.handleInsert(Trigger.new, ClientZone__c.SObjectType);
		}
		if (Trigger.isUpdate) {
			AQMessageService.handleUpdate(Trigger.new, Trigger.oldMap, ClientZone__c.SObjectType);
		}
	}
	if (Trigger.isBefore) {
		if (Trigger.isDelete) {
			AQMessageService.handleDelete(Trigger.old, ClientZone__c.SObjectType);
		}
	}
}