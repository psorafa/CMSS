public without sharing class UnsignedOpportunityNotification_Batch implements Database.Batchable<sObject>, Schedulable {
	private DateTime actualDate;
	static final Set<Integer> VALID_DAYS_FROM_CREATION = new Set<Integer>{ 3 };
	static final String UNFINISHED_CONTRACT_TEMPLATE = 'UnfinishedContractNotification';
	static final String UNSIGNED_CONTRACT_TEMPLATE = 'UnsignedContractNotification';

	public UnsignedOpportunityNotification_Batch() {
		this.actualDate = System.today();
	}

	public void execute(SchedulableContext sc) {
		Database.executeBatch(this);
	}

	public List<Opportunity> start(Database.BatchableContext jobId) {
		return (List<Opportunity>) [
			SELECT
				Category__c,
				StageName,
				ContractId,
				//ContractNumber__c,
				CreatedDateTime__c,
				Owner.Email,
				Account.PersonEmail,
				Account.FirstName,
				Account.LastName
			FROM Opportunity
			WHERE Category__c = '7' AND (StageName = '1' OR StageName = '2')
		];
	}

	public void execute(Database.BatchableContext jobId, List<Opportunity> opportunities) {
		for (Opportunity opportunity : opportunities) {
			Integer numberOfDaysFromOppCreation = (Date.valueOf(opportunity.CreatedDateTime__c)
				.daysBetween(Date.valueOf(actualDate)) + 1);
			if (VALID_DAYS_FROM_CREATION.contains(numberOfDaysFromOppCreation)) {
				if (opportunity?.Account?.PersonEmail != null) {
					SendNotificationHandler userNotificationHandler = new SendNotificationHandler(
						opportunity,
						UNSIGNED_CONTRACT_TEMPLATE,
						opportunity.Account.PersonEmail
					);
					userNotificationHandler.handle();
				}
				if (opportunity?.Owner?.Email != null) {
					SendNotificationHandler ownerNotificationHandler = new SendNotificationHandler(
						opportunity,
						UNFINISHED_CONTRACT_TEMPLATE,
						opportunity.Owner.Email
					);
					ownerNotificationHandler.handle();
				}
			}
		}
	}

	public void finish(Database.BatchableContext jobId) {
	}
}
