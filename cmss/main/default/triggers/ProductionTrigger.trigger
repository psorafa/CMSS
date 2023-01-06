trigger ProductionTrigger on Production__c(after insert, after update) {
	new ProductionTriggerHandler().run();
}
