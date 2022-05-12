public with sharing class KnowledgeArticlesListController {
    public KnowledgeArticlesListController() {

    }

    @AuraEnabled(cacheable=true)
    public static List<Knowledge__kav> getKnowledgeArticles(String topicId, String recordTypeName, String articlesType) {
        List<Knowledge__kav> knowledgeArticlesList = new List<Knowledge__kav>();

        if (topicId != '' && topicId != null) {
            String knowledgeQuery = 'SELECT Id, Title, CMSSArticleNumber__c, ValidFrom__c, ValidTo__c, Priority__c, Author__c, CurrentlyValid__c, LastPublishedDate, RecordType.Name FROM Knowledge__kav '
                                    + 'WHERE PublishStatus = \'Online\' AND Id in (SELECT EntityId FROM TopicAssignment WHERE TopicId = \'' + topicId + '\')'
                                    + ' AND RecordType.Name = ' + '\'' + recordTypeName + '\' ';

            if (articlesType == 'Actual') {
                knowledgeQuery = knowledgeQuery + ' AND CurrentlyValid__c = true';
            }
            if (articlesType == 'Historical') {
                knowledgeQuery = knowledgeQuery + ' AND CurrentlyValid__c = false';
            }
            
            System.debug('KnowledgeArticlesListController::knowledgeQuery::' + knowledgeQuery);
            knowledgeArticlesList = Database.query(knowledgeQuery);
        }
        return knowledgeArticlesList;
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getKnowledgeLabels() {
        Map<String, String> labelsMap = new Map<String, String>();

        String type='Knowledge__kav';

        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();

        for (String fieldName: fieldMap.keySet()) {
            labelsMap.put(fieldName, fieldMap.get(fieldName).getDescribe().getLabel());
        }

        return labelsMap;
    }    
}
