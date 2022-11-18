public without sharing class UnsignedOpportunityNotification_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable, Database.Stateful {
	private Date actualDate;
	private Integer dayLimit;
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
		this.dayLimit = sortedList[sortedList.size() - 1];
	}

	public void execute(SchedulableContext sc) {
		Database.executeBatch(this);
	}

	public Database.QueryLocator start(Database.BatchableContext jobId) {
		this.actualDate = System.today();
		System.debug('Actual date: ' + this.actualDate);
		Integer minusDayLimit = -1 * this.dayLimit;
		this.createdDateLimit = this.actualDate.addDays(minusDayLimit - 2);
		System.debug('Created Date Limit: ' + this.createdDateLimit);

		return Database.getQueryLocator(
			[
				SELECT
					Category__c,
					StageName,
					CreatedDateTime__c,
					Owner.Email,
					Owner.CooperationPartnerType__c,
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
		try {
			SendNotificationHandler userNotificationHandler = new SendNotificationHandler();
			userNotificationHandler.setContext('DIGIKZ');

			for (Opportunity opportunity : opportunities) {
				System.debug('opportunity.CreatedDateTime__c: ' + opportunity.CreatedDateTime__c);
				System.debug('opportunity.CreatedDateTime__c.date(): ' + opportunity.CreatedDateTime__c.date());
				System.debug('this.actualDate: ' + this.actualDate);
				System.debug(
					'opportunity.CreatedDateTime__c.date().daysBetween(this.actualDate): ' +
					opportunity.CreatedDateTime__c.date().daysBetween(this.actualDate)
				);

				System.debug('this.validDaysFromCreation: ' + this.validDaysFromCreation);
				System.debug('this.validDaysFromCreationForOZ: ' + this.validDaysFromCreationForOZ);

				Integer numberOfDaysFromOppCreation = opportunity.CreatedDateTime__c.date()
					.daysBetween(this.actualDate);
				if (
					this.validDaysFromCreation.contains(numberOfDaysFromOppCreation) &&
					opportunity?.Account?.PersonEmail != null
				) {
					userNotificationHandler.setEmailTemplate(UNSIGNED_CONTRACT_TEMPLATE)
						.generateNotifications(opportunity, new List<String>{ opportunity.Account.PersonEmail });
				}
				if (
					numberOfDaysFromOppCreation == this.validDaysFromCreationForOZ &&
					opportunity?.Owner?.Email != null &&
					opportunity?.Owner?.CooperationPartnerType__c == '4' &&
					opportunity.Account.PortfolioMngmtC__c == null
				) {
					userNotificationHandler.setEmailTemplate(UNFINISHED_CONTRACT_TEMPLATE)
						.setSpecialVariables(
							new Map<String, String>{
								'ORG_URL' => URL.getSalesforceBaseUrl().toExternalForm(),
								'CreatedDateTime__c' => opportunity.CreatedDateTime__c.format('dd. MM. yyyy')
							}
						)
						.generateNotifications(opportunity, new List<String>{ opportunity.Owner.Email });
				}
			}
			userNotificationHandler.handleInsertNotifications();
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
