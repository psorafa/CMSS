/**
 * Created by J. Birka on 21.11.2022
 */
trigger ProductionTrigger on Production__c(after insert, after update) {
	if (Trigger.isInsert) {
		ProductionService.insertProductionSharing(Trigger.new);
	} else {
		//update
		ProductionService.deleteProductionSharing(Trigger.old);
		ProductionService.insertProductionSharing(Trigger.new);
	}
}
