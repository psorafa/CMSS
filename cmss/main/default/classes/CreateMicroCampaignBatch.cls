public with sharing class CreateMicroCampaignBatch implements Database.Batchable<String>, Database.Stateful {
	CreateMicroCampaignDto dataFromUser;
	Campaign campaign;
	Task task;

	public CreateMicroCampaignBatch(CreateMicroCampaignDto dataFromUser) {
		this.dataFromUser = dataFromUser;
		this.campaign = prepareCampaignTemplate(dataFromUser.campaign);
		this.task = prepareTaskTemplate(dataFromUser.task, dataFromUser.assignee);
	}

	public Iterable<String> start(Database.BatchableContext bc) {
		return this.dataFromUser.ids;
	}

	public void execute(Database.BatchableContext jobId, List<String> accountIds) {
		MicroCampaignCreator creator = new MicroCampaignCreator(accountIds, dataFromUser.assignee, campaign, task);

		MicroCampaignCreator.CreationResult cr = creator.create();
		if (this.campaign != null) {
			campaign.Id = cr.campaignId;
		}
	}

	public void finish(Database.BatchableContext jobId) {
	}

	private Campaign prepareCampaignTemplate(CreateMicroCampaignDto.InputCampaign campaign) {
		if (campaign.id != null) {
			return SearchController.getCampaign(campaign.id, 'Id, Name, EndDate, StartDate, Description');
		}
		if (campaign != null && campaign.name != null) {
			return new Campaign(
				Name = campaign.name,
				EndDate = campaign.endDate,
				StartDate = campaign.startDate,
				Description = campaign.description,
				Type = '10',
				DataSource__c = '73',
				IsActive = true
			);
		}
		return null;
	}

	private Task prepareTaskTemplate(CreateMicroCampaignDto.InputTask task, String assignee) {
		User actualUser = [SELECT CommissionAccountNr__c FROM User WHERE Id = :UserInfo.getUserId()];

		return new Task(
			ActivityDate = task.dueDate,
			Author__c = actualUser.CommissionAccountNr__c,
			Category__c = task.category,
			Description = task.description,
			OwnerId = assignee,
			Priority = task.priority,
			ProductType__c = task.productType,
			Type = task.type,
			Source__c = '73',
			Status = '1',
			Subject = task.subject,
			ValidFrom__c = Date.today(),
			ValidTo__c = Date.today().addMonths(3)
		);
	}
}
