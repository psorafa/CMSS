@IsTest
public class UpdateRecordTypeToCloasedGDPRClaimTest {

	@IsTest
	static void updateRecordType() {
		User caseManager = TestDataFactory.getUser(new User());
		insert caseManager;
		insert TestDataFactory.getPermissionSetAssignments(caseManager.Id);
		TestDataFactory.defaultCaseOwner = caseManager;
		System.runAs(caseManager) {

			Id recordTypeId1 =
				Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
					.get('ClosedGDPRClaim').getRecordTypeId();

			Id recordTypeId2 =
				Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
					.get('GDPR').getRecordTypeId();


			Case c1 = TestDataFactory.getCase(new Case(
				Subject = 'Case1',
				RecordTypeId = recordTypeId2,
				Status = '2',
				ResponseSentDate__c = Date.today()
			));

			Case c2 = TestDataFactory.getCase(new Case(
				Subject = 'Case2',
				RecordTypeId = recordTypeId2,
				Status = '3',
				ResponseSentDate__c = Date.today()

			));
			Case c3 = TestDataFactory.getCase(new Case(
				Subject = 'Case3',
				RecordTypeId = recordTypeId2,
				Status = '1'

			));
			insert new List<Case>{
				c1, c2, c3
			};

			UpdateRecordTypeToCloasedGDPRClaim batch = new UpdateRecordTypeToCloasedGDPRClaim();

			Test.startTest();
			Database.executeBatch(batch);
			Test.stopTest();
			List<Case> closedGDPRCases = [SELECT Id, RecordType.DeveloperName, Status FROM Case];
			System.assertEquals(closedGDPRCases[0].RecordType.DeveloperName, 'ClosedGDPRClaim');
			System.assertEquals(closedGDPRCases[1].RecordType.DeveloperName, 'ClosedGDPRClaim');
			System.assertEquals(closedGDPRCases[2].RecordType.DeveloperName, 'GDPR');
		}
	}
}