trigger ClientZoneTrigger on ClientZone__c (
	before insert,
	before update,
	before delete,
	after insert,
	after update,
	after delete,
	after undelete
) {
	new ClientZoneTriggerHandler().run();
}