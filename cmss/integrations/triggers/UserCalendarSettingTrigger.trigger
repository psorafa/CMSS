trigger UserCalendarSettingTrigger on UserCalendarSetting__c(after insert, before update, after delete) {
	new UserCalendarSettingTriggerHandler().run();
}
