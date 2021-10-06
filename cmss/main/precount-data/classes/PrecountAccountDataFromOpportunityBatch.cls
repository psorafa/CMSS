global class PrecountAccountDataFromOpportunityBatch implements Database.Batchable<sObject> {
	global Database.QueryLocator start(Database.BatchableContext bc) {
		return Database.getQueryLocator(
			[
				SELECT
					LastModifiedDate,
					CloseDate,
					StageName,
					AccountId,
					Account.OpenedOpportunityDate__c,
					Account.LastInteractionDate__c
				FROM Opportunity
				WHERE AccountId != NULL
			]
		);
	}

	public Void execute(Database.BatchableContext jobId, List<Opportunity> opportunityList) {
		Map<Id, Account> accountsToUpdate = new Map<Id, Account>();
		Account actualAccount;

		for (Opportunity opportunity : opportunityList) {
			actualAccount = accountsToUpdate.containsKey(opportunity.AccountId)
				? accountsToUpdate.get(opportunity.AccountId)
				: opportunity.Account;
			if (
				opportunity.LastModifiedDate.date() <= Date.today() &&
				(opportunity.LastModifiedDate > actualAccount?.LastInteractionDate__c ||
				actualAccount?.LastInteractionDate__c == null)
			) {
				actualAccount.LastInteractionDate__c = (Date) opportunity.LastModifiedDate.date();
				accountsToUpdate.put(actualAccount.Id, actualAccount);
			}

			if (
				opportunity.CloseDate > Date.today() &&
				(opportunity.StageName == '1' ||
				opportunity.StageName == '2' ||
				opportunity.StageName == '3') &&
				(opportunity.CloseDate < actualAccount?.OpenedOpportunityDate__c ||
				actualAccount?.OpenedOpportunityDate__c == null)
			) {
				actualAccount.OpenedOpportunityDate__c = opportunity.CloseDate;
				accountsToUpdate.put(actualAccount.Id, actualAccount);
			}
		}

		update accountsToUpdate.values();
	}

	public Void finish(Database.BatchableContext jobId) {
		Database.executeBatch(new PrecountAccountDataFromTaskBatch());
	}
}
