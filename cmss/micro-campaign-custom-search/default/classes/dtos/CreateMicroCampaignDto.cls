public class CreateMicroCampaignDto {
	@AuraEnabled
	public List<String> ids { get; set; }
	@AuraEnabled
	public InputCampaign campaign { get; set; }
	@AuraEnabled
	public InputTask task { get; set; }
	@AuraEnabled
	public String assignee { get; set; }

	public class InputCampaign {
		@AuraEnabled
		public String id { get; set; }
		@AuraEnabled
		public String name { get; set; }
		@AuraEnabled
		public Date endDate { get; set; }
		@AuraEnabled
		public Date startDate { get; set; }
		@AuraEnabled
		public String description { get; set; }
	}

	public class InputTask {
		@AuraEnabled
		public String subject { get; set; }
		@AuraEnabled
		public String description { get; set; }
		@AuraEnabled
		public String productType { get; set; }
		@AuraEnabled
		public String type { get; set; }
		@AuraEnabled
		public Date dueDate { get; set; }
		@AuraEnabled
		public String category { get; set; }
		@AuraEnabled
		public String priority { get; set; }
	}
}
