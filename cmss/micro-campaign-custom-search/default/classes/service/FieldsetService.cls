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
					FieldsetInfoDto fieldInfo = new FieldsetInfoDto(fieldDescribe.getName(), fieldDescribe.getLabel());
					fieldsetInfo.add(fieldInfo);
				}
			}
		}
		return fieldsetInfo;
	}

	public List<String> getFieldsetInfoToSoql() {
		List<String> fieldsetInfo = new List<String>();
		List<FieldSetMember> fieldSetMembers = this.readFieldSet();
		if (!fieldSetMembers.isEmpty()) {
			for (FieldSetMember member : fieldSetMembers) {
				SObjectField field = member.getSObjectField();
				if (field != null) {
					DescribeFieldResult fieldDescribe = field.getDescribe();
					fieldsetInfo.add(fieldDescribe.getName());
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
