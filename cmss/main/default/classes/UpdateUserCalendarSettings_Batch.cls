public class UpdateUserCalendarSettings_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable {
	public class StatusCodeException extends Exception {
	}

	public Database.QueryLocator start(Database.BatchableContext jobId) {
		String queryString =
			'SELECT  Id, WatchExpirationDateTime__c, WatchId__c, ResourceId__c, UserCalendarID__c ' +
			'FROM UserCalendarSetting__c WHERE WatchExpirationDateTime__c <= NEXT_N_WEEKS:2';
		return Database.getQueryLocator(queryString);
	}

	public void execute(SchedulableContext context) {
		Database.executeBatch(this, 50);
	}

	public void execute(Database.BatchableContext jobId, List<UserCalendarSetting__c> calendarSettings) {
		try {
			GoogleCalendarSyncService service = new GoogleCalendarSyncService();
			List<UserCalendarSetting__c> userCalendarSettingsToUpdate = new List<UserCalendarSetting__c>();
			String pushNotificationsSiteUrl = getPushNotificationsSiteUrl();

			for (UserCalendarSetting__c userCalendarSetting : calendarSettings) {
				GoogleCalendarSyncUtility.GoogleCalendarResponse resp1 = service.stopWatch(
					userCalendarSetting.WatchId__c,
					userCalendarSetting.ResourceId__c
				);
				if (resp1.statusCode == 200) {
					GoogleCalendarSyncService.WatchResponse resp2 = service.createWatch(
						userCalendarSetting.UserCalendarId__c,
						((Long) ((Datetime) System.Today().addMonths(1)).getTime()),
						pushNotificationsSiteUrl
					);
					if (resp2.id != null) {
						userCalendarSetting.WatchExpirationDateTime__c = DateTime.newInstance(resp2.expiration);
						userCalendarSetting.WatchId__c = resp2.id;
						userCalendarSettingsToUpdate.add(userCalendarSetting);
					}
				} else {
					Logger.error('Status code wrong ' + resp1.statusCode + ' ' + resp1.message);
					throw new StatusCodeException('Status code wrong ' + resp1.statusCode + ' ' + resp1.message);
				}
			}
			if (userCalendarSettingsToUpdate.size() > 0) {
				List<Database.SaveResult> results = Database.update(userCalendarSettingsToUpdate, false);
				for (Database.SaveResult result : results) {
					if (!result.isSuccess()) {
						for (Database.Error err : result.getErrors()) {
							Logger.error('Erorr message: ' + err.getMessage() + ' Fields:' + err.getFields());
						}
					}
				}
			}
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	@TestVisible
	private static String getPushNotificationsSiteUrl() {
		if (Test.isRunningTest()) {
			return '';
		}
		Site mySite = [SELECT Id FROM Site WHERE Name = 'googleApiWebhooks'];
		SiteDetail mySiteDetail = [SELECT SecureURL FROM SiteDetail WHERE DurableId = :mySite.Id];
		return mySiteDetail.SecureURL + '/services/apexrest/api/webhooks/google/';
	}

	public void finish(Database.BatchableContext jobId) {
	}
}
