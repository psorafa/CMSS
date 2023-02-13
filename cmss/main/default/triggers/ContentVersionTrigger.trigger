trigger ContentVersionTrigger on ContentVersion(before insert) {
	new ContentVersionTriggerHandler().run();
}
