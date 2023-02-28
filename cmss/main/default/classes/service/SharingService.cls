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

	public static void deleteSharingRecords(Set<String> shareSet, String shareObject, Set<Id> idSet) {
		try {
			List<sObject> shareList = Database.query(
				'SELECT Id, ParentId, RowCause FROM ' +
				shareObject +
				' WHERE ParentId IN :idSet'
			);
			List<sObject> shareIdListReduced = new List<sObject>();
			for (sObject sobj : shareList) {
				String s = (String) sobj.get('ParentId') + '_' + sobj.get('RowCause');
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

	public static sObject prepareCustomShareRecord(
		String shareObj,
		Id parentId,
		Id userId,
		String accessLevel,
		String rowCause
	) {
		sObject obj = (SObject) Type.forName(shareObj).newInstance();
		obj.put('ParentId', parentId);
		obj.put('UserOrGroupId', userId);
		obj.put('AccessLevel', accessLevel);
		obj.put('RowCause', rowCause);
		return obj;
	}

	public static sObject prepareStandardShareRecord(
		String shareObj,
		Id objectId,
		String objectField,
		Id userId,
		String accessLevel,
		String accessField,
		String rowCause
	) {
		sObject obj = (SObject) Type.forName(shareObj).newInstance();
		obj.put(objectField, objectId);
		obj.put('UserOrGroupId', userId);
		obj.put(accessField, accessLevel);
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
}
