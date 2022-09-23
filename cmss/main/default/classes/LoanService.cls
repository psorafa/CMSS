public class LoanService {
	private static final String s_ns0 = 'http://service.cmss.cz/loan/LoanService/v05/datatypes';
	public class LoanServicePort {
		public String endpoint_x = IntegrationSettings__c.getOrgDefaults().EsbEndpoint__c + '/LoanServiceWeb_v05/LoanService';
		public Map<String, String> inputHttpHeaders_x;
		public Map<String, String> outputHttpHeaders_x;
		public String clientCertName_x;
		public String clientCert_x;
		public String clientCertPasswd_x;
		public Integer timeout_x;
		private transient String[] ns_map_type_info = new String[]{'http://service.cmss.cz/loan/LoanService/v05/datatypes', 'LoanServiceDataTypes', 'http://service.cmss.cz/common/CommonMessage/v01', 'CommonMessageService', 'http://service.cmss.cz/common/datamodel/basictypes/v02', 'BasicTypesService'};
		private DOM.XmlNode populateDoc(DOM.Document doc) {
			String env = 'http://schemas.xmlsoap.org/soap/envelope/';
			String dat = 'http://service.cmss.cz/loan/LoanService/v05/datatypes';
			String v01 = 'http://service.cmss.cz/common/CommonMessage/v01';

			DOM.XmlNode envelope = doc.createRootElement('Envelope', env, 'soapenv');
			envelope.setNamespace('dat', dat);
			envelope.setNamespace('v01', v01);
			DOM.XmlNode header = envelope.addChildElement('Header', env, 'soapenv');
			AddHeader(header);
			new SOAPCommonTypes.OutboundHttpHeader().addWssToHeader(
				header,
				IntegrationSettings__c.getOrgDefaults().EsbUsername__c,
				IntegrationSettings__c.getOrgDefaults().EsbPassword__c
			);
			DOM.XmlNode body = envelope.addChildElement('Body', env, 'soapenv');
			return body;
		}

		private void AddHeader(DOM.XmlNode header) {
		}


		public HTTPResponse loadPackagesList_Http(CommonMessageService.RequestHeader requestHeader, LoanServiceDataTypes.LoadPackagesListRequestBodyType requestBody) {
			DOM.Document doc = new DOM.Document();
			DOM.XmlNode body = populateDoc(doc);
			DOM.XmlNode methodNode = body.addChildElement('dat:LoadPackagesListRequest', null, null);
			LoanServiceDataTypes.LoadPackagesListRequestType request_x = new LoanServiceDataTypes.LoadPackagesListRequestType(requestHeader, requestBody);
			request_x.populateXmlNode(methodNode);
			HttpRequest req = new HttpRequest();
			req.setClientCertificateName('test12345');
			req.setEndpoint(endpoint_x);
			req.setMethod('POST');
			req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
			req.setHeader('SOAPAction', 'http://service.cmss.cz/loan/LoanService/v05/loadPackagesList');
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