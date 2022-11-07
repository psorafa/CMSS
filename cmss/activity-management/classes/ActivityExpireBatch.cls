public without sharing class ActivityExpireBatch implements Database.Batchable<sObject>, Schedulable {
	//Scheduling example:
	//System.schedule('Process expired activities','0 0 0 * * ?', new ActivityExpireBatch());

	private final Date expiredDay;
    private final List<Configuration__mdt> activityCfg;
    private final Map<String, String> activityCfgMap;

	/**
	 * constructor
	 */
    public ActivityExpireBatch() {
		this.activityCfg = [
			SELECT Parameter__c, Value__c
			FROM Configuration__mdt
			WHERE Type__c = 'ActivityExpiration'
		];
        
        activityCfgMap = new Map<String, String>();
        
        for(Configuration__mdt a : activityCfg) {
            activityCfgMap.put(a.Parameter__c, a.Value__c);
        }
		System.debug('CFG: ' + JSON.serializePretty(activityCfgMap));

		this.expiredDay = System.today().addDays(-Integer.valueOf(activityCfgMap.get('ExpirationDays')));
	}
    
	/**
	 * Batchable start - do the query.
	 */
	public Database.QueryLocator start(Database.BatchableContext jobId) {
		List<String> finalStatuses = activityCfgMap.get('FinalStatuses').split(',');
        List<String> excludedRTs = activityCfgMap.get('ExcludedRecordTypes').split(',');
        List<String> excludedRTsIDs;
        
        for(String rt : excludedRTs) {
        	excludedRTsIDs.add(Schema.Sobjecttype.Task.getRecordTypeInfosByDeveloperName().get(rt).getRecordTypeId());
        }
            
		return Database.getQueryLocator([
			SELECT Id, Subject, ValidTo__c, Status
			FROM Task
			WHERE ValidTo__c <= TODAY AND Status NOT IN :finalStatuses AND RecordType.Id NOT IN :excludedRTsIDs
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
				act.put('Status', activityCfgMap.get('ExpiredStatus'));
				act.put('DeactivateDate__c', System.today());
				toUpdate.add(act);
			} else {
				act.put('Status', activityCfgMap.get('ClosedStatus'));
				act.put('result__c', activityCfgMap.get('ClosedResult'));
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