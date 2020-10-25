public with sharing class SOAPResponseFactory {

	public static Object constructResponse(Type responseType, SOAPCommonTypes.CommonHeader requestHeader) {
		SOAPCommonTypes.Response response = new SOAPCommonTypes.Response();
		response.responseHeader = buildResponseHeader(requestHeader);
		response.isFault = false;
		String serialized = JSON.serialize(response);
		return JSON.deserialize(serialized, responseType);
	}

	public static Object constructFaultResponse(Type responseType, SOAPCommonTypes.CommonHeader requestHeader, SOAPCommonTypes.BusinessException ex) {
		SOAPCommonTypes.Response response = new SOAPCommonTypes.Response();
		response.responseHeader = buildResponseHeader(requestHeader);
		response.isFault = true;
		response.fault = buildFault(ex);
		String serialized = JSON.serialize(response);
		return JSON.deserialize(serialized, responseType);
	}

	private static SOAPCommonTypes.CommonHeader buildResponseHeader(SOAPCommonTypes.CommonHeader requestHeader) {
		SOAPCommonTypes.CommonHeader responseHeader = new SOAPCommonTypes.CommonHeader();
		if (requestHeader != null) {
			responseHeader.messageId = requestHeader.messageId + '_resp';
			responseHeader.correlationId = requestHeader.correlationId;
			responseHeader.targetSystem = requestHeader.sourceSystem;
			responseHeader.conversationIdValue = requestHeader.conversationIdValue;
			responseHeader.conversationIdName = requestHeader.conversationIdName;
			responseHeader.userId = requestHeader.userId;
		}
		responseHeader.timestamp = System.now();
		responseHeader.sourceSystem = 'SalesForce';
		responseHeader.physicalSource = Url.getSalesforceBaseUrl().toExternalForm();
		return responseHeader;
	}

	private static SOAPCommonTypes.Fault buildFault(SOAPCommonTypes.BusinessException e) {
		SOAPCommonTypes.Fault fault = new SOAPCommonTypes.Fault();
		fault.errorNumber = e.getErrorNumber();
		fault.errorDetail = e.getDetailNumber();
		fault.message = e.getMessage();
		return fault;
	}
}