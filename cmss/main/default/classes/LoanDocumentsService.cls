public class LoanDocumentsService {

	private static final String s_ns0 = 'http://service.cmss.cz/loan/LoanService/v06/datatypes';
	@TestVisible private static String certificateName = 'test12345';
	public class LoanDocumentsServicePort {

		public String endpoint_x = IntegrationSettings__c.getOrgDefaults().EsbEndpoint__c + '/LoanServiceWeb_v06/LoanService';
		public Map<String, String> inputHttpHeaders_x;
		public Map<String, String> outputHttpHeaders_x;
		public String clientCertName_x;
		public String clientCert_x;
		public String clientCertPasswd_x;
		public Integer timeout_x;
		private transient String[] ns_map_type_info = new String[]{'http://service.cmss.cz/loan/LoanService/v06/datatypes', 'LoanServiceDataTypes', 'http://service.cmss.cz/common/CommonMessage/v01', 'CommonMessageService', 'http://service.cmss.cz/common/datamodel/basictypes/v02', 'BasicTypesService'};
		private DOM.XmlNode populateDoc(DOM.Document doc) {
			String env = 'http://schemas.xmlsoap.org/soap/envelope/';
			String v06 = 'http://service.cmss.cz/loan/LoanService/v06';
			String v01 = 'http://service.cmss.cz/common/CommonMessage/v01';

			DOM.XmlNode envelope = doc.createRootElement('Envelope', env, 'soapenv');
			envelope.setNamespace('v01', v01);
			envelope.setNamespace('v06', v06);
			DOM.XmlNode header = envelope.addChildElement('Header', env, 'soapenv');
			AddHeader(header);

			new SOAPCommonTypes.OutboundHttpHeader().addWssToHeader1(
				header,
				IntegrationSettings__c.getOrgDefaults().EsbUsername__c,
				IntegrationSettings__c.getOrgDefaults().EsbPassword__c
			);

			DOM.XmlNode body = envelope.addChildElement('Body', env, 'soapenv');
			return body;
		}

		private void AddHeader(DOM.XmlNode header) {
		}

		public HTTPResponse getLoanDocumentsList_Http(CommonMessageService.RequestHeader requestHeader, LoanDocumentsServiceDataTypes.GetLoanDocumentsListRequestBodyType requestBody) {
			DOM.Document doc = new DOM.Document();
			DOM.XmlNode body = populateDoc(doc);
			DOM.XmlNode methodNode = body.addChildElement('v06:GetLoanDocumentsListRequest', null, null);
			LoanDocumentsServiceDataTypes.GetLoanDocumentsListRequestType request_x = new LoanDocumentsServiceDataTypes.GetLoanDocumentsListRequestType(requestHeader, requestBody);
			request_x.populateXmlNode(methodNode);

			HttpRequest req = new HttpRequest();
			req.setEndpoint(endpoint_x);
			req.setMethod('POST');
			req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
			req.setHeader('SOAPAction', 'http://service.cmss.cz/loan/LoanService/v06/getLoanDocumentsList');
			if (!String.isEmpty(certificateName)) {
				req.setClientCertificateName(certificateName);
			}
			req.setBodyDocument(doc);
			Http http = new Http();
			Logger.debug('Outgoing request', Logger.serializeHttpRequest(req));
			Logger.saveLogs();
			HTTPResponse res = http.send(req);
			Logger.debug('Incoming response', Logger.serializeHttpResponse(res));
			Logger.saveLogs();
			return res;

		}


	}

}