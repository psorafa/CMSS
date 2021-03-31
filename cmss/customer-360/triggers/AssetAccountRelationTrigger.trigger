trigger AssetAccountRelationTrigger on AssetAccountRelation__c(
	before insert,
	before update,
	before delete,
	after insert,
	after update,
	after delete,
	after undelete
) {
	if (Trigger.isBefore) {
		if (Trigger.isInsert || Trigger.isUpdate) {
			AssetAccountRelationTriggerHandler.createAssetAccountRelationProductType(Trigger.new);
		}
	}
}
