trigger CustomSearchConfigurationFilterTrigger on CustomSearchFilter__c(before insert, before update) {
	ValidateSoqlService.validateCustomSearchFilter(Trigger.new);
}
