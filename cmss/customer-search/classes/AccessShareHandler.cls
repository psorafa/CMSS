// public class AccessShareHandler implements iTrigger{
public class AccessShareHandler {
	public static List<AccessShare__c> ownerTypeAccShares = new List<AccessShare__c>();

	public void afterInsert(List<SObject> soList) {
		// if (DataFactoryTest.shouldRunTrigger()) {
		List<AccessShare__c> ownerTypeAccShares = new List<AccessShare__c>();
		List<AccessShare__c> newAccessShares = (List<AccessShare__c>) soList;
		for (AccessShare__c accSh : newAccessShares) {
			if (accSh.Type__c == 'Owner') {
				ownerTypeAccShares.add(accSh);
			}
		}
		if (!ownerTypeAccShares.isEmpty()) {
			AccessShareService.updateOwnershipOnAccounts(ownerTypeAccShares);
		}
		// }
	}

	public void afterUpdate(List<SObject> oldListSo, List<SObject> newListSo) {
		// if (DataFactoryTest.shouldRunTrigger()) {
		List<AccessShare__c> ownerTypeAccShares = new List<AccessShare__c>();
		List<AccessShare__c> newAccessShares = (List<AccessShare__c>) newListSo;
		for (AccessShare__c accSh : newAccessShares) {
			if (accSh.Type__c == 'Owner') {
				ownerTypeAccShares.add(accSh);
			}
		}
		if (!ownerTypeAccShares.isEmpty()) {
			AccessShareService.updateOwnershipOnAccounts(ownerTypeAccShares);
		}
		// }
	}

	public void afterDelete(List<SObject> soList) {
		// if (DataFactoryTest.shouldRunTrigger()) {
		List<AccessShare__c> ownerTypeAccShares = new List<AccessShare__c>();
		List<AccessShare__c> newAccessShares = (List<AccessShare__c>) soList;
		for (AccessShare__c accSh : newAccessShares) {
			if (accSh.Type__c == 'Owner') {
				ownerTypeAccShares.add(accSh);
			}
		}
		if (!ownerTypeAccShares.isEmpty()) {
			AccessShareService.updateOwnershipOnAccounts(ownerTypeAccShares);
		}
		// }
	}

	// public void andFinally() {
	// 	// if (DataFactoryTest.shouldRunTrigger()) {
	// 	// }
	// }
}