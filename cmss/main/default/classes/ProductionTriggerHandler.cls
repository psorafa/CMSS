public class ProductionTriggerHandler extends TriggerHandler {
	public override void afterInsert() {
		ProductionService.insertProductionSharing(Trigger.new);
	}

	public override void afterUpdate() {
		ProductionService.deleteProductionSharing(Trigger.old);
		ProductionService.insertProductionSharing(Trigger.new);
	}
}
