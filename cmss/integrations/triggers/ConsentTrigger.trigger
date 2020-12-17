trigger ConsentTrigger on Consent__c (
    before insert,
	before update,
	before delete,
	after insert,
	after update,
	after delete,
	after undelete
) {
    if (Trigger.isAfter) {
		if (Trigger.isInsert) {
			ConsentService.processGeneralConsent((List<Consent__c>) Trigger.new);
		}
		if (Trigger.isUpdate) {
            ConsentService.processChannelConsent(Trigger.new, Trigger.oldMap);
		}
	}
}