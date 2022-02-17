public without sharing class DeleteClientZoneNotification_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable {
	private DateTime actualDate;
	private final String CANCELATION_TEMPLATE_NAME = 'ClientZoneCancelationNotification';

	public DeleteClientZoneNotification_Batch() {
		this.actualDate = System.now();
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
			Map<Id, AccountRelation__c> associatedAccounts = getAssociatedAccounts(accountToClientZoneMap.keySet());
			Map<Id, Asset> associatedAssets = getAssociatedAssets(accountToClientZoneMap.keySet());
			Map<Id, Opportunity> associatedOpportunities = getAssociatedOpportunities(accountToClientZoneMap.keySet());

			clientZonesToUpdate = processClientZones(
				accountToClientZoneMap,
				associatedAccounts,
				associatedAssets,
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
		Map<Id, AccountRelation__c> associatedAccounts,
		Map<Id, Asset> associatedAssets,
		Map<Id, Opportunity> associatedOpportunities
	) {
		List<ClientZone__c> clientZonesToUpdate = new List<ClientZone__c>();
		for (ClientZone__c clientZone : accountToClientZoneMap.values()) {
			if (
				!associatedAccounts.containsKey(clientZone.Account__c) &&
				!associatedAssets.containsKey(clientZone.Account__c) &&
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
				new Map<String, String>{ 'CANCELATION_DATE' => actualDate.addDays(14).format('dd. MM. yyyy') }
			);
			handler.handle();
		}
	}

	private Map<Id, AccountRelation__c> getAssociatedAccounts(Set<Id> accountIds) {
		List<AccountRelation__c> accountRelations = [
			SELECT GlobalId__c, Account__c, RelatedAccount__c, RelatedGlobalId__c, AccountRole__c
			FROM AccountRelation__c
			WHERE
				(Account__c IN :accountIds
				OR RelatedAccount__c IN :accountIds)
				AND (AccountRole__c = '1501'
				OR AccountRole__c = '1503')
		];

		Map<Id, AccountRelation__c> associatedAccounts = new Map<Id, AccountRelation__c>();

		for (AccountRelation__c relation : accountRelations) {
			if (relation.GlobalId__c != null) {
				associatedAccounts.put(relation.Account__c, relation);
			}
			if (relation.RelatedGlobalId__c != null) {
				associatedAccounts.put(relation.RelatedAccount__c, relation);
			}
		}

		return associatedAccounts;
	}

	private Map<Id, Asset> getAssociatedAssets(Set<Id> accountIds) {
		List<Asset> assets = [
			SELECT Id, AccountId
			FROM Asset
			WHERE
				AccountId IN :accountIds
				AND StateCode__c = '1'
				AND ProductType__c = '11'
				AND AccountId IN (
					SELECT Account__c
					FROM AssetAccountRelation__c
					WHERE RelationType__c = '1' OR RelationType__c = '3' OR RelationType__c = '4'
				)
		];
		Map<Id, Asset> associatedAssets = new Map<Id, Asset>();
		for (Asset asset : assets) {
			associatedAssets.put(asset.AccountId, asset);
		}
		return associatedAssets;
	}

	private Map<Id, Opportunity> getAssociatedOpportunities(Set<Id> accountIds) {
		List<Opportunity> opportunities = [
			SELECT AccountId
			FROM Opportunity
			WHERE
				AccountId IN :accountIds
				AND IsClosed = FALSE
				AND (Category__c = '5'
				OR Category__c = '6'
				OR Category__c = '7')
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
