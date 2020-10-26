public class AQMessageService {
	private static final Map<SObjectType, SObjectType> aqMessageTypes = new Map<SObjectType, SObjectType>{
		Account.SObjectType => AQAccount__e.SObjectType,
		AccountRelation__c.SObjectType => AQAccountRelation__e.SObjectType,
		ClientZone__c.SObjectType => AQClientZone__e.SObjectType,
		Opportunity.SObjectType => AQOpportunity__e.SObjectType,
		Task.SObjectType => AQTask__e.SObjectType
	};

	public static void handleInsert(List<SObject> records, SObjectType sObjectType) {
		checkSObjectType(sObjectType);
		if (!FeatureManagement.checkPermission('Bypass_AQ_Messaging')) {
			AQMessagePublisher publisher = new AQMessagePublisher(
				'CREATE',
				sObjectType,
				aqMessageTypes.get(sObjectType)
			);
			for (SObject record : records) {
				publisher.addMessage(
					record.Id,
					(String) record.get('ExternalId__c'),
					getDataMapForInsertedRecord(record, sObjectType)
				);
			}
			publisher.publish();
		}
	}

	public static void handleUpdate(List<SObject> newRecords, Map<Id, SObject> oldRecordsMap, SObjectType sObjectType) {
		checkSObjectType(sObjectType);
		if (!FeatureManagement.checkPermission('Bypass_AQ_Messaging')) {
			AQMessagePublisher publisher = new AQMessagePublisher(
				'UPDATE',
				sObjectType,
				aqMessageTypes.get(sObjectType)
			);
			for (SObject newRecord : newRecords) {
				publisher.addMessage(
					newRecord.Id,
					(String) newRecord.get('ExternalId__c'),
					getDataMapForUpdatedRecord(newRecord, oldRecordsMap.get(newRecord.Id), sObjectType)
				);
			}
			publisher.publish();
		}
	}

	public static void handleDelete(List<SObject> records, SObjectType sObjectType) {
		checkSObjectType(sObjectType);
		if (!FeatureManagement.checkPermission('Bypass_AQ_Messaging')) {
			AQMessagePublisher publisher = new AQMessagePublisher(
				'DELETE',
				sObjectType,
				aqMessageTypes.get(sObjectType)
			);
			for (SObject record : records) {
				publisher.addMessage(record.Id, (String) record.get('ExternalId__c'));
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

	private static Map<String, Object> getDataMapForUpdatedRecord(
		SObject newRecord,
		SObject oldRecord,
		SObjectType sObjectType
	) {
		Map<String, Object> dataMap = new Map<String, Object>();
		for (SObjectField field : sObjectType.getDescribe().fields.getMap().values()) {
			DescribeFieldResult describe = field.getDescribe();
			if (describe.isAccessible() && newRecord.get(field) != oldRecord.get(field)) {
				dataMap.put(describe.getName(), newRecord.get(field));
			}
		}
		return dataMap;
	}

	private static void checkSObjectType(SObjectType sObjectType) {
		if (!aqMessageTypes.containsKey(sObjectType)) {
			throw new UnsupportedTypeException('SObjectType not supported for AQ messaging: ' + sObjectType);
		}
	}

	public class UnsupportedTypeException extends Exception {
	}
}
