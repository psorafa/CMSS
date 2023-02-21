public class LoanService extends ESBService {
	private static final Map<String, String> NAMESPACES = new Map<String, String>{
		'dat' => 'http://service.cmss.cz/loan/LoanService/v05/datatypes'
	};
	public static final String ENDPOINT_PATH = '/LoanServiceWeb_v05/LoanService';
	public static final String SOAP_ACTION = 'http://service.cmss.cz/loan/LoanService/v05/loadPackagesList';

	public HTTPResponse loadPackagesList_Http(
		CommonMessageService.RequestHeader requestHeader,
		LoanServiceDataTypes.LoadPackagesListRequestBodyType requestBody
	) {
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode body = populateDoc(doc, NAMESPACES);
		DOM.XmlNode methodNode = body.addChildElement('dat:LoadPackagesListRequest', null, null);
		LoanServiceDataTypes.LoadPackagesListRequestType request_x = new LoanServiceDataTypes.LoadPackagesListRequestType(
			requestHeader,
			requestBody
		);
		request_x.populateXmlNode(methodNode);

		return new Callout(this.ENDPOINT_BASE + ENDPOINT_PATH)
			.setClientCertificateName(CERTIFICATE_NAME)
			.setHeader('SOAPAction', SOAP_ACTION)
			.post(doc);
	}
}
