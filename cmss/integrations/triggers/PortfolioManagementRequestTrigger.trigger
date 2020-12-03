trigger PortfolioManagementRequestTrigger on PortfolioManagementRequest__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

	if (Trigger.isBefore) {
		if (Trigger.isInsert) {
			PortfolioManagementRequestService.setPortfolioManager(Trigger.new, null);
		} else if (Trigger.isUpdate) {
			PortfolioManagementRequestService.setPortfolioManager(Trigger.new, Trigger.oldMap);
		}
    } else if (Trigger.isAfter) {
		if (Trigger.isInsert) {
			PortfolioManagementRequestService.changeCPEClientState(Trigger.new);
		}
	}
}