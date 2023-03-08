public class LoanDetailInfoService extends ESBService {
	private static final Map<String, String> NAMESPACES = new Map<String, String>{
		'dat' => 'http://service.cmss.cz/loan/LoanService/v05/datatypes'
	};
	public static final String ENDPOINT_PATH = '/LoanDetailInfoServiceWeb_v05/LoanDetailInfoService';
	public static final String SOAP_ACTION = 'http://service.cmss.cz/loan/LoanDetailInfoService/v05/getLoanDetailInfo';

	public HTTPResponse getLoanDetailInfo_Http(
		CommonMessageService.RequestHeader requestHeader,
		LoanDetailInfoServiceDataTypes.GetLoanDetailInfoRequestBodyType requestBody
	) {
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode body = populateDoc(doc, NAMESPACES);
		DOM.XmlNode methodNode = body.addChildElement('dat:GetLoanDetailInfoRequest', null, null);
		LoanDetailInfoServiceDataTypes.GetLoanDetailInfoRequestType request_x = new LoanDetailInfoServiceDataTypes.GetLoanDetailInfoRequestType(
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
