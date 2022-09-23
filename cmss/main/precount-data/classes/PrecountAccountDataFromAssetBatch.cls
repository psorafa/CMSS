global class PrecountAccountDataFromAssetBatch implements Database.Batchable<sObject> {
	global Database.QueryLocator start(Database.BatchableContext bc) {
		return Database.getQueryLocator(
		[
			SELECT ProductCloseDate__c, AccountId, Account.AssetLastCloseDate__c, Account.LastInteractionDate__c
			FROM Asset
			WHERE AccountId != NULL
		]
		);
	}

	public Void execute(Database.BatchableContext jobId, List<Asset> assetList) {
		Map<Id, Account> accountsToUpdate = new Map<Id, Account>();
		Account actualAccount;

		for (Asset asset : assetList) {
			actualAccount = accountsToUpdate.containsKey(asset.AccountId)
				? accountsToUpdate.get(asset.AccountId)
				: asset.Account;

			if (asset.ProductCloseDate__c <= Date.today()) {
				if (
					asset.ProductCloseDate__c > actualAccount?.LastInteractionDate__c ||
						actualAccount?.LastInteractionDate__c == null
				) {
					actualAccount.LastInteractionDate__c = asset.ProductCloseDate__c;
					accountsToUpdate.put(actualAccount.Id, actualAccount);
				}
				if (
					asset.ProductCloseDate__c > actualAccount?.AssetLastCloseDate__c ||
						actualAccount?.AssetLastCloseDate__c == null
				) {
					actualAccount.AssetLastCloseDate__c = asset.ProductCloseDate__c;
					accountsToUpdate.put(actualAccount.Id, actualAccount);
				}
			}
		}
		update accountsToUpdate.values();
	}

	public Void finish(Database.BatchableContext jobId) {
		Database.executeBatch(new PrecountAccountDataFromOpportunityBatch());
	}
}
