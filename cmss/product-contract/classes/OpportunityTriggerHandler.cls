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
		handleInsertedOppsShares(Trigger.new);
	}

	public override void afterUpdate() {
		AQMessageService.handleUpdate(Trigger.new, Trigger.oldMap, Opportunity.SObjectType);
		handleUpdatedOppsShares(Trigger.old, Trigger.new);
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

	public void handleUpdatedOppsShares(SObject[] oldListSo, SObject[] newListSo) {
		// if (DataFactoryTest.shouldRunTrigger()) {
		List<Opportunity> oldOppList = (List<Opportunity>) oldListSo;
		List<Opportunity> oppList = (List<Opportunity>) newListSo;
		List<Opportunity> oppsWithNewOwner = new List<Opportunity>();
		Map<Id, Opportunity> oldOpps = new Map<Id, Opportunity>(oldOppList);

		List<Opportunity> assignAccessList = new List<Opportunity>();
		List<Opportunity> removeAccessList = new List<Opportunity>();
		for (Opportunity opp : oppList) {
			Opportunity oldOpp = oldOpps.get(opp.Id);

			if (opp.OwnerId != oldOpp.OwnerId) {
				removeAccessList.add(oldOpp);
				assignAccessList.add(opp);
			} else if (opp.CloseDate != oldOpp.CloseDate && opp.StageName != 'Closed Lost') {
				assignAccessList.add(opp);
			}
		}

		if (!removeAccessList.isEmpty())
			AccessShareController.removeOpportunityAccessBulk(removeAccessList);
		if (!assignAccessList.isEmpty())
			AccessShareController.assignOpportunityAccessBulk(assignAccessList);

		Set<Id> oppOwnersIds = new Set<Id>();
		for (Opportunity opp : oppList) {
			// if (opp.Batchcheckbox__c == true) { TODO VM k cemu to je??
			oppOwnersIds.add(opp.OwnerId);
			// }
		}

		// due Autoprolongation of opportunity update AccessShare
		List<AccessShare__c> accShares = AccessShareDao.getAllNonExpiredRecordsFromAccessShareByRequestedByIdsAndType(
			oppOwnersIds,
			'Opportunity'
		);
		// List<Opportunity> oppsToProlongate = OpportunityDao.getAllOpenOpportunitiesByUserIds(oppOwnersIds);
		List<Opportunity> oppsToProlongate = [SELECT Id, AccountId, OwnerId FROM Opportunity WHERE StateCode__c = '0'];

		List<Opportunity> oppsToUpdate = new List<Opportunity>();
		List<AccessShare__c> accSharesToUpdate = new List<AccessShare__c>();

		if (!oppsToProlongate.isEmpty()) {
			for (Opportunity opp : oppsToProlongate) {
				for (AccessShare__c accSh : accShares) {
					if (opp.AccountId != null) {
						if (
							opp.OwnerId == accSh.RequestedBy__c &&
							opp.AccountId == accSh.AccessTo__c &&
							opp.Id == accSh.Reason__c
						) {
							accSh.ExpirationDate__c = opp.CloseDate;
							// opp.Batchcheckbox__c = false; //TODO VM je to k necemu??
							accSharesToUpdate.add(accSh);
							oppsToUpdate.add(opp);
						}
					}
				}
			}

			update oppsToUpdate;
			update accSharesToUpdate;
		}
		// }
	}

	public void handleInsertedOppsShares(SObject[] soList) {
		AccessShareController.assignOpportunityAccessBulk(soList);

		// Set<Id> accIds = new Set<Id>();
		// Set<Id> accOwnersIds = new Set<Id>();

		// for (Opportunity opp : (List<Opportunity>) soList) {
		// 	oppListIds.add(opp.Id);

		// 	if (opp.AccountId != null) {
		// 		accIds.add(m_accountMapAfter.get(opp.AccountId).Id);
		// 		accOwnersIds.add(m_accountMapAfter.get(opp.AccountId).OwnerId);
		// 	}
		// }
	}
}
