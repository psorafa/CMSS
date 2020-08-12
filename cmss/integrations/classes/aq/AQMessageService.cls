public class AQMessageService {

	public static void handleInsert(List<SObject> records, SObjectType sObjectType) {
		if (!FeatureManagement.checkPermission('Bypass_AQ_Messaging')) {
			AQMessagePublisher publisher = new AQMessagePublisher('CREATE', '' + sObjectType);
			for (SObject record : records) {
				publisher.addMessage(record.Id, getDataMapForInsertedRecord(record, sObjectType));
			}
			publisher.publish();
		}
	}

	public static void handleUpdate(List<SObject> newRecords, Map<Id, SObject> oldRecordsMap, SObjectType sObjectType) {
		if (!FeatureManagement.checkPermission('Bypass_AQ_Messaging')) {
			AQMessagePublisher publisher = new AQMessagePublisher('UPDATE', '' + sObjectType);
			for (SObject newRecord : newRecords) {
				publisher.addMessage(
					newRecord.Id,
					getDataMapForUpdatedRecord(newRecord, oldRecordsMap.get(newRecord.Id), sObjectType)
				);
			}
			publisher.publish();
		}
	}

	public static void handleDelete(List<SObject> records, SObjectType sObjectType) {
		if (!FeatureManagement.checkPermission('Bypass_AQ_Messaging')) {
			AQMessagePublisher publisher = new AQMessagePublisher('DELETE', '' + sObjectType);
			for (SObject record : records) {
				publisher.addMessage(record.Id);
			}
			publisher.publish();
		}
	}

	private static Map<String, Object> getDataMapForInsertedRecord(SObject record, SObjectType sObjectType) {
		Map<String, Object> dataMap = new Map<String, Object>();
		for (SObjectField field : sObjectType.getDescribe().fields.getMap().values()) {
			DescribeFieldResult describe = field.getDescribe();
			if (describe.isAccessible() && record.get(field) != null) {
				dataMap.put(describe.getName(), record.get(field));
			}
		}
		return dataMap;
	}

	private static Map<String, Object> getDataMapForUpdatedRecord(SObject newRecord, SObject oldRecord, SObjectType sObjectType) {
		Map<String, Object> dataMap = new Map<String, Object>();
		for (SObjectField field : sObjectType.getDescribe().fields.getMap().values()) {
			DescribeFieldResult describe = field.getDescribe();
			if (describe.isAccessible() && newRecord.get(field) != oldRecord.get(field)) {
				dataMap.put(describe.getName(), newRecord.get(field));
			}
		}
		return dataMap;
	}
}