@IsTest
private class ContentDocumentLinkTriggerHandlerTest {

	@IsTest
	static void testSetExternalVisibility() {
        List<ContentDocumentLink> links = new List<ContentDocumentLink>();
        links.add(new ContentDocumentLink(
            Visibility = 'InternalUsers'
        ));

        Test.startTest();
        ContentDocumentLinkTriggerHandler.setExternalVisibility(links);
        Test.stopTest();

        for (ContentDocumentLink link : links) {
            System.assertEquals('AllUsers', link.Visibility);
        }
	}
}