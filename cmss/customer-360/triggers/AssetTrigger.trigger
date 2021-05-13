trigger AssetTrigger on Asset (after insert) {
	if (Trigger.isAfter && Trigger.isInsert) {
			AssetTriggerHandler.pairOpportunity(Trigger.new);
	}
}