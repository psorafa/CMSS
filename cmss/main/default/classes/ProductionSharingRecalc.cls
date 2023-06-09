public class ProductionSharingRecalc implements Database.Batchable<sObject> {
	public Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(
			[
				SELECT
					Id,
					TeamManager__c,
					RegionManager__c,
					SalesNetManager__c,
					CurrentTeamManager__c,
					CurrentRegionManager__c,
					CurrentSalesNetManager__c
				FROM Production__c
			]
		);
	}

	public void execute(Database.BatchableContext BC, List<Production__c> scope) {
		SharingService.deleteSharingRecords(scope, 'Production__Share');
		Map<Id, Production__c> oldMap = new Map<Id, Production__c>();
		ProductionService.upsertProductionSharing(scope, oldMap);
	}

	public void finish(Database.BatchableContext BC) {
		System.debug('Apex Sharing Recalculation Completed.');
	}
}
