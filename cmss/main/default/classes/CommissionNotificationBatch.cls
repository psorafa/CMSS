public class CommissionNotificationBatch implements Database.Batchable<sObject>, Schedulable {
	public Database.QueryLocator start(Database.BatchableContext jobId) {
		Datetime commissionWindow = Date.Today();
		return Database.getQueryLocator(
			[
				SELECT Id, OwnerId, CreatedDate
				FROM Commission__c
				WHERE CreatedDate >= :commissionWindow
			]
		);
	}

	public void execute(Database.BatchableContext jobId, List<Commission__c> commissions) {
		try {
			List<CustomNotificationType> templateInfoDetail = [
				SELECT Id, DeveloperName
				FROM CustomNotificationType
				WHERE DeveloperName = 'Commission'
				LIMIT 1
			];
		if (templateInfoDetail.size() > 0) {
			for (Commission__c comm : commissions) {
				CustomNotificationService.sendNotification(
					comm.OwnerId,
					templateInfoDetail[0].Id,
					'Provozní výpisy',
					'V CRM Fénix máte nový provizní výpis.'
				);
			}
		}
		} catch (Exception e) {
			Logger.error('An exception thrown', e);
		} finally {
			Logger.saveLogs();
		}
	}
	public void finish(Database.BatchableContext jobId) {
		System.debug('Execution of CommissionNotificationBatch finished');
	}

	public void execute(SchedulableContext sc) {
		Database.executeBatch(this);
	}
}
