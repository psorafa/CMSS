public with sharing class FieldsetService {
	private String fieldsetName;
	private String objectApiName;

	public FieldsetService(String fieldsetName, String objectApiName) {
		this.fieldsetName = fieldsetName;
		this.objectApiName = objectApiName;
	}

	public List<FieldsetInfoDto> getFieldsetInfo() {
		List<FieldsetInfoDto> fieldsetInfo = new List<FieldsetInfoDto>();
		List<FieldSetMember> fieldSetMembers = this.readFieldSet();

		if (!fieldSetMembers.isEmpty()) {
			for (FieldSetMember member : fieldSetMembers) {
				SObjectField field = member.getSObjectField();
				if (field != null) {
					DescribeFieldResult fieldDescribe = field.getDescribe();
					String fieldName = member.getFieldPath();
					DisplayType displayType = fieldDescribe.getType();
					String displayTypeName = displayType.name();
					String fieldLabel = member.getLabel();
					List<SObjectType> sObjectTypes = fieldDescribe.getReferenceTo();

					if (Schema.DisplayType.ID.equals(displayType) || Schema.DisplayType.REFERENCE.equals(displayType)) {
						if (fieldDescribe.isCustom()) {
							fieldName = fieldName.replaceAll('__c', '__r') + '.Name';
						} else if (fieldName == 'ID') {
							fieldName = 'Name';
						} else {
							fieldName = fieldName.replaceAll('Id', '') + '.Name';
						}
						if (!sObjectTypes.isEmpty()) {
							fieldLabel = fieldLabel.replaceAll(' ID', '');
						}
					}

					FieldsetInfoDto fieldInfo = new FieldsetInfoDto(
						fieldName,
						fieldLabel,
						displayTypeName,
						!fieldDescribe.isEncrypted()
					);
					fieldsetInfo.add(fieldInfo);
				}
			}
		}
		return fieldsetInfo;
	}

	public Set<String> getFieldsetInfoToSoql() {
		Set<String> fieldsetInfo = new Set<String>();
		List<FieldSetMember> fieldSetMembers = this.readFieldSet();
		if (!fieldSetMembers.isEmpty()) {
			for (FieldSetMember member : fieldSetMembers) {
				SObjectField field = member.getSObjectField();
				if (field != null) {
					DescribeFieldResult fieldDescribe = field.getDescribe();
					String fieldName = member.getFieldPath();
					DisplayType displayType = fieldDescribe.getType();
					if (fieldName.contains('Date')) {
						fieldName = 'FORMAT(' + fieldName + ')';
					}
					if (
						Schema.DisplayType.PICKLIST.equals(displayType) ||
						Schema.DisplayType.MULTIPICKLIST.equals(displayType)
					) {
						fieldName = 'toLabel(' + fieldName + ')';
					}

					if (Schema.DisplayType.ID.equals(displayType) || Schema.DisplayType.REFERENCE.equals(displayType)) {
						if (fieldDescribe.isCustom()) {
							fieldName = fieldName.replaceAll('__c', '__r') + '.Name';
						} else if (fieldName == 'ID') {
							fieldName = 'Name';
						} else {
							fieldName = fieldName.replaceAll('Id', '') + '.Name';
						}
					}
					fieldsetInfo.add(fieldName);
				}
			}
		}
		return fieldsetInfo;
	}

	private List<Schema.FieldSetMember> readFieldSet() {
		Schema.DescribeSObjectResult describeSObjectResult = Schema.getGlobalDescribe()
			.get(this.objectApiName)
			.getDescribe();

		Schema.FieldSet fieldSetObj = describeSObjectResult.fieldSets.getMap().get(this.fieldsetName);
		if (fieldSetObj != null) {
			return fieldSetObj.getFields();
		}
		return new List<Schema.FieldSetMember>();
	}
}
