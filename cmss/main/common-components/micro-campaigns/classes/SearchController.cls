public without sharing class SearchController {
	@AuraEnabled
	public static List<SObject> search(String objectName, List<String> fields, String searchTerm) {
		return search(objectName, fields, searchTerm, null);
	}

	@AuraEnabled
	public static List<SObject> search(
		String objectName,
		List<String> fields,
		String searchTerm,
		String searchCondition
	) {
		String searchKeyword = searchTerm + '*';
		String returningQuery = '';
		String condition = String.isEmpty(searchCondition) ? '' : ' WHERE ' + searchCondition;
		returningQuery = objectName + ' ( Id, ' + String.join(fields, ',') + condition + ')';
		String query = 'FIND :searchKeyword IN ALL FIELDS RETURNING ' + returningQuery + ' LIMIT 20';
		System.debug('Query ' + query);
		List<List<SObject>> searchRecords = Search.query(query);
		return searchRecords.get(0);
	}

	@AuraEnabled
	public static Campaign getCampaign(Id campaignId, String fields) {
		return Database.query('SELECT ' + fields + ' FROM Campaign WHERE Id = :campaignId');
	}
}
