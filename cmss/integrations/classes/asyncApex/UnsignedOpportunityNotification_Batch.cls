public without sharing class UnsignedOpportunityNotification_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable {
	private DateTime actualDate;
	private DateTime createdDateLimit;

	static final Set<Integer> VALID_DAYS_FROM_CREATION = new Set<Integer>{ 2, 7 };
	static final String UNFINISHED_CONTRACT_TEMPLATE = 'UnfinishedContractNotification';
	static final String UNSIGNED_CONTRACT_TEMPLATE = 'UnsignedContractNotification';

	public UnsignedOpportunityNotification_Batch() {
		this.actualDate = System.today();
		List<Integer> sortedList = new List<Integer>(VALID_DAYS_FROM_CREATION);
		sortedList.sort();
		Integer dayLimit = sortedList[sortedList.size() - 1];
		this.createdDateLimit = this.actualDate.addDays(-dayLimit - 2);
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
				CreatedDateTime__c,
				Owner.Email,
				AccountId,
				Account.PersonEmail,
				Account.FirstName,
				Account.LastName,
				Account.PortfolioMngmtC__c
			FROM Opportunity
			WHERE
				Category__c = '7'
				AND (StageName = '1'
				OR StageName = '2')
				AND CreatedDateTime__c > :this.createdDateLimit
		];
	}

	public void execute(Database.BatchableContext jobId, List<Opportunity> opportunities) {
		try {
			Map<Id, ClientZone__c> associatedClientZones = getAssociatedClientZones(opportunities);

			for (Opportunity opportunity : opportunities) {
				Integer numberOfDaysFromOppCreation = (Date.valueOf(opportunity.CreatedDateTime__c)
					.daysBetween(Date.valueOf(actualDate)) + 1);
				if (VALID_DAYS_FROM_CREATION.contains(numberOfDaysFromOppCreation)) {
					if (opportunity?.Account?.PersonEmail != null) {
						SendNotificationHandler userNotificationHandler = new SendNotificationHandler(
							opportunity,
							UNSIGNED_CONTRACT_TEMPLATE,
							opportunity.Account.PersonEmail,
							new Map<String, String>{
								'ContractNumber__c' => '' +
								String.valueOf(
									associatedClientZones?.get(opportunity.AccountId)?.get('ContractNumber__c')
								)
							}
						);
						userNotificationHandler.handle();
					}
					if (opportunity?.Owner?.Email != null && opportunity.Account.PortfolioMngmtC__c == null) {
						SendNotificationHandler ownerNotificationHandler = new SendNotificationHandler(
							opportunity,
							UNFINISHED_CONTRACT_TEMPLATE,
							opportunity.Owner.Email,
							new Map<String, String>{ 'ORG_URL' => URL.getSalesforceBaseUrl().toExternalForm() }
						);
						ownerNotificationHandler.handle();
					}
				}
			}
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	private Map<Id, ClientZone__c> getAssociatedClientZones(List<Opportunity> opportunities) {
		List<Id> accountIds = new List<Id>();
		for (Opportunity opportunity : opportunities) {
			accountIds.add(opportunity.AccountId);
		}

		Map<Id, ClientZone__c> accountsToClientZones = new Map<Id, ClientZone__c>();
		List<ClientZone__c> clientZones = [
			SELECT ContractNumber__c, Account__c
			FROM ClientZone__c
			WHERE Account__c IN :accountIds
		];

		for (ClientZone__c zone : clientZones) {
			accountsToClientZones.put(zone.Account__c, zone);
		}

		return accountsToClientZones;
	}

	public void finish(Database.BatchableContext jobId) {
	}
}
