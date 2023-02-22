@IsTest
private class ESBServiceTest {
	@TestSetup
	static void makeData() {
		insert TestDataFactory.getIntegrationSettings();
	}

	@IsTest
	static void testPopulateDoc() {
		// Test that the populateDoc method returns the correct XML document
		ESBService esb = new ESBService();
		Map<String, String> namespaces = new Map<String, String>{ 'v01' => esb.V01_NS };
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode body = esb.populateDoc(doc, namespaces);
		//Assert that the document contains the expected elements and namespaces
		System.assertEquals('Envelope', body.getParent().getName());
		System.assertEquals(esb.ENVELOPE_NS, body.getParent().getNamespace());
		System.assertEquals('Body', body.getName());
		System.assertEquals(esb.ENVELOPE_NS, body.getNamespace());
		System.assertEquals(esb.V01_NS, body.getNamespaceFor('v01'));
	}
}
