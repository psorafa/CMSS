@isTest
global class ConsentWebServiceMock {
    global class GeneralConsentMock implements WebServiceMock {
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

    global class ChannelConsentMock implements WebServiceMock {
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
            if (requestName.contains('EnableChannelConsent')) {
                ConsentWebServiceDataTypes.EnableChannelConsentResponseType response_x = new ConsentWebServiceDataTypes.EnableChannelConsentResponseType();
                response_x.responseBody = new ConsentWebServiceDataTypes.EnableChannelConsentResponseBodyType();
                response_x.responseBody.consentGuid = '3267wergjs' + MockServicesUtil.generateUUID();
                response.put('response_x', response_x); 
            } else if (requestName.contains('DisableChannelConsent')) {
                ConsentWebServiceDataTypes.DisableChannelConsentResponseType response_x = new ConsentWebServiceDataTypes.DisableChannelConsentResponseType();
                response_x.responseBody = new ConsentWebServiceDataTypes.DisableChannelConsentResponseBodyType();
                response_x.responseBody.success = new BasicTypes.OperationSuccessType();
                response_x.responseBody.success.Successful = true;
                response.put('response_x', response_x); 
            }
        }
    }

    global class InternalConsentMock implements WebServiceMock {
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
            ConsentWebServiceDataTypes.EnableInternalConsentResponseType response_x = new ConsentWebServiceDataTypes.EnableInternalConsentResponseType();
            response_x.responseBody = new ConsentWebServiceDataTypes.EnableInternalConsentResponseBodyType();
            response_x.responseBody.consentGuid = 'kdslfn450' + MockServicesUtil.generateUUID();
            response.put('response_x', response_x); 
        }
    }
}
