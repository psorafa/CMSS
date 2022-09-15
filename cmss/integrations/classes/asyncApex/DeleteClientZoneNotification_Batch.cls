public without sharing class DeleteClientZoneNotification_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts, Schedulable {
	private DateTime actualDate;
	private Integer daysBeforeFirstNotification;
	private Integer daysBetweenNotificationAndDeletion;
	private Boolean isKZSettingsLoaded = false;
	private final String CANCELATION_TEMPLATE_NAME = 'ClientZoneCancelationNotification';

	public DeleteClientZoneNotification_Batch() {
		KZNotificationSettings__c KZSettings = KZNotificationSettings__c.getOrgDefaults();
		if (KZSettings != null) {
			isKZSettingsLoaded = true;
		}
		this.daysBeforeFirstNotification = (Integer) KZSettings?.DaysFromKZCreation__c;
		this.daysBetweenNotificationAndDeletion = (Integer) KZSettings?.DaysBetweenNotificationAndDeletion__c;
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
					CancelationNotificationSentDate__c,
					ModifiedDate__c,
					SignatureDate__c
				FROM ClientZone__c
				WHERE ClosedBy__c = NULL AND (Role__c = '7' OR Role__c = '9') AND Status__c = '1'
			]
		);
	}

	public void execute(Database.BatchableContext jobId, List<ClientZone__c> recordList) {
		this.actualDate = System.now();
		System.debug('Actual date: ' + this.actualDate);

		List<ClientZone__c> clientZonesToUpdate = new List<ClientZone__c>();
		if (!this.isKZSettingsLoaded) {
			return;
		}
		try {
			Map<Id, ClientZone__c> accountToClientZoneMap = new Map<Id, ClientZone__c>();
			for (ClientZone__c record : recordList) {
				accountToClientZoneMap.put(record.Account__c, record);
			}
			Map<Id, AccountRelation__c> associatedAccounts = getAssociatedAccounts(accountToClientZoneMap.keySet());
			Map<Id, Asset> associatedAssets = getAssociatedAssets(accountToClientZoneMap.keySet());
			Map<Id, Opportunity> associatedOpportunities = getAssociatedOpportunities(accountToClientZoneMap.keySet());
			Map<Id, AssetAccountRelation__c> associatedAssetRelations = getAssociatedAssetRelations(
				accountToClientZoneMap.keySet()
			);

			clientZonesToUpdate = processClientZones(
				accountToClientZoneMap,
				associatedAccounts,
				associatedAssets,
				associatedOpportunities,
				associatedAssetRelations
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
		Map<Id, Opportunity> associatedOpportunities,
		Map<Id, AssetAccountRelation__c> associatedAssetRelations
	) {
		List<ClientZone__c> clientZonesToUpdate = new List<ClientZone__c>();
		for (ClientZone__c clientZone : accountToClientZoneMap.values()) {
			if (
				!associatedAccounts.containsKey(clientZone.Account__c) &&
				!associatedAssets.containsKey(clientZone.Account__c) &&
				!associatedOpportunities.containsKey(clientZone.Account__c) &&
				!associatedAssetRelations.containsKey(clientZone.Account__c)
			) {
				Date clientZoneCheckDate = clientZone.SignatureDate__c != null
					? clientZone.SignatureDate__c
					: clientZone.ModifiedDate__c?.date();

				Integer daysBeforeFirstNotificationIncrement = -1 * (this.daysBeforeFirstNotification);
				Integer daysBetweenNotificationAndDeletionIncrement = -1 * (this.daysBetweenNotificationAndDeletion);
				if (
					clientZone.CancelationNotificationSentDate__c == null &&
					clientZoneCheckDate < actualDate.addDays(daysBeforeFirstNotificationIncrement)
				) {
					sendNotification(clientZone);
					clientZone.CancelationNotificationSentDate__c = System.now();
					clientZonesToUpdate.add(clientZone);
				} else if (
					clientZone.CancelationNotificationSentDate__c != null &&
					clientZone.CancelationNotificationSentDate__c <
					actualDate.addDays(daysBetweenNotificationAndDeletionIncrement) &&
					clientZone.CancelationNotificationSentDate__c >
					actualDate.addDays(daysBetweenNotificationAndDeletionIncrement - 15)
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
		List<Account> accountsWithGlobalIds = [SELECT GlobalId__c FROM Account WHERE Id IN :accountIds];
		Map<String, Id> globalIdToAccountIdMap = new Map<String, Id>();
		for (Account account : accountsWithGlobalIds) {
			globalIdToAccountIdMap.put(account.GlobalId__c, account.Id);
		}

		List<AccountRelation__c> accountRelations = [
			SELECT GlobalId__c, Account__c, RelatedAccount__c, RelatedGlobalId__c, AccountRole__c
			FROM AccountRelation__c
			WHERE
				(GlobalId__c IN :globalIdToAccountIdMap.keySet()
				OR RelatedGlobalId__c IN :globalIdToAccountIdMap.keySet())
				AND (AccountRole__c = '1501'
				OR AccountRole__c = '1503'
				OR RelatedAccountRole__c = '1501'
				OR RelatedAccountRole__c = '1503')
		];

		Map<Id, AccountRelation__c> associatedAccounts = new Map<Id, AccountRelation__c>();

		for (AccountRelation__c relation : accountRelations) {
			if (relation.GlobalId__c != null && globalIdToAccountIdMap.containsKey(relation.GlobalId__c)) {
				associatedAccounts.put(globalIdToAccountIdMap.get(relation.GlobalId__c), relation);
			}
			if (
				relation.RelatedGlobalId__c != null && globalIdToAccountIdMap.containsKey(relation.RelatedGlobalId__c)
			) {
				associatedAccounts.put(globalIdToAccountIdMap.get(relation.RelatedGlobalId__c), relation);
			}
		}

		return associatedAccounts;
	}

	private Map<Id, AssetAccountRelation__c> getAssociatedAssetRelations(Set<Id> accountIds) {
		List<AssetAccountRelation__c> assetAccountRelations = [
			SELECT Account__c, RelationType__c, Asset__r.StateCode__c, Asset__r.ProductType__c
			FROM AssetAccountRelation__c
			WHERE
				Account__c IN :accountIds
				AND Asset__r.StateCode__c = '1'
				AND (Asset__r.ProductType__c = '0'
				OR Asset__r.ProductType__c = '9')
		];

		Map<Id, AssetAccountRelation__c> associatedAssetRelations = new Map<Id, AssetAccountRelation__c>();
		for (AssetAccountRelation__c relation : assetAccountRelations) {
			associatedAssetRelations.put(relation.Account__c, relation);
		}

		return associatedAssetRelations;
	}

	private Map<Id, Asset> getAssociatedAssets(Set<Id> accountIds) {
		List<Asset> assets = [
			SELECT Id, AccountId
			FROM Asset
			WHERE AccountId IN :accountIds AND StateCode__c = '1' AND (ProductType__c = '9' OR ProductType__c = '0')
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
				AND (Category__c = '5'
				OR Category__c = '6'
				OR Category__c = '7')
				AND StageName != '3'
				AND StageName != '5'
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
