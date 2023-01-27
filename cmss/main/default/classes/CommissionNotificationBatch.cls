public class CommissionNotificationBatch implements Database.Batchable<AggregateResult>, Schedulable, Database.Stateful {
	public Id templateId;
	public Iterable<AggregateResult> start(Database.BatchableContext jobId) {
		templateId = [
			SELECT Id, DeveloperName
			FROM CustomNotificationType
			WHERE DeveloperName = 'Commission'
			LIMIT 1
		]
		.Id;

		String query = 'SELECT OwnerId FROM Commission__c WHERE CreatedDate >= TODAY GROUP BY OwnerId';
		return new AggregateResultIterable(query);
	}

	public void execute(Database.BatchableContext jobId, List<AggregateResult> commissions) {
		try {
			system.debug('templateId: ' + templateId);
			for (AggregateResult comm : commissions) {
				CustomNotificationService.sendNotification(
					Id.valueOf((String) comm.get('OwnerId')),
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
