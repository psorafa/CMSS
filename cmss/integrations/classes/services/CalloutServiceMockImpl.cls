@IsTest
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

    public HttpResponse respond(HttpRequest req) {
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
}
