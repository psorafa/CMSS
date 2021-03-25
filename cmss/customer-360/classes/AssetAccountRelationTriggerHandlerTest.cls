@IsTest
public class AssetAccountRelationTriggerHandlerTest {
	@IsTest
	static void createAssetAccountRelationProductTypeTest() {
		AssetAccountRelation__c relation = TestDataFactory.getAssetAccountRelation(new AssetAccountRelation__c());

		Test.startTest();
		insert relation;
		Test.stopTest();

		AssetAccountRelation__c assetAccountRelation = [
			SELECT AssetsProductType__c, Asset__c
			FROM AssetAccountRelation__c
		];

		Asset asset = [SELECT ProductType__c FROM Asset];

		System.assertEquals(asset.ProductType__c, assetAccountRelation.AssetsProductType__c);
	}
}
