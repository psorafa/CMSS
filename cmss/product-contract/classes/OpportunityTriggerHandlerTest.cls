@Istest
public class OpportunityTriggerHandlerTest {
	@isTest
	static void accountFieldsUpdatedTest() {
		Account acc1 = TestDataFactory.getAccount(new Account());
		acc1.OpenedOpportunityDate__c = null;
		acc1.LastInteractionDate__c = null;
		insert acc1;

		Opportunity opportunity = TestDataFactory.getOpportunity();
		opportunity.AccountId = acc1.Id;
		opportunity.CloseDate = System.today().addDays(-2);
		insert opportunity;

		Account updatedAccount = [
			SELECT Id, OpenedOpportunityDate__c, LastInteractionDate__c
			FROM Account
			WHERE Id = :acc1.Id
		];

		System.assertEquals(null, updatedAccount.OpenedOpportunityDate__c);
		System.assertEquals(System.now().date(), updatedAccount.LastInteractionDate__c);

		opportunity.CloseDate = System.today().addDays(5);
		update opportunity;

		updatedAccount = [SELECT Id, OpenedOpportunityDate__c, LastInteractionDate__c FROM Account WHERE Id = :acc1.Id];

		System.assertEquals(opportunity.CloseDate, updatedAccount.OpenedOpportunityDate__c);
	}
}
