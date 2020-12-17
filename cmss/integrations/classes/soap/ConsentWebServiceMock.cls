@isTest
global class ConsentWebServiceMock {
    global class GeneralChannelConsentMock implements WebServiceMock {
        global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) 
        {
            ConsentWebServiceDataTypes.EnableGeneralConsentResponseType response_x = new ConsentWebServiceDataTypes.EnableGeneralConsentResponseType();
            response_x.responseBody = new ConsentWebServiceDataTypes.EnableGeneralConsentResponseBodyType();
            response_x.responseBody.consentGuid = '3267wergjs' + MockServicesUtil.generateUUID();
            response.put('response_x', response_x); 
        }
    }
}
