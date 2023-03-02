public class ProductionTriggerHandler extends TriggerHandler {
	public override void afterInsert() {
		ProductionService.upsertProductionSharing(Trigger.new, new Map<Id, Production__c>());
	}

	public override void afterUpdate() {
		ProductionService.upsertProductionSharing(Trigger.new, Trigger.oldMap);
	}
}
