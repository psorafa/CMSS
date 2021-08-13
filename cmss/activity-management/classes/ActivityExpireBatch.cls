public without sharing class ActivityExpireBatch implements Database.Batchable<sObject>, Schedulable {
	//Scheduling example:
	//System.schedule('Process expired activities','0 0 0 * * ?', new ActivityExpireBatch());

	private final String mode;
	private final Date expiredDay;
	private final ActivityExpirationConfig__mdt cfg;

	/**
	 * Default constructor, go for 'task' mode.
	 */
	public ActivityExpireBatch() {
		this('task');
	}

	/**
	 * Parametrized constructor, set the given mode.
	 */
	public ActivityExpireBatch(String mode) {
		this.cfg = [
			SELECT ClosedResult__c, ClosedStatus__c, ExpirationDays__c, ExpiredStatus__c, FinalStatuses__c
			FROM ActivityExpirationConfig__mdt
			LIMIT 1
		];
		System.debug('CFG: ' + JSON.serializePretty(cfg));

		this.mode = mode;
		this.expiredDay = System.today().addDays(-cfg.ExpirationDays__c.intValue());
	}

	/**
	 * Batchable start - do the query.
	 */
	public List<sObject> start(Database.BatchableContext jobId) {
		return mode == 'task'
			? (List<sObject>) [
					SELECT Id, Subject, ValidTo__c, Status__c
					FROM Task
					WHERE
						(ValidTo__c <= TODAY
						AND (Status__c != :cfg.ClosedStatus__c
						OR Result__c != :cfg.ClosedResult__c))
						OR (ValidTo__c <= :expiredDay
						AND Status__c != :cfg.ExpiredStatus__c)
			  ]
			: (List<sObject>) [
					SELECT Id, Subject, ValidTo__c, Status__c
					FROM Event
					WHERE
						(ValidTo__c <= TODAY
						AND (Status__c != :cfg.ClosedStatus__c
						OR Result__c != :cfg.ClosedResult__c))
						OR (ValidTo__c <= :expiredDay
						AND Status__c != :cfg.ExpiredStatus__c)
			  ];
	}

	/**
	 * Batchable execute - process a block of Activities.
	 */
	public void execute(Database.BatchableContext jobId, List<sObject> recordList) {
		List<sObject> toUpdate = new List<sObject>();

		for (sObject act : recordList) {
			String status = (String) act.get('Status__c');
			Date validTo = (Date) act.get('validTo__c');

			if (validTo < expiredDay) {
				act.put('Status__c', cfg.ExpiredStatus__c);
				act.put('DeactivateDate__c', System.today());
				toUpdate.add(act);
			} else {
				act.put('Status__c', cfg.ClosedStatus__c);
				act.put('result__c', cfg.ClosedResult__c);
				toUpdate.add(act);
			}
		}

		if (toUpdate.size() > 0) {
			System.debug('Updating ' + toUpdate.size() + ' ' + mode + 's.');
			update toUpdate;
		}
	}

	/**
	 * Batchable finish - chain event mode just after the task mode run finishes.
	 */
	public void finish(Database.BatchableContext jobId) {
		if (mode == 'task') {
			ActivityExpireBatch eventBatch = new ActivityExpireBatch('event');
			Database.executeBatch(eventBatch);
		}
	}

	/**
	 * Schedulable execute - start the task mode run.
	 */
	public void execute(SchedulableContext sc) {
		Database.executeBatch(this);
	}
}
