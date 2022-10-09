@isTest
private class AccessSharingUtilsTest {
	@isTest
	static void getRelatedAccessShareDTOsTest() {
		Account client1 = TestDataFactory.getPersonAccount(
			new Account(
				FirstName = 'Gerard',
				LastName = 'Hověz',
				RecordTypeId = RecordTypeUtils.getRecordTypeIdByDeveloperName('PersonAccount', 'Account'),
				AccountStatus__c = '1'
			)
		);
		Account client2 = TestDataFactory.getPersonAccount(
			new Account(
				FirstName = 'Marcela',
				LastName = 'Obdržálková',
				RecordTypeId = RecordTypeUtils.getRecordTypeIdByDeveloperName('PersonAccount', 'Account'),
				AccountStatus__c = '1'
			)
		);
		insert new List<Account>{client1, client2};

		Asset asset = TestDataFactory.getAsset(
			new Asset(AccountId = client1.Id, EndDate__c = System.today().addDays(20))
		);
		insert asset;

		AssetAccountRelation__c relation = TestDataFactory.getAssetAccountRelation(
			new AssetAccountRelation__c(Account__c = client2.Id, Asset__c = asset.Id, RelationType__c = '2')
		);
		insert relation;
		User actualUser = [SELECT Id FROM USER WHERE Id = :UserInfo.getUserId()];
		AccessShareDTO originalDTO = new AccessShareDTO();
		originalDTO.userToShareWith = actualUser;
		originalDTO.reason = 'CustomerSearch';
		originalDTO.expirationDate = System.today().addDays(2);
		originalDTO.accountIdToShare = client2.Id;

		Set<AccessShareDTO> resultDTOs = AccessSharingUtils.getRelatedAccessShareDTOs(
			new Set<AccessShareDTO>{originalDTO}
		);

		List<AccessShareDTO> resultInList = new List<AccessShareDTO>(resultDTOs);

		System.assertEquals(1, resultDTOs.size());
		System.assertEquals(actualUser, resultInList[0].userToShareWith);
		System.assertEquals('CustomerSearch', resultInList[0].reason);
		System.assertEquals(client1.Id, resultInList[0].accountIdToShare);
	}
}
