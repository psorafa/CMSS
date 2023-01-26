public class AccountTriggerHandler extends TriggerHandler {
	public override void beforeInsert() {
		validateAccount(Trigger.new);
		invalidateAccount(Trigger.new);
		setOwner(Trigger.new);
        setHasEmailHasPhoneFields(null, (List<Account>) Trigger.new);
	}

	public override void beforeUpdate() {
		validateAccount(Trigger.new);
		invalidateAccount(Trigger.new);
		setOwner(Trigger.new);
		setLastPortfolioManager((Map<Id, Account>) Trigger.oldMap, (List<Account>) Trigger.new);
        setHasEmailHasPhoneFields((Map<Id, Account>) Trigger.oldMap, (List<Account>) Trigger.new);
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
    private static void setHasEmailHasPhoneFields(Map<Id, Account> oldMap, List<Account> newList) {
        for (Account acc : newList) {
            if (oldMap == null) {
                updateHasFields(acc);
            } else {
                if (oldMap.get(acc.Id).Phone != acc.Phone 
                        || oldMap.get(acc.Id).PersonEmail != acc.PersonEmail 
                        || acc.HasEmail__c == null 
                        || acc.HasPhone__c == null) {

                    updateHasFields(acc);
                }
            }
        }
    }

    private static void updateHasFields(Account acc) {
        if (acc.Phone != null) {
            acc.HasPhone__c = true;
        } else {
            acc.HasPhone__c = false;
        }
        if (acc.PersonEmail != null) {
            acc.HasEmail__c = true;
        } else {
            acc.HasEmail__c = false;
        }
    }

	@TestVisible
	private static void setOwner(List<Account> accounts) {
		CommonSetting__c commonSetting = CommonSetting__c.getOrgDefaults();
		Id communityRecordType = [
			SELECT Id
			FROM RecordType
			WHERE SobjectType = 'Account' AND Name = 'Community Account'
		]
		.Id;
		for (Account a : accounts) {
			if (a.RecordTypeId == communityRecordType) {
				continue;
			}
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
	private static void setLastPortfolioManager(Map<Id, Account> oldAccountsMap, List<Account> newAccounts) {
		for (Account account : newAccounts) {
			if (oldAccountsMap.get(account.Id).PortfolioMngmtA__c != account.PortfolioMngmtA__c) {
				account.LastPortfolioManagerA__c = oldAccountsMap.get(account.Id).PortfolioMngmtA__c;
				account.LastPtfManAChangeDate__c = System.today();
			}
		}
	}

	@TestVisible
	private static void invalidateAccount(List<Account> accounts) {
		for (Account a : accounts) {
			if (a.DateOfDeletion__c != null || a.AccountStatus__c == '5') {
				a.IsInvalid__c = true;
			}
		}
	}

	@TestVisible
	private static void validateAccount(List<Account> accounts) {
		for (Account a : accounts) {
			if (a.IsInvalid__c == true && a.DateOfDeletion__c == null && a.AccountStatus__c != '5') {
				a.IsInvalid__c = false;
			}
		}
	}
}
