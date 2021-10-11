public without sharing class OpportunityExpireBatch implements Database.Batchable<sObject>, Schedulable {
	//System.schedule('Process expired opportunities','0 0 0 * * ?', new OpportunityExpireBatch());

	@testVisible
	private final OpportunityExpirationConfig__mdt cfg;
	@testVisible
	private Datetime validToTreshold;
	@testVisible
	private Datetime validFromTreshold;

	public OpportunityExpireBatch() {
		this.cfg = [
			SELECT ChainActivityExpireBatch__c, ExpirationDaysFromValidTo__c, ExpirationDaysFromValidFrom__c
			FROM OpportunityExpirationConfig__mdt
			LIMIT 1
		];
		System.debug('CFG: ' + JSON.serializePretty(cfg));

		this.validToTreshold = System.now().addDays(-cfg.ExpirationDaysFromValidTo__c.intValue());
		this.validFromTreshold = System.now().addDays(-cfg.ExpirationDaysFromValidFrom__c.intValue());
	}

	/**
	 * Batchable start - do the query.
	 */
	public List<sObject> start(Database.BatchableContext jobId) {
		return [
			SELECT Id, Name, Reason__c
			FROM Opportunity
			WHERE
				StageName != '8'
                AND Category__c = '3'
				AND (ValidTo__c <= :validToTreshold
				OR (ValidTo__c = NULL
				AND ValidFrom__c <= :validFromTreshold))
		];
	}

	/**
	 * Batchable execute - process a block of Opportunities.
	 */
	public void execute(Database.BatchableContext jobId, List<sObject> recordList) {
		final Date today = System.today();
		List<Opportunity> toUpdate = new List<Opportunity>();

		for (Opportunity op : (List<Opportunity>) recordList) {
			op.StageName = '8';
			op.DeactivateDate__c = today;
			op.IsVisibleForNel__c = false;
			if (String.isBlank(op.Reason__c)) {
				op.Reason__c = '9';
			}
			toUpdate.add(op);
		}

		System.debug('Updating ' + toUpdate.size() + ' opportunities.');
		update toUpdate;

		List<Task> tasksToUpdate = new List<Task>();
		for (Task tsk : [SELECT Id FROM Task WHERE WhatId IN :toUpdate AND Status != '5']) {
			tsk.DeactivateDate__c = today;
			tsk.Status = '5';
			tasksToUpdate.add(tsk);
		}
		if (tasksToUpdate.size() > 0) {
			System.debug('Updating ' + tasksToUpdate.size() + ' tasks.');
			update tasksToUpdate;
		}
	}

	/**
	 * Batchable finish - chain activity batch run.
	 */
	public void finish(Database.BatchableContext jobId) {
		if (cfg.ChainActivityExpireBatch__c) {
			ActivityExpireBatch activityBatch = new ActivityExpireBatch();
			Database.executeBatch(activityBatch);
		}
	}

	/**
	 * Schedulable execute - start the batch.
	 */
	public void execute(SchedulableContext sc) {
		Database.executeBatch(this);
	}
}
