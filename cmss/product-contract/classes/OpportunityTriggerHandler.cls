public class OpportunityTriggerHandler extends TriggerHandler {
	public override void beforeInsert() {
		setStateCodeField(Trigger.new);
	}

	public override void beforeUpdate() {
		setStateCodeField(Trigger.new);
	}

	// ***************************** handlers and helping methods***************************************** //

	@TestVisible
	private static void setStateCodeField(List<Opportunity> opportunities) {
		Map<String, String> stageToStateMap = new Map<String, String>();
		for (OpportunityStateCodeMapping__mdt mapping : [SELECT StageName__c, StateCode__c FROM OpportunityStateCodeMapping__mdt]) {
			stageToStateMap.put(mapping.StageName__c, mapping.StateCode__c);
		}
		for (Opportunity opportunity : opportunities) {
			opportunity.StateCode__c = stageToStateMap.get(opportunity.StageName);
		}
	}
}
