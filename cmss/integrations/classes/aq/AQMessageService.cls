public class AQMessageService {
	private static final Map<SObjectType, SObjectType> aqMessageTypes = new Map<SObjectType, SObjectType>{
		Account.SObjectType => AQAccount__e.SObjectType,
		AccountRelation__c.SObjectType => AQAccountRelation__e.SObjectType,
		ClientZone__c.SObjectType => AQClientZone__e.SObjectType,
		Opportunity.SObjectType => AQOpportunity__e.SObjectType,
		Task.SObjectType => AQTask__e.SObjectType
	};

	public static void handleInsert(List<SObject> records, SObjectType sObjectType) {
		handleCreateMessage('CREATE', records, null, sObjectType);
	}

	public static void handleUpdate(List<SObject> newRecords, Map<Id, SObject> oldRecordsMap, SObjectType sObjectType) {
		handleCreateMessage('UPDATE', newRecords, oldRecordsMap, sObjectType);
	}

	public static void handleDelete(List<SObject> records, SObjectType sObjectType) {
		handleCreateMessage('DELETE', records, null, sObjectType);
	}

	private static void handleCreateMessage(
		String type,
		List<SObject> records,
		Map<Id, SObject> oldRecordsMap,
		SObjectType sObjectType
	) {
		checkSObjectType(sObjectType);
		if (!FeatureManagement.checkPermission('Bypass_AQ_Messaging')) {
			AQMessagePublisher publisher = new AQMessagePublisher(type, sObjectType, aqMessageTypes.get(sObjectType));
			for (SObject record : records) {
				if (type == 'DELETE') {
					publisher.addMessage(record);
				} else {
					List<String> changedFields = null;
					if (type == 'UPDATE') {
						changedFields = getFieldsListForUpdatedRecord(
							record,
							oldRecordsMap.get(record.Id),
							sObjectType
						);
					}
					publisher.addMessage(record, getDataMapForNewRecord(record, sObjectType), changedFields);
				}
			}
			publisher.publish();
		}
	}

	private static Map<String, Object> getDataMapForNewRecord(SObject record, SObjectType sObjectType) {
		Map<String, Object> dataMap = new Map<String, Object>();
		for (SObjectField field : sObjectType.getDescribe().fields.getMap().values()) {
			DescribeFieldResult describe = field.getDescribe();
			if (describe.isAccessible() && record.get(field) != null) {
				dataMap.put(describe.getName(), record.get(field));
			}
		}
		return dataMap;
	}

	private static List<String> getFieldsListForUpdatedRecord(
		SObject newRecord,
		SObject oldRecord,
		SObjectType sObjectType
	) {
		List<String> fieldsList = new List<String>();
		for (SObjectField field : sObjectType.getDescribe().fields.getMap().values()) {
			DescribeFieldResult describe = field.getDescribe();
			if (describe.isAccessible() && newRecord.get(field) != oldRecord.get(field)) {
				fieldsList.add(describe.getName());
			}
		}
		return fieldsList;
	}

	private static void checkSObjectType(SObjectType sObjectType) {
		if (!aqMessageTypes.containsKey(sObjectType)) {
			throw new UnsupportedTypeException('SObjectType not supported for AQ messaging: ' + sObjectType);
		}
	}

	public class UnsupportedTypeException extends Exception {
	}
}
