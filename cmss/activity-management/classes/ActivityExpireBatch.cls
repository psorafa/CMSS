public without sharing class ActivityExpireBatch implements Database.Batchable<sObject>, Schedulable {
	//Scheduling example:
	//System.schedule('Process expired activities','0 0 0 * * ?', new ActivityExpireBatch());

	private final Date expiredDay;
    private final List<String> finalStatuses;
    private final List<String> excludedRTsIDs;
    private final String expiredStatus;
    private final String closedStatus;
    private final String closedResult;

	/**
	 * constructor
	 */
    public ActivityExpireBatch() {        
        List<String> excludedRTs = Configuration__mdt.getInstance('ActivityExpiration_ExcludedRecordTypes').Value__c.split(',');
        this.excludedRTsIDs = new List<String>();
        for(String rt : excludedRTs) {
        	excludedRTsIDs.add(Schema.Sobjecttype.Task.getRecordTypeInfosByDeveloperName().get(rt).getRecordTypeId());
        } 
		this.expiredDay = System.today().addDays(-Integer.valueOf(Configuration__mdt.getInstance('ActivityExpiration_ExpirationDays').Value__c));
        this.expiredStatus = Configuration__mdt.getInstance('ActivityExpiration_ExpiredStatus').Value__c;
        this.closedStatus = Configuration__mdt.getInstance('ActivityExpiration_ClosedStatus').Value__c;
        this.closedResult = Configuration__mdt.getInstance('ActivityExpiration_ClosedResult').Value__c;
		this.finalStatuses = (Configuration__mdt.getInstance('ActivityExpiration_FinalStatuses').Value__c).split(',');        
	}
    
	/**
	 * Batchable start - do the query.
	 */
    public Database.QueryLocator start(Database.BatchableContext jobId) {
        return Database.getQueryLocator([
			SELECT Id, Subject, ValidTo__c, Status
			FROM Task
			WHERE ValidTo__c <= TODAY AND Status NOT IN :finalStatuses AND RecordTypeId NOT IN :excludedRTsIDs
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
				act.put('Status', expiredStatus);
				act.put('DeactivateDate__c', System.today());
				toUpdate.add(act);
			} else {
				act.put('Status', closedStatus);
				act.put('result__c', closedResult);
				toUpdate.add(act);
			}
		}

		if (toUpdate.size() > 0) {
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