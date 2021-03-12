@IsTest
public class TestDataFactory {
	private static Integer accountCounter = 0;
	private static Integer opportunityCounter = 0;
	private static Integer assetCounter = 0;
	private static Integer userCounter = 0;
	private static Id personAccountRTId = [
		SELECT Id
		FROM RecordType
		WHERE DeveloperName = 'PersonAccount' AND SobjectType = 'Account'
	]
	.Id;
	private static Integer caseCounter = 0;
	public static User defaultCaseOwner;
	private static List<PermissionSet> permissionSets = [
		SELECT Id FROM PermissionSet WHERE Name IN ('GDPRCaseManager', 'ClientOmbudsman', 'CaseManager')
	];

	public static Account getAccount() {
		return getAccount(new Account());
	}

	public static Account getAccount(Account so) {
		Account template = new Account(
			Name = 'Test account ' + ++accountCounter,
			GlobalId__c = 'G' + accountCounter
		);
		SObjectUtil.copyFields(so, template);
		return template;
	}

	public static Account getPersonAccount(Account so) {
		Account template = new Account(
			FirstName = 'Test firstName ' + ++accountCounter,
			LastName = 'Test lastName ' + ++accountCounter,
			GlobalId__c = 'G' + accountCounter,
			RecordTypeId = personAccountRTId
		);
		SObjectUtil.copyFields(so, template);
		return template;
	}

	public static AccountRelation__c getAccountRelation(AccountRelation__c so) {
		AccountRelation__c template = new AccountRelation__c(
			AccountRole__c = '1',
			RelatedAccountRole__c = '2',
			ValidFrom__c = Date.today().addDays(-1),
			ValidTo__c = Date.today().addDays(1)
		);
		SObjectUtil.copyFields(so, template);
		if (template.Account__c == null) {
			Account a = getAccount();
			insert a;
			template.Account__c = a.Id;
		}
		if (template.RelatedAccount__c == null) {
			Account a = getAccount();
			insert a;
			template.RelatedAccount__c = a.Id;
		}
		return template;
	}

	public static ClientZone__c getClientZone(ClientZone__c so) {
		ClientZone__c template = new ClientZone__c(
			ExternalId__c = UUIDUtil.generateUUID()
		);
		SObjectUtil.copyFields(so, template);
		if (template.Account__c == null) {
			Account a = getAccount();
			insert a;
			template.Account__c = a.Id;
		}
		return template;
	}
	public static ContactInformation__c getContactInformation(ContactInformation__c so) {
		ContactInformation__c template = new ContactInformation__c(
			Type__c = '1',
			Country__c = '16',
			Street__c = 'Street',
			HouseNumber__c = '52',
			City__c = 'City',
			PostalCode__c = '100 00'
		);
		SObjectUtil.copyFields(so, template);
		return template;
	}

	public static Opportunity getOpportunity() {
		return getOpportunity(new Opportunity());
	}

	public static Opportunity getOpportunity(Opportunity so) {
		Opportunity template = new Opportunity(
			Name = 'Opportunity ' + ++opportunityCounter,
			StageName = '1',
			CloseDate = Date.today(),
			ExternalId__c = UUIDUtil.generateUUID()
		);
		SObjectUtil.copyFields(so, template);
		if (template.AccountId == null) {
			Account a = getAccount();
			insert a;
			template.AccountId = a.Id;
		}
		return template;
	}

	public static Task getTask(Task so) {
		Task template = new Task(
			Subject = 'Test task',
			ExternalId__c = UUIDUtil.generateUUID()
		);
		SObjectUtil.copyFields(so, template);
		if (template.WhatId == null) {
			Account a = getAccount();
			insert a;
			template.WhatId = a.Id;
		}
		return template;
	}

	public static Asset getAsset(Asset so) {
		Asset template = new Asset(Name = 'Asset' + ++assetCounter);
		SObjectUtil.copyFields(so, template);
		if (template.AccountId == null) {
			Account a = getAccount();
			insert a;
			template.AccountId = a.Id;
		}
		return template;
	}

	public static User getUser(User so) {
		Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
		String username = 'user' + ++userCounter;
		User template = new User(
			LastName = username,
			Username = username + '@mail.invalid',
			Email = username + '@mail.invalid',
			CommissionAccountNr__c = 'CPU' + userCounter,
			CommissionAccountBase__c = 'B' + userCounter,
			ProfileId = profileId,
			Alias = 'tstU',
			TimeZoneSidKey = 'Europe/Prague',
			LocaleSidKey = 'cs_CZ',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			AgentId__c = 'UA11111' + userCounter
		);
		SObjectUtil.copyFields(so, template);
		return template;
	}

	public static Case getCase(Case so) {
		Case template = new Case(
			Subject = 'Case' + ++caseCounter,
			ReceivedDate__c = Date.today(),
			ReceivingConfirmationDate__c = Date.today(),
			RequestComplete__c = false,
			InternalPrecaution__c = '1',
			Priority = '1',
			Source__c = '2',
			Origin = '2',
			Description = 'Test Case',
			ComplaintAgainst__c = '2',
			CauseLegitComplaint__c = '2',
			SubjectFound__c = true,
			RequestType__c = '1'
		);
		SObjectUtil.copyFields(so, template);
		if (template.AccountId == null) {
			Account a = getAccount();
			insert a;
			template.AccountId = a.Id;
		}
		if (template.OwnerId == null) {
			if (defaultCaseOwner == null) {
				defaultCaseOwner = getUser(new User());
                insert defaultCaseOwner;
                
                List<PermissionSet> permSets = [
                    SELECT Id 
                    FROM PermissionSet 
                    WHERE Name = 'GDPRCaseManager' OR Name = 'ClientOmbudsman' OR Name = 'CaseManager'
                    ORDER BY Name
                ];
                System.runAs(defaultCaseOwner) {
                    PermissionSetAssignment psa1 = new PermissionSetAssignment(AssigneeId = defaultCaseOwner.Id, PermissionSetId = permSets[0].Id);
                    PermissionSetAssignment psa2 = new PermissionSetAssignment(AssigneeId = defaultCaseOwner.Id, PermissionSetId = permSets[1].Id);
                    PermissionSetAssignment psa3 = new PermissionSetAssignment(AssigneeId = defaultCaseOwner.Id, PermissionSetId = permSets[2].Id);
                    insert new List<PermissionSetAssignment>{ psa1, psa2, psa3 };
                }
			}
            template.OwnerId = defaultCaseOwner.Id;
		}
		return template;
    }

	/**
	 * will return list of permission set assigments to permission sets defined in TestDataFactory.permissionSets list
	 * @param userId id of a user to assign permissions
	 * @return list of permission set assigments, records are not inserted yet
	 */
	public static List<PermissionSetAssignment> getPermissionSetAssignments(Id userId) {
		List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>();
		for (PermissionSet permissionSet : permissionSets) {
			assignments.add(new PermissionSetAssignment(
				AssigneeId = userId,
				PermissionSetId = permissionSet.Id
			));
		}
		return assignments;
	}
    
    public static PortfolioManagementRequest__c getPortfolioManagementRequest(PortfolioManagementRequest__c so) {
		PortfolioManagementRequest__c template = new PortfolioManagementRequest__c(
            PortfolioManChangeReason__c = '0',
            ValidFrom__c = Datetime.now(),
            PortfolioManagementType__c = 'A',
            BatchID__c = 'batchId0'
		);
		SObjectUtil.copyFields(so, template);
		if (template.PortfolioManagerCPU__c == null) {
			User u = getUser(new User());
			insert u;
			template.PortfolioManagerCPU__c = u.CommissionAccountBase__c;
		}
		if (template.Account__c == null) {
			Account a = getAccount();
			insert a;
			template.Account__c = a.Id;
		}
		return template;
	}

	public static CaseType__c getCaseType(CaseType__c so) {
		CaseType__c template = new CaseType__c(
		);
		SObjectUtil.copyFields(so, template);
		if (template.Case__c == null) {
			Case c = getCase(new Case());
			insert c;
			template.Case__c = c.Id;
		}
		return template;
    }

    public static Consent__c getConsent(Consent__c so) {
        Consent__c template = new Consent__c(
            EntityConsent__c = '8', 
            GeneralConsentVersion__c = '1', 
            AgentCPU__c = 'agentCPU',
            SubstituteRole__c = '1'
        );
		SObjectUtil.copyFields(so, template);
        if (template.Account__c == null) {
			Account a = getAccount();
			insert a;
            template.Account__c = a.Id;
            so.Account__c = a.Id;
		}
		if (template.SubstitutePerson__c == null) {
			Account sp = getAccount();
			insert sp;
            template.SubstitutePerson__c = sp.Id;
            so.SubstitutePerson__c = sp.Id;
		}
		return template;
	}
    
    public static List<Consent__c> getConsents(Integer amount, Consent__c so) {
        List<Consent__c> consents = new List<Consent__c>();
        for (Integer i = 0; i < amount; i++) {
            consents.add(getConsent(so));
        }
		return consents;
    }
    
    public static InternalConsent__c getInternalConsent(InternalConsent__c so) {
        InternalConsent__c template = new InternalConsent__c(
            InternalConsentType__c = '1',
            InternalConsentValue__c = '1',
            ExternalId__c = 'kdslfn450' + UUIDUtil.generateUUID().substring(20)
        );
        SObjectUtil.copyFields(so, template);
        if (template.Account__c == null) {
			Account a = getAccount();
			insert a;
            template.Account__c = a.Id;
            so.Account__c = a.Id;
		}
		return template;
    }
    
    public static List<InternalConsent__c> getInternalConsents(Integer amount, InternalConsent__c so) {
        List<InternalConsent__c> internalConsents = new List<InternalConsent__c>();
        for (Integer i = 0; i < amount; i++) {
            internalConsents.add(getInternalConsent(so));
        }
		return internalConsents;
    }

	public static IntegrationSettings__c getIntegrationSettings() {
		return new IntegrationSettings__c(
			ConsentServiceEndpoint__c = 'https://test.test',
			ConsentServiceUsername__c = 'testusername',
			ConsentServicePassword__c = 'testpass',
			PortfolioManagementServiceEndpoint__c = 'https://test.test',
			PortfolioManagementServiceUsername__c = 'testusername',
			PortfolioManagementServicePassword__c = 'testpass'
		);
	}
}
