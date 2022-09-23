/**
 * Created by a.olexova on 5/21/2020.
 */
public class CaseTriggerHandler extends TriggerHandler {
	public override void beforeInsert() {
		CaseService.validateOwnerPermission((List<Case>) Trigger.new, null);
		CaseService.assignCaseID(Trigger.new);
		CaseService.populateUserLookupsFromCPU(Trigger.new, null);
	}

	public override void beforeUpdate() {
		CaseService.validateOwnerPermission((List<Case>) Trigger.new, (Map<Id, Case>) Trigger.oldMap);
		CaseService.populateUserLookupsFromCPU(Trigger.new, (Map<Id, Case>) Trigger.oldMap);
	}

	public override void afterInsert() {
		CaseService.setGDPRAndClientCaseOnAccount((List<Case>) Trigger.new, (Map<Id, Case>) Trigger.oldMap);
	}

	public override void afterUpdate() {
		List<Case> newList = Trigger.new;
		Map<Id, Case> oldMap = (Map<Id, Case>) Trigger.oldMap;

		handleMilestoneCompletion(newList, oldMap);
		handleMilestoneForCloseCases(newList);
		CaseService.setGDPRAndClientCaseOnAccount((List<Case>) Trigger.new, (Map<Id, Case>) Trigger.oldMap);
	}

	public override void beforeDelete() {
		preventDeletion(Trigger.old);
	}

	public override void afterDelete() {
		CaseService.setGDPRAndClientCaseOnAccount((List<Case>) Trigger.old, null);
	}

	// ***************************** handlers and helping methods***************************************** //

	/**
	 * @author petr bartonicek
	 * @description check if the any case is closed, if yes close the milestones
	 * @param newList is Trigger.New reference
	 */
	private void handleMilestoneForCloseCases(List<Case> newList) {
		ClientClaimEntitlement__c csEntitlementInfo = ClientClaimEntitlement__c.getOrgDefaults();
		Set<Id> relevantCaseIdsToCloseMilestone = new Set<Id>();

		for (Case newCase : newList) {
			if (newCase.IsClosed == true) {
				relevantCaseIdsToCloseMilestone.add(newCase.Id);
			}
		}

		if (!relevantCaseIdsToCloseMilestone.isEmpty() && csEntitlementInfo != null) {
			//String responseMilestoneName = csEntitlementInfo.ResponseSentMilestoneName__c;
			String confirmMilestoneName = csEntitlementInfo.ReceivingConfirmationMilestoneName__c;
			List<String> milestonesNames = new List<String>{confirmMilestoneName};
			CaseMilestoneUtils.closeMilestones(relevantCaseIdsToCloseMilestone, milestonesNames);
		}
	}

	/**
	 * @author andrea olexova
	 * @description method to handle completion of relevant case milestones when particulat updates to cases occur
	 *   created for story CRM-284
	 * @param newList is Trigger.New reference, @param oldMap is Trigger.OldMap reference
	 */
	private void handleMilestoneCompletion(List<Case> newList, Map<Id, Case> oldMap) {
		Set<Id> relevantCaseIdsConfirmation = new Set<Id>();
		Set<Id> relevantCaseIdsResponse = new Set<Id>();

		for (Case newCase : newList) {
			if (isRelevantForAction(newCase, oldMap, ACTION_COMPLETE_RESPONSE_MILESTONE)) {
				relevantCaseIdsResponse.add(newCase.Id);
			}
			if (isRelevantForAction(newCase, oldMap, ACTION_COMPLETE_CONFIRMATION_MILESTONE)) {
				relevantCaseIdsConfirmation.add(newCase.Id);
			}
		}
		if (!relevantCaseIdsResponse.isEmpty() || !relevantCaseIdsConfirmation.isEmpty()) {
			completeRelevantMilestones(relevantCaseIdsResponse, relevantCaseIdsConfirmation);
		}
	}

	@TestVisible
	private static final String ACTION_COMPLETE_RESPONSE_MILESTONE = 'COMPLETE_RESPONSE_MILESTONE';
	@TestVisible
	private static final String ACTION_COMPLETE_CONFIRMATION_MILESTONE = 'COMPLETE_CONFIRMATION_MILESTONE';

	/**
	 * @author andrea olexova
	 * @description method to check whether the current case meets the criteria for the particular action name
	 */
	@TestVisible
	private static Boolean isRelevantForAction(Case newCase, Map<Id, Case> oldMap, String actionName) {
		Case oldCase = oldMap != null ? oldMap.get(newCase.Id) : null;
		if (
			ACTION_COMPLETE_RESPONSE_MILESTONE == actionName && newCase.IsClientClaim__c &&
				String.isNotBlank(newCase.EntitlementId) &&
				newCase.ResponseSentDate__c != null &&
				oldCase != null &&
				oldCase.ResponseSentDate__c != newCase.ResponseSentDate__c
		) {
			return true;
		} else if (
			ACTION_COMPLETE_CONFIRMATION_MILESTONE == actionName && newCase.IsClientClaim__c &&
				String.isNotBlank(newCase.EntitlementId) &&
				newCase.ReceivingConfirmationDate__c != null &&
				oldCase != null &&
				oldCase.ReceivingConfirmationDate__c != newCase.ReceivingConfirmationDate__c
		) {
			return true;
		}
		return false;
	}

	/**
	 * @author andrea olexova
	 * @description method to call the method from CaseMilestoneUtils class with relevant parameters
	 *   created for story CRM-284
	 */
	@TestVisible
	private static void completeRelevantMilestones(Set<Id> caseIdsResponse, Set<Id> caseIdsConfirmation) {
		ClientClaimEntitlement__c csEntitlementInfo = ClientClaimEntitlement__c.getOrgDefaults();
		if (csEntitlementInfo != null) {
			String responseMilestoneName = csEntitlementInfo.ResponseSentMilestoneName__c;
			String confirmMilestoneName = csEntitlementInfo.ReceivingConfirmationMilestoneName__c;
			if (!caseIdsResponse.isEmpty() && String.isNotBlank(responseMilestoneName)) {
				CaseMilestoneUtils.completeMilestones(caseIdsResponse, responseMilestoneName, null);
			}
			if (!caseIdsConfirmation.isEmpty() && String.isNotBlank(confirmMilestoneName)) {
				CaseMilestoneUtils.completeMilestones(caseIdsConfirmation, confirmMilestoneName, null);
			}
		}
	}

	@TestVisible
	private static void preventDeletion(List<Case> cases) {
		if (!FeatureManagement.checkPermission('DeleteCases')) {
			for (Case c : cases) {
				c.addError(Label.YouDoNotHavePermissionToDeleteCases);
			}
		}
	}
}