trigger AssetTrigger on Asset(
	before insert,
	before update,
	before delete,
	after insert,
	after update,
	after delete,
	after undelete
) {
	if (!FeatureManagement.checkPermission('SkipCalculations')) {
		dlrs.RollupService.triggerHandler();
	}
	new AssetTriggerHandler().run();
}