public without sharing class UnsignedOpportunityNotification_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable {
	private Date actualDate;
	private DateTime createdDateLimit;
	private Set<Integer> validDaysFromCreation;
	private Integer validDaysFromCreationForOZ;

	static final String UNFINISHED_CONTRACT_TEMPLATE = 'UnfinishedContractNotification';
	static final String UNSIGNED_CONTRACT_TEMPLATE = 'UnsignedContractNotification';

	public UnsignedOpportunityNotification_Batch() {
		KZNotificationSettings__c KZSettings = KZNotificationSettings__c.getOrgDefaults();
		this.validDaysFromCreationForOZ = (Integer) KZSettings.DaysFromOppCreationOZ__c;
		this.validDaysFromCreation = new Set<Integer>();
		for (String value : KZSettings.DaysFromOppCreation__c.split(',')) {
			this.validDaysFromCreation.add(Integer.valueOf(value));
		}

		List<Integer> sortedList = new List<Integer>(this.validDaysFromCreation);
		sortedList.add(this.validDaysFromCreationForOZ);
		sortedList.sort();
		System.debug('list of days: ' + sortedList);
		Integer dayLimit = sortedList[sortedList.size() - 1];
		this.createdDateLimit = this.actualDate.addDays(-dayLimit - 2);

		Logger.debug('KZ Setting: ' + JSON.serialize(KZSettings) + ' + numbers of days: ' + sortedList);
		Logger.saveLogs();
	}

	public void execute(SchedulableContext sc) {
		Database.executeBatch(this);
	}

	public Database.QueryLocator start(Database.BatchableContext jobId) {
		return Database.getQueryLocator(
			[
				SELECT
					Category__c,
					StageName,
					CreatedDateTime__c,
					Owner.Email,
					AccountId,
					Account.PersonEmail,
					Account.FirstName,
					Account.LastName,
					Account.PortfolioMngmtC__c,
					OriginalAsset__r.Name
				FROM Opportunity
				WHERE
					Category__c = '7'
					AND (StageName = '1'
					OR StageName = '2')
					AND CreatedDateTime__c > :this.createdDateLimit
			]
		);
	}

	public void execute(Database.BatchableContext jobId, List<Opportunity> opportunities) {
		this.actualDate = System.today();
		System.debug('Actual date: ' + this.actualDate);
		try {
			for (Opportunity opportunity : opportunities) {
				Integer numberOfDaysFromOppCreation = opportunity.CreatedDateTime__c.date().daysBetween(actualDate);
				if (
					this.validDaysFromCreation.contains(numberOfDaysFromOppCreation) &&
					opportunity?.Account?.PersonEmail != null
				) {
					SendNotificationHandler userNotificationHandler = new SendNotificationHandler(
						opportunity,
						UNSIGNED_CONTRACT_TEMPLATE,
						opportunity.Account.PersonEmail
					);
					userNotificationHandler.handle();
				}
				if (
					numberOfDaysFromOppCreation == this.validDaysFromCreationForOZ &&
					opportunity?.Owner?.Email != null &&
					opportunity.Account.PortfolioMngmtC__c == null
				) {
					SendNotificationHandler ownerNotificationHandler = new SendNotificationHandler(
						opportunity,
						UNFINISHED_CONTRACT_TEMPLATE,
						opportunity.Owner.Email,
						new Map<String, String>{
							'ORG_URL' => URL.getSalesforceBaseUrl().toExternalForm(),
							'CreatedDateTime__c' => opportunity.CreatedDateTime__c.format('dd. MM. yyyy')
						}
					);
					ownerNotificationHandler.handle();
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
	}
}
