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
		System.debug('data: ' + jsonData.get(0));
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