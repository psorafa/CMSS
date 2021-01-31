trigger InternalConsentTrigger on InternalConsent__c ( 
    before insert,
	before update,
	before delete,
	after insert,
	after update,
	after delete,
	after undelete
) {
    if (Trigger.isAfter) {
		if (Trigger.isUpdate) {
            ConsentService.processInternalConsent((InternalConsent__c[]) Trigger.new, (Map<Id, InternalConsent__c>) Trigger.oldMap);
		}
	}
}