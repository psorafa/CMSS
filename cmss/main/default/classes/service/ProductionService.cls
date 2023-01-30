public with sharing class ProductionService {
	public static void deleteProductionSharing(List<Production__c> oldProductions) {
		try {
			List<Id> oldProductionIDs = new List<Id>();
			for (Production__c prod : oldProductions) {
				oldProductionIDs.add(prod.Id);
			}

			List<Production__Share> oldProductionShrs = [
				SELECT Id
				FROM Production__Share
				WHERE
					ParentId IN :oldProductionIDs
					AND (RowCause = :Schema.Production__Share.rowCause.TeamManager__c
					OR RowCause = :Schema.Production__Share.rowCause.RegionManager__c
					OR RowCause = :Schema.Production__Share.rowCause.SalesNetManager__c)
			];
			delete oldProductionShrs;
		} catch (Exception e) {
			Logger.error('Error in ProductionService.deleteProductionSharing', e);
		} finally {
			Logger.saveLogs();
		}
	}

	private static Production__Share prepareProductionShare(
		Id productionId,
		Id userId,
		String accessLevel,
		String rowCause
	) {
		Production__Share mngrShr = new Production__Share(
			ParentId = productionId,
			UserOrGroupId = userId,
			AccessLevel = accessLevel,
			RowCause = rowCause
		);
		return mngrShr;
	}

	public static void insertProductionSharing(List<Production__c> newProductions) {
		try {
			List<Production__Share> productionShrs = new List<Production__Share>();

			for (Production__c production : newProductions) {
				if (production.CurrentTeamManager__c != production.TeamManager__c) {
					productionShrs.add(
						prepareProductionShare(
							production.Id,
							production.TeamManager__c,
							'Read',
							Schema.Production__Share.rowCause.TeamManager__c
						)
					);
				}
				if (production.CurrentRegionManager__c != production.RegionManager__c) {
					productionShrs.add(
						prepareProductionShare(
							production.Id,
							production.RegionManager__c,
							'Read',
							Schema.Production__Share.rowCause.RegionManager__c
						)
					);
				}
				if (production.CurrentSalesNetManager__c != production.SalesNetManager__c) {
					productionShrs.add(
						prepareProductionShare(
							production.Id,
							production.SalesNetManager__c,
							'Read',
							Schema.Production__Share.rowCause.SalesNetManager__c
						)
					);
				}
			}
			if (!productionShrs.isEmpty()) {
				Database.SaveResult[] lsr = Database.insert(productionShrs, false);
				Integer i = 0;
				for (Database.SaveResult sr : lsr) {
					if (!sr.isSuccess()) {
						Database.Error err = sr.getErrors()[0];
						if (
							!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION &&
							err.getMessage().contains('AccessLevel'))
						) {
							Logger.error(
								'Error in ProductionService.insertProductionSharing',
								'Unable to grant sharing access for Id=' +
								productionShrs[i].ParentId +
								' due to following exception: ' +
								err.getMessage()
							);
						}
					}
					i++;
				}
			}
		} catch (Exception e) {
			Logger.error('Error in ProductionService.insertProductionSharing', e);
		} finally {
			Logger.saveLogs();
		}
	}
}
