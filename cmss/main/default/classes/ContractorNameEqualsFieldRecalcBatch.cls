public class ContractorNameEqualsFieldRecalcBatch implements Database.Batchable<sObject> {
	public Database.QueryLocator start(Database.BatchableContext jobId) {
		return Database.getQueryLocator(
			[
				SELECT
					Id,
					ComplainerLastName__c,
					ComplainerFirstName__c,
					ComplainerContractor__c,
					ComplainerContractor__r.FirstName,
					ComplainerContractor__r.LastName,
					Account.FirstName,
					Account.LastName,
					AccountId,
					AccountComplainerNameEquals__c,
					AccountContractorNameEquals__c,
					ContractorNameEquals__c
				FROM Case
				WHERE IsClosed != TRUE
			]
		);
	}
	public void execute(Database.BatchableContext jobId, List<Case> caseList) {
		List<Case> toUpdateCaseList = new List<Case>();

		for (Case c : caseList) {
			setAccountContractorNameEquals(c);
			setAccountComplainerNameEquals(c);
			setContractorNameEquals(c);

			toUpdateCaseList.add(c);
		}
		try {
			update toUpdateCaseList;
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	public void finish(Database.BatchableContext jobId) {
	}

	private void setContractorNameEquals(Case c) {
		if (c.ComplainerContractor__c != null) {
			if (
				c.ComplainerFirstName__c == c.ComplainerContractor__r.FirstName &&
				c.ComplainerLastName__c == c.ComplainerContractor__r.LastName
			) {
				c.ContractorNameEquals__c = true;
			} else {
				c.ContractorNameEquals__c = false;
			}
		} else {
			c.ContractorNameEquals__c = false;
		}
	}

	private void setAccountContractorNameEquals(Case c) {
		if (c.Account != null && c.ComplainerContractor__c != null) {
			if (
				c.Account.FirstName == c.ComplainerContractor__r.FirstName &&
				c.Account.LastName == c.ComplainerContractor__r.LastName
			) {
				c.AccountContractorNameEquals__c = true;
			} else {
				c.AccountContractorNameEquals__c = false;
			}
		} else {
			c.AccountContractorNameEquals__c = false;
		}
	}
	private void setAccountComplainerNameEquals(Case c) {
		if (c.Account != null) {
			if (c.ComplainerFirstName__c == c.Account.FirstName && c.ComplainerLastName__c == c.Account.LastName) {
				c.AccountComplainerNameEquals__c = true;
			} else {
				c.AccountComplainerNameEquals__c = false;
			}
		} else {
			c.AccountComplainerNameEquals__c = false;
		}
	}
}
