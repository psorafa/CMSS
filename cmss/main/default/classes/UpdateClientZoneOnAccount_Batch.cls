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
						WHERE AgreementDate__c != NULL AND Role__c != NULL
						ORDER BY AgreementDate__c DESC NULLS LAST
						LIMIT 1
					)
				FROM Account
				WHERE Id IN (SELECT Account__c FROM ClientZone__c WHERE AgreementDate__c != NULL AND Role__c != NULL)
			]
		);
	}

	/**
	 * Batchable execute - process a block of Activities.
	 */
	public void execute(Database.BatchableContext jobId, List<Account> acc) {
		try {
			List<Account> accountsToUpdate = new List<Account>();
			for (Account a : acc) {
				if (a.ClientZones__r.size() == 0) {
					continue;
				}
				a.ClientZoneAccess__c = a.ClientZones__r[0].Role__c;
				accountsToUpdate.add(a);
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
		System.debug('Execution of UpdateClientZoneOnAccount_Batch finished');
	}
}
