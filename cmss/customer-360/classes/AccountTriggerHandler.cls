public class AccountTriggerHandler extends TriggerHandler {
	public override void beforeInsert() {
		invalidateAccount(Trigger.new);
		changeOwnerOfInvalidatedAccounts(Trigger.new);
	}

	public override void beforeUpdate() {
		invalidateAccount(Trigger.new);
		changeOwnerOfInvalidatedAccounts(Trigger.new);
	}

	public override void beforeDelete() {
		AQMessageService.handleDelete(Trigger.old, Account.SObjectType);
	}

	public override void afterInsert() {
		AQMessageService.handleInsert(Trigger.new, Account.SObjectType);
	}

	public override void afterUpdate() {
		AQMessageService.handleUpdate(Trigger.new, Trigger.oldMap, Account.SObjectType);
	}

	public override void afterUndelete() {
		AQMessageService.handleInsert(Trigger.new, Account.SObjectType);
	}

	// ***************************** handlers and helping methods***************************************** //

	@TestVisible
	private static void changeOwnerOfInvalidatedAccounts(List<Account> accounts) {
		Id ownerForHiddenRecordsId = CommonSetting__c.getOrgDefaults().OwnerForHiddenRecords__c;
		if (ownerForHiddenRecordsId != null) {
			for (Account a : accounts) {
				if (a.IsInvalid__c && a.OwnerId != ownerForHiddenRecordsId) {
					a.OwnerId = ownerForHiddenRecordsId;
				}
			}
		}
	}

	@TestVisible
	private static void invalidateAccount(List<Account> accounts) {
		//Pokud je vyplněný date of deletion nebo pokud je status klienta 4 nebo 5
		for (Account a : accounts) {
			if (a.DateOfDeletion__c != null || a.AccountStatus__c == '4' || a.AccountStatus__c == '5') {
				a.isInvalid__c = true;
			}
		}
	}
}
