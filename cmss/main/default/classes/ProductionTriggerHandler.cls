public class ProductionTriggerHandler extends TriggerHandler {
	public override void afterInsert() {
		Map<Id, Production__c> oldMap = new Map<Id, Production__c>();
		ProductionService.upsertProductionSharing(Trigger.newMap, oldMap);
	}

	public override void afterUpdate() {
		ProductionService.upsertProductionSharing(Trigger.newMap, Trigger.oldMap);
	}
}
