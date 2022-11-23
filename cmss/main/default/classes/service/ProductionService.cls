/**
 * Created by J. Birka on 21.11.2022
 */
public without sharing class ProductionService {
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

	public static void insertProductionSharing(List<Production__c> newProductions) {
		try {
			List<Production__Share> productionShrs = new List<Production__Share>();
			Production__Share teamMngrShr;
			Production__Share regionMngrShr;
			Production__Share salesNetMngrShr;

			for (Production__c production : newProductions) {
				if (production.CurrentTeamManager__c != production.TeamManager__c) {
					teamMngrShr = new Production__Share();
					teamMngrShr.ParentId = production.Id;
					teamMngrShr.UserOrGroupId = production.TeamManager__C;
					teamMngrShr.AccessLevel = 'Read';
					teamMngrShr.RowCause = Schema.Production__Share.rowCause.TeamManager__c;
					productionShrs.add(teamMngrShr);
				}
				if (production.CurrentRegionManager__c != production.RegionManager__c) {
					regionMngrShr = new Production__Share();
					regionMngrShr.ParentId = production.Id;
					regionMngrShr.UserOrGroupId = production.RegionManager__c;
					regionMngrShr.AccessLevel = 'Read';
					regionMngrShr.RowCause = Schema.Production__Share.rowCause.RegionManager__c;
					productionShrs.add(regionMngrShr);
				}
				if (production.CurrentSalesNetManager__c != production.SalesNetManager__c) {
					salesNetMngrShr = new Production__Share();
					salesNetMngrShr.ParentId = production.Id;
					salesNetMngrShr.UserOrGroupId = production.SalesNetManager__c;
					salesNetMngrShr.AccessLevel = 'Read';
					salesNetMngrShr.RowCause = Schema.Production__Share.rowCause.SalesNetManager__c;
					productionShrs.add(salesNetMngrShr);
				}

				if (!productionShrs.isEmpty()) {
					// Insert sharing records and capture save result
					Database.SaveResult[] lsr = Database.insert(productionShrs, false);
					Integer i = 0;
					// Process the save results
					for (Database.SaveResult sr : lsr) {
						if (!sr.isSuccess()) {
							Database.Error err = sr.getErrors()[0];

							// Check if the error is related to a trivial access level
							// Access levels equal or more permissive than the object's default access level are not allowed.
							// These sharing records are not required and thus an insert exception is acceptable.
							if (
								!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION &&
								err.getMessage().contains('AccessLevel'))
							) {
								// Log an error when the error is not related to trivial access level.
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
					} //end for
				} //end empty check
			}
		} catch (Exception e) {
			Logger.error('Error in ProductionService.insertProductionSharing', e);
		} finally {
			Logger.saveLogs();
		}
	}
}
