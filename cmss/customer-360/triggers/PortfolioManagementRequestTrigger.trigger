trigger PortfolioManagementRequestTrigger on PortfolioManagementRequest__c (
	before insert,
	before update,
	before delete,
	after insert,
	after update,
	after delete,
	after undelete
) {
	new PortfolioManagementRequestTriggerHandler().run();
}