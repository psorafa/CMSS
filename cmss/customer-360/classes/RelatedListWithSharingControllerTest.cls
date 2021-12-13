@IsTest
public class RelatedListWithSharingControllerTest {
	private static Asset asset1;
	private static Asset asset2;
	private static Account acc;

	@TestSetup
	static void makeData() {
		acc = new Account();
		acc.name = 'testAccount';
		insert acc;

		asset1 = new Asset();
		asset1.name = 'testAsset 1';
		asset1.AccountId = acc.Id;

		asset2 = new Asset();
		asset2.name = 'testAsset 2';
		asset2.AccountId = acc.Id;
		insert new List<Asset>{ asset1, asset2 };

		AssetRelationship relationship = new AssetRelationship();
		relationship.AssetId = asset1.Id;
		relationship.RelatedAssetId = asset2.Id;
		relationship.FromDate = System.today().addDays(-5);
		relationship.ToDate = System.today().addDays(5);
		insert relationship;
	}

	@IsTest
	public static void testGetDataForDataTable() {
		Asset testAsset = [SELECT Id FROM Asset WHERE Name = 'testAsset 1'][0];
		List<string> listOfFields = new List<string>{
			'RelatedAssetId',
			'ProductTypeAssetId__c',
			'RelationshipType',
			'RelatedAsset.Account.Name',
			'FromDate',
			'ToDate'
		};
		String myData = RelatedListWithSharingController.getDataForDataTable(
			'AssetRelationship',
			listOfFields,
			'',
			testAsset.Id,
			'AssetId',
			'RelatedAssetId'
		);

		List<AssetRelationship> expectedData = [
			SELECT
				ProductTypeAssetId__c,
				AssetId,
				RelatedAssetId,
				RelationshipType,
				RelatedAsset.Account.Name,
				FromDate,
				ToDate
			FROM AssetRelationship
			WHERE AssetId = :testAsset.Id
		];

		List<SObject> deserializedObjs = (List<SObject>) JSON.deserialize(myData, List<SObject>.class);

		System.assertEquals(expectedData.size(), deserializedObjs.size());
		System.assertEquals(1, deserializedObjs.size());
	}

	@isTest
	public static void testGetFieldsDetails() {
		List<String> listOfFields = new List<String>{ 'Id', 'Email__c', 'Street__c' };
		List<ColumnDTO> myData = RelatedListWithSharingController.getFieldsDetailsWithButtons(
			'ContactInformation__c',
			listOfFields
		);
	}

	@isTest
	public static void testshareRelatedAccount() {
		Id profileId = [SELECT Id, Name FROM Profile WHERE Name = 'CMSS User'].Id;
		Asset AssetToShare = [SELECT Id, Name FROM Asset WHERE Name = 'testAsset 1'][0];

		User testUser = TestDataFactory.getUser(new User(ProfileId = profileId));
		insert testUser;

		List<AccountShare> sharesBefore = [SELECT Id FROM AccountShare];
		Test.startTest();
		System.runAs(testUser) {
			RelatedListWithSharingController.shareRelatedAccount(AssetToShare.Id, false);
		}
		Test.stopTest();
		List<AccountShare> sharesAfter = [SELECT Id FROM AccountShare];

		System.assertEquals(sharesBefore.size() + 1, sharesAfter.size());
	}
}
