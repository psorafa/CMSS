@IsTest 
public class DocumentsListControllerTest {
    @TestSetup
	static void initializeTestData() {
		
        ContentVersion docv1 = TestDataFactory.getContentVersion(new ContentVersion(Type__c = 'Training'));
        insert docv1;
        ContentVersion docv2 = TestDataFactory.getContentVersion(new ContentVersion(Type__c = 'Training'));
        insert docv2;
        ContentVersion docv3 = TestDataFactory.getContentVersion(new ContentVersion(Type__c = 'Guides'));
        insert docv3;

        List<ContentDocument> docs = [SELECT Id FROM ContentDocument];

        Topic top = TestDataFactory.getTopic();
        insert top;
        TopicAssignment topicAssignment1 = TestDataFactory.getTopicAssignment(new TopicAssignment(EntityId = docs[0].Id, TopicId = top.Id));
        insert topicAssignment1;
        TopicAssignment topicAssignment2 = TestDataFactory.getTopicAssignment(new TopicAssignment(EntityId = docs[1].Id, TopicId = top.Id));
        insert topicAssignment2;  
        TopicAssignment topicAssignment3 = TestDataFactory.getTopicAssignment(new TopicAssignment(EntityId = docs[2].Id, TopicId = top.Id));
        insert topicAssignment3;
        
	}

   	@IsTest
    public static void testGetDocumentPositive() {
        Topic top = [SELECT ID FROM Topic LIMIT 1];

        List<ContentVersion> result = null;

        Test.startTest();
            result = DocumentsListController.getDocuments(top.Id, 'Training');                 
        Test.stopTest();

        System.assert(result != null, 'Should not return null.');
        System.assertEquals(2, result.size(), 'Should return two documents');
    }  
    
   	@IsTest
    public static void testGetDocumentNegative() {
        Topic top = [SELECT ID FROM Topic LIMIT 1];

        List<ContentVersion> result = null;

        Test.startTest();
            result = DocumentsListController.getDocuments(top.Id, 'Test');                 
        Test.stopTest();

        System.assert(result != null, 'Should not return null.');
        System.assertEquals(0, result.size(), 'Should return zero documents');
    }
    
   	@IsTest
    public static void testGetDocumentLabels() {

        Map<String, String> labelsMap = DocumentsListController.getLabels();

        System.assert(labelsMap != null, 'Should not return null.');
        System.assertNotEquals(0, labelsMap.size());
        System.assert(labelsMap.containsKey('validfrom__c'));
    }      

}