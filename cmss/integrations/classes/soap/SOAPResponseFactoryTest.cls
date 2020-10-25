@IsTest
private class SOAPResponseFactoryTest {

	@IsTest
	static void constructResponseTest() {
		SOAPCommonTypes.CommonHeader requestHeader = prepareCommonHeader();
		MockResponse response = (MockResponse) SOAPResponseFactory.constructResponse(MockResponse.class, requestHeader);
		System.assert(response.isFault == false);
		System.assertEquals(null, response.fault);
		assertHeader(requestHeader, response.responseHeader);
	}

	@IsTest
	static void constructFaultResponseTest() {
		SOAPCommonTypes.BusinessException ex = new SOAPCommonTypes.BusinessException(9, 'test exception');
		SOAPCommonTypes.CommonHeader requestHeader = prepareCommonHeader();
		MockResponse response = (MockResponse) SOAPResponseFactory.constructFaultResponse(MockResponse.class, requestHeader, ex);
		System.assert(response.isFault);
		System.assertEquals(null, response.responseBody);
		assertHeader(requestHeader, response.responseHeader);
		System.assertEquals(9, response.fault.errorNumber);
		System.assertEquals('test exception', response.fault.message);
	}

	private static void assertHeader(SOAPCommonTypes.CommonHeader requestHeader, SOAPCommonTypes.CommonHeader responseHeader) {
		System.assertEquals(requestHeader.conversationIdValue, responseHeader.conversationIdValue);
		System.assertEquals(requestHeader.conversationIdName, responseHeader.conversationIdName);
		System.assertEquals(requestHeader.userId, responseHeader.userId);
		System.assertEquals('SalesForce', responseHeader.sourceSystem);
		System.assertEquals(requestHeader.sourceSystem, responseHeader.targetSystem);
		System.assertEquals(Url.getSalesforceBaseUrl().toExternalForm(), responseHeader.physicalSource);
		System.assertEquals(requestHeader.messageId + '_resp', responseHeader.messageId);
		System.assertEquals(requestHeader.correlationId, responseHeader.correlationId);
	}

	private static SOAPCommonTypes.CommonHeader prepareCommonHeader() {
		SOAPCommonTypes.CommonHeader h = new SOAPCommonTypes.CommonHeader();
		h.conversationIdValue = 'convIDV';
		h.conversationIdName = 'conv.IDN';
		h.userId = 'XYZUSER';
		h.sourceSystem = 'TEST';
		h.targetSystem = 'SF';
		h.physicalSource = 'muj-pokojicek';
		h.messageId = '123123123';
		h.correlationId = 'corrrela';
		h.timestamp = System.now();
		return h;
	}

	public class MockResponse {
		public SOAPCommonTypes.CommonHeader responseHeader;
		public Boolean isFault = false;
		public SOAPCommonTypes.Fault fault;
		public Object responseBody;
	}
}