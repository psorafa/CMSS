@isTest
global class PortfolioManagementServiceMock implements WebServiceMock {
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
        PortfolioManagementService.ChangeCPEClientStateResponse response_x = new PortfolioManagementService.ChangeCPEClientStateResponse();
        response_x.responseBody = new PortfolioManagementService.ChangeCPEClientStateResponseBody();
        response_x.responseBody.emptyElement = 'ok';
        response.put('response_x', response_x); 
    }
}