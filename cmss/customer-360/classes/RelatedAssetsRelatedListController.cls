public without sharing class RelatedAssetsRelatedListController {
	@AuraEnabled(cacheable=true)
	public static String getDataForDataTable(String assetId) {
		List<AssetRelationship> result = [
			SELECT
				AssetId,
				RelatedAssetId,
				Asset.Name,
				RelatedAsset.Name,
				toLabel(ProductTypeAssetId__c),
				toLabel(RelationshipType),
				Asset.Account.Name,
				RelatedAsset.Account.Name,
				FromDate,
				ToDate
			FROM AssetRelationship
			WHERE RelatedAssetId = :assetId OR AssetId = :assetId
		];
		return JSON.serialize(result);
	}
}
