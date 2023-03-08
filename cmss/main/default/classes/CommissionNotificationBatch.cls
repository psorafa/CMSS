public class CommissionNotificationBatch implements Database.Batchable<AggregateResult>, Schedulable, Database.Stateful {
	public Id templateId;
	public Datetime dayAgo = System.now().addHours(-24);
	public Iterable<AggregateResult> start(Database.BatchableContext jobId) {
		templateId = [
			SELECT Id, DeveloperName
			FROM CustomNotificationType
			WHERE DeveloperName = 'Commission'
			LIMIT 1
		]
		.Id;

		return new AggregateResultIterable(
			[SELECT OwnerId FROM Commission__c WHERE CreatedDate >= :dayAgo GROUP BY OwnerId]
		);
	}

	public void execute(Database.BatchableContext jobId, List<AggregateResult> commissions) {
		try {
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
