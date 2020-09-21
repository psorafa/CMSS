public with sharing class GenericRelatedListController {
	@AuraEnabled
	public static String getDataForDataTable(
		String sObjectName,
		List<String> fieldsToShow,
		String condition
	) {
		List<SObject> result = queryData(sObjectName, fieldsToShow, condition);
		System.debug('JSON Result: ' + JSON.serialize(result));
		return JSON.serialize(result);
	}

	@AuraEnabled
	public static List<ColumnDTO> getFieldsDetails(String objectName, List<String> fieldsToShow) {
		ColumnDTOsBuilder builder = new ColumnDTOsBuilder(objectName, fieldsToShow);
		return builder.getColumnDTOs();
	}

	public static List<SObject> queryData(
		String sObjectName,
		List<String> fieldsToShow,
		String condition
	) {
		Set<String> fields = convertFields(fieldsToShow, sObjectName);
		String soql = prepareSOQL(sObjectName, fields, condition);
		List<SObject> result = Database.query(soql);
		result = Security.stripInaccessible(AccessType.READABLE, result).getRecords();
		return result;
	}

	private static Set<String> convertFields(List<String> fieldsList, String sObjectName) {
		Set<String> fieldsSet = new Set<String>();
		for (String fieldName : fieldsList) {
			fieldName = fieldName.trim();
			DescribeFieldResult descr = SchemaUtil.describeField(sObjectName, fieldName);
			if (descr.getType() == DisplayType.REFERENCE) {
				String relationshipName = descr.getRelationshipName();
				fieldsSet.add(relationshipName + '.Id');
				fieldsSet.add(relationshipName + '.' + SchemaUtil.getNameField(descr.getReferenceTo().get(0)));
			} else if (descr.getType() == DisplayType.PICKLIST) {
				fieldsSet.add('toLabel(' + fieldName + ')');
			} else {
				fieldsSet.add(fieldName);
			}
		}
		return fieldsSet;
	}

	private static String prepareSOQL(
		String objectName,
		Set<String> fields,
		String condition
	) {
		String soql =
			'SELECT ' +
				String.join(new List<String>(fields), ',') +
				' FROM ' +
				objectName;
		if (!String.isBlank(condition)) {
			soql += ' WHERE ' + condition;
		}
		System.debug('prepared SOQL: ' + soql);
		return soql;
	}
}
