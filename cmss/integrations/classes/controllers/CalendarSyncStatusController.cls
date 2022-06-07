public without sharing class CalendarSyncStatusController {
	@AuraEnabled(cacheable=true)
	public static String getTechnicalUserMail() {
		return JSON.serialize(GoogleCalendarSyncSettings__c.getOrgDefaults()?.GoogleTechnicalUser__c);
	}

	@AuraEnabled(cacheable=true)
	public static UserCalendarSetting__c getUserCalendarSetting() {
		UserCalendarSetting__c setting;
		try {
			List<UserCalendarSetting__c> settings = [
				SELECT
					Id,
					ResourceId__c,
					SyncActive__c,
					SyncToken__c,
					User__c,
					UserCalendarID__c,
					WatchExpirationDateTime__c,
					WatchId__c
				FROM UserCalendarSetting__c
				WHERE User__c = :UserInfo.getUserId()
				LIMIT 1
			];
			setting = settings.size() > 0 ? settings[0] : null;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
		return setting;
	}

	@AuraEnabled
	public static Boolean validateCalendarConnection(String googleCalendarId) {
		Boolean isCalendarConnected = false;
		try {
			GoogleCalendarSyncService service = new GoogleCalendarSyncService();
			isCalendarConnected = service.isCalendarConnected(googleCalendarId);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		} finally {
			Logger.saveLogs();
		}
		return isCalendarConnected;
	}

	@AuraEnabled
	public static void createWatch(Id calendarId) {
		UserCalendarSetting__c calendarSetting = (UserCalendarSetting__c) [
			SELECT Id, WatchId__c, WatchExpirationDateTime__c, ResourceId__c, UserCalendarID__c
			FROM UserCalendarSetting__c
			WHERE Id = :calendarId
		];
		if (calendarSetting == null) {
			return;
		}
		String watchUrl = '';
		if (!Test.isRunningTest()) {
			Site mySite = [SELECT Id FROM Site WHERE Name = 'googleApiWebhooks'];
			SiteDetail mySiteDetail = [SELECT SecureURL FROM SiteDetail WHERE DurableId = :mySite.Id];
			watchUrl = mySiteDetail.SecureURL + '/services/apexrest/api/webhooks/google/';
		}

		GoogleCalendarSyncService syncService = new GoogleCalendarSyncService();

		GoogleCalendarSyncService.WatchResponse watchResponse = syncService.createWatch(
			calendarSetting.UserCalendarId__c,
			((Long) ((Datetime) System.Today().addMonths(1)).getTime()),
			watchUrl
		);
		calendarSetting.WatchId__c = watchResponse.id;
		calendarSetting.ResourceId__c = watchResponse.resourceId;
		calendarSetting.WatchExpirationDateTime__c = DateTime.now().addMonths(1);
		update calendarSetting;
	}
}
