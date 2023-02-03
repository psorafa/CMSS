global class AccountMassUpdateBatch implements Database.Batchable<sObject> {
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(
			'SELECT Id, Phone, PersonEmail, HasPhone__c, HasEmail__c FROM Account WHERE HasPhone__c = null OR HasEmail__c = null'
		);
	}
	global void execute(Database.BatchableContext BC, List<Account> scope) {
		for (Account acc : scope) {
			acc.HasPhone__c = false;
			acc.HasEmail__c = false;
		}
		update scope;
	}
	global void finish(Database.BatchableContext BC) {
	}
}
