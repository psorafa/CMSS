global class PrecountAccountDataFromTaskBatch implements Database.Batchable<sObject> {
	global Database.QueryLocator start(Database.BatchableContext bc) {
		return Database.getQueryLocator(
		[
			SELECT
				ActivityDate,
				CompletedDateTime,
				AccountId,
				Status,
				Account.OpenedActivityDate__c,
				Account.LastInteractionDate__c
			FROM Task
			WHERE AccountId != NULL
		]
		);
	}

	public Void execute(Database.BatchableContext jobId, List<Task> taskList) {
		Map<Id, Account> accountsToUpdate = new Map<Id, Account>();
		Account actualAccount;

		for (Task task : taskList) {
			actualAccount = accountsToUpdate.containsKey(task.AccountId)
				? accountsToUpdate.get(task.AccountId)
				: task.Account;
			if (
				task?.CompletedDateTime?.date() <= Date.today() &&
					(task?.CompletedDateTime > actualAccount?.LastInteractionDate__c ||
						actualAccount?.LastInteractionDate__c == null)
			) {
				actualAccount.LastInteractionDate__c = (Date) task?.CompletedDateTime.date();
				accountsToUpdate.put(actualAccount.Id, actualAccount);
			}

			if (
				task.ActivityDate >= Date.today() && (task.Status == '1' || task.Status == '2') &&
					task.ActivityDate < actualAccount?.OpenedActivityDate__c || actualAccount?.OpenedActivityDate__c == null
			) {
				actualAccount.OpenedActivityDate__c = task?.ActivityDate;
				accountsToUpdate.put(actualAccount.Id, actualAccount);
			}
		}

		update accountsToUpdate.values();
	}

	public Void finish(Database.BatchableContext jobId) {
	}
}
