public with sharing class AssetAccountRelationTriggerHandler extends TriggerHandler {
	public static void createAssetAccountRelationProductType(List<AssetAccountRelation__c> assetAccountRelationList) {
		Set<Id> assetIdSet = new Set<Id>();
		for (AssetAccountRelation__c relation : assetAccountRelationList) {
			assetIdSet.add(relation.Asset__c);
		}
		Map<Id, String> assetIdProductMap = new Map<Id, String>();

		for (Asset assetItem : [SELECT Id, ProductType__c FROM Asset WHERE Id IN :assetIdSet]) {
			assetIdProductMap.put(assetItem.Id, assetItem.ProductType__c);
		}
		for (AssetAccountRelation__c relationProductItem : assetAccountRelationList) {
			relationProductItem.AssetsProductType__c = assetIdProductMap.get(relationProductItem.Asset__c);
		}
	}
}
