@IsTest
private class CalloutTest {
    public class SuccessCalloutMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setBody(request.getBody());
            response.setStatusCode(200);
            return response;
        }
    }

    public class FailureCalloutMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setBody(request.getBody());
            response.setStatusCode(400);
            return response;
        }
    }

    static void shouldSetCompressedAndReturnGetForNamedCredentialEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        Callout callout = new Callout('myNamedCredential', '/test').setCompressed();
        callout.get();

        System.assert(callout.request.getCompressed());
    }

    static void shouldSetCompressedAndReturnGetForFullEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        Callout callout = new Callout('https://example.com').setCompressed();
        callout.get();

        System.assert(callout.request.getCompressed());
    }

    static void shouldSetHeadersAndReturnGetForNamedCredentialEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        String headerKey = 'myKey';
        String headerValue = 'myValue';

        Callout callout = new Callout('myNamedCredential', '/test').setHeader(headerKey, headerValue);
        callout.get();

        System.assertEquals(headerValue, callout.request.getHeader(headerKey));
    }

    static void shouldSetHeadersAndReturnGetForFullEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        String headerKey = 'myKey';
        String headerValue = 'myValue';

        Callout callout = new Callout('https://example.com').setHeader(headerKey, headerValue);
        callout.get();

        System.assertEquals(headerValue, callout.request.getHeader(headerKey));
    }

    static void shouldSetParametersAndReturnGetForNamedCredentialEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        String parameterKey = 'myKey';
        String parameterValue = 'myValue';

        Callout callout = new Callout('myNamedCredential', '/test').setParameter(parameterKey, parameterValue);
        callout.get();

        String parameter = parameterKey + '=' + parameterValue;
        System.assert(callout.request.getEndpoint().contains(parameter), callout.request.getEndpoint());
    }

    static void shouldSetParametersAndReturnGetForFullEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        String parameterKey = 'myKey';
        String parameterValue = 'myValue';

        Callout callout = new Callout('https://example.com').setParameter(parameterKey, parameterValue);
        callout.get();

        String parameter = parameterKey + '=' + parameterValue;
        System.assert(callout.request.getEndpoint().contains(parameter), callout.request.getEndpoint());
    }

    static void shouldSetTimeoutAndReturnGetForNamedCredentialEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        Callout callout = new Callout('myNamedCredential', '/test').setTimeout(600);
        callout.get();
    }

    @isTest
    static void shouldSetTimeoutAndReturnGetForFullEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        Callout callout = new Callout('https://example.com').setTimeout(600);
        callout.get();
    }

    @isTest
    static void shouldReturnDelForNamedCredentialEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        HttpResponse response = new Callout('myNamedCredential', '/test').del();
    }

    @isTest
    static void shouldReturnDelForFullEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        HttpResponse response = new Callout('https://example.com').del();
    }

    @isTest
    static void shouldReturnGetForNamedCredentialEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        HttpResponse response = new Callout('myNamedCredential', '/test').get();
    }

    @isTest
    static void shouldReturnGetForFullEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        HttpResponse response = new Callout('https://example.com').get();
    }

    @isTest
    static void shouldReturnHeadForNamedCredentialEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        HttpResponse response = new Callout('myNamedCredential', '/test').head();
    }

    @isTest
    static void shouldReturnHeadForFullEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        HttpResponse response = new Callout('https://example.com').head();
    }

    @isTest
    static void shouldReturnPatchForBlobForNamedCredentialEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        Blob theBlob = Blob.valueof('StringToBlob');
        HttpResponse response = new Callout('myNamedCredential', '/test').patch(theBlob);
    }

    @isTest
    static void shouldReturnPatchForBlobForFullEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        Blob theBlob = Blob.valueof('StringToBlob');
        HttpResponse response = new Callout('https://example.com').patch(theBlob);
    }

    @isTest
    static void shouldReturnPatchForDomDocumentForNamedCredentialEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        Dom.Document domDocument = new Dom.Document();
        domDocument.load('<myxmlnode />');
        HttpResponse response = new Callout('myNamedCredential', '/test').patch(domDocument);
    }

    @isTest
    static void shouldReturnPatchForDomDocumentForFullEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        Dom.Document domDocument = new Dom.Document();
        domDocument.load('<myxmlnode />');
        HttpResponse response = new Callout('https://example.com').patch(domDocument);
    }

    @isTest
    static void shouldReturnPatchForSObjectForNamedCredentialEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        HttpResponse response = new Callout('myNamedCredential', '/test').patch(new Account(Name = 'Test'));
    }

    @isTest
    static void shouldReturnPatchForSObjectForFullEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        HttpResponse response = new Callout('https://example.com').patch(new Account(Name = 'Test'));
    }

    @isTest
    static void shouldReturnPostForBlobForNamedCredentialEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        Blob theBlob = Blob.valueof('StringToBlob');
        HttpResponse response = new Callout('myNamedCredential', '/test').post(theBlob);
    }

    @isTest
    static void shouldReturnPostForBlobForFullEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        Blob theBlob = Blob.valueof('StringToBlob');
        HttpResponse response = new Callout('https://example.com').post(theBlob);
    }

    @isTest
    static void shouldReturnPostForDomDocumentForNamedCredentialEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        HttpResponse response = new Callout('myNamedCredential', '/test').post(new Account(Name = 'Test'));
    }

    @isTest
    static void shouldReturnPostForDomDocumentForFullEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        Dom.Document domDocument = new Dom.Document();
        domDocument.load('<myxmlnode />');
        HttpResponse response = new Callout('https://example.com').post(domDocument);
    }

    @isTest
    static void shouldReturnPostForSObjectForNamedCredentialEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        Dom.Document domDocument = new Dom.Document();
        domDocument.load('<myxmlnode />');
        HttpResponse response = new Callout('myNamedCredential', '/test').post(domDocument);
    }

    @isTest
    static void shouldReturnPostForSObjectForFullEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        HttpResponse response = new Callout('https://example.com').post(new Account(Name = 'Test'));
    }

    @isTest
    static void shouldReturnPutForBlobForNamedCredentialEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        Blob theBlob = Blob.valueof('StringToBlob');
        HttpResponse response = new Callout('myNamedCredential', '/test').put(theBlob);
    }

    @isTest
    static void shouldReturnPutForBlobForFullEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        Blob theBlob = Blob.valueof('StringToBlob');
        HttpResponse response = new Callout('https://example.com').put(theBlob);
    }

    @isTest
    static void shouldReturnPutForDomDocumentForNamedCredentialEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        Dom.Document domDocument = new Dom.Document();
        domDocument.load('<myxmlnode />');
        HttpResponse response = new Callout('myNamedCredential', '/test').put(domDocument);
    }

    @isTest
    static void shouldReturnPutForDomDocumentForFullEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        Dom.Document domDocument = new Dom.Document();
        domDocument.load('<myxmlnode />');
        HttpResponse response = new Callout('https://example.com').put(domDocument);
    }

    @isTest
    static void shouldReturnPutForSObjectForNamedCredentialEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        HttpResponse response = new Callout('myNamedCredential', '/test').put(new Account(Name = 'Test'));
    }

    @isTest
    static void shouldReturnPutForSObjectForFullEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        HttpResponse response = new Callout('https://example.com').put(new Account(Name = 'Test'));
    }

    @isTest
    static void shouldReturnTraceForNamedCredentialEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        HttpResponse response = new Callout('myNamedCredential', '/test').trace();
    }

    @isTest
    static void shouldReturnTraceForFullEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

        HttpResponse response = new Callout('https://example.com').trace();
    }

    @isTest
    static void shouldThrowExceptionForStatusCode400ForNamedCredentialEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new FailureCalloutMock());

        try {
            HttpResponse response = new Callout('myNamedCredential', '/test').get();
            System.assert(false, 'Exception expected here');
        } catch (Callout.HttpResponseException e) {
            System.assert(e.getMessage().startsWith('Callout failed'));
        }
    }

    @isTest
    static void shouldThrowExceptionForStatusCode400ForFullEndpointTest() {
        Test.setMock(HttpCalloutMock.class, new FailureCalloutMock());

        try {
            HttpResponse response = new Callout('https://example.com').get();
            System.assert(false, 'Exception expected here');
        } catch (Callout.HttpResponseException e) {
            System.assert(e.getMessage().startsWith('Callout failed'));
        }
    }
}