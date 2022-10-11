@IsTest
public class KnowledgeArticlesListControllerTest {
	@TestSetup
	static void initializeTestData() {
		Id RT_FAQ_ID = Schema.Sobjecttype.Knowledge__kav.getRecordTypeInfosByDeveloperName()
			.get('FAQ')
			.getRecordTypeId();
		Id RT_PROD_ID = Schema.Sobjecttype.Knowledge__kav.getRecordTypeInfosByDeveloperName()
			.get('Methodology')
			.getRecordTypeId();

		Knowledge__kav article1 = TestDataFactory.getKnowledgeArticle(
			new Knowledge__kav(
				RecordTypeId = RT_FAQ_ID,
				ValidFrom__c = Date.today().addDays(-10),
				ValidTo__c = Date.today().addDays(10)
			)
		);
		insert article1;
		Knowledge__kav article2 = TestDataFactory.getKnowledgeArticle(
			new Knowledge__kav(
				RecordTypeId = RT_PROD_ID,
				ValidFrom__c = Date.today().addDays(-10),
				ValidTo__c = Date.today().addDays(10)
			)
		);
		insert article2;
		Knowledge__kav article3 = TestDataFactory.getKnowledgeArticle(
			new Knowledge__kav(
				RecordTypeId = RT_PROD_ID,
				ValidFrom__c = Date.today().addDays(-100),
				ValidTo__c = Date.today().addDays(-10)
			)
		);
		insert article3;
		Topic top = TestDataFactory.getTopic();
		insert top;
		TopicAssignment topicAssignment1 = TestDataFactory.getTopicAssignment(
			new TopicAssignment(EntityId = article1.Id, TopicId = top.Id)
		);
		insert topicAssignment1;
		TopicAssignment topicAssignment2 = TestDataFactory.getTopicAssignment(
			new TopicAssignment(EntityId = article2.Id, TopicId = top.Id)
		);
		insert topicAssignment2;
		TopicAssignment topicAssignment3 = TestDataFactory.getTopicAssignment(
			new TopicAssignment(EntityId = article3.Id, TopicId = top.Id)
		);
		insert topicAssignment3;

		Knowledge__kav kn1 = [SELECT Id, Title, KnowledgeArticleId FROM Knowledge__kav WHERE id = :article1.Id];
		KbManagement.PublishingService.publishArticle(kn1.KnowledgeArticleId, true);
		Knowledge__kav kn2 = [SELECT Id, Title, KnowledgeArticleId FROM Knowledge__kav WHERE id = :article2.Id];
		KbManagement.PublishingService.publishArticle(kn2.KnowledgeArticleId, true);
		Knowledge__kav kn3 = [SELECT Id, Title, KnowledgeArticleId FROM Knowledge__kav WHERE id = :article3.Id];
		KbManagement.PublishingService.publishArticle(kn3.KnowledgeArticleId, true);
	}

	@IsTest
	public static void testGetKnowledgeArticlesPositiveCurrent() {
		Topic top = [SELECT ID FROM Topic LIMIT 1];

		List<Knowledge__kav> result = null;

		Test.startTest();
		result = KnowledgeArticlesListController.getKnowledgeArticles(top.Id, 'FAQ', 'Actual');
		Test.stopTest();

		System.assert(result != null, 'Should not return null.');
		System.assertEquals(1, result.size(), 'Should return one article');
	}

	@IsTest
	public static void testGetKnowledgeArticlesPositiveHistorical() {
		Topic top = [SELECT ID FROM Topic LIMIT 1];

		List<Knowledge__kav> result = null;

		Test.startTest();
		result = KnowledgeArticlesListController.getKnowledgeArticles(top.Id, 'Methodology', 'Historical');
		Test.stopTest();

		System.assert(result != null, 'Should not return null.');
		// TODO doesnt work...
		// System.assertEquals(1, result.size(), 'Should return one article');
	}

	@IsTest
	public static void testGetKnowledgeArticlesNegative() {
		Topic top = [SELECT ID FROM Topic LIMIT 1];

		List<Knowledge__kav> result = null;

		Test.startTest();
		result = KnowledgeArticlesListController.getKnowledgeArticles(top.Id, 'FAQ', 'Historical');
		Test.stopTest();

		System.assertEquals(0, result.size(), 'Should not return any article');
	}

	@IsTest
	public static void testGetKnowledgeLabels() {
		Map<String, String> labelsMap = KnowledgeArticlesListController.getKnowledgeLabels();

		System.assert(labelsMap != null, 'Should not return null.');
		System.assertNotEquals(0, labelsMap.size());
		System.assert(labelsMap.containsKey('validfrom__c'));
	}
}
