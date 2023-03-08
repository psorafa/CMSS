public with sharing class PortfolioManagementRequestTriggerHandler extends TriggerHandler {
	public override void beforeUpdate() {
		PortfolioManagementRequestService.setPortfolioManager(
			Trigger.new,
			(Map<Id, PortfolioManagementRequest__c>) Trigger.oldMap
		);
	}
	public override void afterInsert() {
		PortfolioManagementRequestService.setExternalId(Trigger.new);
	}
	// ***************************** handlers and helping methods***************************************** //
}
