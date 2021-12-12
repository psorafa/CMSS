public without sharing class RelatedListWithSharingController {
	@AuraEnabled(cacheable=true)
	public static String getDataForDataTable(
		String sObjectName,
		List<String> fieldsToShow,
		String condition,
		Id recordId,
		String primaryRelationField,
		String secondaryRelationField
	) {
		if (!fieldsToShow.contains(primaryRelationField)) {
			fieldsToShow.addAll(getAditionalRelatedFields(sObjectName, primaryRelationField));
		}
		if (!fieldsToShow.contains(secondaryRelationField)) {
			fieldsToShow.addAll(getAditionalRelatedFields(sObjectName, secondaryRelationField));
		}
		List<SObject> result = queryData(sObjectName, fieldsToShow, condition);
		return JSON.serialize(result);
	}

	public static List<SObject> queryData(String sObjectName, List<String> fieldsToShow, String condition) {
		Set<String> fields = convertFields(fieldsToShow, sObjectName);
		String soql = prepareSOQL(sObjectName, fields, condition);
		List<SObject> result = Database.query(soql);
		result = Security.stripInaccessible(AccessType.READABLE, result).getRecords();
		return result;
	}

	private static Set<String> convertFields(List<String> fieldsList, String sObjectName) {
		Set<String> fieldsSet = new Set<String>();
		for (String fieldWholeName : fieldsList) {
			fieldWholeName = fieldWholeName.trim();

			String fieldName = fieldWholeName;
			String objName = sObjectName.removeEnd('Id');
			List<String> lookupFieldDivision = fieldName.split('\\.');

			if (lookupFieldDivision.size() > 1) {
				objName = lookupFieldDivision[lookupFieldDivision.size() - 2].removeEnd('Id').replace('__r', '__c');
				if (objName == 'Account__c' || objName == 'Asset__c') {
					objName = objName.replace('__c', '');
				}
				fieldName = lookupFieldDivision[lookupFieldDivision.size() - 1];
			}

			DescribeFieldResult descr = SchemaUtil.describeField(objName, fieldName);
			if (descr.getType() == DisplayType.REFERENCE && fieldWholeName == fieldName) {
				String relationshipName = descr.getRelationshipName();
				fieldsSet.add(relationshipName + '.Id');
				fieldsSet.add(relationshipName + '.' + SchemaUtil.getNameField(descr.getReferenceTo().get(0)));
			} else if (descr.getType() == DisplayType.PICKLIST) {
				fieldsSet.add('toLabel(' + fieldWholeName + ')');
			} else {
				fieldsSet.add(fieldWholeName);
			}
		}
		return fieldsSet;
	}

	private static String prepareSOQL(String objectName, Set<String> fields, String condition) {
		String soql = 'SELECT ' + String.join(new List<String>(fields), ',') + ' FROM ' + objectName;
		if (!String.isBlank(condition)) {
			soql += ' WHERE ' + condition;
		}
		return soql;
	}

	private static List<String> getAditionalRelatedFields(String sObjectName, String relationFieldName) {
		List<String> aditionalFields = new List<String>();
		aditionalFields.add(relationFieldName);
		String accountfield = getAccountFieldName(getFieldTypeName(sObjectName, relationFieldName));

		if (accountfield == 'Id') {
			aditionalFields.add(relationFieldName.replace('__c', '__r').removeEnd('Id') + '.' + accountfield);
		} else {
			aditionalFields.add(relationFieldName.replace('__c', '__r').removeEnd('Id') + '.' + accountfield);
			aditionalFields.add(
				relationFieldName.replace('__c', '__r').removeEnd('Id') +
				'.' +
				accountfield.replace('__c', '__r').removeEnd('Id') +
				'.Name'
			);
		}

		return aditionalFields;
	}

	@AuraEnabled(cacheable=true)
	public static List<ColumnDTO> getFieldsDetailsWithButtons(String objectName, List<String> fieldsToShow) {
		ColumnDTOsBuilder builder = new ColumnDTOsBuilder(objectName, fieldsToShow, true);
		return builder.getColumnDTOs();
	}

	@AuraEnabled
	public static String shareRelatedAccount(Id objectId, Boolean sharingDisabled) {
		String sobjectType = objectId?.getSObjectType().getDescribe().getName();
		if (sharingDisabled) {
			return sobjectType;
		}
		Id accountId = getAccountId(objectId, sobjectType);

		AccessShareDTO newAccessShare = new AccessShareDTO();
		newAccessShare.accountIdToShare = accountId;
		newAccessShare.userToShareWith = UserDao.getUserById(UserInfo.getUserId());
		newAccessShare.expirationDate = Datetime.now().addDays(2);
		newAccessShare.reason = 'RelatedListReference';

		AccessShareService.assignAccess(new Set<AccessShareDTO>{ newAccessShare }, 'Reference');
		return sobjectType;
	}

	private static Id getAccountId(Id objectId, String sObjectType) {
		try {
			if (sobjectType == 'Account') {
				return objectId;
			}

			String soqlString = '';
			String accountField = getAccountFieldName(sObjectType);

			soqlString = 'SELECT ' + accountField + ' FROM ' + sobjectType + ' WHERE Id = \'' + objectId + '\'';
			SObject obj = Database.query(soqlString)[0];
			return (Id) obj.get(accountField);
		} catch (Exception e) {
			throw new UnsupportedTypeException('Account Id could not be resolved from object: ' + objectId + '; ' + e);
		}
	}

	private static String getAccountFieldName(String sObjectTypeName) {
		if (sObjectTypeName == 'Account') {
			return 'Id';
		}
		String accountField;
		try {
			Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
			Schema.SObjectType sobjType = globalDescribe.get(sObjectTypeName);
			Schema.DescribeSObjectResult describeResult = sobjType.getDescribe();
			Set<String> objectFields = describeResult.fields.getMap().keySet();

			if (objectFields.contains('account')) {
				accountField = 'Account';
			} else if (objectFields.contains('account__c')) {
				accountField = 'Account__c';
			} else if (objectFields.contains('accountid')) {
				accountField = 'AccountId';
			}
		} catch (Exception e) {
			throw new UnsupportedTypeException(
				'Account Field Name could not be resolved from object: ' +
				sObjectTypeName +
				'; ' +
				e
			);
		}
		return accountField;
	}

	private static String getFieldTypeName(String sObjectName, String fieldName) {
		Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe()
			.get(sObjectName)
			.getDescribe()
			.fields
			.getMap()
			.get(fieldName)
			.getDescribe();

		return fieldResult.getReferenceTo()[0]?.getDescribe().getName();
	}

	public class UnsupportedTypeException extends Exception {
	}
}
