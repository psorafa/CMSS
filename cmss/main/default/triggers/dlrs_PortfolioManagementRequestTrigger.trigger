/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_PortfolioManagementRequestTrigger on PortfolioManagementRequest__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(PortfolioManagementRequest__c.SObjectType);
}