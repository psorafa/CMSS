@isTest
private class PortfolioManagementRequestServiceTest {

    @isTest
    static void testChangeCPEClientState() {
        Test.setMock(WebServiceMock.class, new PortfolioManagementServiceMock());

        PortfolioManagementRequest__c pmr = TestDataFactory.getPortfolioManagementRequest(new PortfolioManagementRequest__c());
        insert pmr;
    }
}
