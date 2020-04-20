/**
 * Created by a.olexova on 3/24/2020.
 * @description class to store methods related to Record Types frequently used by different classes
 */

public with sharing class RecordTypeUtils {
	/**
	 * @author aolexova
	 * @description returns the id of the record type based on it developer name and sobject type
	 * */
	public static String getRecordTypeIdByDeveloperName(String developerName, String sObjectName) {
		if (String.isBlank(developerName) || String.isBlank(sObjectName)) {
			return null;
		}

		String recordTypeId;
		RecordTypeInfo rti = getRecordTypeInfoByDeveloperName(developerName, sObjectName);

		if (rti != null && String.isNotBlank(rti.getRecordTypeId())) {
			recordTypeId = rti.getRecordTypeId();
		}

		return recordTypeId;
	}

	/**
	 * @author aolexova
	 * @description returns the information about record type for the sObject and developer name specified in params
	 * @param developerName - developer name of the record type about which we want the information
	 * @param sObjectName - name of the object for witch we want the information about the record type
	 */
	public static RecordTypeInfo getRecordTypeInfoByDeveloperName(String developerName, String sObjectName) {
		if (String.isBlank(developerName) || String.isBlank(sObjectName)) {
			return null;
		}

		Map<String, Schema.RecordTypeInfo> rtMap = getRecordTypeInfoMapByDeveloperName(sObjectName);
		RecordTypeInfo rti;

		if (rtMap != null && rtMap.containsKey(developerName)) {
			rti = rtMap.get(developerName);
		}

		return rti;
	}

	/**
	 * @author aolexova
	 * @description returns map of all record type infos for the specified sObject, keys are developer names of the record types
	 * @param sObjectName - name of the object for which we want the map of the record types infos
	 */
	public static Map<String, Schema.RecordTypeInfo> getRecordTypeInfoMapByDeveloperName(String sObjectName) {
		if (String.isBlank(sObjectName)) {
			return null;
		}
		Schema.SObjectType sObjType = Schema.getGlobalDescribe().get(sObjectName);
		return sObjType.getDescribe().getRecordTypeInfosByDeveloperName();
	}
}
