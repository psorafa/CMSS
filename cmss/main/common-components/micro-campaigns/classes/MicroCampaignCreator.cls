public with sharing class MicroCampaignCreator {
	private final Boolean assetsBased;
	private final Task taskTemplate;
	private final Campaign campaign;
	private Map<Id, CampaignMember__c> campaignMembersByAccountId;
	private Map<Id, Account> accountsMap;
	private Map<Id, Asset> assetsMap;
	private Map<Id, Account> accountsByPersonContactId;
	private Set<Account> uninsertableMembers = new Set<Account>();

	public MicroCampaignCreator(List<Id> ids, Campaign campaignTemplate, Task taskTemplate) {
		this.assetsBased = ids.get(0).getSobjectType() == Asset.SObjectType;
		this.taskTemplate = taskTemplate;
		this.campaign = campaignTemplate;
		loadDataToMaps(ids);
	}

	private void loadDataToMaps(List<Id> ids) {
		if (assetsBased) {
			assetsMap = new Map<Id, Asset>([SELECT Id, AccountId FROM Asset WHERE Id IN :ids AND AccountId != NULL]);
			Set<Id> accountIds = new Set<Id>();
			for (Asset asset : assetsMap.values()) {
				accountIds.add(asset.AccountId);
			}
			ids = new List<Id>(accountIds);
		}
		accountsMap = new Map<Id, Account>(
			[
				SELECT
					Id,
					Name,
					PersonContactId,
					PersonEmail,
					BillingStreet,
					BillingCity,
					BillingPostalCode,
					Phone,
					OwnerId,
					UserRecordAccess.HasEditAccess
				FROM Account
				WHERE Id IN :ids
			]
		);
		accountsByPersonContactId = new Map<Id, Account>();
		for (Account account : accountsMap.values()) {
			accountsByPersonContactId.put(account.PersonContactId, account);
		}
	}

	public CreationResult create() {
		createCampaign();
		createCampaignMembers();
		List<Task> tasks;
		if (assetsBased) {
			tasks = prepareTasksFromAssets();
		} else {
			tasks = prepareTasksFromAccounts();
		}
		return insertTasks(tasks);
	}

	private void createCampaign() {
		if (campaign != null && campaign.Id == null) {
			insert campaign;
		}
	}

	private void createCampaignMembers() {
		campaignMembersByAccountId = new Map<Id, CampaignMember__c>();
		if (campaign != null) {
			for (Id accountId : accountsMap.keySet()) {
				if (accountsMap.get(accountId)?.UserRecordAccess?.HasEditAccess) {
					CampaignMember__c member = new CampaignMember__c(Account__c = accountId, Campaign__c = campaign.Id);
					campaignMembersByAccountId.put(accountId, member);
				} else {
					uninsertableMembers.add(accountsMap.get(accountId));
				}
			}
			insert campaignMembersByAccountId.values();
		}
	}

	private List<Task> prepareTasksFromAccounts() {
		List<Task> tasks = new List<Task>();
		for (Account account : accountsMap.values()) {
			if (campaignMembersByAccountId.keySet().contains(String.valueOf(account.Id))) {
				Task t = prepareTaskFromTemplate(account);
				tasks.add(t);
			}
		}
		return tasks;
	}

	private List<Task> prepareTasksFromAssets() {
		List<Task> tasks = new List<Task>();
		for (Asset asset : assetsMap.values()) {
			if (campaignMembersByAccountId.keySet().contains(String.valueOf(asset.AccountId))) {
				Task t = prepareTaskFromTemplate(accountsMap.get(asset.AccountId));
				t.Asset__c = asset.Id;
				tasks.add(t);
			}
		}
		return tasks;
	}

	private Task prepareTaskFromTemplate(Account account) {
		Task t = taskTemplate.clone();
		if (campaign != null) {
			t.CampaignMember__c = campaignMembersByAccountId.get(account.Id).Id;
			t.WhatId = campaign.Id;
		}
		if (t.OwnerId == null) {
			t.OwnerId = account.OwnerId;
		}
		t.WhoId = account.PersonContactId;
		t.Email__c = account.PersonEmail;
		t.Location__c = account.BillingStreet + ' ' + account.BillingCity + ' ' + account.BillingPostalCode;
		t.Phone__c = account.Phone;
		return t;
	}

	private CreationResult insertTasks(List<Task> tasks) {
		CreationResult creationResult = new CreationResult();
		creationResult.erroredAccounts = new List<Account>();
		creationResult.erroredRecords = new List<SObject>();
		creationResult.numberOfSuccesses = 0;
		creationResult.campaignId = campaign?.Id;

		List<Database.SaveResult> saveResults = Database.insert(tasks, false);
		for (Integer i = 0; i < tasks.size(); i++) {
			Task task = tasks.get(i);
			Database.SaveResult saveResult = saveResults.get(i);
			if (saveResult.isSuccess()) {
				creationResult.numberOfSuccesses++;
			} else {
				if (assetsBased) {
					creationResult.erroredRecords.add(assetsMap.get(task.Asset__c));
				} else {
					creationResult.erroredRecords.add(accountsByPersonContactId.get(task.WhoId));
				}
				Logger.error(
					'Cannot create task for micro-campaign',
					'Task:\n' +
					JSON.serializePretty(tasks.get(i)) +
					'\nError:\n' +
					JSON.serializePretty(saveResult.getErrors())
				);
			}
		}
		for (Account limitedAccessAccount : uninsertableMembers) {
			creationResult.erroredAccounts.add(limitedAccessAccount);
			Logger.error(
				'Cannot create campaign member for micro-campaign ' + JSON.serializePretty(campaign),
				'Insufficient access to Account:\n' + JSON.serializePretty(limitedAccessAccount)
			);
		}
		creationResult.numberOfErrors = creationResult.erroredRecords.size() + creationResult.erroredAccounts.size();
		creationResult.transactionId = Logger.getTransactionId();
		return creationResult;
	}

	public class CreationResult {
		@AuraEnabled
		public Integer numberOfSuccesses;
		@AuraEnabled
		public Integer numberOfErrors;
		@AuraEnabled
		public List<SObject> erroredRecords;
		@AuraEnabled
		public List<Account> erroredAccounts;
		@AuraEnabled
		public String transactionId;
		@AuraEnabled
		public Id campaignId;
	}
}
