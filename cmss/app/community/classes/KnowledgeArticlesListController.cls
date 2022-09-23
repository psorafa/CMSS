public with sharing class KnowledgeArticlesListController {
	public KnowledgeArticlesListController() {
	}

	@AuraEnabled(cacheable=true)
	public static List<Knowledge__kav> getKnowledgeArticles(
		String topicId,
		String recordTypeName,
		String arcticlesType
	) {
		List<Knowledge__kav> knowledgeArticlesList = new List<Knowledge__kav>();

		if (topicId != '' && topicId != null) {
			List<TopicAssignment> topAss = [SELECT EntityId FROM TopicAssignment WHERE TopicId = :topicId LIMIT 1000];
			String knowledgeQuery =
				'SELECT Id, Title, CMSSArticleNumber__c, ValidTo__c, Type__c, AdditionalQuestionsAnswers__c, CurrentlyValid__c, LastPublishedDate, RecordType.Name FROM Knowledge__kav ' +
					'WHERE PublishStatus = \'Online\' AND Id in (';

			for (TopicAssignment ta : topAss) {
				knowledgeQuery += ' \'' + ta.EntityId + '\',';
			}

			knowledgeQuery = knowledgeQuery.removeEnd(',');

			knowledgeQuery += ') AND RecordType.Name = ' + '\'' + recordTypeName + '\' ';

			if (arcticlesType == 'Actual') {
				knowledgeQuery += ' AND CurrentlyValid__c = true';
			}
			if (arcticlesType == 'Historical') {
				knowledgeQuery += ' AND CurrentlyValid__c = false';
			}

			knowledgeQuery += ' ORDER BY LastPublishedDate';

			System.debug('KnowledgeArticlesListController::knowledgeQuery::' + knowledgeQuery);
			knowledgeArticlesList = Database.query(knowledgeQuery);
		}
		return knowledgeArticlesList;
	}

	@AuraEnabled(cacheable=true)
	public static Map<String, String> getKnowledgeLabels() {
		Map<String, String> labelsMap = new Map<String, String>();

		String type = 'Knowledge__kav';

		Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
		Schema.SObjectType leadSchema = schemaMap.get(type);
		Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();

		for (String fieldName : fieldMap.keySet()) {
			labelsMap.put(fieldName, fieldMap.get(fieldName).getDescribe().getLabel());
		}

		return labelsMap;
	}
}