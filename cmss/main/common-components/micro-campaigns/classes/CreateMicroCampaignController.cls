public with sharing class CreateMicroCampaignController {
	public class PicklistEntry {
		@AuraEnabled
		public String value;
		@AuraEnabled
		public String label;
	}

	@AuraEnabled(Cacheable=true)
	public static List<PicklistEntry> getPicklistValues(String objectName, String fieldName) {
		try {
			Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectName);
			Schema.DescribeSObjectResult res = convertToObj.getDescribe();
			Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(fieldName).getDescribe();
			List<PicklistEntry> pickListValuesList = new List<PicklistEntry>();
			List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			for (Schema.PicklistEntry pickListVal : ple) {
				PicklistEntry entry = new PicklistEntry();
				entry.label = pickListVal.getLabel();
				entry.value = pickListVal.getValue();
				pickListValuesList.add(entry);
			}
			return pickListValuesList;
		} catch (Exception e) {
			Logger.error('Unexpected error', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	@AuraEnabled
	public static MicroCampaignCreator.CreationResult createMicroCampaign(String jsonData) {
		try {
			Logger.debug('Incoming data', jsonData);
			InputData data = (InputData) JSON.deserialize(jsonData, InputData.class);
			MicroCampaignCreator creator = new MicroCampaignCreator(
				data.ids,
				prepareCampaignTemplate(data.campaign),
				prepareTaskTemplate(data.task, data.assignee)
			);
			return creator.create();
		} catch (Exception e) {
			Logger.error('Error in micro-campaign creation', e);
			throw new AuraHandledException(
				'Unexpected exception: ' +
				e.getMessage() +
				'; transactionId: ' +
				Logger.getTransactionId()
			);
		} finally {
			Logger.saveLogs();
		}
	}

	@TestVisible
	private static Campaign prepareCampaignTemplate(InputCampaign campaign) {
		if (campaign.id != null) {
			return SearchController.getCampaign(campaign.id, 'Id, Name, EndDate, StartDate, Description');
		}
		if (campaign != null && campaign.name != null) {
			return new Campaign(
				Name = campaign.name,
				EndDate = campaign.endDate,
				StartDate = campaign.startDate,
				Description = campaign.description,
				Type = 'Microcampaign',
				DataSource__c = '73',
				IsActive = true
			);
		}
		return null;
	}

	private static Task prepareTaskTemplate(InputTask task, String assignee) {
		return new Task(
			ActivityDate = task.dueDate,
			Author__c = UserInfo.getName(),
			Category__c = task.category,
			Description = task.description,
			OwnerId = assignee,
			Priority = 'Low',
			ProductType__c = task.productType,
			Type = task.type,
			Source__c = '73',
			Status = '1',
			Subject = task.subject,
			ValidFrom__c = Date.today(),
			ValidTo__c = Date.today().addMonths(3)
		);
	}

	public class InputData {
		public List<String> ids;
		public InputCampaign campaign;
		public InputTask task;
		public String assignee;
	}

	public class InputCampaign {
		public String id;
		public String name;
		public Date endDate;
		public Date startDate;
		public String description;
	}

	public class InputTask {
		public String subject;
		public String description;
		public String productType;
		public String type;
		public Date dueDate;
		public String category;
	}
}
