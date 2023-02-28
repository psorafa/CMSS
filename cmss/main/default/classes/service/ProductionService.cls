public with sharing class ProductionService {
	public static void upsertProductionSharing(Map<Id, sObject> newProductionsMap, Map<Id, sObject> oldProductionsMap) {
		List<sObject> productionShrsInsert = new List<sObject>();
		Set<String> productionShrsDeleteSet = new Set<String>();
		Set<Id> productionIdSet = new Set<Id>();

		for (sObject production : newProductionsMap.values()) {
			if (
				production.get('CurrentTeamManager__c') != production.get('TeamManager__c') &&
				(oldProductionsMap.size() == 0 ||
				(oldProductionsMap.size() > 0 &&
				newProductionsMap.get(production.Id).get('TeamManager__c') !=
				oldProductionsMap.get(production.Id).get('TeamManager__c')))
			) {
				productionShrsInsert.add(
					SharingService.prepareCustomShareRecord(
						'Production__Share',
						(Id) production.get('Id'),
						(Id) production.get('TeamManager__c'),
						'Read',
						Schema.Production__Share.rowCause.TeamManager__c
					)
				);
				if (oldProductionsMap.size() > 0) {
					productionShrsDeleteSet.add(
						Id.valueOf(production.Id) +
						'_' +
						Schema.Production__Share.rowCause.TeamManager__c
					);
					productionIdSet.add(production.Id);
				}
			}
			if (
				production.get('CurrentRegionManager__c') != production.get('RegionManager__c') &&
				(oldProductionsMap.size() == 0 ||
				(oldProductionsMap.size() > 0 &&
				newProductionsMap.get(production.Id).get('RegionManager__c') !=
				oldProductionsMap.get(production.Id).get('RegionManager__c')))
			) {
				productionShrsInsert.add(
					SharingService.prepareCustomShareRecord(
						'Production__Share',
						(Id) production.get('Id'),
						(Id) production.get('RegionManager__c'),
						'Read',
						Schema.Production__Share.rowCause.RegionManager__c
					)
				);
				if (oldProductionsMap.size() > 0) {
					productionShrsDeleteSet.add(
						Id.valueOf(production.Id) +
						'_' +
						Schema.Production__Share.rowCause.RegionManager__c
					);
					productionIdSet.add(production.Id);
				}
			}
			if (
				production.get('CurrentSalesNetManager__c') != production.get('SalesNetManager__c') &&
				(oldProductionsMap.size() == 0 ||
				(oldProductionsMap.size() > 0 &&
				newProductionsMap.get(production.Id).get('SalesNetManager__c') !=
				oldProductionsMap.get(production.Id).get('SalesNetManager__c')))
			) {
				productionShrsInsert.add(
					SharingService.prepareCustomShareRecord(
						'Production__Share',
						(Id) production.get('Id'),
						(Id) production.get('SalesNetManager__c'),
						'Read',
						Schema.Production__Share.rowCause.SalesNetManager__c
					)
				);
				if (oldProductionsMap.size() > 0) {
					productionShrsDeleteSet.add(
						Id.valueOf(production.Id) +
						'_' +
						Schema.Production__Share.rowCause.SalesNetManager__c
					);
					productionIdSet.add(production.Id);
				}
			}
		}
		if (!productionShrsDeleteSet.isEmpty()) {
			SharingService.deleteSharingRecords(productionShrsDeleteSet, 'Production__Share', productionIdSet);
		}

		if (!productionShrsInsert.isEmpty()) {
			SharingService.insertShareRecords(productionShrsInsert);
		}
	}
}
