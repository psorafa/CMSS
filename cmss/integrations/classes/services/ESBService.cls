public virtual class ESBService {
	@TestVisible
	protected String ENVELOPE_NS = 'http://schemas.xmlsoap.org/soap/envelope/';
	@TestVisible
	protected String V01_NS = 'http://service.cmss.cz/common/CommonMessage/v01';

	@TestVisible
	protected String CERTIFICATE_NAME = Test.isRunningTest()
		? null
		: IntegrationSettings__c.getOrgDefaults().CertificateName__c;
	@TestVisible
	protected String ENDPOINT_BASE = IntegrationSettings__c.getOrgDefaults().EsbEndpoint__c;
	@TestVisible
	protected String MTLS_ENDPOINT_BASE = IntegrationSettings__c.getOrgDefaults().EsbEndpoint__c + ':8443';

	@TestVisible
	protected DOM.XmlNode populateDoc(DOM.Document doc, Map<String, String> namespaces) {
		DOM.XmlNode envelope = doc.createRootElement('Envelope', ENVELOPE_NS, 'soapenv');
		for (String key : namespaces.keySet()) {
			envelope.setNamespace(key, namespaces.get(key));
		}
		envelope.setNamespace('v01', V01_NS);
		DOM.XmlNode header = envelope.addChildElement('Header', ENVELOPE_NS, 'soapenv');
		new SOAPCommonTypes.OutboundHttpHeader()
			.addWssToHeader(
				header,
				IntegrationSettings__c.getOrgDefaults().EsbUsername__c,
				IntegrationSettings__c.getOrgDefaults().EsbPassword__c
			);
		DOM.XmlNode body = envelope.addChildElement('Body', ENVELOPE_NS, 'soapenv');
		return body;
	}
}
