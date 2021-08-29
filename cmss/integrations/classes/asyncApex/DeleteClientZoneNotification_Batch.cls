public without sharing class DeleteClientZoneNotification_Batch implements Database.Batchable<sObject>, Schedulable {
	private DateTime actualDate;
	private final String CANCELATION_TEMPLATE_NAME = 'ClientZoneCancelationNotification';

	public DeleteClientZoneNotification_Batch() {
		this.actualDate = System.today();
	}

	public void execute(SchedulableContext sc) {
		Database.executeBatch(this);
	}

	public List<ClientZone__c> start(Database.BatchableContext jobId) {
		return (List<ClientZone__c>) [
			SELECT
				Id,
				ClosedBy__c,
				Role__c,
				Status__c,
				Account__c,
				Account__r.PersonEmail,
				CreatedDate__c,
				CancelationNotificationSentDate__c
			FROM ClientZone__c
			WHERE ClosedBy__c = NULL AND (Role__c = '7' OR Role__c = '9') AND Status__c = '1'
		];
	}

	public void execute(Database.BatchableContext jobId, List<ClientZone__c> recordList) {
		Map<Id, ClientZone__c> accountToClientZoneMap = new Map<Id, ClientZone__c>();
		for (ClientZone__c record : recordList) {
			accountToClientZoneMap.put(record.Account__c, record);
		}

		Map<Id, AccountRelation__c> validAccountRelations = getAssociatedAccounts(accountToClientZoneMap.keySet());
		Map<Id, Task> associatedTasks = getAssociatedTasks(accountToClientZoneMap.keySet());
		List<ClientZone__c> clientZonesToUpdate = new List<ClientZone__c>();

		for (ClientZone__c clientZone : accountToClientZoneMap.values()) {
			if (
				!validAccountRelations.containsKey(clientZone.Account__c) ||
				!associatedTasks.containsKey(clientZone.Account__c)
			) {
				if (
					clientZone.CreatedDate__c < actualDate.addDays(-15) &&
					clientZone.CancelationNotificationSentDate__c == null
				) {
					SendNotificationHandler handler = new SendNotificationHandler(
						clientZone,
						CANCELATION_TEMPLATE_NAME,
						clientZone.Account__r.PersonEmail
					);
					handler.handle();
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
		update clientZonesToUpdate;
	}

	private Map<Id, AccountRelation__c> getAssociatedAccounts(Set<Id> accountIds) {
		List<AccountRelation__c> accountRelations = [
			SELECT GlobalId__c, RelatedGlobalId__c, RelationTypeNEL__c
			FROM AccountRelation__c
			WHERE (GlobalId__c IN :accountIds OR RelatedGlobalId__c IN :accountIds) AND RelationTypeNEL__c = '1'
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

	public void finish(Database.BatchableContext jobId) {
	}
}
