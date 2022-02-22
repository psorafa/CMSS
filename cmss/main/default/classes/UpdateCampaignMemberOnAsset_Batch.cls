public class UpdateCampaignMemberOnAsset_Batch implements Database.Batchable<sObject>, Schedulable {
	/**
	 * Batchable start - do the query.
	 */
	public Database.QueryLocator start(Database.BatchableContext jobId) {
		return Database.getQueryLocator(
			[
				SELECT
					Id,
					AccountId,
					ProductCloseDate__c,
					ProductType__c,
					(
						SELECT Id, Name, Account__c, CampaignEndDate__c, CampaignStartDate__c, Product__c
						FROM CampaignMembers__r
						ORDER BY CampaignStartDate__c DESC NULLS LAST
					)
				FROM Asset
				WHERE
					AccountId IN (
						SELECT Account__c
						FROM CampaignMember__c
						WHERE CampaignStartDate__c != NULL AND CampaignEndDate__c != NULL
					)
					AND ProductCloseDate__c != NULL
			]
		);
	}

	public void execute(Database.BatchableContext jobId, List<Asset> assets) {
		try {
			List<Asset> assetsToUpdate = new List<Asset>();
			for (Asset a : assets) {
				if (a.CampaignMembers__r.size() == 0) {
					continue;
				}
				List<CampaignMember__c> campaignMembersToProceed = new List<CampaignMember__c>();
				for (CampaignMember__c cm : a.CampaignMembers__r) {
					if (
						a.ProductCloseDate__c > cm.CampaignStartDate__c &&
						a.ProductCloseDate__c < cm.CampaignEndDate__c + 30
					) {
						campaignMembersToProceed.add(cm);
					}
				}

				if (campaignMembersToProceed.size() == 0) {
					continue;
				}
				Boolean foundCMWithSameProduct = false;

				for (CampaignMember__c cm : campaignMembersToProceed) {
					if (a.ProductType__c == cm.Product__c) {
						a.CampaignMember__c = cm.Id;
						foundCMWithSameProduct = true;
						break;
					}
				}
				if (!foundCMWithSameProduct) {
					a.CampaignMember__c = campaignMembersToProceed[0].Id;
				}

				assetsToUpdate.add(a);
			}
			if (assetsToUpdate.size() > 0) {
				System.debug('Updating ' + assetsToUpdate.size() + ' assets.');
				List<Database.SaveResult> results = Database.update(assetsToUpdate, false);
				for (Database.SaveResult result : results) {
					if (!result.isSuccess()) {
						for (Database.Error err : result.getErrors()) {
							Logger.error('Erorr message: ' + err.getMessage() + ' Fields:' + err.getFields());
						}
					}
				}
			}
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}
	/**
	 * Batchable finish - mandatory
	 */
	public void finish(Database.BatchableContext jobId) {
		System.debug('Execution of UpdateCampaignMemberOnAsset_Batch finished');
	}

	public void execute(SchedulableContext sc) {
		Database.executeBatch(this);
	}
}
