public class FinancialOperationService {
	private static final String s_ns0 = 'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes';

	public class FinancialOperationServicePort {
		public String endpoint_x =
			IntegrationSettings__c.getOrgDefaults().EsbEndpoint__c +
			'/FinancialOperationServiceWeb_v05/FinancialOperationService';
		public Map<String, String> inputHttpHeaders_x;
		public Map<String, String> outputHttpHeaders_x;
		private transient String[] ns_map_type_info = new List<String>{
			'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes',
			'FinancialOperationDataTypesService',
			'http://service.cmss.cz/common/CommonMessage/v01',
			'CommonMessageService',
			'http://service.cmss.cz/common/datamodel/basictypes/v02',
			'BasicTypesService'
		};

		private DOM.XmlNode populateDoc(DOM.Document doc) {
			String dat = 'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes';
			String v01 = 'http://service.cmss.cz/common/CommonMessage/v01';
			String env = 'http://schemas.xmlsoap.org/soap/envelope/';

			DOM.XmlNode envelope = doc.createRootElement('Envelope', env, 'soapenv');
			envelope.setNamespace('dat', dat);
			envelope.setNamespace('v01', v01);

			DOM.XmlNode header = envelope.addChildElement('Header', env, 'soapenv');
			new SOAPCommonTypes.OutboundHttpHeader()
				.addWssToHeader(
					header,
					IntegrationSettings__c.getOrgDefaults().EsbUsername__c,
					IntegrationSettings__c.getOrgDefaults().EsbPassword__c
				);

			DOM.XmlNode body = envelope.addChildElement('Body', env, 'soapenv');
			return body;
		}

		private void AddHeader(DOM.XmlNode header) {
		}

		public FinancialOperationDataTypesService.GetFinancialOperationInfoResponseBodyType getFinancialOperationInfo_Http(
			CommonMessageService.RequestHeader requestHeader,
			FinancialOperationDataTypesService.GetFinancialOperationInfoRequestBodyType requestBody
		) {
			DOM.Document doc = new DOM.Document();
			DOM.XmlNode body = populateDoc(doc);
			DOM.XmlNode methodNode = body.addChildElement(
				'GetFinancialOperationInfoRequest',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes',
				'dat'
			);
			FinancialOperationDataTypesService.GetFinancialOperationInfoRequestType request_x = new FinancialOperationDataTypesService.GetFinancialOperationInfoRequestType(
				requestHeader,
				requestBody
			);
			request_x.populateXmlNode(methodNode);
			HttpRequest req = new HttpRequest();
			req.setEndpoint(endpoint_x);
			req.setMethod('POST');
			req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
			req.setHeader(
				'SOAPAction',
				'http://service.cmss.cz/account/FinancialOperationService/v05/getFinancialOperationInfo'
			);
			req.setBodyDocument(doc);
			Http http = new Http();
			Logger.debug('Outgoing request', Logger.serializeHttpRequest(req));
			Logger.saveLogs();
			HTTPResponse res = http.send(req);
			Logger.debug('Incoming response', Logger.serializeHttpResponse(res));
			Logger.saveLogs();
			Dom.Document responseDoc = res.getBodyDocument();
			Dom.XmlNode rootNode = responseDoc.getRootElement();
			Dom.XmlNode bodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
			Dom.XmlNode GetFinancialOperationInfoResponseNode = bodyNode.getChildElement(
				'GetFinancialOperationInfoResponse',
				'http://service.cmss.cz/account/FinancialOperationService/v05/datatypes'
			);

			FinancialOperationDataTypesService.GetFinancialOperationInfoResponseType response_x = new FinancialOperationDataTypesService.GetFinancialOperationInfoResponseType(
				GetFinancialOperationInfoResponseNode
			);
			return response_x.responseBody;
		}
	}
}
