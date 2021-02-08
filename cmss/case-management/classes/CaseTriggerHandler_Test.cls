/**
 * Created by a.olexova on 5/21/2020.
 */

@IsTest
private class CaseTriggerHandler_Test {
	static Case c1;
	static Case c2;
	static Case c3;

	static void testSetup() {
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

		String clientClaimRTId = RecordTypeUtils.getRecordTypeIdByDeveloperName('NewClientClaim', 'Case');
		c1 = TestDataFactory.getCase(new Case(
			RecordTypeId = clientClaimRTId,
			ReceivedDate__c = Date.today().addDays(-50),
			Origin = '1',
			Source__c = '1',
			AccountId = acc.Id,
			EntitlementId = ent.Id
		));
		c2 = TestDataFactory.getCase(new Case(
			RecordTypeId = clientClaimRTId,
			ReceivedDate__c = Date.today().addDays(-10),
			Origin = '1',
			Source__c = '1',
			AccountId = acc.Id,
			EntitlementId = ent.Id
		));
		c3 = TestDataFactory.getCase(new Case(
			RecordTypeId = clientClaimRTId,
			ReceivedDate__c = Date.today().addDays(-3),
			Origin = '1',
			Source__c = '1',
			AccountId = acc.Id,
			EntitlementId = ent.Id
		));
		insert new List<Case>{
			c1, c2, c3
		};
		CaseType__c ct1 = TestDataFactory.getCaseType(new CaseType__c(Case__c = c1.Id));
		CaseType__c ct2 = TestDataFactory.getCaseType(new CaseType__c(Case__c = c2.Id));
		CaseType__c ct3 = TestDataFactory.getCaseType(new CaseType__c(Case__c = c3.Id));
		insert new List<CaseType__c>{
			ct1, ct2, ct3
		};
	}

	@IsTest
	static void testHandleMilestoneCompletionNoUpdate() {
		User caseManager = TestDataFactory.getUser(new User());
		insert caseManager;
		insert TestDataFactory.getPermissionSetAssignments(caseManager.Id);
		TestDataFactory.defaultCaseOwner = caseManager;
		System.runAs(caseManager) {
			testSetup();
			Set<Id> caseIds = new Set<Id>{
				c1.Id, c2.Id, c3.Id
			};
			Date completionDate = Date.today().addDays(-1);

			c1.ReceivedDate__c = completionDate;
			c1.ComplainerFirstName__c = 'testFirstName';
			c1.ComplainerFirstName__c = 'testLastName';
			c2.Source__c = '2';
			c2.Description = 'descrioption 123';
			c3.Origin = '2';

			Test.startTest();
			update new List<Case>{
				c1, c2, c3
			};
			Test.stopTest();

			List<CaseMilestone> caseMilestones = [
				SELECT Id, CaseId, CompletionDate, MilestoneType.Name, IsCompleted, IsViolated
				FROM CaseMilestone
				WHERE CaseId IN :caseIds
			];
			System.assert(!caseMilestones.isEmpty(), 'Case Milestones not found.');
			for (CaseMilestone cm : caseMilestones) {
				System.assertEquals(false, cm.IsCompleted, 'Case Milestone should NOT be completed yet.');
				System.assertEquals(
					null,
					cm.CompletionDate,
					'Case Milestone Completion Date should be not filled for for Milestone Type: ' + cm.MilestoneType.Name
				);
			}
		}
	}

	@IsTest
	static void testHandleMilestoneCompletionResponse() {
		User caseManager = TestDataFactory.getUser(new User());
		insert caseManager;
		insert TestDataFactory.getPermissionSetAssignments(caseManager.Id);
		TestDataFactory.defaultCaseOwner = caseManager;
		System.runAs(caseManager) {
			testSetup();
			Set<Id> caseIds = new Set<Id>{
				c1.Id, c2.Id, c3.Id
			};
			Date completionDate = Date.today().addDays(-2);

			c1.ResponseSentDate__c = completionDate;
			c2.ResponseSentDate__c = completionDate.addDays(1);
			c3.Description = 'response sent test - no milestone update for c3';

			Test.startTest();
			update new List<Case>{
				c1, c2, c3
			};
			Test.stopTest();

			List<CaseMilestone> caseMilestones = [
				SELECT Id, CaseId, Case.ResponseSentDate__c, CompletionDate, MilestoneType.Name, IsCompleted, IsViolated
				FROM CaseMilestone
				WHERE CaseId IN :caseIds
			];
			System.assert(!caseMilestones.isEmpty(), 'Case Milestones not found.');
			ClientClaimEntitlement__c csEntitlement = ClientClaimEntitlement__c.getOrgDefaults();
			for (CaseMilestone cm : caseMilestones) {
				if (c3.Id == cm.CaseId || csEntitlement.ReceivingConfirmationMilestoneName__c == cm.MilestoneType.Name) {
					System.assertEquals(false, cm.IsCompleted, 'Case Milestone should NOT be completed yet.');
					System.assertEquals(
						null,
						cm.CompletionDate,
						'Case Milestone Completion Date should be not filled for for c3'
					);
				} else if (csEntitlement.ResponseSentMilestoneName__c == cm.MilestoneType.Name) {
					System.assertEquals(true, cm.IsCompleted, 'Case Milestone should be completed.');
					System.assertEquals(
						cm.Case.ResponseSentDate__c,
						Date.newInstance(cm.CompletionDate.year(), cm.CompletionDate.month(), cm.CompletionDate.day()),
						'Case Milestone Completion Date not as expected.'
					);
				}
			}
		}
	}

	@IsTest
	static void testHandleMilestoneCompletionConfirmation() {
		User caseManager = TestDataFactory.getUser(new User());
		insert caseManager;
		insert TestDataFactory.getPermissionSetAssignments(caseManager.Id);
		TestDataFactory.defaultCaseOwner = caseManager;
		System.runAs(caseManager) {
			testSetup();
			Set<Id> caseIds = new Set<Id>{
				c1.Id, c2.Id, c3.Id
			};
			Date completionDate = Date.today().addDays(-2);

			c1.ReceivingConfirmationDate__c = completionDate;
			c2.ReceivingConfirmationDate__c = completionDate.addDays(1);
			c3.Description = 'confirmation sent test - no milestone update for c3';

			Test.startTest();
			update new List<Case>{
				c1, c2, c3
			};
			Test.stopTest();

			List<CaseMilestone> caseMilestones = [
				SELECT
					Id,
					CaseId,
					Case.ReceivingConfirmationDate__c,
					CompletionDate,
					MilestoneType.Name,
					IsCompleted,
					IsViolated
				FROM CaseMilestone
				WHERE CaseId IN :caseIds
			];
			System.assert(!caseMilestones.isEmpty(), 'Case Milestones not found.');
			ClientClaimEntitlement__c csEntitlement = ClientClaimEntitlement__c.getOrgDefaults();
			for (CaseMilestone cm : caseMilestones) {
				if (c3.Id == cm.CaseId || csEntitlement.ResponseSentMilestoneName__c == cm.MilestoneType.Name) {
					System.assertEquals(false, cm.IsCompleted, 'Case Milestone should NOT be completed yet.');
					System.assertEquals(
						null,
						cm.CompletionDate,
						'Case Milestone Completion Date should be not filled for for c3'
					);
				} else if (csEntitlement.ReceivingConfirmationMilestoneName__c == cm.MilestoneType.Name) {
					System.assertEquals(true, cm.IsCompleted, 'Case Milestone should be completed.');
					System.assertEquals(
						cm.Case.ReceivingConfirmationDate__c,
						Date.newInstance(cm.CompletionDate.year(), cm.CompletionDate.month(), cm.CompletionDate.day()),
						'Case Milestone Completion Date not as expected.'
					);
				}
			}
		}
	}

	@IsTest
	static void testHandleMilestoneCompletionConfirmationAndResponse() {
		User caseManager = TestDataFactory.getUser(new User());
		insert caseManager;
		insert TestDataFactory.getPermissionSetAssignments(caseManager.Id);
		TestDataFactory.defaultCaseOwner = caseManager;
		System.runAs(caseManager) {
			testSetup();
			Set<Id> caseIds = new Set<Id>{
				c1.Id, c2.Id, c3.Id
			};
			Date completionDateResponse = Date.today().addDays(-1);
			Date completionDateConfirmation = Date.today().addDays(-2);

			c1.ReceivingConfirmationDate__c = completionDateConfirmation;
			c1.ResponseSentDate__c = completionDateResponse;
			c2.ReceivingConfirmationDate__c = completionDateConfirmation.addDays(1);
			c2.ResponseSentDate__c = completionDateResponse.addDays(1);
			c3.Description = 'confirmation and response sent test - no milestone update for c3';

			Test.startTest();
			update new List<Case>{
				c1, c2, c3
			};
			Test.stopTest();

			List<CaseMilestone> caseMilestones = [
				SELECT
					Id,
					CaseId,
					Case.ResponseSentDate__c,
					Case.ReceivingConfirmationDate__c,
					CompletionDate,
					MilestoneType.Name,
					IsCompleted,
					IsViolated
				FROM CaseMilestone
				WHERE CaseId IN :caseIds
			];
			System.assert(!caseMilestones.isEmpty(), 'Case Milestones not found.');
			ClientClaimEntitlement__c csEntitlement = ClientClaimEntitlement__c.getOrgDefaults();
			for (CaseMilestone cm : caseMilestones) {
				if (c3.Id == cm.CaseId) {
					System.assertEquals(false, cm.IsCompleted, 'Case Milestone should NOT be completed yet.');
					System.assertEquals(
						null,
						cm.CompletionDate,
						'Case Milestone Completion Date should be not filled for for c3'
					);
				} else if (
					csEntitlement.ResponseSentMilestoneName__c == cm.MilestoneType.Name ||
						csEntitlement.ReceivingConfirmationMilestoneName__c == cm.MilestoneType.Name
					) {
					System.assertEquals(true, cm.IsCompleted, 'Case Milestone should be completed');
					if (csEntitlement.ResponseSentMilestoneName__c == cm.MilestoneType.Name) {
						System.assertEquals(
							cm.Case.ResponseSentDate__c,
							Date.newInstance(cm.CompletionDate.year(), cm.CompletionDate.month(), cm.CompletionDate.day()),
							'Case Milestone Completion Date not as expected.'
						);
					} else if (csEntitlement.ReceivingConfirmationMilestoneName__c == cm.MilestoneType.Name) {
						System.assertEquals(
							cm.Case.ReceivingConfirmationDate__c,
							Date.newInstance(cm.CompletionDate.year(), cm.CompletionDate.month(), cm.CompletionDate.day()),
							'Case Milestone Completion Date not as expected.'
						);
					}
				}
			}
		}
	}
}
