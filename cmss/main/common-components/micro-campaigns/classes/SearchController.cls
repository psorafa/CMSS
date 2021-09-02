public with sharing class SearchController {

	@AuraEnabled
	public static List<SObject> search(String objectName, List<String> fields, String searchTerm){
		String searchKeyword = searchTerm + '*';
		String returningQuery = '';
		returningQuery = objectName+' ( Id, '+String.join(fields,',')+')';
		String query = 'FIND :searchKeyword IN ALL FIELDS RETURNING '+returningQuery+' LIMIT 20';
		System.debug('Query '+query);
		List<List<SObject>> searchRecords = Search.query(query);
		return searchRecords.get(0);
	}
}