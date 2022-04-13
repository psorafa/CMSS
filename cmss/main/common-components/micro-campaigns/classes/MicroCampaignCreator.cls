public with sharing class MicroCampaignCreator {
	private final Boolean assetsBased;
	private final Task taskTemplate;
	private final Campaign campaign;
	private final Id assignedUser;
	private Map<Id, CampaignMember__c> campaignMembersByAccountId;
	private Map<Id, Account> accountsMap;
	private Map<Id, Asset> assetsMap;
	private Map<Id, Account> accountsByPersonContactId;
	private Set<Account> invalidAccounts = new Set<Account>();
	private Map<Id, String> invalidResults = new Map<Id, String>();
	private Set<Account> uninsertableMembers = new Set<Account>();
	private Map<Id, UserRole> allRoles;
	private Map<Id, Id> usersToRoleIds;
	private String actualUserProfileName;

	public MicroCampaignCreator(List<Id> ids, Id assignedUser, Campaign campaignTemplate, Task taskTemplate) {
		this.assetsBased = ids.get(0).getSobjectType() == Asset.SObjectType;
		this.assignedUser = assignedUser;
		this.taskTemplate = taskTemplate;
		this.campaign = campaignTemplate;
		this.actualUserProfileName = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()].Name;
		loadDataToMaps(ids);
	}

	private void loadDataToMaps(List<Id> ids) {
		if (assetsBased) {
			assetsMap = new Map<Id, Asset>(
				[SELECT Id, AccountId, Name FROM Asset WHERE Id IN :ids AND AccountId != NULL]
			);
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
		generateRolesMap(accountsMap.values());

		if (assignedUser != null && !isAssigneeSubordinate(assignedUser)) {
			invalidAccounts.addAll(accountsMap.values());
			for (Id accId : accountsMap.keySet()) {
				invalidResults.put(accId, 'Uživatel není váš podřízený.');
			}
		} else {
			for (Account account : accountsMap.values()) {
				if (account.PersonContactId != null && isAssigneeSubordinate(account.OwnerId)) {
					accountsByPersonContactId.put(account.PersonContactId, account);
				} else {
					invalidAccounts.add(account);
					if (account.PersonContactId == null) {
						invalidResults.put(account.Id, 'Zvolený account není klient.');
					} else {
						invalidResults.put(account.Id, 'Uživatel není váš podřízený.');
					}
				}
			}
		}
	}

	private void generateRolesMap(List<Account> accounts) {
		allRoles = new Map<Id, UserRole>([SELECT Id, ParentRoleId FROM UserRole]);
		usersToRoleIds = new Map<Id, Id>();
		Set<Id> ownerIds = new Set<Id>();
		for (Account acc : accounts) {
			ownerIds.add(acc.OwnerId);
		}
		if (assignedUser != null) {
			ownerIds.add(assignedUser);
		}
		List<User> owners = [SELECT Id, UserRoleId FROM User WHERE Id IN :ownerIds];
		for (User owner : owners) {
			usersToRoleIds.put(owner.Id, owner.UserRoleId);
		}
	}

	private Boolean isAssigneeSubordinate(Id userId) {
		Id actualUserRoleId = UserInfo.getUserRoleId();
		if (actualUserProfileName == 'System Administrator') {
			return true;
		}
		Id assigneeUserRoleId = usersToRoleIds.get(userId);
		if (assigneeUserRoleId == null) {
			return false;
		}
		if (actualUserRoleId == assigneeUserRoleId) {
			return true;
		}
		UserRole actualRole = allRoles.get(assigneeUserRoleId);
		while (actualRole?.ParentRoleId != null) {
			if (actualRole.ParentRoleId == actualUserRoleId) {
				return true;
			}
			actualRole = allRoles.get(actualRole.ParentRoleId);
		}
		return false;
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
			if (
				(campaign == null || campaignMembersByAccountId.keySet().contains(String.valueOf(account.Id))) &&
				!invalidAccounts.contains(account)
			) {
				Task t = prepareTaskFromTemplate(account);
				tasks.add(t);
			}
		}
		return tasks;
	}

	private List<Task> prepareTasksFromAssets() {
		List<Task> tasks = new List<Task>();
		for (Asset asset : assetsMap.values()) {
			if (
				(campaign == null || campaignMembersByAccountId.keySet().contains(String.valueOf(asset.AccountId))) &&
				!invalidAccounts.contains(accountsMap.get(asset.AccountId))
			) {
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
		creationResult.successfulRecords = new List<SObject>();
		creationResult.erroredRecords = new List<ErroredRecord>();
		creationResult.numberOfSuccesses = 0;
		creationResult.campaignId = campaign?.Id;

		List<Database.SaveResult> saveResults = Database.insert(tasks, false);
		for (Integer i = 0; i < tasks.size(); i++) {
			Task task = tasks.get(i);
			Database.SaveResult saveResult = saveResults.get(i);
			if (saveResult.isSuccess()) {
				creationResult.numberOfSuccesses++;
				if (assetsBased) {
					creationResult.successfulRecords.add(assetsMap.get(task.Asset__c));
				} else {
					creationResult.successfulRecords.add(accountsByPersonContactId.get(task.WhoId));
				}
			} else {
				if (assetsBased) {
					creationResult.erroredRecords.add(
						new ErroredRecord(assetsMap.get(task.Asset__c), saveResult.getErrors().toString())
					);
				} else {
					creationResult.erroredRecords.add(
						new ErroredRecord(accountsByPersonContactId.get(task.WhoId), saveResult.getErrors().toString())
					);
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
			Logger.error(
				'Cannot create campaign member for micro-campaign ' + JSON.serializePretty(campaign),
				'Insufficient access to Account:\n' + JSON.serializePretty(limitedAccessAccount)
			);
		}
		creationResult.numberOfErrors = creationResult.erroredRecords.size();
		for (Account invalidAccount : invalidAccounts) {
			creationResult.numberOfErrors++;
			creationResult.erroredRecords.add(new ErroredRecord(invalidAccount, invalidResults.get(invalidAccount.Id)));
		}

		creationResult.transactionId = Logger.getTransactionId();
		creationResult.onObject = assetsBased ? 'Asset' : 'Account';

		System.debug(creationResult.erroredRecords);
		return creationResult;
	}

	public class CreationResult {
		@AuraEnabled
		public Integer numberOfSuccesses;
		@AuraEnabled
		public Integer numberOfErrors;
		@AuraEnabled
		public List<ErroredRecord> erroredRecords;
		@AuraEnabled
		public List<SObject> successfulRecords;
		@AuraEnabled
		public String transactionId;
		@AuraEnabled
		public Id campaignId;
		@AuraEnabled
		public String onObject;
	}

	public class ErroredRecord {
		@AuraEnabled
		public SObject erroredObject;
		@AuraEnabled
		public String errorMessage;

		public ErroredRecord(SObject erroredObject, String errorMessage) {
			this.erroredObject = erroredObject;
			this.errorMessage = errorMessage;
		}
	}
}
