public class ProductionSharingRecalc implements Database.Batchable<sObject> {
	public Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(
			[
				SELECT Id, TeamManager__c, RegionManager__c, SalesNetManager__c
				FROM Production__c
			]
		);
	}

	public void execute(Database.BatchableContext BC, List<sObject> scope) {
		List<Production__c> productions = new List<Production__c>((List<Production__c>) scope);
		ProductionService.deleteProductionSharing(Trigger.old);
		ProductionService.insertProductionSharing(Trigger.new);
	}

	public void finish(Database.BatchableContext BC) {
		System.debug('Apex Sharing Recalculation Completed.');
	}
}
