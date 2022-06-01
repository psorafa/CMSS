public class UpdateRecordTypeToCloasedGDPRClaim implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext jobId) {
        return Database.getQueryLocator(
            [
                SELECT Id, Status
                FROM Case
                WHERE
                RecordType.DeveloperName = 'GDPR'
                AND
                (Status = '2'
                 OR Status = '3')
            ]
        );
    }
    
    public void execute(Database.BatchableContext jobId, List<Case> cases) {
        system.debug('cases ' + cases);
        try {
            List<Case> casesToUpdate = new List<Case>();
            Id recordTypeId =
                Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
                .get('ClosedGDPRClaim').getRecordTypeId();
            
            for (Case c : cases) {
                c.RecordTypeId = recordTypeId;
                casesToUpdate.add(c);
            }
            system.debug('casestoupdate' + casesToUpdate);
            if (casesToUpdate.size() > 0) {
                System.debug('Updating ' + casesToUpdate.size() + ' cases.');
                List<Database.SaveResult> results = Database.update(casesToUpdate, false);
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
    
    public void finish(Database.BatchableContext jobId) {
        System.debug('Execution of UpdateRecordTypeToCloasedGDPRClaim finished');
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(this);
    }
    
}