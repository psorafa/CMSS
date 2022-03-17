public class UserCalendarSettingTriggerHandler extends TriggerHandler {
	private static boolean shouldRunAfterInsertTrigger = true;
	private static final GoogleCalendarSyncService calendarSyncService = new GoogleCalendarSyncService();

	public override void afterInsert() {
		if (!Test.isRunningTest()) {
			initialEventSync(Trigger.new);
		}
	}

	public override void beforeUpdate() {
		stopWatchingUpdate(
			(List<UserCalendarSetting__c>) Trigger.old,
			(Map<Id, UserCalendarSetting__c>) Trigger.newMap
		);
	}

	public override void afterDelete() {
		stopWatching(Trigger.old);
	}

	@testVisible
	private static void initialEventSync(List<UserCalendarSetting__c> newSettings) {
		if (shouldRunAfterInsertTrigger) {
			for (UserCalendarSetting__c setting : newSettings) {
				initialEventSyncFuture(setting.Id);
			}
		}
	}

	@testVisible
	private static void shouldNotRunAfterInsertTrigger() {
		shouldRunAfterInsertTrigger = false;
	}

	@testVisible
	private static void shouldRunAfterInsertTrigger() {
		shouldRunAfterInsertTrigger = true;
	}

	@Future(callout=true)
	private static void initialEventSyncFuture(Id settingsId) {
		UserCalendarSetting__c setting = [
			SELECT Id, OwnerId, UserCalendarId__c, SyncActive__c, SyncToken__c, ResourceId__c, User__c
			FROM UserCalendarSetting__c
			WHERE Id = :settingsId
		];
		InitialCalendarSyncController.sync(setting);
	}

	@testVisible
	private static void stopWatchingUpdate(
		List<UserCalendarSetting__c> oldSettings,
		Map<Id, UserCalendarSetting__c> newSettingsMap
	) {
		List<UserCalendarSetting__c> settingsToStopWatching = new List<UserCalendarSetting__c>();
		for (UserCalendarSetting__c oldSetting : oldSettings) {
			UserCalendarSetting__c newSetting = newSettingsMap.get(oldSetting.Id);
			if (oldSetting.SyncActive__c && !newSetting.SyncActive__c) {
				newSetting.WatchId__c = null;
				newSetting.WatchExpirationDateTime__c = null;
				settingsToStopWatching.add(newSetting);
			}
		}
		stopWatching(settingsToStopWatching);

		for (UserCalendarSetting__c setting : settingsToStopWatching) {
			setting.WatchId__c = null;
			setting.WatchExpirationDateTime__c = null;
		}
	}

	private static void stopWatching(List<UserCalendarSetting__c> settings) {
		for (UserCalendarSetting__c setting : settings) {
			stopWatchingFuture(setting.WatchId__c, setting.ResourceId__c);
		}
	}

	@Future(callout=true)
	private static void stopWatchingFuture(String watchId, String resourceId) {
		calendarSyncService.stopWatch(watchId, resourceId);
	}
}
