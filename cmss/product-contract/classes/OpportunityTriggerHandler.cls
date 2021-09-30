public class OpportunityTriggerHandler extends TriggerHandler {
	public override void beforeInsert() {
		IntegrationUtility.populateDefaultExternalId(Trigger.new);
	}

	public override void beforeUpdate() {
		IntegrationUtility.populateDefaultExternalId(Trigger.new);
	}

	public override void beforeDelete() {
		AQMessageService.handleDelete(Trigger.old, Opportunity.SObjectType);
	}

	public override void afterInsert() {
		AQMessageService.handleInsert(Trigger.new, Opportunity.SObjectType);
		handleUpdateAccountDateFields();
		// handleInsertedOppsShares(Trigger.new);
	}

	public override void afterUpdate() {
		AQMessageService.handleUpdate(Trigger.new, Trigger.oldMap, Opportunity.SObjectType);
		handleUpdateAccountDateFields();
		// handleAfterUpdateOppsShares(Trigger.old, Trigger.new);
	}

	public override void afterUndelete() {
		AQMessageService.handleInsert(Trigger.new, Opportunity.SObjectType);
	}

	// ***************************** handlers and helping methods***************************************** //

	public void handleUpdateAccountDateFields() {
		Set<Account> accountsToUpdate = new Set<Account>();
		Map<Id, Opportunity> opportunityWithAccount = new Map<Id, Opportunity>(
			[
				SELECT AccountId, Account.LastInteractionDate__c, Account.OpenedOpportunityDate__c
				FROM Opportunity
				WHERE Id IN :Trigger.newMap.keySet()
			]
		);

		for (Opportunity newOpportunity : (Opportunity[]) Trigger.new) {
			Opportunity oldOpportunity = (Opportunity) (Trigger.isInsert
				? new Opportunity()
				: Trigger.oldMap.get(newOpportunity.Id));
			Account actualOpportunityAccount = opportunityWithAccount.get(newOpportunity.Id)?.Account;
			if (actualOpportunityAccount == null) {
				continue;
			}
			if (
				newOpportunity.LastModifiedDate != oldOpportunity?.LastModifiedDate &&
				newOpportunity.LastModifiedDate.date() <= Date.today() &&
				(newOpportunity.LastModifiedDate > actualOpportunityAccount?.LastInteractionDate__c ||
				actualOpportunityAccount?.LastInteractionDate__c == null)
			) {
				actualOpportunityAccount.LastInteractionDate__c = (Date) newOpportunity.LastModifiedDate.date();
				accountsToUpdate.add(actualOpportunityAccount);
			}

			if (
				newOpportunity.CloseDate != oldOpportunity?.CloseDate &&
				newOpportunity.CloseDate > Date.today() &&
				(newOpportunity.StageName == '1' ||
				newOpportunity.StageName == '2' ||
				newOpportunity.StageName == '3') &&
				(newOpportunity.CloseDate < actualOpportunityAccount?.OpenedOpportunityDate__c ||
				actualOpportunityAccount?.OpenedOpportunityDate__c == null)
			) {
				actualOpportunityAccount.OpenedOpportunityDate__c = newOpportunity.CloseDate;
				accountsToUpdate.add(actualOpportunityAccount);
			}
		}

		update new List<Account>(new Set<Account>(accountsToUpdate));
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
