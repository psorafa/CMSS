public class UpdateClientZoneOnAccount_Batch implements Database.Batchable<sObject> {
	/**
	 * Batchable start - do the query.
	 */
	public Database.QueryLocator start(Database.BatchableContext jobId) {
		return Database.getQueryLocator(
			[
				SELECT
					Id,
					(
						SELECT Id, AgreementDate__c, toLabel(Role__c)
						FROM ClientZones__r
						ORDER BY AgreementDate__c DESC NULLS LAST
					)
				FROM Account
			]
		);
	}

	/**
	 * Batchable execute - process a block of Activities.
	 */
	public void execute(Database.BatchableContext jobId, List<Account> acc) {
		List<Account> accountsToUpdate = new List<Account>();
		for (Account a : acc) {
			if (a.ClientZones__r.size() == 0) {
				continue;
			}
			if (a.ClientZones__r[0].AgreementDate__c != null) {
				a.ClientZoneAccess__c = a.ClientZones__r[0].Role__c;
				accountsToUpdate.add(a);
			}
		}
		if (accountsToUpdate.size() > 0) {
			System.debug('Updating ' + accountsToUpdate.size() + ' accounts.');
			List<Database.SaveResult> results = Database.update(accountsToUpdate, false);
			for (Database.SaveResult result : results) {
				if (!result.isSuccess()) {
					for (Database.Error err : result.getErrors()) {
						Logger.error('Erorr message: ' + err.getMessage() + ' Fields:' + err.getFields());
					}
				}
			}
			Logger.saveLogs();
		}
	}
	/**
	 * Batchable finish - mandatory
	 */
	public void finish(Database.BatchableContext jobId) {
		System.debug('Execution of UpdateClientZoneOnAccount_Batch finished');
	}
}
