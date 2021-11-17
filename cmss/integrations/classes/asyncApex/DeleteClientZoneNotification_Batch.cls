public without sharing class DeleteClientZoneNotification_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable {
	private DateTime actualDate;
	private final String CANCELATION_TEMPLATE_NAME = 'ClientZoneCancelationNotification';

	public DeleteClientZoneNotification_Batch() {
		this.actualDate = System.today();
	}

	public void execute(SchedulableContext sc) {
		Database.executeBatch(this);
	}

	public Database.QueryLocator start(Database.BatchableContext jobId) {
		return Database.getQueryLocator(
			[
				SELECT
					Id,
					ClosedBy__c,
					Role__c,
					Status__c,
					Account__c,
					Email__c,
					CreatedDate,
					CancelationNotificationSentDate__c
				FROM ClientZone__c
				WHERE ClosedBy__c = NULL AND (Role__c = '7' OR Role__c = '9') AND Status__c = '1'
			]
		);
	}

	public void execute(Database.BatchableContext jobId, List<ClientZone__c> recordList) {
		List<ClientZone__c> clientZonesToUpdate = new List<ClientZone__c>();
		try {
			Map<Id, ClientZone__c> accountToClientZoneMap = new Map<Id, ClientZone__c>();
			for (ClientZone__c record : recordList) {
				accountToClientZoneMap.put(record.Account__c, record);
			}
			Map<Id, AccountRelation__c> validAccountRelations = getAssociatedAccounts(accountToClientZoneMap.keySet());
			Map<Id, Task> associatedTasks = getAssociatedTasks(accountToClientZoneMap.keySet());
			Map<Id, Opportunity> associatedOpportunities = getAssociatedOpportunities(accountToClientZoneMap.keySet());

			clientZonesToUpdate = processClientZones(
				accountToClientZoneMap,
				validAccountRelations,
				associatedTasks,
				associatedOpportunities
			);
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
			update clientZonesToUpdate;
		}
	}

	private List<ClientZone__c> processClientZones(
		Map<Id, ClientZone__c> accountToClientZoneMap,
		Map<Id, AccountRelation__c> validAccountRelations,
		Map<Id, Task> associatedTasks,
		Map<Id, Opportunity> associatedOpportunities
	) {
		List<ClientZone__c> clientZonesToUpdate = new List<ClientZone__c>();
		for (ClientZone__c clientZone : accountToClientZoneMap.values()) {
			if (
				!validAccountRelations.containsKey(clientZone.Account__c) ||
				!associatedTasks.containsKey(clientZone.Account__c) ||
				!associatedOpportunities.containsKey(clientZone.Account__c)
			) {
				if (
					clientZone.CancelationNotificationSentDate__c == null &&
					clientZone.CreatedDate < actualDate.addDays(-15)
				) {
					sendNotification(clientZone);
					clientZone.CancelationNotificationSentDate__c = System.now();
					clientZonesToUpdate.add(clientZone);
				} else if (
					clientZone.CancelationNotificationSentDate__c != null &&
					clientZone.CancelationNotificationSentDate__c < actualDate.addDays(-15) &&
					clientZone.CancelationNotificationSentDate__c > actualDate.addDays(-75)
				) {
					CancelCZContractHandler handler = new CancelCZContractHandler(clientZone);
					handler.handle();
				}
			}
		}
		return clientZonesToUpdate;
	}

	private void sendNotification(ClientZone__c clientZone) {
		if (clientZone.Email__c != null) {
			SendNotificationHandler handler = new SendNotificationHandler(
				clientZone,
				CANCELATION_TEMPLATE_NAME,
				clientZone.Email__c,
				new Map<String, String>{ 'CANCELATION_DATE' => this.actualDate.addDays(14).format('dd. MM. yyyy') }
			);
			handler.handle();
		}
	}

	private Map<Id, AccountRelation__c> getAssociatedAccounts(Set<Id> accountIds) {
		List<AccountRelation__c> accountRelations = [
			SELECT GlobalId__c, RelatedGlobalId__c, AccountRole__c
			FROM AccountRelation__c
			WHERE (GlobalId__c IN :accountIds OR RelatedGlobalId__c IN :accountIds) AND AccountRole__c = '1501'
		];

		Map<Id, AccountRelation__c> associatedAccounts = new Map<Id, AccountRelation__c>();
		Map<Id, Id> otherToOriginalAccountIds = new Map<Id, Id>();

		for (AccountRelation__c relation : accountRelations) {
			if (relation.GlobalId__c != null && accountIds.contains(relation.GlobalId__c)) {
				associatedAccounts.put(relation.GlobalId__c, relation);
				if (relation.RelatedGlobalId__c != null) {
					otherToOriginalAccountIds.put(relation.RelatedGlobalId__c, relation.GlobalId__c);
				}
			}
			if (relation.RelatedGlobalId__c != null && accountIds.contains(relation.RelatedGlobalId__c)) {
				associatedAccounts.put(relation.RelatedGlobalId__c, relation);
				if (relation.GlobalId__c != null) {
					otherToOriginalAccountIds.put(relation.GlobalId__c, relation.RelatedGlobalId__c);
				}
			}
		}

		List<Asset> otherAccountAssets = [
			SELECT Id, AccountId, Active__c
			FROM Asset
			WHERE AccountId IN :otherToOriginalAccountIds.keySet() AND Active__c = TRUE
		];

		Map<Id, AccountRelation__c> validAssociatedAccounts = new Map<Id, AccountRelation__c>();
		for (Asset asset : otherAccountAssets) {
			Id originalAccountId = otherToOriginalAccountIds.get(asset.AccountId);
			validAssociatedAccounts.put(originalAccountId, associatedAccounts.get(originalAccountId));
		}

		return validAssociatedAccounts;
	}

	private Map<Id, Task> getAssociatedTasks(Set<Id> accountIds) {
		List<Task> tasks = [SELECT WhoId, Type FROM Task WHERE WhoId IN :accountIds AND Type = '5'];

		Map<Id, Task> associatedTasks = new Map<Id, Task>();
		for (Task task : tasks) {
			associatedTasks.put(task.WhoId, task);
		}
		return associatedTasks;
	}

	private Map<Id, Opportunity> getAssociatedOpportunities(Set<Id> accountIds) {
		List<Opportunity> opportunities = [
			SELECT AccountId
			FROM Opportunity
			WHERE AccountId IN :accountIds AND IsClosed = FALSE
		];

		Map<Id, Opportunity> associatedOpportunities = new Map<Id, Opportunity>();
		for (Opportunity opportunity : opportunities) {
			associatedOpportunities.put(opportunity.AccountId, opportunity);
		}
		return associatedOpportunities;
	}

	public void finish(Database.BatchableContext jobId) {
	}
}
