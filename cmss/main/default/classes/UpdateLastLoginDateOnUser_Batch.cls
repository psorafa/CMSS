public class UpdateLastLoginDateOnUser_Batch implements Database.Batchable<sObject>, Schedulable  {
    
    Datetime lastBatchExecution = SuperAdminLogin__c.getOrgDefaults().SuperAdminLoginDate__c;
    public Database.QueryLocator start(Database.BatchableContext jobId) {
        Id superAdminProfileId = [SELECT Id FROM Profile WHERE Name = 'SuperAdmin'].Id;
        return Database.getQueryLocator(
            [
                SELECT Id, LastLoginDate FROM USER WHERE ProfileId = :superAdminProfileId AND LastLoginDate > :lastBatchExecution
            ]
        );
    }
    
    public void execute(Database.BatchableContext jobId, List<User> users) {
        try{
            List<User> usersToUpdate = new List<User>();
            
            for (User user: users){
              
                user.LastLoginDate__c = user.LastLoginDate;
                
                usersToUpdate.add(user);
            }
            	if (usersToUpdate.size() > 0) {
				System.debug('Updating ' + usersToUpdate.size() + ' users.');
				List<Database.SaveResult> results = Database.update(usersToUpdate, false);
				for (Database.SaveResult result : results) {
					if (!result.isSuccess()) {
						for (Database.Error err : result.getErrors()) {
							Logger.error('Erorr message: ' + err.getMessage() + ' Fields:' + err.getFields());
						}
					}
				} 
			} 
        }
        catch (Exception e) {
            Logger.error('An unhandled exception thrown', e);
            throw e;
        } finally {
            
            Logger.saveLogs();
        }
    }
    public void finish(Database.BatchableContext jobId) {
        lastBatchExecution = Datetime.now();
        System.debug('Execution of UpdateLastLoginDateOnUser_Batch finished');
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(this);
    }
}