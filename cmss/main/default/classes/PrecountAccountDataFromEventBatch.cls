public class PrecountAccountDataFromEventBatch implements Database.Batchable<sObject> {
	public Database.QueryLocator start(Database.BatchableContext bc) {
		return Database.getQueryLocator(
			[
				SELECT
					ActivityDate,
					EndDate,
					EndDateTime,
					AccountId,
					Account.OpenedActivityDate__c,
					Account.LastInteractionDate__c
				FROM Event
				WHERE AccountId != NULL
			]
		);
	}

	public Void execute(Database.BatchableContext jobId, List<Event> events) {
		Map<Id, Account> accountsToUpdate = new Map<Id, Account>();
		Account actualAccount;

		for (Event event : events) {
			actualAccount = accountsToUpdate.containsKey(event.AccountId)
				? accountsToUpdate.get(event.AccountId)
				: event.Account;
			if (
				Date.valueOf(event?.EndDateTime) > actualAccount?.LastInteractionDate__c &&
				Date.valueOf(event?.EndDateTime) <= Date.today() || actualAccount?.LastInteractionDate__c == null
			) {
				actualAccount.LastInteractionDate__c = Date.valueOf(event?.EndDateTime);
				accountsToUpdate.put(actualAccount.Id, actualAccount);
			}

			if (
				event.ActivityDate < actualAccount?.OpenedActivityDate__c && event.ActivityDate > Date.today() ||
				actualAccount?.OpenedActivityDate__c == null
			) {
				actualAccount.OpenedActivityDate__c = event?.ActivityDate;
				accountsToUpdate.put(actualAccount.Id, actualAccount);
			}
		}

		update accountsToUpdate.values();
	}

	public Void finish(Database.BatchableContext jobId) {
	}
}
