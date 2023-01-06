public class CommissionNotificationBatch implements Database.Batchable<sObject>, Schedulable {
	public Id templateId;
	public Database.QueryLocator start(Database.BatchableContext jobId) {
		Datetime commissionWindow = Date.Today();
		templateId = [
			SELECT Id, DeveloperName
			FROM CustomNotificationType
			WHERE DeveloperName = 'Commission'
			LIMIT 1
		]
		.Id;
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
			for (Commission__c comm : commissions) {
				CustomNotificationService.sendNotification(
					comm.OwnerId,
					templateId,
					'Provozní výpisy',
					'V CRM Fénix máte nový provizní výpis.'
				);
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
		Database.executeBatch(this, 150);
	}
}
