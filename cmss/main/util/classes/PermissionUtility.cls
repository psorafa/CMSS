public with sharing class PermissionUtility {

	public static void checkForInsert(SObject so) {
		for (DescribeFieldResult descr : getFieldDescribesFromSObject(so)) {
			if (!descr.isCreateable()) {
				throw new InsufficientAccessException('No permission to create field: ' + descr.getName());
			}
		}
	}

	public static void checkForInsert(List<SObject> sObjects) {
		for (SObject so : sObjects) {
			checkForInsert(so);
		}
	}

	private static List<DescribeFieldResult> getFieldDescribesFromSObject(SObject so) {
		Map<String, SObjectField> fields = so.getSObjectType().getDescribe().fields.getMap();
		List<DescribeFieldResult> fieldDescribes = new List<DescribeFieldResult>();
		Map<String, Object> converted = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(so));
		for (String fieldName : converted.keySet()) {
			System.debug('fieldName: '+ fieldName);
			if (fields.containsKey(fieldName)) {
				fieldDescribes.add(fields.get(fieldName).getDescribe());
			}
		}
		return fieldDescribes;
	}

	public class InsufficientAccessException extends Exception {}
}