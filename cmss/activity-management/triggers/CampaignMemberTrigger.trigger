trigger CampaignMemberTrigger on CampaignMember__c(
	before insert,
	before update,
	before delete,
	after insert,
	after update,
	after delete,
	after undelete
) {
	if (!FeatureManagement.checkPermission('SkipCalculations')) {
		dlrs.RollupService.triggerHandler(CampaignMember__c.SObjectType);
	}
}
