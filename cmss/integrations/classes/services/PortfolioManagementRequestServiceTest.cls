@isTest
private class PortfolioManagementRequestServiceTest {

    @isTest
    static void testSetPortfolioManager() {
        User u = TestDataFactory.getUser(new User(CommissionAccountNr__c = 'CPU0'));
        User u2 = TestDataFactory.getUser(new User(CommissionAccountNr__c = 'CPU1'));
        insert new User[]{ u, u2 };

        Test.setMock(WebServiceMock.class, new PortfolioManagementServiceMock());
        PortfolioManagementRequest__c pmr = TestDataFactory.getPortfolioManagementRequest(new PortfolioManagementRequest__c());
        insert pmr;

        PortfolioManagementRequest__c queriedPMR = [SELECT PortfolioManager__c FROM PortfolioManagementRequest__c WHERE Id =: pmr.Id];
        System.assertEquals(u.Id, queriedPMR.PortfolioManager__c);

        pmr.PortfolioManagerCPU__c = u2.CommissionAccountNr__c;
        update pmr;

        queriedPMR = [SELECT PortfolioManager__c FROM PortfolioManagementRequest__c WHERE Id =: pmr.Id];
        System.assertEquals(u2.Id, queriedPMR.PortfolioManager__c);
    }

    @isTest
    static void testSetPortfolioManagerNotFound() {
        Test.setMock(WebServiceMock.class, new PortfolioManagementServiceMock());
        PortfolioManagementRequest__c pmr = TestDataFactory.getPortfolioManagementRequest(
            new PortfolioManagementRequest__c(PortfolioManagerCPU__c = '43429643927')
        );
        Boolean exceptionThrown = false;

        try {
            insert pmr;
        } catch(DmlException e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown);

        PortfolioManagementRequest__c[] queriedPMRs = [SELECT PortfolioManager__c FROM PortfolioManagementRequest__c WHERE Id =: pmr.Id];
        System.assertEquals(0, queriedPMRs.size());
    }

    @isTest
    static void testChangeCPEClientState() {
        User u = TestDataFactory.getUser(new User(CommissionAccountNr__c = 'CPU0'));
        insert new User[]{ u };
        Test.setMock(WebServiceMock.class, new PortfolioManagementServiceMock());
        PortfolioManagementRequest__c pmr = TestDataFactory.getPortfolioManagementRequest(new PortfolioManagementRequest__c());
        insert pmr;
    }
}
