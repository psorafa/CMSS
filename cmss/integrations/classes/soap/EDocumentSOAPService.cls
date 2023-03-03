public class EDocumentSOAPService extends ESBService {
	private static final String s_ns0 = 'http://service.cmss.cz/edocument/EDocumentService/v05';

	private static final Map<String, String> NAMESPACES = new Map<String, String>{
		'v05' => 'http://service.cmss.cz/edocument/EDocumentService/v05'
	};

	public static final String ENDPOINT_PATH = '/EDocumentServiceWeb_v05/EDocumentService';
	public static final String SOAP_ACTION = 'http://service.cmss.cz/edocument/EDocumentService/v05/getDocumentBySBId';

	public class EDocumentSOAPServiceException extends Exception {
	}

	public String getDocumentBySBId_Http(
		CommonMessageService.RequestHeader requestHeader,
		EDocumentSOAPService.GetDocumentBySBIdRequestBody requestBody
	) {
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode body = populateDoc(doc, NAMESPACES);
		DOM.XmlNode methodNode = body.addChildElement(
			'GetDocumentBySBIdRequest',
			'http://service.cmss.cz/edocument/EDocumentService/v05',
			'v05'
		);
		EDocumentSOAPService.GetDocumentBySBIdRequest request_x = new EDocumentSOAPService.GetDocumentBySBIdRequest(
			requestHeader,
			requestBody
		);
		request_x.populateXmlNode(methodNode);

		HttpResponse res = new Callout(this.MTLS_ENDPOINT_BASE + ENDPOINT_PATH)
			.setClientCertificateName(CERTIFICATE_NAME)
			.setHeader('SOAPAction', SOAP_ACTION)
			.post(doc);
		Logger.saveLogs();

		String content = res.getBody();
		if (content.contains('<soapenv:Fault>')) {
			String errorMessage = content.substringAfter('<ns2:message>');
			errorMessage = errorMessage.substringBefore('</ns2:message>');
			Logger.error('Incoming response error', errorMessage);
			throw new EDocumentSOAPServiceException(errorMessage);
		} else if (!content.contains('<ns3:eDocumentData>')) {
			Logger.error('Unexpected response', Logger.serializeHttpResponse(res));
			throw new EDocumentSOAPServiceException('Unkown error');
		}
		content = content.substringAfter('<ns3:eDocumentData>');
		content = content.substringBefore('</ns3:eDocumentData>');
		return content;
	}

	public class GetDocumentBySBIdRequest {
		public CommonMessageService.RequestHeader requestHeader;
		private transient String[] requestHeader_type_info = new List<String>{
			'requestHeader',
			s_ns0,
			'RequestHeader',
			'1',
			'1',
			'false'
		};
		public EDocumentSOAPService.GetDocumentBySBIdRequestBody requestBody;
		private transient String[] requestBody_type_info = new List<String>{
			'requestBody',
			s_ns0,
			'GetDocumentBySBIdRequestBody',
			'1',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{ s_ns0, 'true', 'false' };
		private transient String[] field_order_type_info = new List<String>{ 'requestHeader', 'requestBody' };

		public GetDocumentBySBIdRequest(
			CommonMessageService.RequestHeader requestHeader,
			EDocumentSOAPService.GetDocumentBySBIdRequestBody requestBody
		) {
			this.requestHeader = requestHeader;
			this.requestBody = requestBody;
		}

		public void populateXmlNode(Dom.XmlNode outerNode) {
			CommonMessageService.RequestHeader requestHeaderObj = this.requestHeader;
			Dom.XmlNode requestHeaderNode = outerNode.addChildElement(
				'requestHeader',
				'http://service.cmss.cz/common/CommonMessage/v01',
				'v01'
			);
			if (requestHeaderObj != null) {
				requestHeaderObj.populateXmlNode(requestHeaderNode);
			}

			EDocumentSOAPService.GetDocumentBySBIdRequestBody requestBodyObj = this.requestBody;
			Dom.XmlNode requestBodyNode = outerNode.addChildElement(
				'requestBody',
				'http://service.cmss.cz/edocument/EDocumentService/v05',
				'v05'
			);
			if (requestBodyObj != null) {
				requestBodyObj.populateXmlNode(requestBodyNode);
			}
		}
	}

	public class GetDocumentBySBIdRequestBody {
		public String documentSBId;
		private transient String[] documentSBId_type_info = new List<String>{
			'documentSBId',
			s_ns0,
			'AlphanumericIdType',
			'0',
			'1',
			'false'
		};
		private transient String[] apex_schema_type_info = new List<String>{ s_ns0, 'true', 'false' };
		private transient String[] field_order_type_info = new List<String>{ 'documentSBId' };
		public GetDocumentBySBIdRequestBody() {
		}
		public void populateXmlNode(Dom.XmlNode outerNode) {
			Dom.XmlNode documentSBIdNode = outerNode.addChildElement(
				'documentSBId',
				'http://service.cmss.cz/edocument/EDocumentService/v05',
				'v05'
			);
			documentSBIdNode.addTextNode((this.documentSBId == null) ? '' : this.documentSBId);
		}
	}
}
