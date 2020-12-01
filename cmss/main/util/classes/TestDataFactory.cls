@IsTest
public class TestDataFactory {
	private static Integer accountCounter = 0;
	private static Integer opportunityCounter = 0;
	private static Integer assetCounter = 0;
	private static Integer userCounter = 0;
	private static Id personAccountRTId = [
		SELECT Id
		FROM RecordType
		WHERE DeveloperName = 'PersonAccount' AND SObjectType = 'Account'
	]
	.Id;
	private static Integer caseCounter = 0;
	private static User defaultCaseOwner;

	public static Account getAccount() {
		return getAccount(new Account());
	}

	public static Account getAccount(Account so) {
		Account template = new Account(Name = 'Test account ' + ++accountCounter, GlobalId__c = 'G' + accountCounter);
		copyFields(so, template);
		return template;
	}

	public static Account getPersonAccount(Account so) {
		Account template = new Account(
			FirstName = 'Test firstName ' + ++accountCounter,
			LastName = 'Test lastName ' + ++accountCounter,
			GlobalId__c = 'G' + accountCounter,
			RecordTypeId = personAccountRTId
		);
		copyFields(so, template);
		return template;
	}

	public static AccountRelation__c getAccountRelation(AccountRelation__c so) {
		AccountRelation__c template = new AccountRelation__c(
			AccountRole__c = '1',
			RelatedAccountRole__c = '2',
			ValidFrom__c = Date.today().addDays(-1),
			ValidTo__c = Date.today().addDays(1)
		);
		copyFields(so, template);
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
		ClientZone__c template = new ClientZone__c();
		copyFields(so, template);
		if (template.Account__c == null) {
			Account a = getAccount();
			insert a;
			template.Account__c = a.Id;
		}
		return template;
	}

	public static Opportunity getOpportunity() {
		return getOpportunity(new Opportunity());
	}

	public static Opportunity getOpportunity(Opportunity so) {
		Opportunity template = new Opportunity(
			Name = 'Opportunity ' + ++opportunityCounter,
			StageName = '1',
			CloseDate = Date.today()
		);
		copyFields(so, template);
		if (template.AccountId == null) {
			Account a = getAccount();
			insert a;
			template.AccountId = a.Id;
		}
		return template;
	}

	public static Task getTask(Task so) {
		Task template = new Task(Subject = 'Test task');
		copyFields(so, template);
		if (template.WhatId == null) {
			Account a = getAccount();
			insert a;
			template.WhatId = a.Id;
		}
		return template;
	}

	public static Asset getAsset(Asset so) {
		Asset template = new Asset(Name = 'Asset' + ++assetCounter);
		copyFields(so, template);
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
			ProfileId = profileId,
			Alias = 'tstU',
			TimeZoneSidKey = 'Europe/Prague',
			LocaleSidKey = 'cs_CZ',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			AgentId__c = 'UA11111'
		);
		copyFields(so, template);
		return template;
	}

	public static Case getCase(Case so) {
		Case template = new Case(
			Subject = 'Case' + ++caseCounter,
			ReceivedDate__c = Date.today(),
			ReceivingConfirmationDate__c = Date.today(),
			RequestComplete__c = false,
			InternalPrecaution__c = 'No',
			Priority = '1',
			Source__c = '2',
			Origin = '2',
			Description = 'Test Case',
			ComplaintAgainst__c = '2',
			CauseLegitComplaint__c = '2',
			SubjectFound__c = true,
			RequestType__c = '1'
		);
		copyFields(so, template);
		if (template.AccountId == null) {
			Account a = getAccount();
			insert a;
			template.AccountId = a.Id;
		}
		if (template.OwnerId == null) {
			if (defaultCaseOwner == null) {
				defaultCaseOwner = getUser(new User());
				insert defaultCaseOwner;
			}
			template.OwnerId = defaultCaseOwner.Id;
		}
		return template;
	}

	public static CaseType__c getCaseType(CaseType__c so) {
		CaseType__c template = new CaseType__c(
		);
		copyFields(so, template);
		if (template.Case__c == null) {
			Case c = getCase(new Case());
			insert c;
			template.Case__c = c.Id;
		}
		return template;
	}

	private static void copyFields(SObject source, SObject destination) {
		if (source == null) {
			return;
		}
		Map<String, Object> soMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(source));
		for (String fieldName : soMap.keySet()) {
			if (fieldName != 'attributes') {
				destination.put(fieldName, source.get(fieldName));
			}
		}
	}
}
