public without sharing class AccessShareService {
	public class UnprocessedRecords {
		public AccountShare[] accountShares = new List<AccountShare>{};
		public AccessShare__c[] accessShares = new List<AccessShare__c>{};
	}

	public static UnprocessedRecords assignAccess(Set<AccessShareDTO> accessShareDtos, String type) {
		UnprocessedRecords unprocessedRecords = new UnprocessedRecords();
		Set<AccessShareDTO> fullAccessShareDtos = accessShareDtos;
		if (type == 'search') {
			fullAccessShareDtos.addAll(AccessSharingUtils.getRelatedAccessShareDTOs(accessShareDtos));
		}

		if (fullAccessShareDtos != null && !fullAccessShareDtos.isEmpty()) {
			AccountShare[] newAccountShares = AccountSharingUtils.getNewAccountShareWithFullAccessList2(
				fullAccessShareDtos
			);

			AccessShare__c[] newAccessShares = AccessSharingUtils.getNewAccessShareList2(fullAccessShareDtos, type);

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
				AccessLogService.insertAccessLogsFromShares(accessSharesToUpsert);
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
				AccessLogService.insertErrorLog('Error', e.getMessage() + '\n' + e.getStackTraceString());
			}
		}
	}
}
