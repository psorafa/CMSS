@Istest
public class OpportunityTriggerHandlerTest {

	@IsTest
	public static void testSetStateCode() {
		Map<String, String> stageToStateMap = new Map<String, String>();
		for (OpportunityStateCodeMapping__mdt mapping : [SELECT StageName__c, StateCode__c FROM OpportunityStateCodeMapping__mdt]) {
			stageToStateMap.put(mapping.StageName__c, mapping.StateCode__c);
		}
		List<Opportunity> opportunities = new List<Opportunity>();
		for (String stage : stageToStateMap.keySet()) {
			opportunities.add(TestDataFactory.getOpportunity(new Opportunity(
				StageName = stageToStateMap.get(stage)
			)));
		}
		Test.startTest();
		insert opportunities;
		Test.stopTest();

		opportunities = [SELECT Id, StageName, StateCode__c FROM Opportunity];
		for (Opportunity opportunity: opportunities) {
			System.assertEquals(stageToStateMap.get(opportunity.StageName), opportunity.StateCode__c);
		}

		Opportunity o = TestDataFactory.getOpportunity(new Opportunity());
		insert o;
		o.StageName = '3';
		update o;
		o = [SELECT Id, StageName, StateCode__c FROM Opportunity WHERE Id = :o.Id];
		System.assertEquals(stageToStateMap.get(o.StageName), o.StateCode__c);
	}
}