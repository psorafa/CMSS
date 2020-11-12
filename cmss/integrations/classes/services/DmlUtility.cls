public with sharing class DmlUtility {

	public static void insertRecord(SObject record) {
		try {
			PermissionUtility.checkForInsert(record);
			insert record;
		} catch (DmlException e) {
			throw new SOAPCommonTypes.BusinessException(301, 'Cannot insert record: ' + e.getMessage(), e);
		}
	}

	public static void insertRecords(List<SObject> records) {
		try {
			PermissionUtility.checkForInsert(records);
			insert records;
		} catch (DmlException e) {
			throw new SOAPCommonTypes.BusinessException(301, 'Cannot insert record: ' + e.getMessage(), e);
		}
	}

	public static void updateRecord(SObject record) {
		try {
			PermissionUtility.checkForUpdate(record);
			update record;
		} catch (DmlException e) {
			throw new SOAPCommonTypes.BusinessException(302, 'Cannot update record: ' + e.getMessage(), e);
		}
	}

	public static void updateRecords(List<SObject> records) {
		try {
			PermissionUtility.checkForUpdate(records);
			update records;
		} catch (DmlException e) {
			throw new SOAPCommonTypes.BusinessException(302, 'Cannot update record: ' + e.getMessage(), e);
		}
	}
}