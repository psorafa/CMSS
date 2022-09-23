public without sharing class ActivityExpireBatch implements Database.Batchable<sObject>, Schedulable {
	//Scheduling example:
	//System.schedule('Process expired activities','0 0 0 * * ?', new ActivityExpireBatch());

	private final Date expiredDay;
	private final ActivityExpirationConfig__mdt cfg;

	/**
	 * constructor
	 */
	public ActivityExpireBatch() {
		this.cfg = [
			SELECT ClosedResult__c, ClosedStatus__c, ExpirationDays__c, ExpiredStatus__c, FinalStatuses__c
			FROM ActivityExpirationConfig__mdt
			LIMIT 1
		];
		System.debug('CFG: ' + JSON.serializePretty(cfg));

		this.expiredDay = System.today().addDays(-cfg.ExpirationDays__c.intValue());
	}

	/**
	 * Batchable start - do the query.
	 */
	public Database.QueryLocator start(Database.BatchableContext jobId) {
		List<String> finalStatuses = cfg.FinalStatuses__c.split(',');

		return Database.getQueryLocator([
			SELECT Id, Subject, ValidTo__c, Status
			FROM Task
			WHERE ValidTo__c <= TODAY AND Status NOT IN :finalStatuses
			ORDER BY WhatId
		]);
	}

	/**
	 * Batchable execute - process a block of Activities.
	 */
	public void execute(Database.BatchableContext jobId, List<sObject> recordList) {
		List<sObject> toUpdate = new List<sObject>();

		for (sObject act : recordList) {
			String status = (String) act.get('Status');
			Date validTo = (Date) act.get('validTo__c');

			if (validTo < expiredDay) {
				act.put('Status', cfg.ExpiredStatus__c);
				act.put('DeactivateDate__c', System.today());
				toUpdate.add(act);
			} else {
				act.put('Status', cfg.ClosedStatus__c);
				act.put('result__c', cfg.ClosedResult__c);
				toUpdate.add(act);
			}
		}

		if (toUpdate.size() > 0) {
			System.debug('Updating ' + toUpdate.size() + ' tasks.');
			update toUpdate;
		}
	}

	/**
	 * Batchable finish - mandatory
	 */
	public void finish(Database.BatchableContext jobId) {
		System.debug('Execution of ActivityExpireBatch finished');
	}

	/**
	 * Schedulable execute
	 */
	public void execute(SchedulableContext sc) {
		Database.executeBatch(this, 100);
	}
}
