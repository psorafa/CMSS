@IsTest
public class TestDataFactory {

	private static Integer accountCounter = 0;
	private static Integer opportunityCounter = 0;

	public static Account getAccount() {
		return new Account(
			Name = 'Test account ' + ++accountCounter
		);
	}

	public static AccountRelation__c getAccountRelation(Id accountId, Id relatedAccountId) {
		if (accountId == null) {
			Account a = getAccount();
			insert a;
			accountId = a.Id;
		}
		if (relatedAccountId == null) {
			Account a = getAccount();
			insert a;
			relatedAccountId = a.Id;
		}
		return new AccountRelation__c(
			Account__c = accountId,
			RelatedAccount__c = relatedAccountId
		);
	}

	public static ClientZone__c getClientZone(Id accountId) {
		if (accountId == null) {
			Account a = getAccount();
			insert a;
			accountId = a.Id;
		}
		return new ClientZone__c(
			Account__c = accountId
		);
	}

	public static Opportunity getOpportunity(Id accountId) {
		if (accountId == null) {
			Account a = getAccount();
			insert a;
			accountId = a.Id;
		}
		return new Opportunity(
			Name = 'Opportunity ' + ++opportunityCounter,
			StageName = '1',
			AccountId = accountId,
			CloseDate = Date.today()
		);
	}

	public static Task getTask(Id whatId) {
		if (whatId == null) {
			Account a = getAccount();
			insert a;
			whatId = a.Id;
		}
		return new Task(
			WhatId = whatId,
			Subject = 'Test task'
		);
	}
}