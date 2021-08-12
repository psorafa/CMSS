public class OpportunityTriggerHandler extends TriggerHandler {
	public override void beforeInsert() {
		setStateCodeField(Trigger.new);
		IntegrationUtility.populateDefaultExternalId(Trigger.new);
	}

	public override void beforeUpdate() {
		setStateCodeField(Trigger.new);
		IntegrationUtility.populateDefaultExternalId(Trigger.new);
	}

	public override void beforeDelete() {
		AQMessageService.handleDelete(Trigger.old, Opportunity.SObjectType);
	}

	public override void afterInsert() {
		AQMessageService.handleInsert(Trigger.new, Opportunity.SObjectType);
		// handleInsertedOppsShares(Trigger.new);
	}

	public override void afterUpdate() {
		AQMessageService.handleUpdate(Trigger.new, Trigger.oldMap, Opportunity.SObjectType);
		// handleAfterUpdateOppsShares(Trigger.old, Trigger.new);
	}

	public override void afterUndelete() {
		AQMessageService.handleInsert(Trigger.new, Opportunity.SObjectType);
	}

	// ***************************** handlers and helping methods***************************************** //

	@TestVisible
	private static void setStateCodeField(List<Opportunity> opportunities) {
		Map<String, String> stageToStateMap = new Map<String, String>();
		for (OpportunityStateCodeMapping__mdt mapping : [
			SELECT StageName__c, StateCode__c
			FROM OpportunityStateCodeMapping__mdt
		]) {
			stageToStateMap.put(mapping.StageName__c, mapping.StateCode__c);
		}
		for (Opportunity opportunity : opportunities) {
			opportunity.StateCode__c = stageToStateMap.get(opportunity.StageName);
		}
	}

	private void handleAfterUpdateOppsShares(SObject[] oldListSo, SObject[] newListSo) {
		List<Opportunity> oldOppList = (List<Opportunity>) oldListSo;
		List<Opportunity> oppList = (List<Opportunity>) newListSo;
		List<Opportunity> oppsWithNewOwner = new List<Opportunity>();
		Map<Id, Opportunity> oldOpps = new Map<Id, Opportunity>(oldOppList);

		List<Opportunity> assignAccessList = new List<Opportunity>();
		List<Opportunity> removeAccessList = new List<Opportunity>();

		List<String> closedLostOppStages = new List<String>{ '4', '5', '7' };

		for (Opportunity opp : oppList) {
			Opportunity oldOpp = oldOpps.get(opp.Id);

			if (opp.OwnerId != oldOpp.OwnerId) {
				removeAccessList.add(oldOpp);
				assignAccessList.add(opp);
			} else if (opp.StageName != oldOpp.StageName) {
				if (!closedLostOppStages.contains(opp.StageName)) {
					assignAccessList.add(opp);
				} else {
					removeAccessList.add(opp);
				}
			}
		}

		if (!removeAccessList.isEmpty())
			AccessShareController.removeOpportunityAccessBulk(removeAccessList);
		if (!assignAccessList.isEmpty())
			AccessShareController.assignOpportunityAccessBulk(assignAccessList);
	}

	public void handleInsertedOppsShares(SObject[] soList) {
		AccessShareController.assignOpportunityAccessBulk(soList);
	}
}
