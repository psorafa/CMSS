public with sharing class DocumentsListController {

    @AuraEnabled(cacheable=true)
    public static List<ContentVersion> getDocuments(String topicId, String documentType) {
        List<ContentVersion> documentsList = new List<ContentVersion>();

        if (topicId != '' && topicId != null) {
            String queryString = 'SELECT Id, Title, ValidFrom__c, ValidTo__c, Author__c, CurrentlyValid__c, LastModifiedDate, FileType, ContentSize, Type__c, ContentDocumentId FROM ContentVersion '
                                    + 'WHERE ContentDocumentId in (SELECT EntityId FROM TopicAssignment WHERE TopicId = \'' + topicId + '\')'
                                    + ' AND Type__c = ' + '\'' + documentType + '\''
                                    + ' AND IsLatest = true ORDER BY LastModifiedDate';
            System.debug('DocumentsListController::queryString::' + queryString);
            documentsList = Database.query(queryString);
        }
        return documentsList;
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getLabels() {
        Map<String, String> labelsMap = new Map<String, String>();

        String type='ContentVersion';

        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();

        for (String fieldName: fieldMap.keySet()) {
            labelsMap.put(fieldName, fieldMap.get(fieldName).getDescribe().getLabel());
        }

        return labelsMap;
    }    
}