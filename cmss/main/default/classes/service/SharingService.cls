public class SharingService {
	public static void deleteSharingRecords(List<sObject> sObjectList, String shareObject) {
		try {
			List<Id> idList = new List<Id>();
			for (sObject prod : sObjectList) {
				idList.add(prod.Id);
			}

			List<sObject> shareList = Database.query(
				'SELECT Id, ParentId, RowCause FROM ' +
				shareObject +
				' WHERE ParentId IN :idList'
			);
			delete shareList;
		} catch (Exception e) {
			Logger.error('Error in SharingService.deleteSharingRecords', e);
		} finally {
			Logger.saveLogs();
		}
	}

	public static void deleteSharingRecords(
		Set<String> shareSet,
		String shareObject,
		Set<Id> idSet,
		String objectField
	) {
		try {
			List<sObject> shareList = Database.query(
				'SELECT Id, ' +
				objectField +
				', RowCause FROM ' +
				shareObject +
				' WHERE ' +
				objectField +
				' IN :idSet'
			);
			List<sObject> shareIdListReduced = new List<sObject>();
			for (sObject sobj : shareList) {
				String s = (String) sobj.get(objectField) + '_' + sobj.get('RowCause');
				if (shareSet.contains(s)) {
					shareIdListReduced.add(sobj);
				}
			}

			delete shareIdListReduced;
		} catch (Exception e) {
			Logger.error('Error in SharingService.deleteSharingRecords', e);
		} finally {
			Logger.saveLogs();
		}
	}

	public static sObject prepareShareRecord(
		String shareObject,
		String sharingFieldName,
		Id objectId,
		Id userId,
		String accessFieldName,
		String accessLevel,
		String rowCause
	) {
		sObject obj = (SObject) Type.forName(shareObject).newInstance();
		obj.put(sharingFieldName, objectId);
		obj.put('UserOrGroupId', userId);
		obj.put(accessFieldName, accessLevel);
		obj.put('RowCause', rowCause);
		return obj;
	}

	public static void insertShareRecords(List<sObject> shareObjects) {
		try {
			Database.SaveResult[] lsr = Database.insert(shareObjects, false);
			Integer i = 0;
			for (Database.SaveResult sr : lsr) {
				if (!sr.isSuccess()) {
					Database.Error err = sr.getErrors()[0];
					if (
						!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION &&
						err.getMessage().contains('AccessLevel'))
					) {
						Logger.error(
							'Error in SharingService.insertShareRecords',
							'Unable to grant sharing access for Id=' +
							shareObjects[i].get('ParentId') +
							' due to following exception: ' +
							err.getMessage()
						);
					}
				}
				i++;
			}
		} catch (Exception e) {
			Logger.error('Error in SharingService.insertShareRecords', e);
		} finally {
			Logger.saveLogs();
		}
	}

	public class sharingSettingsWrap {
		String accessLevel;
		String accessFieldName;
		String rowCause;
		String compareFieldName;

		public sharingSettingsWrap(String accssFieldName, String accssLevel, String rCause, String cmprFieldName) {
			this.accessFieldName = accssFieldName;
			this.accessLevel = accssLevel;
			this.rowCause = rCause;
			this.compareFieldName = cmprFieldName;
		}
	}

	private static Set<Id> extractActiveUsers(
		List<sObject> newSObjectVersionList,
		Map<String, sharingSettingsWrap> sharingSettingsMap
	) {
		Set<Id> userIDsSet = new Set<Id>();
		for (sObject obj : newSObjectVersionList) {
			for (String objectFieldNameWithUserId : sharingSettingsMap.keySet()) {
				userIDsSet.add((Id) obj.get(objectFieldNameWithUserId));
			}
		}
		return new Map<Id, SObject>([SELECT Id, IsActive FROM User WHERE IsActive = TRUE AND Id IN :userIDsSet])
			.keySet();
	}

	public static void upsertSharing(
		List<sObject> newSObjectVersionList,
		Map<Id, sObject> oldSObjectVersionMap,
		Map<String, sharingSettingsWrap> sharingSettingsMap,
		String sharingFieldName
	) {
		String sObjectName = String.valueOf(newSObjectVersionList[0].getSObjectType());
		Boolean isCustom = newSObjectVersionList[0].getSObjectType().getDescribe().isCustom();
		Set<Id> activeUserIDsSet = extractActiveUsers(newSObjectVersionList, sharingSettingsMap);
		String shareObjectName;
		Boolean compareFieldCondition = true;

		if (isCustom) {
			shareObjectName = sObjectName.substring(0, sObjectName.length() - 1) + 'Share';
		} else {
			shareObjectName = sObjectName + 'Share';
		}

		List<sObject> shareInsertList = new List<sObject>();
		Set<String> shareDeleteSet = new Set<String>();
		Set<Id> idSet = new Set<Id>();

		for (sObject obj : newSObjectVersionList) {
			for (String objectFieldNameWithUserId : sharingSettingsMap.keySet()) {
				if (String.isNotBlank(sharingSettingsMap.get(objectFieldNameWithUserId).compareFieldName)) {
					compareFieldCondition = obj.get(objectFieldNameWithUserId) !=
						obj.get(sharingSettingsMap.get(objectFieldNameWithUserId).compareFieldName)
						? true
						: false;
				}
				if (
					(oldSObjectVersionMap.size() == 0 ||
					(obj.get(objectFieldNameWithUserId) !=
					oldSObjectVersionMap.get(obj.Id).get(objectFieldNameWithUserId))) &&
					compareFieldCondition &&
					activeUserIDsSet.contains((Id) obj.get(objectFieldNameWithUserId))
				) {
					shareInsertList.add(
						prepareShareRecord(
							shareObjectName,
							sharingFieldName,
							(Id) obj.get('Id'),
							(Id) obj.get(objectFieldNameWithUserId),
							sharingSettingsMap.get(objectFieldNameWithUserId).accessFieldName,
							sharingSettingsMap.get(objectFieldNameWithUserId).accessLevel,
							sharingSettingsMap.get(objectFieldNameWithUserId).rowCause
						)
					);

					if (oldSObjectVersionMap.size() > 0) {
						shareDeleteSet.add(
							Id.valueOf((Id) obj.get('Id')) +
							'_' +
							sharingSettingsMap.get(objectFieldNameWithUserId).rowCause
						);
						idSet.add((Id) obj.get('Id'));
					}
				}
			}
		}

		if (!shareDeleteSet.isEmpty()) {
			deleteSharingRecords(shareDeleteSet, shareObjectName, idSet, sharingFieldName);
		}

		if (!shareInsertList.isEmpty()) {
			insertShareRecords(shareInsertList);
		}
	}
}
