@isTest
private class GeneralConsentEnablementTest {
    PRIVATE STATIC FINAL STRING INSERTED_AGENT_CPU = '3244223csadv4';
    PRIVATE STATIC FINAL STRING NON_EXIST_AGENT_CPU = '32442igiiyg';
    
    @TestSetup
	private static void testSetup() {
		User u1 = TestDataFactory.getUser(new User());
        u1.CommissionAccountBase__c = '';
		insert u1;
        
        User u2 = TestDataFactory.getUser(new User());
        u2.CommissionAccountBase__c = INSERTED_AGENT_CPU;
		insert u2;
	}

	@isTest
	private static void testCheckAgentCPU() {
        Boolean hasAgentCPUEmpty = GeneralConsentEnablement.checkAgentCPU(NON_EXIST_AGENT_CPU);
        Boolean hasAgentCPUrandom = GeneralConsentEnablement.checkAgentCPU(INSERTED_AGENT_CPU);
        System.assertEquals(false, hasAgentCPUEmpty, 'Agent CPU doesnt exist, it must be false.');
        System.assertEquals(true, hasAgentCPUrandom, 'Agent CPU exist, it must be equal to assigned one.');
    }
}