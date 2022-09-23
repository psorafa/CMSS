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
				Case.ResponseSentDate__c,
				Case.ReceivingConfirmationDate__c,
				MilestoneType.Name
			FROM CaseMilestone
			WHERE CaseId IN :caseIds AND MilestoneType.Name = :milestoneName AND CompletionDate = null
		];

		if (!caseMilestones.isEmpty()) {
			updateMilestones(caseMilestones, completionDate);
		}
	}

	public static void closeMilestones(Set<Id> caseIds, List<String> milestoneNames) {
		List<CaseMilestone> caseMilestones = [
			SELECT
				Id,
				CompletionDate,
				IsCompleted,
				MilestoneType.Name
			FROM CaseMilestone
			WHERE CaseId IN :caseIds AND MilestoneType.Name IN :milestoneNames AND CompletionDate = null
		];

		if (!caseMilestones.isEmpty()) {
			for (CaseMilestone cm : caseMilestones) {
				cm.CompletionDate = Date.Today();
			}
			update caseMilestones;
		}
	}

	private static void updateMilestones(List<CaseMilestone> caseMilestones, Datetime completionDate) {
		List<CaseMilestone> cmsToUpdate = new List<CaseMilestone>();
		ClientClaimEntitlement__c csEntitlementInfo = ClientClaimEntitlement__c.getOrgDefaults();

		for (CaseMilestone cm : caseMilestones) {
			Datetime originalCompletionDate = cm.CompletionDate;
			if (completionDate != null) {
				cm.CompletionDate = completionDate;
			} else if (csEntitlementInfo != null) {
				String responseMilestoneName = csEntitlementInfo.ResponseSentMilestoneName__c;
				String confirmMilestoneName = csEntitlementInfo.ReceivingConfirmationMilestoneName__c;

				if (
					String.isNotBlank(confirmMilestoneName) &&
						confirmMilestoneName == cm.MilestoneType.Name &&
						cm.Case.ReceivingConfirmationDate__c != null
				) {
					Date newCompletionDate = cm.Case.ReceivingConfirmationDate__c;
					Time newCompletionTime = newCompletionDate == Date.today()
						? Time.newInstance(Datetime.now().hour(), Datetime.now().minute(), Datetime.now().second(), 0)
						: Time.newInstance(20, 0, 0, 0);
					cm.CompletionDate = Datetime.newInstance(newCompletionDate, newCompletionTime);
				} else if (
					String.isNotBlank(responseMilestoneName) &&
						responseMilestoneName == cm.MilestoneType.Name &&
						cm.Case.ResponseSentDate__c != null
				) {
					Date newCompletionDate = cm.Case.ResponseSentDate__c;
					Time newCompletionTime = newCompletionDate == Date.today()
						? Time.newInstance(Datetime.now().hour(), Datetime.now().minute(), Datetime.now().second(), 0)
						: Time.newInstance(20, 0, 0, 0);
					cm.CompletionDate = Datetime.newInstance(newCompletionDate, newCompletionTime);
				}
			}
			if (originalCompletionDate != cm.CompletionDate) {
				cmsToUpdate.add(cm);
			}
		}
		update cmsToUpdate;
	}
}