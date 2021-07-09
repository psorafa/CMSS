public without sharing class Utils {
	public static String getObjectNameByRecordId(Id recordId) {
		return recordId.getSObjectType().getDescribe().getName();
	}

	/**
	 * @description Adds an SObject record to a List in a Map
	 * @author      Jakub Novotny
	 * @param       mapObj Map to modify
	 * @param       key Map key
	 * @param       value Value to add to the list at key
	 */
	public static void addToMapsList(Map<String, SObject[]> mapObj, String key, SObject value) {
		SObject[] values = mapObj.get(key);

		if (values == null) {
			values = new List<SObject>{};
		}
		values.add(value);

		mapObj.put(key, values);
	}

	public static void addToMapsSet(Map<Id, Set<Id>> mapObj, Id key, Id value) {
		Set<Id> values = mapObj.get(key);

		if (values == null) {
			values = new Set<Id>();
		}
		values.add(value);

		mapObj.put(key, values);
	}

	public class AccountShareHelper {
		public void addToMapsList(Map<String, AccountShare[]> mapObj, String key, AccountShare value) {
			AccountShare[] values = mapObj.get(key);

			if (values == null) {
				values = new List<AccountShare>{};
			}
			values.add(value);

			mapObj.put(key, values);
		}
	}

	public class AccessShareHelper {
		public void addToMapsList(Map<String, AccessShare__c[]> mapObj, String key, AccessShare__c value) {
			AccessShare__c[] values = mapObj.get(key);

			if (values == null) {
				values = new List<AccessShare__c>{};
			}
			values.add(value);

			mapObj.put(key, values);
		}
	}
}
