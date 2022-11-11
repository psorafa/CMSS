/**
 * Created by J.Birka on 11.11.2022
 */
@IsTest
private class OpportunityControllerTest {
    static OpportunityController.OpportunityControllerDTO resultGood;
    static OpportunityController.OpportunityControllerDTO resultError;
    static OpportunityController.OpportunityControllerDTO resultNull;     
    
	private static Account createTestAccount(String name) {
        Account a = new Account(Name=name);
		insert a;
        return a;
	}
	
    private static Task createTestTask(Id accId) {
        Task t = new Task(WhatId = accId);
		insert t;
        return t;
	} 

    private static Opportunity createTestOpportunity(String name) {
        Opportunity o = new Opportunity(Name=name, StageName='1', CloseDate=System.today());
		insert o;
        return o;
	}    
    
    @IsTest
    static void OpportunityControllerTest() {
        Account acc = createTestAccount('Test Account');
		resultGood = OpportunityController.createOpportunity(acc.Id);
        Id opptyAccountId = [Select AccountId from Opportunity Limit 1][0].AccountId;
        System.assertEquals(acc.Id, opptyAccountId, 'OpportunityId from Account context not as expected.');
        
        Opportunity opp = createTestOpportunity('Test Opportunity');
		resultGood = OpportunityController.createOpportunity(opp.Id);
        Id opptyId = [Select Id from Opportunity Where Name='Test Opportunity' Limit 1][0].Id;
        System.assertEquals(opp.Id, opptyId, 'OpportunityId from Opportunity context not as expected.');

        Task tsk = createTestTask(acc.Id);
		resultGood = OpportunityController.createOpportunity(tsk.Id);
        Id opptyAccountId2 = [Select AccountId from Opportunity Where Name='eÚvěry' Limit 1][0].AccountId;
        System.debug('tsk.WhatId' + tsk.WhatId);
        System.debug('opptyAccountId2' + opptyAccountId2);
        System.assertEquals(tsk.WhatId, opptyAccountId2, 'OpportunityId from Task context not as expected.'); 
        
		resultGood = OpportunityController.createOpportunity('');
        Opportunity opptyId2 = [Select Id from Opportunity Where Id = :resultGood.OpportunityId];
        System.assertEquals(resultGood.OpportunityId, opptyId2.Id, 'OpportunityId from HomePage context not as expected.');        
       	
        resultError = OpportunityController.createOpportunity('123');
		System.assert(!String.isBlank(resultError.ErrorMessage), 'ErrorMessage not as expected.');  
        
        Contact c = new Contact(LastName='Test Contact');
        insert c;
        resultNull = OpportunityController.createOpportunity(c.Id);
		System.assertEquals(null, resultNull, 'Result not as expected.');         
    }
}