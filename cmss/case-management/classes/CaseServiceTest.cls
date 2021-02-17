@IsTest
private class CaseServiceTest {

	@IsTest
	static void assignCaseIDTest() {
		User user = TestDataFactory.getUser(new User());
		insert user;
		insert TestDataFactory.getPermissionSetAssignments(user.Id);
		TestDataFactory.defaultCaseOwner = user;
		System.runAs(user) {
			Case newClientCase = TestDataFactory.getCase(
				new Case(
					RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByDeveloperName()
						.get('NewClientClaim')
						.getRecordTypeId()
				)
			);
			Case newGDPRCase = TestDataFactory.getCase(
				new Case(
					RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDPR').getRecordTypeId()
				)
			);
			NumericalSeriesSettings__c customSettingsValue = new NumericalSeriesSettings__c();
			customSettingsValue.ClientClaimID__c = 2.0;
			customSettingsValue.GDPRClaimID__c = 5.0;
			insert customSettingsValue;

			Test.startTest();
			insert new List<Case>{
				newClientCase, newGDPRCase
			};
			Test.stopTest();

			NumericalSeriesSettings__c newIssuedClaimID = [
				SELECT ClientClaimID__c, GDPRClaimID__c
				FROM NumericalSeriesSettings__c
				LIMIT 1
			];

			newClientCase = [SELECT CaseID__c FROM Case WHERE Id = :newClientCase.Id LIMIT 1];
			newGDPRCase = [SELECT CaseID__c FROM Case WHERE Id = :newGDPRCase.Id LIMIT 1];

			System.assertEquals(3, newIssuedClaimID.ClientClaimID__c);
			System.assertEquals(6, newIssuedClaimID.GDPRClaimID__c);
			System.assertEquals('' + Date.today().year() + '3' + '0000', newClientCase.CaseID__c);
			System.assertEquals('00000' + '6' + '' + Date.today().year(), newGDPRCase.CaseID__c);
		}
	}

	@IsTest
	static void testValidateOwnerPermission() {
		User user = TestDataFactory.getUser(new User(AgentId__c = 'UA18439'));
		User user2 = TestDataFactory.getUser(new User(AgentId__c = 'UA18438'));
		insert new List<User>{
			user, user2
		};

		List<PermissionSet> permSets = [
			SELECT Id
			FROM PermissionSet
			WHERE Name = 'GDPRCaseManager' OR Name = 'ClientOmbudsman' OR Name = 'CaseManager'
			ORDER BY Name
		];
		PermissionSetAssignment psa1 = new PermissionSetAssignment(AssigneeId = user2.Id, PermissionSetId = permSets[0].Id);
		PermissionSetAssignment psa2 = new PermissionSetAssignment(AssigneeId = user.Id, PermissionSetId = permSets[1].Id);
		PermissionSetAssignment psa3 = new PermissionSetAssignment(AssigneeId = user.Id, PermissionSetId = permSets[2].Id);
		insert new List<PermissionSetAssignment>{
			psa1, psa2, psa3
		};

		Test.startTest();
		Case newClientCase;
		System.runAs(user) {
			newClientCase = TestDataFactory.getCase(
				new Case(
					Subject = 'newClientCase',
					OwnerId = user.Id,
					RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByDeveloperName()
						.get('NewClientClaim')
						.getRecordTypeId()
				)
			);
			Case newGDPRCase = TestDataFactory.getCase(
				new Case(
					Subject = 'newGDPRCase',
					OwnerId = user.Id,
					RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDPR').getRecordTypeId()
				)
			);
			insert new List<Case>{
				newClientCase, newGDPRCase
			};
		}
		Test.stopTest();

		List<Case> queriedCases = [SELECT OwnerId FROM Case WHERE OwnerId = :user.Id];
		System.assertEquals(2, queriedCases.size());

		System.runAs(user) {
			newClientCase.OwnerId = user2.Id;
			update newClientCase;
		}

		queriedCases = [SELECT OwnerId FROM Case ORDER BY Subject];
		System.assertEquals(2, queriedCases.size());
		System.assertEquals(user2.Id, queriedCases[0].OwnerId);
		System.assertEquals(user.Id, queriedCases[1].OwnerId);
	}

	@IsTest
	static void testValidateOwnerPermissionError() {
		User user = TestDataFactory.getUser(new User(AgentId__c = 'UA18439'));
		insert user;

		List<PermissionSet> permSets = [
			SELECT Id
			FROM PermissionSet
			WHERE Name = 'GDPRCaseManager'
		];
		PermissionSetAssignment psa1 = new PermissionSetAssignment(AssigneeId = user.Id, PermissionSetId = permSets[0].Id);
		insert psa1;

		System.runAs(user) {
			Case newClientCase = TestDataFactory.getCase(
				new Case(
					OwnerId = user.Id,
					RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByDeveloperName()
						.get('NewClientClaim')
						.getRecordTypeId()
				)
			);
			Case newGDPRCase = TestDataFactory.getCase(
				new Case(
					OwnerId = user.Id,
					RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDPR').getRecordTypeId()
				)
			);

			try {
				insert new List<Case>{
					newClientCase, newGDPRCase
				};
				System.assert(false, 'This assert should not be reached.');
			} catch (DMLException e) {
				System.assert(e.getMessage().contains(CaseService.CASE_OWNER_MISSING_PERMISSION_ERR));
			}
		}
	}

	@IsTest
	static void testPopulateUserLookupsFromCPU() {
		User user1 = TestDataFactory.getUser(new User(
			CommissionAccountBase__c = 'CPU001'
		));
		User user2 = TestDataFactory.getUser(new User(
			CommissionAccountBase__c = 'CPU002'
		));
		User user3 = TestDataFactory.getUser(new User(
			CommissionAccountBase__c = 'CPU003'
		));
		insert new List<User>{
			user1, user2, user3
		};
		User caseManager = TestDataFactory.getUser(new User());
		insert caseManager;
		insert TestDataFactory.getPermissionSetAssignments(caseManager.Id);
		TestDataFactory.defaultCaseOwner = caseManager;
		System.runAs(caseManager) {

			Case cas = TestDataFactory.getCase(new Case(
				ContractorCPU__c = 'CPU001',
				ComplainerContractorCPU__c = 'CPU002'
			));
			insert cas;

			cas = [SELECT Id, ComplainerContractor__c, Contractor__c FROM Case WHERE Id = :cas.Id];
			System.assertEquals(user1.Id, cas.Contractor__c);
			System.assertEquals(user2.Id, cas.ComplainerContractor__c);

			cas.ContractorCPU__c = null;
			cas.ComplainerContractorCPU__c = 'CPU003';

			update cas;

			cas = [SELECT Id, ComplainerContractor__c, Contractor__c FROM Case WHERE Id = :cas.Id];
			System.assertEquals(null, cas.Contractor__c);
			System.assertEquals(user3.Id, cas.ComplainerContractor__c);
		}
	}
}
