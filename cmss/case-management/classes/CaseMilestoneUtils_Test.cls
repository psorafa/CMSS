/**
 * Created by a.olexova on 5/20/2020.
 */

@isTest
private class CaseMilestoneUtils_Test {
	static Case c1WithResponseSent;
	static Case c2WithResponseSent;
	static Case c3WithConfirmationSent;
	static Case c4WithConfirmationSent;

	static void testSetup() {
		insert TestDataFactory.getNumericalSettings();
		Account acc = new Account(
			RecordTypeId = RecordTypeUtils.getRecordTypeIdByDeveloperName('PersonAccount', 'Account'),
			FirstName = 'Filip',
			LastName = 'Fiala',
			Phone = '111222333',
			GlobalId__c = 'Test123'
		);
		insert acc;
		Entitlement ent = new Entitlement(
			Name = 'Default',
			AccountId = acc.Id,
			SlaProcessId = [SELECT Id FROM SlaProcess WHERE Name = 'claim management' LIMIT 1]
			.Id,
			StartDate = Date.today().addDays(-100),
			EndDate = Date.today().addDays(20000)
		);
		insert ent;
		ClientClaimEntitlement__c csEntitlement = new ClientClaimEntitlement__c(
			SetupOwnerId = UserInfo.getOrganizationId(),
			EntitlementId__c = ent.Id,
			ReceivingConfirmationMilestoneName__c = 'Odeslání potvrzení o přijetí podání',
			ResponseSentMilestoneName__c = 'Odeslání odpovědi na podání'
		);
		insert csEntitlement;

		User defaultCaseOwner = TestDataFactory.getUser(new User());
		insert defaultCaseOwner;

		List<PermissionSet> permSets = [
			SELECT Id
			FROM PermissionSet
			WHERE Name = 'GDPRCaseManager' OR Name = 'ClientOmbudsman' OR Name = 'CaseManager'
			ORDER BY Name
		];
		System.runAs(defaultCaseOwner) {
			PermissionSetAssignment psa1 = new PermissionSetAssignment(
				AssigneeId = defaultCaseOwner.Id,
				PermissionSetId = permSets[0].Id
			);
			PermissionSetAssignment psa2 = new PermissionSetAssignment(
				AssigneeId = defaultCaseOwner.Id,
				PermissionSetId = permSets[1].Id
			);
			PermissionSetAssignment psa3 = new PermissionSetAssignment(
				AssigneeId = defaultCaseOwner.Id,
				PermissionSetId = permSets[2].Id
			);
			insert new List<PermissionSetAssignment>{ psa1, psa2, psa3 };
		}

		String clientClaimRTId = RecordTypeUtils.getRecordTypeIdByDeveloperName('NewClientClaim', 'Case');
		c1WithResponseSent = new Case(
			OwnerId = defaultCaseOwner.Id,
			RecordTypeId = clientClaimRTId,
			ReceivedDate__c = Date.today().addDays(-50),
			Origin = '1',
			Source__c = '1',
			AccountId = acc.Id,
			EntitlementId = ent.Id,
			ResponseSentDate__c = Date.today().addDays(-4),
			ComplaintLegitimacy__c = '4',
			ThirtyDayPeriodOverReason__c = 'Reason'
		);
		c2WithResponseSent = new Case(
			OwnerId = defaultCaseOwner.Id,
			RecordTypeId = clientClaimRTId,
			ReceivedDate__c = Date.today().addDays(-10),
			Origin = '1',
			Source__c = '1',
			AccountId = acc.Id,
			EntitlementId = ent.Id,
			ResponseSentDate__c = Date.today(),
			ComplaintLegitimacy__c = '4',
			ThirtyDayPeriodOverReason__c = 'Reason'
		);
		c3WithConfirmationSent = new Case(
			OwnerId = defaultCaseOwner.Id,
			RecordTypeId = clientClaimRTId,
			ReceivedDate__c = Date.today().addDays(-3),
			Origin = '1',
			Source__c = '1',
			AccountId = acc.Id,
			EntitlementId = ent.Id,
			ReceivingConfirmationDate__c = Date.today().addDays(-2),
			ComplaintLegitimacy__c = '4',
			ThirtyDayPeriodOverReason__c = 'Reason'
		);
		c4WithConfirmationSent = new Case(
			OwnerId = defaultCaseOwner.Id,
			RecordTypeId = clientClaimRTId,
			ReceivedDate__c = Date.today().addDays(-3),
			Origin = '1',
			Source__c = '1',
			AccountId = acc.Id,
			EntitlementId = ent.Id,
			ReceivingConfirmationDate__c = Date.today(),
			ComplaintLegitimacy__c = '4',
			ThirtyDayPeriodOverReason__c = 'Reason'
		);
		System.runAs(defaultCaseOwner) {
			insert new List<Case>{
				c1WithResponseSent,
				c2WithResponseSent,
				c3WithConfirmationSent,
				c4WithConfirmationSent
			};
		}
	}

	@isTest
	static void testCompleteMilestoneExplicitDate() {
		testSetup();
		Set<Id> caseIds = new Set<Id>{
			c1WithResponseSent.Id,
			c2WithResponseSent.Id,
			c3WithConfirmationSent.Id,
			c4WithConfirmationSent.Id
		};
		Datetime completionDate = Datetime.now().addHours(-12);
		ClientClaimEntitlement__c csEntitlement = ClientClaimEntitlement__c.getOrgDefaults();
		System.assertNotEquals(null, csEntitlement, 'Custom setting record not existing.');
		Test.startTest();
		CaseMilestoneUtils.completeMilestones(caseIds, csEntitlement.ResponseSentMilestoneName__c, completionDate);
		Test.stopTest();
		List<CaseMilestone> caseMilestones = [
			SELECT Id, CaseId, CompletionDate, MilestoneType.Name, IsCompleted, IsViolated
			FROM CaseMilestone
			WHERE CaseId IN :caseIds
		];
		System.assert(!caseMilestones.isEmpty(), 'Case Milestones not found.');
		for (CaseMilestone cm : caseMilestones) {
			if (csEntitlement.ResponseSentMilestoneName__c == cm.MilestoneType.Name) {
				System.assertEquals(true, cm.IsCompleted, 'Case Milestone should be completed');
				System.assertEquals(
					completionDate,
					cm.CompletionDate,
					'Case Milestone Completion Date not as expected for Case Id: ' +
					cm.CaseId +
					' and Milestone Type: ' +
					cm.MilestoneType.Name
				);
			} else {
				System.assertEquals(false, cm.IsCompleted, 'Case Milestone should NOT be completed yet.');
				System.assertEquals(
					null,
					cm.CompletionDate,
					'Case Milestone Completion Date should be not filled for for Case Id: ' +
					cm.CaseId +
					' and Milestone Type: ' +
					cm.MilestoneType.Name
				);
			}
		}
	}

	@isTest
	static void testCompleteMilestoneResponseSent() {
		testSetup();
		Set<Id> caseIds = new Set<Id>{
			c1WithResponseSent.Id,
			c2WithResponseSent.Id,
			c3WithConfirmationSent.Id,
			c4WithConfirmationSent.Id
		};

		ClientClaimEntitlement__c csEntitlement = ClientClaimEntitlement__c.getOrgDefaults();
		System.assertNotEquals(null, csEntitlement, 'Custom setting record not existing.');
		Test.startTest();
		CaseMilestoneUtils.completeMilestones(caseIds, csEntitlement.ResponseSentMilestoneName__c, null);
		Test.stopTest();
		List<CaseMilestone> caseMilestones = [
			SELECT Id, CaseId, CompletionDate, MilestoneType.Name, IsCompleted, IsViolated
			FROM CaseMilestone
			WHERE CaseId IN :caseIds
		];
		System.assert(!caseMilestones.isEmpty(), 'Case Milestones not found.');
		for (CaseMilestone cm : caseMilestones) {
			if (
				csEntitlement.ResponseSentMilestoneName__c == cm.MilestoneType.Name &&
				(c1WithResponseSent.Id == cm.CaseId ||
				c2WithResponseSent.Id == cm.CaseId)
			) {
				System.assertEquals(true, cm.IsCompleted, 'Case Milestone should be completed');
				if (c1WithResponseSent.Id == cm.CaseId) {
					System.assertEquals(
						c1WithResponseSent.ResponseSentDate__c,
						Date.newInstance(cm.CompletionDate.year(), cm.CompletionDate.month(), cm.CompletionDate.day()),
						'Case Milestone Completion Date not as expected for Case 1'
					);
				} else if (c2WithResponseSent.Id == cm.CaseId) {
					System.assertEquals(
						c2WithResponseSent.ResponseSentDate__c,
						Date.newInstance(cm.CompletionDate.year(), cm.CompletionDate.month(), cm.CompletionDate.day()),
						'Case Milestone Completion Date not as expected for Case 2'
					);
				}
			} else {
				System.assertEquals(false, cm.IsCompleted, 'Case Milestone should NOT be completed yet.');
				System.assertEquals(
					null,
					cm.CompletionDate,
					'Case Milestone Completion Date should be not filled for for Case Id: ' +
					cm.CaseId +
					' and Milestone Type: ' +
					cm.MilestoneType.Name
				);
			}
		}
	}

	@isTest
	static void testCompleteMilestoneConfirmationSent() {
		testSetup();
		Set<Id> caseIds = new Set<Id>{
			c1WithResponseSent.Id,
			c2WithResponseSent.Id,
			c3WithConfirmationSent.Id,
			c4WithConfirmationSent.Id
		};

		ClientClaimEntitlement__c csEntitlement = ClientClaimEntitlement__c.getOrgDefaults();
		System.assertNotEquals(null, csEntitlement, 'Custom setting record not existing.');
		Test.startTest();
		CaseMilestoneUtils.completeMilestones(caseIds, csEntitlement.ReceivingConfirmationMilestoneName__c, null);
		Test.stopTest();
		List<CaseMilestone> caseMilestones = [
			SELECT Id, CaseId, CompletionDate, MilestoneType.Name, IsCompleted, IsViolated
			FROM CaseMilestone
			WHERE CaseId IN :caseIds
		];
		System.assert(!caseMilestones.isEmpty(), 'Case Milestones not found.');
		for (CaseMilestone cm : caseMilestones) {
			if (
				csEntitlement.ReceivingConfirmationMilestoneName__c == cm.MilestoneType.Name &&
				(c3WithConfirmationSent.Id == cm.CaseId ||
				c4WithConfirmationSent.Id == cm.CaseId)
			) {
				System.assertEquals(true, cm.IsCompleted, 'Case Milestone should be completed');
				if (c3WithConfirmationSent.Id == cm.CaseId) {
					System.assertEquals(
						c3WithConfirmationSent.ReceivingConfirmationDate__c,
						Date.newInstance(cm.CompletionDate.year(), cm.CompletionDate.month(), cm.CompletionDate.day()),
						'Case Milestone Completion Date not as expected for Case 1'
					);
				} else if (c4WithConfirmationSent.Id == cm.CaseId) {
					System.assertEquals(
						c4WithConfirmationSent.ReceivingConfirmationDate__c,
						Date.newInstance(cm.CompletionDate.year(), cm.CompletionDate.month(), cm.CompletionDate.day()),
						'Case Milestone Completion Date not as expected for Case 2'
					);
				}
			} else {
				System.assertEquals(false, cm.IsCompleted, 'Case Milestone should NOT be completed yet.');
				System.assertEquals(
					null,
					cm.CompletionDate,
					'Case Milestone Completion Date should be not filled for for Case Id: ' +
					cm.CaseId +
					' and Milestone Type: ' +
					cm.MilestoneType.Name
				);
			}
		}
	}
}
