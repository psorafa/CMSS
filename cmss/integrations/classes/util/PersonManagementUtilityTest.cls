@IsTest
private class PersonManagementUtilityTest {
	@IsTest
	static void buildUpdateSObjectListTest() {
		Account parentAccount = TestDataFactory.getAccount();
		insert parentAccount;

		List<Asset> assets = new List<Asset>{
			TestDataFactory.getAsset(
				new Asset(
					ExternalId__c = '123456789',
					AccountId = parentAccount.Id,
					Name = 'Asset 1',
					ProductType__c = '1'
				)
			),
			TestDataFactory.getAsset(
				new Asset(
					ExternalId__c = '234567891',
					AccountId = parentAccount.Id,
					Name = 'Asset 2',
					ProductType__c = '2'
				)
			),
			TestDataFactory.getAsset(
				new Asset(
					ExternalId__c = '345678912',
					AccountId = parentAccount.Id,
					Name = 'Asset 3',
					ProductType__c = '7'
				)
			)
		};
		insert assets;

		List<Asset> resultAssetsUpdateResponse = PersonManagementUtility.buildUpdateSObjectList(
			assets,
			'AccountId',
			parentAccount.Id,
			Asset.sObjectType
		);

		System.assertEquals(3, resultAssetsUpdateResponse.size());
		System.assertNotEquals(assets, resultAssetsUpdateResponse);

		Map<Id, Asset> resultAssetsMap = new Map<Id, Asset>(resultAssetsUpdateResponse);
		System.assertEquals(assets[0].ExternalId__c, resultAssetsMap.get(assets[0].Id).ExternalId__c);
		System.assertEquals(assets[0].AccountId, resultAssetsMap.get(assets[0].Id).AccountId);
		System.assertEquals(null, resultAssetsMap.get(assets[0].Id).Name);
	}

	@IsTest
	static void removeEmptyDateFieldsTest() {
		String json =
			'[{"Name":"Account 1","Birthdate__c":"1960-04-21","DateOfDeletion__c":"",' +
			'"Assets":[{"Name":"Asset1","DueDate__c":"","ValidTo__c":""}]},' +
			'{"Name":"Account 2","Birthdate__c":""}]';

		String expectedResultForAsset =
			'[{"Name":"Account 1","Birthdate__c":"1960-04-21","DateOfDeletion__c":"",' +
			'"Assets":[{"Name":"Asset1"}]},' +
			'{"Name":"Account 2","Birthdate__c":""}]';
		String expectedResultForAccount =
			'[{"Name":"Account 1","Birthdate__c":"1960-04-21",' +
			'"Assets":[{"Name":"Asset1","DueDate__c":"","ValidTo__c":""}]},' +
			'{"Name":"Account 2"}]';

		String resultForAssetFields = PersonManagementUtility.removeEmptyDateFields(json, 'Asset');
		String resultForAccountFields = PersonManagementUtility.removeEmptyDateFields(json, 'Account');

		System.assertEquals(expectedResultForAsset, resultForAssetFields);
		System.assertEquals(expectedResultForAccount, resultForAccountFields);
	}

	@IsTest
	static void insertPersonCSOBDataTest() {
		String serializedInput =
			'{"getPersonCSOBDataResponse":{' +
			'"Account":{"Name":"Account 1","Birthdate__c":"1960-04-21","DateOfDeletion__c":"","ExternalId__c":"987654"},' +
			'"Asset":[{"Name":"Asset1","DueDate__c":"","ValidTo__c":"","ExternalId__c":"234567"},{"Name":"Asset2","ExternalId__c":"123456"}],' +
			'"ContactInformation":[{"Name":"Contact Information 1","ExternalId__c":"3456789"}]' +
			'}}';

		PersonManagementUtility.UpdatePersonCSOBDataRequest resultUpdateRequest;
		Test.startTest();
		resultUpdateRequest = PersonManagementUtility.insertPersonCSOBData(serializedInput);
		Test.stopTest();
		Account createdAccount = [SELECT Id, Name, ExternalId__c FROM Account WHERE Name = 'Account 1'][0];

		System.assertEquals(null, resultUpdateRequest.Account.Name);
		System.assertEquals(createdAccount.ExternalId__c, resultUpdateRequest.Account.ExternalId__c);
		System.assertEquals(createdAccount.Id, resultUpdateRequest.Account.Id);
		System.assertEquals(2, resultUpdateRequest.Asset.size());
		System.assertEquals(createdAccount.Id, resultUpdateRequest.Asset[0].AccountId);
		System.assertNotEquals(null, resultUpdateRequest.Asset[0].Id);
		System.assertEquals(1, resultUpdateRequest.ContactInformation.size());
		System.assertEquals(createdAccount.Id, resultUpdateRequest.ContactInformation[0].Account__c);
		System.assertEquals('3456789', resultUpdateRequest.ContactInformation[0].ExternalId__c);
	}
}
