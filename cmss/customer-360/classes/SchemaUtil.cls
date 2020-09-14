/**
 * Utility class to handle common schema-related actions
 */
public with sharing class SchemaUtil {

	public static DescribeFieldResult describeField(String sObjectName, String fieldName) {
		Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(sObjectName);
		if (sObjectType == null) {
			throw new SchemaUtilException('Unknown object: ' + sObjectName + ', please make sure that name of the object is correct. Object name is case-sensitive.');
		}
		Schema.SObjectField sObjectField = sObjectType.getDescribe().fields.getMap().get(fieldName);
		if (sObjectField == null) {
			throw new SchemaUtilException('Unknown field: ' + sObjectName + '.' + fieldName + ', please make sure that name of the field is correct. Field name is case-sensitive.');
		}
		return sObjectField.getDescribe();
	}

	public static String getNameField(SObjectType objectType) {
		// this "hardcode" implementation is ok for now, may be upgraded to dynamic later
		if (objectType == Case.SObjectType) {
			return 'CaseNumber';
		}
		if (objectType == Task.SObjectType || objectType == Event.SObjectType) {
			return 'Subject';
		}
		if (objectType == Contract.SObjectType) {
			return 'ContractNumber';
		}
		return 'Name';
	}

	public class SchemaUtilException extends Exception {
	}

}