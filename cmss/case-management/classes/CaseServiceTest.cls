@IsTest
private class CaseServiceTest {

	@TestSetup
	static void insertCustomSettings() {
		insert TestDataFactory.getIntegrationSettings();
	}

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
					RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByDeveloperName()
						.get('GDPR')
						.getRecordTypeId()
				)
			);
			NumericalSeriesSettings__c customSettingsValue = new NumericalSeriesSettings__c();
			customSettingsValue.ClientClaimID__c = 2.0;
			customSettingsValue.GDPRClaimID__c = 5.0;
			insert customSettingsValue;

			Test.startTest();
			insert new List<Case>{ newClientCase, newGDPRCase };
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
			System.assertEquals('' + Date.today().year() + '0000' + '3', newClientCase.CaseID__c);
			System.assertEquals('00000' + '6' + '' + Date.today().year(), newGDPRCase.CaseID__c);
		}
	}
	@IsTest
	static void assignCaseIDTest_LongNumber() {
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
					RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByDeveloperName()
						.get('GDPR')
						.getRecordTypeId()
				)
			);
			NumericalSeriesSettings__c customSettingsValue = new NumericalSeriesSettings__c();
			customSettingsValue.ClientClaimID__c = 22222.0;
			customSettingsValue.GDPRClaimID__c = 55555.0;
			insert customSettingsValue;

			Test.startTest();
			insert new List<Case>{ newClientCase, newGDPRCase };
			Test.stopTest();

			NumericalSeriesSettings__c newIssuedClaimID = [
				SELECT ClientClaimID__c, GDPRClaimID__c
				FROM NumericalSeriesSettings__c
				LIMIT 1
			];

			newClientCase = [SELECT CaseID__c FROM Case WHERE Id = :newClientCase.Id LIMIT 1];
			newGDPRCase = [SELECT CaseID__c FROM Case WHERE Id = :newGDPRCase.Id LIMIT 1];

			System.assertEquals('' + Date.today().year() + '' + '22223', newClientCase.CaseID__c);
			System.assertEquals('0' + '55556' + '' + Date.today().year(), newGDPRCase.CaseID__c);
		}
	}
	@IsTest
	static void testValidateOwnerPermission() {
		User user = TestDataFactory.getUser(new User(AgentId__c = 'UA18439'));
		User user2 = TestDataFactory.getUser(new User(AgentId__c = 'UA18438'));
		insert new List<User>{ user, user2 };

		List<PermissionSet> permSets = [
			SELECT Id
			FROM PermissionSet
			WHERE Name = 'GDPRCaseManager' OR Name = 'ClientOmbudsman' OR Name = 'CaseManager'
			ORDER BY Name
		];
		PermissionSetAssignment psa1 = new PermissionSetAssignment(
			AssigneeId = user2.Id,
			PermissionSetId = permSets[0].Id
		);
		PermissionSetAssignment psa2 = new PermissionSetAssignment(
			AssigneeId = user.Id,
			PermissionSetId = permSets[1].Id
		);
		PermissionSetAssignment psa3 = new PermissionSetAssignment(
			AssigneeId = user.Id,
			PermissionSetId = permSets[2].Id
		);
		insert new List<PermissionSetAssignment>{ psa1, psa2, psa3 };

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
					RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByDeveloperName()
						.get('GDPR')
						.getRecordTypeId()
				)
			);
			insert new List<Case>{ newClientCase, newGDPRCase };
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

		List<PermissionSet> permSets = [SELECT Id FROM PermissionSet WHERE Name = 'GDPRCaseManager'];
		PermissionSetAssignment psa1 = new PermissionSetAssignment(
			AssigneeId = user.Id,
			PermissionSetId = permSets[0].Id
		);
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
					RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByDeveloperName()
						.get('GDPR')
						.getRecordTypeId()
				)
			);

			try {
				insert new List<Case>{ newClientCase, newGDPRCase };
				System.assert(false, 'This assert should not be reached.');
			} catch (DMLException e) {
				System.assert(e.getMessage().contains(CaseService.CASE_OWNER_MISSING_PERMISSION_ERR));
			}
		}
	}

	@IsTest
	static void testPopulateUserLookupsFromCPU() {
		User user1 = TestDataFactory.getUser(new User(CommissionAccountBase__c = 'CPU001'));
		User user2 = TestDataFactory.getUser(new User(CommissionAccountBase__c = 'CPU002'));
		User user3 = TestDataFactory.getUser(new User(CommissionAccountBase__c = 'CPU003'));
		insert new List<User>{ user1, user2, user3 };
		User caseManager = TestDataFactory.getUser(new User());
		insert caseManager;
		insert TestDataFactory.getPermissionSetAssignments(caseManager.Id);
		TestDataFactory.defaultCaseOwner = caseManager;
		System.runAs(caseManager) {
			Case cas = TestDataFactory.getCase(
				new Case(ContractorCPU__c = 'CPU001', ComplainerContractorCPU__c = 'CPU002')
			);
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

	@IsTest
	static void testSetGDPRAndClientCaseOnAccount() {
		User user = TestDataFactory.getUser(new User(AgentId__c = 'UA18439'));
		insert user;

		List<PermissionSet> permSets = [
			SELECT Id
			FROM PermissionSet
			WHERE Name = 'GDPRCaseManager' OR Name = 'ClientOmbudsman' OR Name = 'CaseManager' OR Name = 'EditAllData'
			ORDER BY Name
		];
		PermissionSetAssignment psa1 = new PermissionSetAssignment(
			AssigneeId = user.Id,
			PermissionSetId = permSets[0].Id
		);
		PermissionSetAssignment psa2 = new PermissionSetAssignment(
			AssigneeId = user.Id,
			PermissionSetId = permSets[1].Id
		);
		PermissionSetAssignment psa3 = new PermissionSetAssignment(
			AssigneeId = user.Id,
			PermissionSetId = permSets[2].Id
		);
		PermissionSetAssignment psa4 = new PermissionSetAssignment(
			AssigneeId = user.Id,
			PermissionSetId = permSets[3].Id
		);
		insert new List<PermissionSetAssignment>{ psa1, psa2, psa3, psa4 };

		Test.startTest();
		System.runAs(user) {
			Account a = TestDataFactory.getAccount();
			insert a;
			Case cas = TestDataFactory.getCase(
				new Case(
					AccountId = a.Id,
					RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByDeveloperName()
						.get('NewClientClaim')
						.getRecordTypeId(),
					Status = '1'
				)
			);
			Case cas2 = TestDataFactory.getCase(
				new Case(
					AccountId = a.Id,
					RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByDeveloperName()
						.get('GDPR')
						.getRecordTypeId(),
					Status = '1'
				)
			);
			insert new List<Case>{ cas, cas2 };

			Account acc = [SELECT GDPRCase__c, ClientCase__c FROM Account LIMIT 1];
			System.assert(acc.ClientCase__c == '1');
			System.assert(acc.GDPRCase__c == '1');

			Account a2 = TestDataFactory.getAccount();
			insert a2;

			cas.AccountId = a2.Id;
			update cas;

			Account[] accs = [SELECT GDPRCase__c, ClientCase__c FROM Account ORDER BY GlobalId__c ASC];
			System.assert(accs.size() == 2);
			System.assert(accs[0].ClientCase__c == '0');
			System.assert(accs[0].GDPRCase__c == '1');
			System.assert(accs[1].ClientCase__c == '1');
			System.assert(accs[1].GDPRCase__c == '0');

			CaseType__c caseType = TestDataFactory.getCaseType(new CaseType__c(Case__c = cas.Id));
			insert caseType;
			cas.ResponseSentDate__c = Date.today();
			cas.Status = '2';
			update cas;

			accs = [SELECT GDPRCase__c, ClientCase__c FROM Account ORDER BY GlobalId__c ASC];
			System.assert(accs.size() == 2);
			System.assert(accs[0].ClientCase__c == '0');
			System.assert(accs[0].GDPRCase__c == '1');
			System.assert(accs[1].ClientCase__c == '0');
			System.assert(accs[1].GDPRCase__c == '0');

			delete cas2;
			accs = [SELECT GDPRCase__c, ClientCase__c FROM Account ORDER BY GlobalId__c ASC];
			System.assert(accs.size() == 2);
			System.assert(accs[0].ClientCase__c == '0');
			System.assert(accs[0].GDPRCase__c == '0');
			System.assert(accs[1].ClientCase__c == '0');
			System.assert(accs[1].GDPRCase__c == '0');
		}
		Test.stopTest();
	}

	@IsTest
	static void testSetupCaseStatuses() {
		User caseManager = TestDataFactory.getUser(new User());
		insert caseManager;
		insert TestDataFactory.getPermissionSetAssignments(caseManager.Id);
		TestDataFactory.defaultCaseOwner = caseManager;
		Case testCase1;
		Case testCase2;
		Case testCase3;
		System.runAs(caseManager) {
			testCase1 = TestDataFactory.getCase(new Case(Subject = 'Case 1', Status = '1'));
			testCase2 = TestDataFactory.getCase(
				new Case(
					Subject = 'Case 2',
					Status = '1',
					TotalRequestsNumber__c = 5,
					FailedRequestsNumber__c = 0,
					SuccessRequestsNumber__c = 5
				)
			);
			testCase3 = TestDataFactory.getCase(
				new Case(
					Subject = 'Case 3',
					Status = '1',
					TotalRequestsNumber__c = 6,
					FailedRequestsNumber__c = 3,
					SuccessRequestsNumber__c = 3
				)
			);
			insert new List<Case>{ testCase1, testCase2, testCase3 };
		}
		testCase1 = [SELECT Status FROM Case WHERE Subject = 'Case 1'];
		testCase2 = [SELECT Status FROM Case WHERE Subject = 'Case 2'];
		testCase3 = [SELECT Status FROM Case WHERE Subject = 'Case 3'];
		System.assertEquals('1', testCase1.Status);
		System.assertEquals('29', testCase2.Status);
		System.assertEquals('30', testCase3.Status);
	}


    @isTest
    static void testChangeCPEClientState() {
		User u = TestDataFactory.getUser(new User(CommissionAccountBase__c = 'CPU0', IsAgentActive__c = true));
		insert new List<User>{u};

        Case c = TestDataFactory.getCase(
            new Case(
                RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByDeveloperName()
                    .get('PortfolioManagementChangeRequest')
                    .getRecordTypeId(),
                NewPortfolioManager__c = u.Id
            )
        );
        insert c;        
        PortfolioManagementRequest__c validRequest = TestDataFactory.getPortfolioManagementRequest(
            new PortfolioManagementRequest__c(PortfolioManagerCPU__c = 'CPU0', Case__c = c.Id)
        );
        PortfolioManagementRequest__c invalidRequest = TestDataFactory.getPortfolioManagementRequest(
            new PortfolioManagementRequest__c(PortfolioManagerCPU__c = 'CPU0', Case__c = c.Id)
        );
        insert new List<PortfolioManagementRequest__c>{validRequest, invalidRequest};
        Account invalidRequestAccount = new Account(Id=invalidRequest.Account__c, LastPtfManAChangeDate__c = System.Today() + 1);
        update invalidRequestAccount;

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns3:ChangeCPEClientStateResponse xmlns:ns3=\"http://service.cmss.cz/person/PortfolioManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\"><ns3:responseBody><ns3:listOfRequestStatuses><ns3:listOfRequestStatusesItem><ns3:stateChangeRequestId>' +
				validRequest.Id +
				'</ns3:stateChangeRequestId><ns3:requestStatus>3</ns3:requestStatus></ns3:listOfRequestStatusesItem></ns3:listOfRequestStatuses></ns3:responseBody></ns3:ChangeCPEClientStateResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        Test.startTest();
            c.Status = '3';
            update c;
        Test.stopTest();

        c = [SELECT CPECallAttempts__c, Status FROM Case WHERE Id =: c.Id];
        validRequest = [SELECT RequestStatus__c FROM PortfolioManagementRequest__c WHERE Id =: validRequest.Id];
        invalidRequest = [SELECT RequestStatus__c, PortfolioManChangeResult__c FROM PortfolioManagementRequest__c WHERE Id =: invalidRequest.Id];

        System.assert(c.Status == '7');
        System.assert(c.CPECallAttempts__c == 1);
        System.assertEquals('3', validRequest.RequestStatus__c);
        System.assertEquals('2', invalidRequest.RequestStatus__c);
        System.assertEquals('927', invalidRequest.PortfolioManChangeResult__c);
    }


    @isTest
    static void testChangeCPEClientState_invalidResponse() {
		User u = TestDataFactory.getUser(new User(CommissionAccountBase__c = 'CPU0', IsAgentActive__c = true));
		insert new List<User>{u};

        Case c = TestDataFactory.getCase(
            new Case(
                RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByDeveloperName()
                    .get('PortfolioManagementChangeRequest')
                    .getRecordTypeId(),
                NewPortfolioManager__c = u.Id
            )
        );
        insert c;        
        PortfolioManagementRequest__c validRequest = TestDataFactory.getPortfolioManagementRequest(
            new PortfolioManagementRequest__c(PortfolioManagerCPU__c = 'CPU0', Case__c = c.Id)
        );
        insert validRequest;

		CalloutServiceMockImpl fakeResponse = new CalloutServiceMockImpl(
			200,
			'OK',
			'<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><ns3:ChangeCPEClientStateResponse xmlns:ns3=\"http://service.cmss.cz/person/PortfolioManagementService/v10\" xmlns:ns2=\"http://service.cmss.cz/common/CommonMessage/v01\"><ns3:responseBody><ns3:listOfRequestStatuses></ns3:listOfRequestStatuses></ns3:responseBody></ns3:ChangeCPEClientStateResponse></soapenv:Body></soapenv:Envelope>',
			null,
			null
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        Test.startTest();
            c.Status = '3';
            update c;
        Test.stopTest();

        Log__c[] logs = [SELECT Payload__c FROM Log__c WHERE Message__c = 'Invalid response!'];
		System.assertEquals(1, logs.size());
    }

    @isTest
    static void testScheduleJobOfFailureCallout() {
        Test.startTest();
            Id jobId = PortfolioManagementRequestService.scheduleJobOfFailureCallout(new Set<Id>(), 1);
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, State FROM CronTrigger WHERE Id =: jobId];
            System.assert(ct != null);
            System.assertEquals(0, ct.TimesTriggered);         
            System.assertEquals('WAITING', ct.State);
        Test.stopTest();
    } 
}