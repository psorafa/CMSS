public class PersonManagementUtility {
	public static UpdatePersonCSOBDataRequest insertPersonCSOBData(String personCSOBDataResponse) {
		String cleanPersonCSOBDataResponse = personCSOBDataResponse.trim();

		Map<String, Object> cObjMap = (Map<String, Object>) JSON.deserializeUntyped(cleanPersonCSOBDataResponse);
		String getPersonCSOBDataResponse = JSON.serialize(cObjMap.get('getPersonCSOBDataResponse')).trim();
		getPersonCSOBDataResponse = prepareDataForDeserialization(getPersonCSOBDataResponse);
		GetPersonCSOBDataResponse deserializedResponse = (GetPersonCSOBDataResponse) JSON.deserialize(
			getPersonCSOBDataResponse,
			GetPersonCSOBDataResponse.class
		);
		if (deserializedResponse == null) {
			return null;
		}
		GetPersonCSOBDataResponse insertedEntities = insertCSOBPersonEntities(deserializedResponse);
		UpdatePersonCSOBDataRequest updateRequest = buildUpdateRequest(insertedEntities);

		return updateRequest;
	}

	@TestVisible
	private static String prepareDataForDeserialization(String data) {
		String finalData = data;

		finalData = removeEmptyDateFields(finalData, 'Account');
		finalData = removeEmptyDateFields(finalData, 'Asset');
		finalData = removeEmptyDateFields(finalData, 'ContactInformation__c');
		return finalData;
	}

	@TestVisible
	private static GetPersonCSOBDataResponse insertCSOBPersonEntities(GetPersonCSOBDataResponse deserializedData) {
		Id accountOwnerId = [SELECT Id FROM User WHERE Name = 'Hidden Records Owner'].Id;
		deserializedData.Account.CSOBSNonClient__c = true;
		deserializedData.Account.OwnerId = accountOwnerId;
		insert deserializedData.Account;

		if (deserializedData?.Asset != null && deserializedData.Asset.size() > 0) {
			for (Asset asset : deserializedData?.Asset) {
				asset.AccountId = deserializedData.Account.Id;
			}
			insert deserializedData?.Asset;
		}
		if (deserializedData?.ContactInformation != null && deserializedData.ContactInformation.size() > 0) {
			for (ContactInformation__c contactInformation : deserializedData?.ContactInformation) {
				contactInformation.Account__c = deserializedData.Account.Id;
			}
			insert deserializedData?.ContactInformation;
		}

		return deserializedData;
	}

	@TestVisible
	private static UpdatePersonCSOBDataRequest buildUpdateRequest(GetPersonCSOBDataResponse createdEntities) {
		UpdatePersonCSOBDataRequest updateRequest = new UpdatePersonCSOBDataRequest();
		updateRequest.Account = new Account(
			ExternalId__c = createdEntities.Account.ExternalId__c,
			Id = createdEntities.Account.Id
		);
		updateRequest.Asset = new List<Asset>();
		updateRequest.ContactInformation = new List<ContactInformation__c>();

		updateRequest.Asset = buildUpdateSObjectList(
			createdEntities.Asset,
			'AccountId',
			createdEntities.Account.Id,
			Asset.sObjectType
		);
		updateRequest.ContactInformation = buildUpdateSObjectList(
			createdEntities.ContactInformation,
			'Account__c',
			createdEntities.Account.Id,
			ContactInformation__c.sObjectType
		);

		return updateRequest;
	}

	@TestVisible
	private static List<SObject> buildUpdateSObjectList(
		List<SObject> createdEntitiesList,
		String accountFieldName,
		Id accountId,
		SObjectType sObjectType
	) {
		List<SObject> updateRequestList = new List<SObject>();

		if (createdEntitiesList != null && createdEntitiesList.size() > 0) {
			for (SObject createdEntity : createdEntitiesList) {
				SObject newObj = sObjectType.newSObject();
				newObj.put('ExternalId__c', createdEntity.get('ExternalId__c'));
				newObj.put('Id', createdEntity.Id);
				newObj.put(accountFieldName, accountId);
				updateRequestList.add(newObj);
			}
		}
		return updateRequestList;
	}

	@TestVisible
	public static String removeEmptyDateFields(String text, String sobjectName) {
		String finalString = text;
		Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe()
			.get(sobjectName)
			.getDescribe()
			.fields.getMap();

		for (Schema.SObjectField field : fields.values()) {
			String emptyFieldLocator = '"' + field.getDescribe().getName() + '":""';
			if (
				(field.getDescribe().getType() == Schema.DisplayType.DATE ||
				field.getDescribe().getType() == Schema.DisplayType.DATETIME) && finalString.contains(emptyFieldLocator)
			) {
				finalString = finalString.replaceAll(emptyFieldLocator, '');
				finalString = finalString.replaceAll(',,', ',');
			}
		}
		while (finalString.contains(',}') || finalString.contains('{,')) {
			finalString = finalString.replace(',}', '}');
			finalString = finalString.replace('{,', '{');
		}
		return finalString;
	}

	public class UpdatePersonCSOBDataRequest {
		public Account Account;
		public List<Asset> Asset;
		public List<ContactInformation__c> ContactInformation;
	}

	public class GetPersonCSOBDataResponse {
		public Account Account;
		public List<Asset> Asset;
		public List<ContactInformation__c> ContactInformation;
	}
}
