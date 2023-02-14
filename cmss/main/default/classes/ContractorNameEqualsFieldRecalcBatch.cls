public class ContractorNameEqualsFieldRecalcBatch implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext jobId) {
        // collect the batches of records or objects to be passed to execute

        return Database.getQueryLocator(
		[
			SELECT
				Id,
				ContractorNameEquals__c,
				ComplainerLastName__c,
				ComplainerFirstName__c,
				ComplainerContractor__r.FirstName,
                ComplainerContractor__r.LastName,
                AccountId
			FROM Case
			WHERE IsClosed != TRUE
		]);
    }
    public void execute(Database.BatchableContext jobId, List<Case> caseList) {
        
        // process each batch of records default size is 200
        List<Case> toUpdateCaseList = new List<Case>();
        List<Id> userIds = new List<Id>();
        List<Id> accountsIds = new List<Id>();
        for (Case c : caseList) {
            userIds.add(c.ComplainerContractor__c);
            accountsIds.add(c.AccountId);
        }
        Map<ID, User> contractors = new Map<ID, User>([SELECT FirstName, LastName FROM User WHERE id in :userIds]);
        Map<ID, Account> accounts = new Map<ID, Account>([SELECT FirstName, LastName FROM ACCOUNT WHERE id in :accountsIds]);
       for (Case c : caseList) {
            

                if (c.ComplainerContractor__c != null){

                    String ComplainerName = c.ComplainerFirstName__c + ' ' + c.ComplainerLastName__c;
                    System.debug('ComplainerName>> ' + ComplainerName);
                    id userId = c.ComplainerContractor__c;
                    System.debug('ContractorName>> ' + contractors.get(c.ComplainerContractor__c).FirstName + ' ' +contractors.get(c.ComplainerContractor__c).LastName);
                    if (ComplainerName == (contractors.get(c.ComplainerContractor__c).FirstName + ' ' +contractors.get(c.ComplainerContractor__c).LastName)) {
                        c.ContractorNameEquals__c = true;
                        System.debug('ContractorNameEquals__c>> ' + c.ContractorNameEquals__c);
                    } else {
                        c.ContractorNameEquals__c = false;
                        System.debug('ContractorNameEquals__c>> ' + c.ContractorNameEquals__c);
                    }
                }
            
             
                if (c.AccountId != null && c.ComplainerContractor__c != null){
                        System.debug('AccountName>> ' + accounts.get(c.AccountId).FirstName + ' ' + accounts.get(c.AccountId).LastName);
                        System.debug('ContractorName>> ' + contractors.get(c.ComplainerContractor__c).FirstName + ' ' +contractors.get(c.ComplainerContractor__c).LastName);
                        if ((accounts.get(c.AccountId).FirstName + ' ' + accounts.get(c.AccountId).LastName) == (contractors.get(c.ComplainerContractor__c).FirstName + ' ' +contractors.get(c.ComplainerContractor__c).LastName)) {
                            c.AccountContractorNameEquals__c = true;
                            System.debug('AccountContractorNameEquals__c>> ' + c.AccountContractorNameEquals__c);
                        } else {
                            c.AccountContractorNameEquals__c = false;
                            System.debug('AccountContractorNameEquals__c>> ' + c.AccountContractorNameEquals__c);
                        }
            }
             if (c.AccountId != null){
                        String ComplainerName = c.ComplainerFirstName__c + ' ' + c.ComplainerLastName__c;
                        System.debug('ComplainerName2>> ' + ComplainerName);
                        System.debug('AccountName2>> ' + accounts.get(c.AccountId).FirstName + ' ' + accounts.get(c.AccountId).LastName);
                        if (ComplainerName == (accounts.get(c.AccountId).FirstName + ' ' + accounts.get(c.AccountId).LastName)) {
                            c.AccountComplainerNameEquals__c = true;
                            System.debug('AccountComplainerNameEquals__c>> ' + c.AccountComplainerNameEquals__c);
                        } else {
                            c.AccountComplainerNameEquals__c = false;
                            System.debug('AccountComplainerNameEquals__c>> ' + c.AccountComplainerNameEquals__c);
                        }
                }
                toUpdateCaseList.add(c);
        } 
        try {
            update toUpdateCaseList;
         
        } catch(Exception e) {
            System.debug(e);
        }
         
    }   
     
    public void finish(Database.BatchableContext jobId) {
        System.debug('End');
    }
}