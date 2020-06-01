/**
 * Created by a.olexova on 5/20/2020.
 */

public with sharing class CaseMilestoneUtils {
	public static void completeMilestones(Set<Id> caseIds, String milestoneName, Datetime completionDate) {
		List<CaseMilestone> caseMilestones = [
			SELECT
				Id,
				CompletionDate,
				IsCompleted,
				Case.ResponseSent__c,
				Case.ComplaintReceivingConfirmation__c,
				MilestoneType.Name
			FROM CaseMilestone
			WHERE CaseId IN :caseIds AND MilestoneType.Name = :milestoneName AND CompletionDate = null
		];

		if (!caseMilestones.isEmpty()) {
			updateMilestones(caseMilestones, completionDate);
		}
	}

	private static void updateMilestones(List<CaseMilestone> caseMilestones, Datetime completionDate) {
		List<CaseMilestone> cmsToUpdate = new List<CaseMilestone>();
		ClientClaimEntitlement__c csEntitlementInfo = ClientClaimEntitlement__c.getInstance();

		for (CaseMilestone cm : caseMilestones) {
			Datetime originalCompletionDate = cm.CompletionDate;
			if (completionDate != null) {
				cm.CompletionDate = completionDate;
			} else if (csEntitlementInfo != null) {
				String responseMilestoneName = csEntitlementInfo.ResponseSentMilestoneName__c;
				String confirmMilestoneName = csEntitlementInfo.ReceivingConfirmationMilestoneName__c;

				if (String.isNotBlank(confirmMilestoneName) && confirmMilestoneName == cm.MilestoneType.Name) {
					cm.CompletionDate = cm.Case.ComplaintReceivingConfirmation__c;
				} else if (String.isNotBlank(responseMilestoneName) && responseMilestoneName == cm.MilestoneType.Name) {
					cm.CompletionDate = cm.Case.ResponseSent__c;
				}
			}
			if (originalCompletionDate != cm.CompletionDate) {
				cmsToUpdate.add(cm);
			}
		}
		update cmsToUpdate;
	}
}
