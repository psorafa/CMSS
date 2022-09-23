public without sharing class AssetRelatedListController {
	@AuraEnabled
	public static String getDataForDataTable(
		List<String> fieldsToShow,
		String accountId,
		String conditionAssets,
		String conditionRelations
	) {
		List<AssetAccountRelation__c> relations = selectRelations(accountId, conditionRelations);
		Set<Id> relatedAssetsIds = getAssetIds(relations);
		String assetsCondition = prepareAssetsCondition(accountId, conditionAssets, new List<Id>(relatedAssetsIds));
		Map<Id, Asset> assetMap = new Map<Id, Asset>(
			(List<Asset>) GenericRelatedListController.queryData('Asset', fieldsToShow, assetsCondition)
		);

		List<Map<String, Object>> assetObjectsFromRelations = new List<Map<String, Object>>();
		// assets from relations, respecting relations order
		for (AssetAccountRelation__c relation : relations) {
			Asset asset = assetMap.get(relation.Asset__c);
			if (asset == null) {
				continue;
			}
			Map<String, Object> untypedMap = convertToUntypedMap(asset);
			untypedMap.put('Relation', relation);
			assetObjectsFromRelations.add(untypedMap);
			assetMap.remove(relation.Asset__c);
		}

		// remaining assets (these will be at the top of list)
		List<Map<String, Object>> assetObjects = new List<Map<String, Object>>();
		for (Asset asset : assetMap.values()) {
			Map<String, Object> untypedMap = convertToUntypedMap(asset);
			assetObjects.add(untypedMap);
		}
		assetObjects.addAll(assetObjectsFromRelations);
		return JSON.serialize(assetObjects);
	}

	private static List<AssetAccountRelation__c> selectRelations(Id accountId, String condition) {
		String query =
			'SELECT Id, toLabel(RelationType__c), Asset__c FROM AssetAccountRelation__c WHERE Account__c = \'' +
				accountId +
				'\'';
		if (!String.isBlank(condition)) {
			query += ' AND ' + condition;
		}
		query += ' ORDER BY Priority__c';
		return (List<AssetAccountRelation__c>) Database.query(query);
	}

	private static Set<Id> getAssetIds(List<AssetAccountRelation__c> relations) {
		Set<Id> ids = new Set<Id>();
		for (AssetAccountRelation__c relation : relations) {
			ids.add(relation.Asset__c);
		}
		return ids;
	}

	private static String prepareAssetsCondition(Id accountId, String condition, List<Id> assetIds) {
		String result = '(AccountId = \'' + accountId + '\'';
		if (!assetIds.isEmpty()) {
			result += ' OR Id IN (\'';
			result += String.join(assetIds, '\',\'');
			result += '\')';
		}
		result += ')';
		if (!String.isBlank(condition)) {
			result += ' AND ' + condition;
		}
		return result;
	}

	private static Map<String, Object> convertToUntypedMap(SObject record) {
		String serialized = JSON.serialize(record);
		Map<String, Object> untypedMap = (Map<String, Object>) JSON.deserializeUntyped(serialized);
		return untypedMap;
	}
}
