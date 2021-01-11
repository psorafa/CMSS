@isTest
public class CalloutServiceMockImpl implements HttpCalloutMock {

    protected Integer code;
    protected String status;
    protected String bodyAsString;
    protected Map<String, String> methodNamesToBodies;
    protected Map<String, String> responseHeaders;

    public CalloutServiceMockImpl(Integer code, String status, String body, Map<String, String> methodNamesToBodies, Map<String, String> responseHeaders) {
        this.code = code;
        this.status = status;
        this.bodyAsString = body;
        this.methodNamesToBodies = methodNamesToBodies;
        this.responseHeaders = responseHeaders;
    }

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse resp = new HttpResponse();
        resp.setStatusCode(code);
        resp.setStatus(status);
        if (bodyAsString != null) {
            resp.setBody(bodyAsString);
        } else if (methodNamesToBodies != null) {
            DOM.Document reqDoc = req.getBodyDocument();
            DOM.XmlNode rootNode = reqDoc.getRootElement();
            DOM.XmlNode reqBodyNode = rootNode.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
            DOM.XmlNode[] methodNode = reqBodyNode.getChildElements();

            for (String methodName : methodNamesToBodies.keySet()) {
                System.debug(methodNode[0].getName());
                if (methodNode[0].getName() == methodName) {
                    resp.setBody(methodNamesToBodies.get(methodName));
                }
            }
        }

        if (responseHeaders != null) {
            for (String key : responseHeaders.keySet()) {
                resp.setHeader(key, responseHeaders.get(key));
            }
        }
        return resp;
    }

    /*
    global HTTPResponse respond(HTTPRequest req){
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		DOM.Document responseDoc = new DOM.Document();
		DOM.XmlNode envelope = responseDoc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 's');
		DOM.XmlNode bodyNode = envelope.addChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/', null);
        
		DOM.Document reqDoc = req.getBodyDocument();
		DOM.XmlNode rootNode = reqDoc.getRootElement();
		DOM.XmlNode reqBodyNode = rootNode.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
		DOM.XmlNode[] methodNode = reqBodyNode.getChildElements();
		if(methodNode[0].getName() == 'changeCPEClientState'){
			DOM.XmlNode ResponseNode = bodyNode.addChildElement('ChangeCPEClientStateResponse', 'http://service.cmss.cz/person/PortfolioManagementService/v10', null);
		}
		res.setBody(responseDoc.toXmlString());
		res.setStatusCode(200);
		return res;
	}*/
}
