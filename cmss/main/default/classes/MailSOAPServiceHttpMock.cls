public class MailSOAPServiceHttpMock implements HttpCalloutMock {
	public HTTPResponse respond(HTTPRequest req) {
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		DOM.Document responseDoc = new DOM.Document();
		DOM.XmlNode envelope = responseDoc.createRootElement(
			'Envelope',
			'http://schemas.xmlsoap.org/soap/envelope/',
			's'
		);
		DOM.XmlNode bodyNode = envelope.addChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/', null);

		DOM.Document reqDoc = req.getBodyDocument();
		DOM.XmlNode rootNode = reqDoc.getRootElement();
		DOM.XmlNode reqBodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
		DOM.XmlNode[] methodNode = reqBodyNode.getChildElements();
		if (methodNode[0].getName() == 'sendEmail') {
			DOM.XmlNode ResponseNode = bodyNode.addChildElement(
				'sendEmailResponse',
				'http://service.cmss.cz/mail',
				null
			);
		} else if (methodNode[0].getName() == 'sendEmailWithAttachments') {
			DOM.XmlNode ResponseNode = bodyNode.addChildElement(
				'sendEmailWithAttachmentsResponse',
				'http://service.cmss.cz/mail',
				null
			);
		}
		res.setBody(responseDoc.toXmlString());
		res.setStatusCode(200);
		return res;
	}
}
