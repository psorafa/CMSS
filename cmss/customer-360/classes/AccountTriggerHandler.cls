public class AccountTriggerHandler extends TriggerHandler {
	public override void beforeInsert() {
		invalidateAccount(Trigger.new);
		setOwner(Trigger.new);
	}

	public override void beforeUpdate() {
		invalidateAccount(Trigger.new);
		setOwner(Trigger.new);
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
	private static void setOwner(List<Account> accounts) {
		CommonSetting__c commonSetting = CommonSetting__c.getOrgDefaults();
		for (Account a : accounts) {
			if (commonSetting.OwnerForHiddenRecords__c != null && a.IsInvalid__c) {
				a.OwnerId = commonSetting.OwnerForHiddenRecords__c;
			} else if (a.PortfolioMngmtA__c != null) {
				a.OwnerId = a.PortfolioMngmtA__c;
			} else if (commonSetting.AccountDefaultOwner__c != null) {
				a.OwnerId = commonSetting.AccountDefaultOwner__c;
			}
		}
	}

	@TestVisible
	private static void invalidateAccount(List<Account> accounts) {
		for (Account a : accounts) {
			if (a.DateOfDeletion__c != null || a.AccountStatus__c == '4' || a.AccountStatus__c == '5') {
				a.IsInvalid__c = true;
			}
		}
	}
}
