public without sharing class AccountConsolidationUtility {

	public static void changeOwnerOfInvalidatedAccounts(List<Account> accounts) {
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