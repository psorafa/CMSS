trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

	if (Trigger.isAfter) {
		if (Trigger.isInsert || Trigger.isUndelete) {
			AQMessageService.handleInsert(Trigger.new, Opportunity.SObjectType);
		}
		if (Trigger.isUpdate) {
			AQMessageService.handleUpdate(Trigger.new, Trigger.oldMap, Opportunity.SObjectType);
		}
	}
	if (Trigger.isBefore) {
		if (Trigger.isDelete) {
			AQMessageService.handleDelete(Trigger.old, Opportunity.SObjectType);
		}
	}
}