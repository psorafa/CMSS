public class PersonManagementSOAPService extends ESBService {
	private static final Map<String, String> NAMESPACES = new Map<String, String>{
		'v10' => 'http://service.cmss.cz/person/PersonManagementService/v10'
	};

	private static final String ENDPOINT_PATH = ':444/PersonManagementServiceWeb_v10/PersonManagementService';
	private static final Integer TIMEOUT = 120000;

	public PersonManagementSOAPServiceTypes.SearchCSOBSNonClientResponseBody searchCSOBSNonClient_Http(
		CommonMessageService.RequestHeader requestHeader,
		PersonManagementSOAPServiceTypes.SearchCSOBSNonClientRequestBody requestBody
	) {
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode body = populateDoc(doc, NAMESPACES);
		DOM.XmlNode methodNode = body.addChildElement('v10:SearchCSOBSNonClientRequest', null, null);
		PersonManagementSOAPServiceTypes.SearchCSOBSNonClientRequest request_x = new PersonManagementSOAPServiceTypes.SearchCSOBSNonClientRequest(
			requestHeader,
			requestBody
		);
		request_x.populateXmlNode(methodNode);

		HttpResponse res = new Callout(this.ENDPOINT_BASE + ENDPOINT_PATH)
			.setClientCertificateName(CERTIFICATE_NAME)
			.setHeader('SOAPAction', 'http://service.cmss.cz/person/PersonManagementService/v10/searchCSOBSNonClient')
			.setTimeout(TIMEOUT)
			.post(doc);
		Logger.saveLogs();

		Dom.Document responseDoc = res.getBodyDocument();
		Dom.XmlNode rootNode = responseDoc.getRootElement();
		Dom.XmlNode bodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
		Dom.XmlNode SearchCSOBSNonClientResponseNode = bodyNode.getChildElement(
			'SearchCSOBSNonClientResponse',
			'http://service.cmss.cz/person/PersonManagementService/v10'
		);

		PersonManagementSOAPServiceTypes.SearchCSOBSNonClientResponse response_x = new PersonManagementSOAPServiceTypes.SearchCSOBSNonClientResponse(
			SearchCSOBSNonClientResponseNode
		);
		return response_x.responseBody;
	}

	public PersonManagementSOAPServiceTypes.UpdateCSOBNonClientResponseBody updateCSOBNonClient_Http(
		CommonMessageService.RequestHeader requestHeader,
		PersonManagementSOAPServiceTypes.UpdateCSOBNonClientRequestBody requestBody
	) {
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode body = populateDoc(doc, NAMESPACES);
		DOM.XmlNode methodNode = body.addChildElement('v10:UpdateCSOBNonClientRequest', null, null);
		PersonManagementSOAPServiceTypes.UpdateCSOBNonClientRequest request_x = new PersonManagementSOAPServiceTypes.UpdateCSOBNonClientRequest(
			requestHeader,
			requestBody
		);
		request_x.populateXmlNode(methodNode);

		HttpResponse res = new Callout(this.ENDPOINT_BASE + ENDPOINT_PATH)
			.setClientCertificateName(CERTIFICATE_NAME)
			.setHeader('SOAPAction', 'http://service.cmss.cz/person/PersonManagementService/v10/updateCSOBNonClient')
			.setTimeout(TIMEOUT)
			.post(doc);

		Dom.Document responseDoc = res.getBodyDocument();
		Dom.XmlNode rootNode = responseDoc.getRootElement();
		Dom.XmlNode bodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
		Dom.XmlNode UpdateCSOBNonClientResponseNode = bodyNode.getChildElement(
			'UpdateCSOBNonClientResponse',
			'http://service.cmss.cz/person/PersonManagementService/v10'
		);

		PersonManagementSOAPServiceTypes.UpdateCSOBNonClientResponse response_x = new PersonManagementSOAPServiceTypes.UpdateCSOBNonClientResponse(
			UpdateCSOBNonClientResponseNode
		);
		return response_x.responseBody;
	}

	public PersonManagementSOAPServiceTypes.CoupleDocumentResponseBody coupleDocument_Http(
		CommonMessageService.RequestHeader requestHeader,
		PersonManagementSOAPServiceTypes.CoupleDocumentRequestBody requestBody
	) {
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode body = populateDoc(doc, NAMESPACES);
		DOM.XmlNode methodNode = body.addChildElement(
			'coupleDocument',
			'http://service.cmss.cz/person/PersonManagementService/v10',
			''
		);
		PersonManagementSOAPServiceTypes.CoupleDocumentRequest request_x = new PersonManagementSOAPServiceTypes.CoupleDocumentRequest(
			requestHeader,
			requestBody
		);
		request_x.populateXmlNode(methodNode);

		HttpRequest req = new HttpRequest();
		req.setEndpoint(this.ENDPOINT_BASE + ENDPOINT_PATH);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
		req.setHeader('SOAPAction', 'http://service.cmss.cz/person/PersonManagementService/v10/coupleDocument');
		req.setBodyDocument(doc);
		req.setTimeout(TIMEOUT);
		Http http = new Http();
		HTTPResponse res = http.send(req);
		Dom.Document responseDoc = res.getBodyDocument();
		Dom.XmlNode rootNode = responseDoc.getRootElement();
		Dom.XmlNode bodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
		Dom.XmlNode CoupleDocumentResponseNode = bodyNode.getChildElement(
			'CoupleDocumentResponse',
			'http://service.cmss.cz/person/PersonManagementService/v10'
		);

		PersonManagementSOAPServiceTypes.CoupleDocumentResponse response_x = new PersonManagementSOAPServiceTypes.CoupleDocumentResponse(
			CoupleDocumentResponseNode
		);
		return response_x.responseBody;
	}

	public PersonManagementSOAPServiceTypes.CreateClientResponseBody createClient_Http(
		CommonMessageService.RequestHeader requestHeader,
		PersonManagementSOAPServiceTypes.CreateClientRequestBody requestBody
	) {
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode body = populateDoc(doc, NAMESPACES);
		DOM.XmlNode methodNode = body.addChildElement(
			'createClient',
			'http://service.cmss.cz/person/PersonManagementService/v10',
			''
		);
		PersonManagementSOAPServiceTypes.CreateClientRequest request_x = new PersonManagementSOAPServiceTypes.CreateClientRequest(
			requestHeader,
			requestBody
		);
		request_x.populateXmlNode(methodNode);
		HttpRequest req = new HttpRequest();
		req.setEndpoint(this.ENDPOINT_BASE + ENDPOINT_PATH);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
		req.setHeader('SOAPAction', 'http://service.cmss.cz/person/PersonManagementService/v10/createClient');
		req.setBodyDocument(doc);
		req.setTimeout(TIMEOUT);
		Http http = new Http();
		Logger.debug('Outgoing request', Logger.serializeHttpRequest(req));
		HTTPResponse res = http.send(req);
		Logger.debug('Incoming response', Logger.serializeHttpResponse(res));
		Dom.Document responseDoc = res.getBodyDocument();
		Dom.XmlNode rootNode = responseDoc.getRootElement();
		Dom.XmlNode bodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
		Dom.XmlNode CreateClientResponseNode = bodyNode.getChildElement(
			'CreateClientResponse',
			'http://service.cmss.cz/person/PersonManagementService/v10'
		);

		PersonManagementSOAPServiceTypes.CreateClientResponse response_x = new PersonManagementSOAPServiceTypes.CreateClientResponse(
			CreateClientResponseNode
		);
		return response_x.responseBody;
	}

	public PersonManagementSOAPServiceTypes.CreatePersonRelationResponseBody createPersonRelation_Http(
		CommonMessageService.RequestHeader requestHeader,
		PersonManagementSOAPServiceTypes.CreatePersonRelationRequestBody requestBody
	) {
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode body = populateDoc(doc, NAMESPACES);
		DOM.XmlNode methodNode = body.addChildElement(
			'createPersonRelation',
			'http://service.cmss.cz/person/PersonManagementService/v10',
			''
		);
		PersonManagementSOAPServiceTypes.CreatePersonRelationRequest request_x = new PersonManagementSOAPServiceTypes.CreatePersonRelationRequest(
			requestHeader,
			requestBody
		);
		request_x.populateXmlNode(methodNode);

		HttpRequest req = new HttpRequest();
		req.setEndpoint(this.ENDPOINT_BASE + ENDPOINT_PATH);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
		req.setHeader('SOAPAction', 'http://service.cmss.cz/person/PersonManagementService/v10/createPersonRelation');
		req.setBodyDocument(doc);
		req.setTimeout(TIMEOUT);
		Http http = new Http();
		HTTPResponse res = http.send(req);
		Dom.Document responseDoc = res.getBodyDocument();
		Dom.XmlNode rootNode = responseDoc.getRootElement();
		Dom.XmlNode bodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
		Dom.XmlNode CreatePersonRelationResponseNode = bodyNode.getChildElement(
			'CreatePersonRelationResponse',
			'http://service.cmss.cz/person/PersonManagementService/v10'
		);

		PersonManagementSOAPServiceTypes.CreatePersonRelationResponse response_x = new PersonManagementSOAPServiceTypes.CreatePersonRelationResponse(
			CreatePersonRelationResponseNode
		);
		return response_x.responseBody;
	}

	public PersonManagementSOAPServiceTypes.GetReservedGlobalIdResponseBody getReservedGlobalId_Http(
		CommonMessageService.RequestHeader requestHeader,
		PersonManagementSOAPServiceTypes.GetReservedGlobalIdRequestBody requestBody
	) {
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode body = populateDoc(doc, NAMESPACES);
		DOM.XmlNode methodNode = body.addChildElement(
			'getReservedGlobalId',
			'http://service.cmss.cz/person/PersonManagementService/v10',
			''
		);
		PersonManagementSOAPServiceTypes.GetReservedGlobalIdRequest request_x = new PersonManagementSOAPServiceTypes.GetReservedGlobalIdRequest(
			requestHeader,
			requestBody
		);
		request_x.populateXmlNode(methodNode);

		HttpRequest req = new HttpRequest();
		req.setEndpoint(this.ENDPOINT_BASE + ENDPOINT_PATH);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
		req.setHeader('SOAPAction', 'http://service.cmss.cz/person/PersonManagementService/v10/getReservedGlobalId');
		req.setBodyDocument(doc);
		req.setTimeout(TIMEOUT);
		Http http = new Http();
		HTTPResponse res = http.send(req);
		Dom.Document responseDoc = res.getBodyDocument();
		Dom.XmlNode rootNode = responseDoc.getRootElement();
		Dom.XmlNode bodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
		Dom.XmlNode GetReservedGlobalIdResponseNode = bodyNode.getChildElement(
			'GetReservedGlobalIdResponse',
			'http://service.cmss.cz/person/PersonManagementService/v10'
		);

		PersonManagementSOAPServiceTypes.GetReservedGlobalIdResponse response_x = new PersonManagementSOAPServiceTypes.GetReservedGlobalIdResponse(
			GetReservedGlobalIdResponseNode
		);
		return response_x.responseBody;
	}

	public PersonManagementSOAPServiceTypes.SearchPersonByIdNumberResponseBody searchPersonByIdNumber_Http(
		CommonMessageService.RequestHeader requestHeader,
		PersonManagementSOAPServiceTypes.SearchPersonByIdNumberRequestBody requestBody
	) {
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode body = populateDoc(doc, NAMESPACES);
		DOM.XmlNode methodNode = body.addChildElement(
			'searchPersonByIdNumber',
			'http://service.cmss.cz/person/PersonManagementService/v10',
			''
		);
		PersonManagementSOAPServiceTypes.SearchPersonByIdNumberRequest request_x = new PersonManagementSOAPServiceTypes.SearchPersonByIdNumberRequest(
			requestHeader,
			requestBody
		);
		request_x.populateXmlNode(methodNode);

		HttpRequest req = new HttpRequest();
		req.setEndpoint(this.ENDPOINT_BASE + ENDPOINT_PATH);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
		req.setHeader('SOAPAction', 'http://service.cmss.cz/person/PersonManagementService/v10/searchPersonByIdNumber');
		req.setBodyDocument(doc);
		req.setTimeout(TIMEOUT);
		Http http = new Http();
		HTTPResponse res = http.send(req);
		Dom.Document responseDoc = res.getBodyDocument();
		Dom.XmlNode rootNode = responseDoc.getRootElement();
		Dom.XmlNode bodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
		Dom.XmlNode SearchPersonByIdNumberResponseNode = bodyNode.getChildElement(
			'SearchPersonByIdNumberResponse',
			'http://service.cmss.cz/person/PersonManagementService/v10'
		);

		PersonManagementSOAPServiceTypes.SearchPersonByIdNumberResponse response_x = new PersonManagementSOAPServiceTypes.SearchPersonByIdNumberResponse(
			SearchPersonByIdNumberResponseNode
		);
		return response_x.responseBody;
	}

	public PersonManagementSOAPServiceTypes.UpdateClientResponseBody updateClient_Http(
		CommonMessageService.RequestHeader requestHeader,
		PersonManagementSOAPServiceTypes.UpdateClientRequestBody requestBody
	) {
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode body = populateDoc(doc, NAMESPACES);
		DOM.XmlNode methodNode = body.addChildElement(
			'updateClient',
			'http://service.cmss.cz/person/PersonManagementService/v10',
			''
		);
		PersonManagementSOAPServiceTypes.UpdateClientRequest request_x = new PersonManagementSOAPServiceTypes.UpdateClientRequest(
			requestHeader,
			requestBody
		);
		request_x.populateXmlNode(methodNode);

		HttpRequest req = new HttpRequest();
		req.setEndpoint(this.ENDPOINT_BASE + ENDPOINT_PATH);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
		req.setHeader('SOAPAction', 'http://service.cmss.cz/person/PersonManagementService/v10/updateClient');
		req.setBodyDocument(doc);
		req.setTimeout(TIMEOUT);
		Http http = new Http();
		HTTPResponse res = http.send(req);
		Dom.Document responseDoc = res.getBodyDocument();
		Dom.XmlNode rootNode = responseDoc.getRootElement();
		Dom.XmlNode bodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
		Dom.XmlNode UpdateClientResponseNode = bodyNode.getChildElement(
			'UpdateClientResponse',
			'http://service.cmss.cz/person/PersonManagementService/v10'
		);

		PersonManagementSOAPServiceTypes.UpdateClientResponse response_x = new PersonManagementSOAPServiceTypes.UpdateClientResponse(
			UpdateClientResponseNode
		);
		return response_x.responseBody;
	}

	public PersonManagementSOAPServiceTypes.UpdateCommunicationsResponseBody updateCommunications_Http(
		CommonMessageService.RequestHeader requestHeader,
		PersonManagementSOAPServiceTypes.UpdateCommunicationsRequestBody requestBody
	) {
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode body = populateDoc(doc, NAMESPACES);
		DOM.XmlNode methodNode = body.addChildElement(
			'updateCommunications',
			'http://service.cmss.cz/person/PersonManagementService/v10',
			''
		);
		PersonManagementSOAPServiceTypes.UpdateCommunicationsRequest request_x = new PersonManagementSOAPServiceTypes.UpdateCommunicationsRequest(
			requestHeader,
			requestBody
		);
		request_x.populateXmlNode(methodNode);

		HttpRequest req = new HttpRequest();
		req.setEndpoint(this.ENDPOINT_BASE + ENDPOINT_PATH);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
		req.setHeader('SOAPAction', 'http://service.cmss.cz/person/PersonManagementService/v10/updateCommunications');
		req.setBodyDocument(doc);
		req.setTimeout(TIMEOUT);
		Http http = new Http();
		HTTPResponse res = http.send(req);
		Dom.Document responseDoc = res.getBodyDocument();
		Dom.XmlNode rootNode = responseDoc.getRootElement();
		Dom.XmlNode bodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
		Dom.XmlNode UpdateCommunicationsResponseNode = bodyNode.getChildElement(
			'UpdateCommunicationsResponse',
			'http://service.cmss.cz/person/PersonManagementService/v10'
		);

		PersonManagementSOAPServiceTypes.UpdateCommunicationsResponse response_x = new PersonManagementSOAPServiceTypes.UpdateCommunicationsResponse(
			UpdateCommunicationsResponseNode
		);
		return response_x.responseBody;
	}

	public PersonManagementSOAPServiceTypes.ValidateClientResponseBody validateClient_Http(
		CommonMessageService.RequestHeader requestHeader,
		PersonManagementSOAPServiceTypes.ValidateClientRequestBody requestBody
	) {
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode body = populateDoc(doc, NAMESPACES);
		DOM.XmlNode methodNode = body.addChildElement(
			'validateClient',
			'http://service.cmss.cz/person/PersonManagementService/v10',
			''
		);
		PersonManagementSOAPServiceTypes.ValidateClientRequest request_x = new PersonManagementSOAPServiceTypes.ValidateClientRequest(
			requestHeader,
			requestBody
		);
		request_x.populateXmlNode(methodNode);

		HttpRequest req = new HttpRequest();
		req.setEndpoint(this.ENDPOINT_BASE + ENDPOINT_PATH);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
		req.setHeader('SOAPAction', 'http://service.cmss.cz/person/PersonManagementService/v10/validateClient');
		req.setBodyDocument(doc);
		req.setTimeout(TIMEOUT);
		Http http = new Http();
		HTTPResponse res = http.send(req);
		Dom.Document responseDoc = res.getBodyDocument();
		Dom.XmlNode rootNode = responseDoc.getRootElement();
		Dom.XmlNode bodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
		Dom.XmlNode ValidateClientResponseNode = bodyNode.getChildElement(
			'ValidateClientResponse',
			'http://service.cmss.cz/person/PersonManagementService/v10'
		);

		PersonManagementSOAPServiceTypes.ValidateClientResponse response_x = new PersonManagementSOAPServiceTypes.ValidateClientResponse(
			ValidateClientResponseNode
		);
		return response_x.responseBody;
	}
}
