/**
 * Created by J.Birka on 11.11.2022
 */
@IsTest
private class OpportunityControllerTest {
	static Id resultGood;
	static Id resultError;
	static String resultErrorString;
	static Id resultNull;

	@IsTest
	static void OpportunityControllerTest() {
		Account acc = TestDataFactory.getAccount(new Account(GlobalId__c = 'GLID'));
		insert acc;

		resultGood = OpportunityController.createOpportunity(acc.Id);
		Id opptyAccountId = [SELECT AccountId FROM Opportunity LIMIT 1][0].AccountId;
		System.assertEquals(acc.Id, opptyAccountId, 'OpportunityId from Account context not as expected.');
		delete resultGood.getSobjectType().newSObject(resultGood);

		Opportunity opp = TestDataFactory.getOpportunity(new Opportunity(AccountId = acc.Id));
		insert opp;
		resultGood = OpportunityController.createOpportunity(opp.Id);
		System.assertEquals(opp.Id, resultGood, 'OpportunityId from Opportunity context not as expected.');

		Task tsk = TestDataFactory.getTask(new Task(WhatId = acc.Id));
		insert tsk;
		resultGood = OpportunityController.createOpportunity(tsk.Id);
		Id opptyAccountId2 = [SELECT AccountId FROM Opportunity WHERE Name = 'eÚvěry' LIMIT 1][0].AccountId;
		System.debug('tsk.WhatId' + tsk.WhatId);
		System.debug('opptyAccountId2' + opptyAccountId2);
		System.assertEquals(tsk.WhatId, opptyAccountId2, 'OpportunityId from Task context not as expected.');

		resultGood = OpportunityController.createOpportunity('');
		Opportunity opptyId2 = [SELECT Id FROM Opportunity WHERE Id = :resultGood];
		System.assertEquals(resultGood, opptyId2.Id, 'OpportunityId from HomePage context not as expected.');

		try {
			resultError = OpportunityController.createOpportunity('123');
		} catch (Exception e) {
			resultErrorString = e.getMessage();
		} finally {
			System.assert(!String.isBlank(resultErrorString), 'ErrorMessage not as expected.');
		}

		Asset ass = TestDataFactory.getAsset(new Asset());
		insert ass;
		resultNull = OpportunityController.createOpportunity(ass.Id);
		System.assertEquals(null, resultNull, 'Result not as expected. Returned: ' + resultNull);
	}
}
