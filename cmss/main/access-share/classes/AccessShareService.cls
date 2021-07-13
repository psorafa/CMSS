public without sharing class AccessShareService {
	// public static void updateOwnershipOnAccounts(List<AccessShare__c> ownerTypeAccessShares) {
	// 	Map<Id, AccessShare__c> accSharesWithAccIdsMap = new Map<Id, AccessShare__c>();
	// 	Set<Id> accIds = new Set<Id>();
	// 	Set<Id> ownerIds = new Set<Id>();

	// 	for (AccessShare__c accSh : ownerTypeAccessShares) {
	// 		accIds.add(accSh.AccessTo__c);
	// 		ownerIds.add(accSh.RequestedBy__c);
	// 		accSharesWithAccIdsMap.put(accSh.AccessTo__c, accSh);
	// 	}
	// 	List<Account> accounts = [SELECT Co_ownership__c FROM Account WHERE Id IN :accIds FOR UPDATE];

	// 	Map<Id, Account> accountsMap = new Map<Id, Account>(accounts);

	// 	Map<Account, Set<Id>> accountsWithOwnersMap = new Map<Account, Set<Id>>();
	// 	List<AccessShare__c> allRelatedAccessShares = AccessShareDao.getNonExpiredAccessShareByRecordIdsAndType(
	// 		accIds,
	// 		'Owner'
	// 	);

	// 	Set<Id> allOwnersIds = new Set<Id>();

	// 	for (AccessShare__c accSh : allRelatedAccessShares) {
	// 		allOwnersIds.add(accSh.RequestedBy__c);
	// 	}

	// 	List<User> activeUsers = UserDao.getActiveUsersByIds(allOwnersIds);
	// 	Set<Id> activeUsersIds = new Set<Id>();
	// 	for (User u : activeUsers) {
	// 		activeUsersIds.add(u.Id);
	// 	}

	// 	List<AccessShare__c> allActiveRelatedAccessShares = AccessShareDao.getNonExpiredAccessShareByRecordIdsAndRequestedByAndType(
	// 		accIds,
	// 		activeUsersIds,
	// 		'Owner'
	// 	);

	// 	for (Account acc : accounts) {
	// 		Set<Id> accOwnerIds = new Set<Id>();
	// 		for (AccessShare__c accSh : allActiveRelatedAccessShares) {
	// 			if (acc.Id == accSh.AccessTo__c) {
	// 				accOwnerIds.add(accSh.RequestedBy__c);
	// 			}
	// 		}
	// 		accountsWithOwnersMap.put(acc, accOwnerIds);
	// 	}

	// 	List<Account> accountsToUpdate = new List<Account>();
	// 	for (Account acc : accountsWithOwnersMap.keyset()) {
	// 		Set<Id> ownersForAccIds = accountsWithOwnersMap.get(acc);
	// 		acc.Co_ownership__c = '';
	// 		Integer i = 0;
	// 		for (Id ownerId : ownersForAccIds) {
	// 			acc.Co_ownership__c += ownerId + '/';
	// 			i++;
	// 			// set to maximum of 12 possible IDS - text can contain only 255 charactes -> 255 : 18 (length of ID) >= 12

	// 			if (i == 12) {
	// 				break;
	// 			}
	// 		}
	// 		acc.Co_ownership__c.substringBeforeLast('/');
	// 		accountsToUpdate.add(acc);
	// 	}

	// 	update accountsToUpdate;
	// }

	public class UnprocessedRecords {
		public AccountShare[] accountShares = new List<AccountShare>{};
		public AccessShare__c[] accessShares = new List<AccessShare__c>{};
	}

	public static UnprocessedRecords assignAccess(Set<AccessShareDTO> accessShareDtos, String type) {
		UnprocessedRecords unprocessedRecords = new UnprocessedRecords();

		if (accessShareDtos != null && !accessShareDtos.isEmpty()) {
			AccountShare[] newAccountShares = AccountSharingUtils.getNewAccountShareWithFullAccessList2(
				accessShareDtos
			);

			AccessShare__c[] newAccessShares = AccessSharingUtils.getNewAccessShareList2(accessShareDtos, type);

			Set<Id> accountIds = new Set<Id>();
			Set<Id> userIds = new Set<Id>();
			Map<String, AccountShare[]> accShareMap = new Map<String, AccountShare[]>();
			Utils.AccountShareHelper accountShareHelper = new Utils.AccountShareHelper();

			for (AccountShare accountShare : newAccountShares) {
				accountIds.add(accountShare.AccountId);
				userIds.add(accountShare.UserOrGroupId);
				accountShareHelper.addToMapsList(
					accShareMap,
					'' +
					accountShare.UserOrGroupId +
					accountShare.AccountId,
					accountShare
				);
			}

			//remove accountShare duplicates from list
			for (AccountShare originAccountShare : [
				SELECT AccountId, UserOrGroupId
				FROM AccountShare
				WHERE UserOrGroupId IN :userIds AND AccountId IN :accountIds
			]) {
				accShareMap.remove('' + originAccountShare.UserOrGroupId + originAccountShare.AccountId);
			}
			newAccountShares.clear();

			for (AccountShare[] shares : accShareMap.values()) {
				newAccountShares.addAll(shares);
			}

			Map<String, AccessShare__c[]> accessShareMap = new Map<String, AccessShare__c[]>();

			Utils.AccessShareHelper accessShareHelper = new Utils.AccessShareHelper();
			for (AccessShare__c accessShare : newAccessShares) {
				accessShareHelper.addToMapsList(
					accessShareMap,
					accessShare.RequestedBy__c +
					',' +
					accessShare.AccessTo__c +
					',' +
					accessShare.Type__c +
					',' +
					accessShare.Reason__c,
					accessShare
				);
			}

			//remove accessShare duplicates from list
			AccessShare__c[] accessShareToUpdateList = new List<AccessShare__c>{};

			for (AccessShare__c origShare : [
				SELECT AccessTo__c, ExpirationDate__c, Reason__c, RequestedBy__c, Type__c
				FROM AccessShare__c
				WHERE RequestedBy__c IN :userIds AND AccessTo__c IN :accountIds
			]) {
				String key =
					origShare.RequestedBy__c +
					',' +
					origShare.AccessTo__c +
					',' +
					origShare.Type__c +
					',' +
					origShare.Reason__c;
				AccessShare__c[] duplicateShares = accessShareMap.remove(key);

				//// this sections would work for extending shares
				// DateTime expirationDate = origShare.ExpirationDate__c;
				// Boolean doUpdate = false;

				// if (duplicateShares != null) {
				// 	for (AccessShare__c duplShare : duplicateShares) {
				// 		if (origShare.ExpirationDate__c < duplShare.ExpirationDate__c) {
				// 			expirationDate = duplShare.ExpirationDate__c;
				// 			doUpdate = true;
				// 		}
				// 	}

				// 	if (doUpdate) {
				// 		origShare.ExpirationDate__c = expirationDate;
				// 		accessShareToUpdateList.add(origShare);
				// 	}
				// }
			}

			newAccessShares.clear();
			for (AccessShare__c[] shares : accessShareMap.values()) {
				newAccessShares.addAll(shares);
			}

			AccessShare__c[] accessSharesToUpsert = new List<AccessShare__c>(newAccessShares);
			accessSharesToUpsert.addAll(accessShareToUpdateList);

			Integer canUpsertCount = 9999 - Limits.getDmlRows();
			Integer accountShareCount = newAccountShares.size();
			Integer accessShareCount = accessSharesToUpsert.size();

			SObject[] canUpsert = new List<SObject>{};

			if (accountShareCount > canUpsertCount) {
				for (Integer i = canUpsertCount; i < accountShareCount + 1; i++) {
					unprocessedRecords.accountShares.add(newAccountShares.remove(i));
				}
			}

			canUpsertCount -= newAccountShares.size();
			if (accessShareCount > canUpsertCount) {
				for (Integer i = canUpsertCount; i < accessShareCount + 1; i++) {
					unprocessedRecords.accessShares.add(accessSharesToUpsert.remove(i));
				}
			}

			if (!newAccountShares.isEmpty()) {
				insert newAccountShares;
			}
			if (!accessSharesToUpsert.isEmpty()) {
				upsert accessSharesToUpsert;
			}
		}

		return unprocessedRecords;
	}

	public static void removeAccess(
		Set<AccessShareDTO.Remove> accessShareDtoRemoves,
		AccessShare__c[] accessShares, //input all accessShare needs to be list of all records whre user-accountid is combination we want to remove from accountshare (!!! Do  not filter also type
		String type
	) {
		if (
			accessShareDtoRemoves != null &&
			accessShareDtoRemoves != null &&
			!accessShares.isEmpty() &&
			!accessShares.isEmpty()
		) {
			// Integration_Log__c log = new Integration_Log__c();

			try {
				List<AccessShare__c> accessShareToBeDeleted = new List<AccessShare__c>();
				for (AccessShareDTO.Remove accessShareDtoRemove : accessShareDtoRemoves) {
					for (Integer i = 0; i < accessShares.size(); i++) {
						if (
							accessShares[i].AccessTo__c == accessShareDtoRemove.AccountId &&
							accessShares[i].RequestedBy__c == accessShareDtoRemove.userId
						) {
							if (
								accessShares[i].Type__c == type &&
								accessShares[i].Reason__c == accessShareDtoRemove.reason
							) {
								accessShareToBeDeleted.add(accessShares[i]);
								accessShares.remove(i--);
							} else {
								accessShareDtoRemove.toBeDeleted = false;
							}
						}
					}
				}

				Set<AccountShare> accountShareToBeDeleted = new Set<AccountShare>();
				for (AccessShareDTO.Remove accessShareDtoRemove : accessShareDtoRemoves) {
					if (
						accessShareDtoRemove.toBeDeleted &&
						accessShareDtoRemove.isManual &&
						accessShareDtoRemove.accountShare.Id != null
					) {
						accountShareToBeDeleted.add(accessShareDtoRemove.accountShare);
					}
				}

				if (accessShareToBeDeleted != null && !accessShareToBeDeleted.isEmpty()) {
					delete accessShareToBeDeleted;
				}

				if (accountShareToBeDeleted != null && !accountShareToBeDeleted.isEmpty()) {
					delete new List<AccountShare>(accountShareToBeDeleted);
				}
			} catch (Exception e) {
				// IntegrationLogService.errorIntegrationLog(log, null, 'AccessShareService', 'Failed to remove AccessShares', e.getMessage() + '\n' + e.getStackTraceString());
				// insert log;
				System.debug('### TODO should log exception');
			}
		}
	}
}
