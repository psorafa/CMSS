@IsTest
public class RelatedAssetsRelatedListControllerTest {
	@TestSetup
	static void makeData() {
		Asset asset1 = TestDataFactory.getAsset(new Asset(Name = 'Primary test asset'));
		Asset asset2 = TestDataFactory.getAsset(new Asset());
		Asset asset3 = TestDataFactory.getAsset(new Asset());
		insert new List<Asset>{ asset1, asset2, asset3 };

		List<AssetRelationship> assetRelations = new List<AssetRelationship>();
		AssetRelationship relation1 = new AssetRelationship(AssetId = asset1.Id, RelatedAssetId = asset2.Id);
		AssetRelationship relation2 = new AssetRelationship(AssetId = asset3.Id, RelatedAssetId = asset1.Id);
		insert new List<AssetRelationship>{ relation1, relation2 };
	}

	@IsTest
	public static void testGetDataForDataTable() {
		Asset primaryAsset = [SELECT Id FROM Asset WHERE Name = 'Primary test asset' LIMIT 1];

		List<AssetRelationship> resultRelations = (List<AssetRelationship>) JSON.deserialize(
			RelatedAssetsRelatedListController.getDataForDataTable(primaryAsset.Id),
			List<AssetRelationship>.class
		);

		System.assertEquals(resultRelations.size(), 2);
		System.assertNotEquals(resultRelations[0].AssetId, resultRelations[0].RelatedAssetId);
		System.assertNotEquals(resultRelations[1].AssetId, resultRelations[1].RelatedAssetId);
		System.assert(
			resultRelations[0].AssetId == primaryAsset.Id ||
			resultRelations[0].RelatedAssetId == primaryAsset.Id
		);
		System.assert(
			resultRelations[1].AssetId == primaryAsset.Id ||
			resultRelations[1].RelatedAssetId == primaryAsset.Id
		);
	}
}
