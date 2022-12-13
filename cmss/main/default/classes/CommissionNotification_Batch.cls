public class CommissionNotification_Batch implements Database.Batchable<sObject>, Schedulable {
	Datetime commissionWindow = Date.Today();
    
	public Database.QueryLocator start(Database.BatchableContext jobId) {        
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
				CustomNotificationService.sendNotification(comm.OwnerId, 'Commission', 'Provozní výpisy', 'V CRM Fénix máte nový provizní výpis.');                             
            }
		} catch (Exception e) {
			Logger.error('An exception thrown', e);
		} finally {
			Logger.saveLogs();
		}
	}
	public void finish(Database.BatchableContext jobId) {
		System.debug('Execution of CommissionNotification_Batch finished');
	}

	public void execute(SchedulableContext sc) {
		Database.executeBatch(this);
	}
}