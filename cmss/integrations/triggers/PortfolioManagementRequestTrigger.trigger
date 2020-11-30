trigger PortfolioManagementRequestTrigger on PortfolioManagementRequest__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

	if (Trigger.isAfter) {
		if (Trigger.isInsert) {
			PortfolioManagementRequestService.changeCPEClientState(Trigger.new);
		}
	}
}