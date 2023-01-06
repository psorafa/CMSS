public with sharing class PortfolioManagementRequestTriggerHandler extends TriggerHandler {
	public static final String DEFAULT_REQUEST_STATUS = '4';

	public override void beforeInsert() {
		setDefaultRequestStatus(Trigger.new);
	}

	public override void beforeUpdate() {
		PortfolioManagementRequestService.setPortfolioManager(
			Trigger.new,
			(Map<Id, PortfolioManagementRequest__c>) Trigger.oldMap
		);
	}

	// ***************************** handlers and helping methods***************************************** //

    private static void setDefaultRequestStatus(List<PortfolioManagementRequest__c> requests) {
		for (PortfolioManagementRequest__c request : requests) {
			request.RequestStatus__c = DEFAULT_REQUEST_STATUS;
		}
	}
}
