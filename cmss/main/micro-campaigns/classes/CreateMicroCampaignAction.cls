public with sharing class CreateMicroCampaignAction {

	public class Result {
		@InvocableVariable public Integer successes;
		@InvocableVariable public Integer total;
		@InvocableVariable public Integer errorsCount;
		@InvocableVariable public List<Error> errors;
	}

	public class Error {
		@InvocableVariable public String recordName;
		@InvocableVariable public String recordId;
		@InvocableVariable public String errorDetail;
	}

	@InvocableMethod(Label='Create Micro-Campaign' Description='Will create campaign and tasks record')
	public static List<Result> createMicroCampaign(List<String> jsonData) {
		// todo Logger
		System.debug('data: ' + jsonData.get(0));
		InputData data = (InputData) JSON.deserialize(jsonData.get(0), InputData.class);

		Map<Id, Account> accountsMap = new Map<Id, Account>([
			SELECT Id, BillingStreet, BillingCity, BillingPostalCode, OwnerId, Phone, PersonEmail, PersonContactId FROM Account WHERE Id IN :data.ids
		]);

		Id campaignId = createCampaign(data.campaign);
		List<Id> campaignMemberIds = createMembers(campaignId, data);

		List<Task> tasks = new List<Task>();
		for (Integer i = 0; i < data.ids.size(); i++) {
			Id cmId = campaignMemberIds.get(i);
			Id accountId = data.ids.get(i);
			tasks.add(prepareTask(accountsMap.get(accountId), data, cmId, campaignId));
		}

		Result result = new Result();
		result.errors = new List<CreateMicroCampaignAction.Error>();
		result.errorsCount = 0;
		result.successes = 0;

		List<Database.SaveResult> saveResults = Database.insert(tasks, false);
		for (Integer i = 0; i < tasks.size(); i++) {
			Database.SaveResult saveResult = saveResults.get(i);
			if (saveResult.isSuccess()) {
				result.successes++;
			} else {
				result.errorsCount++;
				Error error = new Error();
				// todo log
				error.errorDetail = saveResult.getErrors().get(0).message;
				error.recordId = data.ids.get(i);
				error.recordName = accountsMap.get(data.ids.get(i)).Name;
				result.errors.add(error);
			}
		}
		return new List<Result>{ result };
	}

	private static Task prepareTask(Account account, InputData data, Id cmId, Id campaignId) {
		return new Task(
			ActivityDate = data.task.dueDate,
			Asset__c = null, // todo
			Author__c = UserInfo.getName(),
			CampaignMember__c = cmId,
			Category__c = data.task.category,
			Description = data.task.description,
			Email__c = account.PersonEmail,
			Location__c = account.BillingStreet + ' ' + account.BillingCity + ' ' + account.BillingPostalCode,
			OwnerId = (data.assignee == null) ? account.OwnerId : data.assignee,
			Phone__c = account.Phone,
			Priority = 'Low',
			ProductType__c = data.task.productType,
			Source__c = '73',
			Status = '0',
			StatusReason__c = '12',
			Subject = data.task.subject,
			ValidFrom__c = Date.today(),
			ValidTo__c = Date.today().addMonths(3),
			WhatId = campaignId,
			WhoId = account.PersonContactId
		);
	}

	private static List<Id> createMembers(Id campaignId, InputData data) {
		List<Id> result = new List<Id>();
		if (campaignId != null) {
			List<CampaignMember__c> members = new List<CampaignMember__c>();
			for (Id accountId : data.ids) {
				members.add(new CampaignMember__c(
					Account__c = accountId,
					Campaign__c = campaignId
				));
			}
			insert members;
			for (CampaignMember__c member : members) {
				result.add(member.Id);
			}
		} else {
			for (Id accountId : data.ids) {
				result.add(null);
			}
		}
		return result;
	}

	private static Id createCampaign(InputCampaign campaign) {
		if (campaign.name != null) {
			Campaign c = new Campaign(
				Name = campaign.name,
				EndDate = campaign.endDate,
				Description = campaign.description,
				Type = 'Microcampaign',
				DataSource__c = '73',
				IsActive = true
			);
			insert c;
			return c.Id;
		}
		return null;
	}

	public class InputData {
		public List<String> ids;
		public InputCampaign campaign;
		public InputTask task;
		public String assignee;
	}

	public class InputCampaign {
		public String name;
		public Date endDate;
		public String description;
	}
	public class InputTask {
		public String subject;
		public String description;
		public String productType;
		public Date dueDate;
		public String category;
	}

}