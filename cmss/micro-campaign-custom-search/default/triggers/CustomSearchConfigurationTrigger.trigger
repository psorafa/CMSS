trigger CustomSearchConfigurationTrigger on CustomSearchConfiguration__c(before insert, before update) {
	ValidateSoqlService.validateCustomSearchConfiguration(Trigger.new);
}
