public class ClientZoneTriggerHandler extends TriggerHandler {
	public override void beforeInsert() {
		IntegrationUtility.populateDefaultExternalId(Trigger.new);
	}

	public override void beforeUpdate() {
		IntegrationUtility.populateDefaultExternalId(Trigger.new);
	}

	public override void beforeDelete() {
		AQMessageService.handleDelete(Trigger.old, ClientZone__c.SObjectType);
	}

	public override void afterInsert() {
		AQMessageService.handleInsert(Trigger.new, ClientZone__c.SObjectType);
		setClientZone(Trigger.new);
	}

	public override void afterUndelete() {
		AQMessageService.handleInsert(Trigger.new, ClientZone__c.SObjectType);
	}

	public override void afterDelete() {
		deleteClientZone(Trigger.old);
	}

	public override void afterUpdate() {
		Map<Id, ClientZone__c> newClientZoneById = (Map<Id, ClientZone__c>) Trigger.newMap;
		Map<Id, ClientZone__c> oldClientZoneById = (Map<Id, ClientZone__c>) Trigger.oldMap;
		setClientZoneAfterUpdate(newClientZoneById, oldClientZoneById);
		AQMessageService.handleUpdate(Trigger.new, Trigger.oldMap, ClientZone__c.SObjectType);
	}

	@TestVisible
	private static void setClientZoneAfterUpdate(
		Map<Id, ClientZone__c> newClientZoneById,
		Map<Id, ClientZone__c> oldClientZoneById
	) {
		List<ClientZone__c> clientZones = new List<ClientZone__c>();
		for (ClientZone__c cz : newClientZoneById.values()) {
			if (
				cz.AgreementDate__c != oldClientZoneById.get(cz.Id).AgreementDate__c ||
				cz.Role__c != oldClientZoneById.get(cz.Id).Role__c
			) {
				clientZones.add(cz);
			}
		}
		if (clientZones.size() > 0) {
			setClientZone(clientZones);
		}
	}
	@TestVisible
	private static void setClientZone(List<ClientZone__c> clientZones) {
		Set<Id> accountIds = new Set<Id>();
		for (ClientZone__c cz : clientZones) {
			accountIds.add(cz.Account__c);
		}
		updateAccountWithClientZone(accountIds);
	}

	private static Map<Id, ClientZone__c> getLatestClientZoneByAccountId(Set<Id> accountIds) {
		Map<Id, ClientZone__c> latestClientZoneByAccountId = new Map<Id, ClientZone__c>();
		for (ClientZone__c czItem : [
			SELECT Id, AgreementDate__c, toLabel(Role__c), Account__c
			FROM ClientZone__c
			WHERE Account__c IN :accountIds
		]) {
			if (latestClientZoneByAccountId.containsKey(czItem.Account__c)) {
				if (latestClientZoneByAccountId.get(czItem.Account__c).AgreementDate__c < czItem.AgreementDate__c) {
					latestClientZoneByAccountId.put(czItem.Account__c, czItem);
				}
			} else {
				latestClientZoneByAccountId.put(czItem.Account__c, czItem);
			}
		}
		return latestClientZoneByAccountId;
	}

	private static Map<Id, Account> getAccountById(Set<Id> accountIds) {
		return new Map<Id, Account>(
			[SELECT Id, ClientZonewithLatestAgreementDate__c, ClientZoneAccess__c FROM Account WHERE ID IN :accountIds]
		);
	}
	@TestVisible
	private static void deleteClientZone(List<ClientZone__c> deletedRecords) {
		Set<Id> accountIds = new Set<Id>();
		for (ClientZone__c cz : deletedRecords) {
			accountIds.add(cz.Account__c);
		}
		updateAccountWithClientZone(accountIds);
	}
	private static void updateAccountWithClientZone(Set<Id> accountIds) {
		Map<Id, ClientZone__c> clientZoneByAccountId = getLatestClientZoneByAccountId(accountIds);
		List<Account> accounts = new List<Account>();
		Map<Id, Account> accountById = getAccountById(accountIds);
		for (Id acc : accountIds) {
			//continue when account shouldnt be changed
			if (
				clientZoneByAccountId.containsKey(acc) &&
				clientZoneByAccountId.get(acc).Id == accountById.get(acc).ClientZonewithLatestAgreementDate__c &&
				clientZoneByAccountId.get(acc).Role__c == accountById.get(acc).ClientZoneAccess__c
			) {
				continue;
			}
			Account a = new Account();
			a.Id = acc;
			if (clientZoneByAccountId.containsKey(acc)) {
				Clientzone__c cz = clientZoneByAccountId.get(acc);
				a.ClientZonewithLatestAgreementDate__c = cz.Id;
				a.ClientZoneAccess__c = cz.Role__c;
			} else {
				//when record is deleted
				a.ClientZonewithLatestAgreementDate__c = null;
				a.ClientZoneAccess__c = null;
			}
			accounts.add(a);
		}
		update accounts;
	}
}
