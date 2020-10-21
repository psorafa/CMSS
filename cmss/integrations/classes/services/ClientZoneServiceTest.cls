@IsTest
private class ClientZoneServiceTest {

	private static String contractNumber = '012345';
	private static String userName = 'user@name.invalid';
	private static String verPhone = '987654321';
	private static String mail = 'user@mail.invalid';
	private static String clientRole8NoAccess = '8';
	private static String clientRole1 = '1';
	private static String clientRole2 = '2';
	private static String clientRole3 = '3';
	private static String clientRole4 = '4';
	private static String clientRole5 = '5';
	private static String clientRole6 = '6';
	private static String clientRole7 = '7';
	private static User closedBy = createUser('testUser');
	private static String globalId = '01234';
	private static Account client = createAccount('TestAcc', globalId);

	private static Date validTo1 = Date.today().addMonths(12);
	private static Date validTo2 = Date.today().addMonths(12);
	private static Date validTo3 = Date.today().addMonths(12);

	@IsTest
	static void createClientZoneTest() {
		List<ClientZone__c> clientZonesEmpty = [SELECT Id FROM ClientZone__c WHERE Account__c = :client.Id LIMIT 1];
		System.assert(clientZonesEmpty.isEmpty());

		List<SF_PersonManagementSOAPService.ClientRelationType> accountRelationTypes = new List<SF_PersonManagementSOAPService.ClientRelationType>();
		accountRelationTypes.add(prepareAccountRelationType(validTo1));
		accountRelationTypes.add(prepareAccountRelationType(validTo2));
		accountRelationTypes.add(prepareAccountRelationType(validTo3));
		SF_PersonManagementSOAPService.CreateClientZoneRequest clientZoneRequest = prepareData(accountRelationTypes, globalId, clientRole8NoAccess);
		System.debug('LTEST prepared req: ' + clientZoneRequest);

		Test.startTest();
		SF_PersonManagementSOAPService.CreateCZContractResponseType czContractResponseType = SF_PersonManagementSOAPService.createClientZone(clientZoneRequest);
		Test.stopTest();

		System.debug('LTEST resp: ' + czContractResponseType);
		List<ClientZone__c> clientZones = [SELECT Id, Name, Username__c, VerificationPhone__c, Email__c, Role__c, ClosedBy__c, ExternalId__c, Account__c FROM ClientZone__c WHERE Account__c = :client.Id LIMIT 1];
		System.assertEquals(1, clientZones.size());
		ClientZone__c clientZone = clientZones.get(0);
		System.assertEquals(clientZone.Name, contractNumber);
		System.assertEquals(clientZone.Username__c, userName);
		System.assertEquals(clientZone.VerificationPhone__c, verPhone);
		System.assertEquals(clientZone.Email__c, mail);
		System.assertEquals(clientZone.Role__c, clientRole8NoAccess);
		System.assertEquals(clientZone.ClosedBy__c, closedBy.Id);
		System.assertEquals(clientZone.ExternalId__c, globalId);
		System.assertEquals(clientZone.Account__c, client.Id);

		List<AccountRelation__c> accountRelations = [
				SELECT Id, Account__c, AccountRole__c, RelatedAccount__c, RelatedAccountRole__c, ValidTo__c
				FROM AccountRelation__c
		];
		System.assertEquals(3, accountRelations.size());
		Integer correctValidToCount = 0;
		for (AccountRelation__c accountRelation : accountRelations) {
			System.assertEquals(client.Id, accountRelation.RelatedAccount__c);
			System.assertEquals(clientRole7, accountRelation.RelatedAccountRole__c);
			System.assertEquals(clientRole7, accountRelation.AccountRole__c);
			if (validTo1 == accountRelation.ValidTo__c || validTo2 == accountRelation.ValidTo__c || validTo3 == accountRelation.ValidTo__c) {
				correctValidToCount++;
				System.debug('LTEST validTo upped: ' + correctValidToCount);
			}
		}
		System.assertEquals(3, correctValidToCount);
	}

	@IsTest
	static void updateClientZoneTestFromNoAccess() {
		String globalIdUpdate = 'globalIdUpdate';
		Account account = createAccount('updateAcc', globalIdUpdate);
		ClientZone__c clientZone = new ClientZone__c(Status__c = '1', Account__c = account.Id, Role__c = '8');
		insert clientZone;
		System.debug('LTEST sel ClZone after insert: ' + [SELECT Id, Account__c FROM ClientZone__c WHERE Id = :clientZone.Id]);

		SF_PersonManagementSOAPService.CreateClientZoneRequest clientZoneRequest = prepareData(null, globalIdUpdate, clientRole1);
		System.debug('LTEST req: ' + clientZoneRequest);
		Test.startTest();
		SF_PersonManagementSOAPService.CreateCZContractResponseType czContractResponseType = SF_PersonManagementSOAPService.createClientZone(clientZoneRequest);
		Test.stopTest();

		System.debug('LTEST update resp.: ' + czContractResponseType);
		System.assert(czContractResponseType.isSuccess);
	}

	@IsTest
	static void updateClientZoneTestFromLower() {
		String globalIdUpdate = 'globalIdUpdate';
		Account account = createAccount('updateAcc', globalIdUpdate);
		ClientZone__c clientZone = new ClientZone__c(Status__c = '1', Account__c = account.Id, Role__c = '1');
		insert clientZone;
		System.debug('LTEST sel ClZone after insert: ' + [SELECT Id, Account__c FROM ClientZone__c WHERE Id = :clientZone.Id]);

		SF_PersonManagementSOAPService.CreateClientZoneRequest clientZoneRequest = prepareData(null, globalIdUpdate, clientRole2);
		System.debug('LTEST req: ' + clientZoneRequest);
		Test.startTest();
		SF_PersonManagementSOAPService.CreateCZContractResponseType czContractResponseType = SF_PersonManagementSOAPService.createClientZone(clientZoneRequest);
		Test.stopTest();

		System.debug('LTEST update resp.: ' + czContractResponseType);
		System.assert(czContractResponseType.isSuccess);
	}

	@IsTest
	static void updateClientZoneTestSameLevel() {
		String globalIdUpdate = 'globalIdUpdate';
		Account account = createAccount('updateAcc', globalIdUpdate);
		ClientZone__c clientZone = new ClientZone__c(Status__c = '1', Account__c = account.Id, Role__c = '1');
		insert clientZone;
		System.debug('LTEST sel ClZone after insert: ' + [SELECT Id, Account__c FROM ClientZone__c WHERE Id = :clientZone.Id]);

		SF_PersonManagementSOAPService.CreateClientZoneRequest clientZoneRequest = prepareData(null, globalIdUpdate, clientRole1);
		System.debug('LTEST req: ' + clientZoneRequest);
		Test.startTest();
		SF_PersonManagementSOAPService.CreateCZContractResponseType czContractResponseType = SF_PersonManagementSOAPService.createClientZone(clientZoneRequest);
		Test.stopTest();

		System.debug('LTEST update resp.: ' + czContractResponseType);
		System.assert(czContractResponseType.isSuccess);
	}

	@IsTest
	static void updateClientZoneTestSameLevelWhen8() {
		String globalIdUpdate = 'globalIdUpdate';
		Account account = createAccount('updateAcc', globalIdUpdate);
		ClientZone__c clientZone = new ClientZone__c(Status__c = '1', Account__c = account.Id, Role__c = '8');
		insert clientZone;
		System.debug('LTEST sel ClZone after insert: ' + [SELECT Id, Account__c FROM ClientZone__c WHERE Id = :clientZone.Id]);

		SF_PersonManagementSOAPService.CreateClientZoneRequest clientZoneRequest = prepareData(null, globalIdUpdate, clientRole8NoAccess);
		System.debug('LTEST req: ' + clientZoneRequest);
		Test.startTest();
		SF_PersonManagementSOAPService.CreateCZContractResponseType czContractResponseType = SF_PersonManagementSOAPService.createClientZone(clientZoneRequest);
		Test.stopTest();

		System.debug('LTEST update resp.: ' + czContractResponseType);
		System.assert(czContractResponseType.isSuccess);
	}

	@IsTest
	static void updateClientZoneTestToLower() {
		String globalIdUpdate = 'globalIdUpdate';
		Account account = createAccount('updateAcc', globalIdUpdate);
		ClientZone__c clientZone = new ClientZone__c(Status__c = '1', Account__c = account.Id, Role__c = '6');
		insert clientZone;
		System.debug('LTEST sel ClZone after insert: ' + [SELECT Id, Account__c FROM ClientZone__c WHERE Id = :clientZone.Id]);

		SF_PersonManagementSOAPService.CreateClientZoneRequest clientZoneRequest = prepareData(null, globalIdUpdate, clientRole2);
		System.debug('LTEST req: ' + clientZoneRequest);
		Test.startTest();
		SF_PersonManagementSOAPService.CreateCZContractResponseType czContractResponseType = SF_PersonManagementSOAPService.createClientZone(clientZoneRequest);
		Test.stopTest();

		System.debug('LTEST update resp.: ' + czContractResponseType);
		System.assert(!czContractResponseType.isSuccess);
		System.assertEquals(-3, czContractResponseType.errorNumber);
	}

	@isTest
	static void getNewCZContractIDTest() {
		//in Test Class instantiate the custom settings object
		NumericalSeriesSettings__c customSettingsValue = new NumericalSeriesSettings__c();
		//and create the records of the custom settings
		customSettingsValue.ContractNumber__c = 5.0;
		//and insert it in Test class itself.
		insert customSettingsValue;

		Test.startTest();
		Decimal lastIssuedContractNumber = ClientZoneService.getNewCZContractID();
		Test.stopTest();

		NumericalSeriesSettings__c newIssuedContractNumber = [
			SELECT ContractNumber__c
			FROM NumericalSeriesSettings__c
			LIMIT 1
		];
		System.assertEquals(6, lastIssuedContractNumber);
		System.assert(newIssuedContractNumber != null);
		System.assertEquals(6, newIssuedContractNumber.ContractNumber__c);
	}

	private static SF_PersonManagementSOAPService.CreateClientZoneRequest prepareData(List<SF_PersonManagementSOAPService.ClientRelationType> accountRelationTypes, String globalId, String chosenRole) {
		SF_PersonManagementSOAPService.CreateClientZoneRequest request = new SF_PersonManagementSOAPService.CreateClientZoneRequest();
		SF_PersonManagementSOAPService.ClientZoneType clientZoneType = new SF_PersonManagementSOAPService.ClientZoneType();
		request.clientZone = clientZoneType;

		request.clientZone.contractNumber = contractNumber;
		request.clientZone.userName = userName;
		request.clientZone.verificationPhone = verPhone;
		request.clientZone.email = mail;
		request.clientZone.role = chosenRole;
		request.clientZone.closedBy = closedBy.Id;
		request.clientZone.globalId = globalId;
		request.clientZone.clientId = client.Id;

		request.accountRelations = accountRelationTypes;

		return request;
	}

	private static SF_PersonManagementSOAPService.ClientRelationType prepareAccountRelationType(Date validTo) {
		SF_PersonManagementSOAPService.ClientRelationType accountRelationType = new SF_PersonManagementSOAPService.ClientRelationType();
		accountRelationType.relatedClientId = client.Id;
		accountRelationType.clientRole = clientRole7;
		accountRelationType.validTo = validTo;
		accountRelationType.externalId = generateRandomNumberInString();

		return accountRelationType;
	}

	private static Account createAccount(String lastName, String globalId) {
		Account account = new Account();
		account.LastName = lastName;
		account.GlobalId__c = globalId;
		insert account;
		return account;
	}

	private static User createUser(String userName) {
		Id standardProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id;
		System.debug(standardProfileId);
		User user = new User();
		user.LastName = userName;
		user.Username = userName + '@mail.invalid';
		user.Email = userName + '@mail.invalid';
		user.ProfileId = standardProfileId;
		user.Alias = 'tstU';
		user.TimeZoneSidKey = 'Europe/Prague';
		user.LocaleSidKey = 'cs_CZ';
		user.EmailEncodingKey = 'UTF-8';
		user.LanguageLocaleKey = 'en_US';
		insert user;
		return user;
	}

	public static String generateRandomNumberInString() {
		return String.valueOf(Math.random()).substringAfterLast('.').left(8);
	}
}