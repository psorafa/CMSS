public class AccountTriggerHandler extends TriggerHandler {

	public override void beforeInsert() {
		changeOwnerOfInvalidatedAccounts(Trigger.new);
	}

	public override void beforeUpdate() {
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
}