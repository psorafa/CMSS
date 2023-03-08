public class LoanDocumentsService extends ESBService {
	private static final String SOAP_ACTION = 'http://service.cmss.cz/loan/LoanService/v06/getLoanDocumentsList';
	private static final String DATA_NS = 'http://service.cmss.cz/loan/LoanService/v06/datatypes';
	private static final Map<String, String> NAMESPACES = new Map<String, String>{
		'v06' => 'http://service.cmss.cz/loan/LoanService/v06'
	};

	public static final String ENDPOINT_PATH = '/LoanServiceWeb_v06/LoanService';

	public HTTPResponse getLoanDocumentsList_Http(
		CommonMessageService.RequestHeader requestHeader,
		LoanDocumentsServiceDataTypes.GetLoanDocumentsListRequestBodyType requestBody
	) {
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode body = populateDoc(doc, NAMESPACES);
		DOM.XmlNode methodNode = body.addChildElement('v06:GetLoanDocumentsListRequest', null, null);
		LoanDocumentsServiceDataTypes.GetLoanDocumentsListRequestType request_x = new LoanDocumentsServiceDataTypes.GetLoanDocumentsListRequestType(
			requestHeader,
			requestBody
		);
		request_x.populateXmlNode(methodNode);

		HttpResponse res = new Callout(this.MTLS_ENDPOINT_BASE + ENDPOINT_PATH)
			.setClientCertificateName(CERTIFICATE_NAME)
			.setHeader('SOAPAction', SOAP_ACTION)
			.post(doc);

		return res;
	}
}
