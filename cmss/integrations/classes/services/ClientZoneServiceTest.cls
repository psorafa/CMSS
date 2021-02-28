@IsTest
private class ClientZoneServiceTest {

	private static String contractNumber = '012345';
	private static String userName = 'user@name.invalid';
	private static String verPhone = '987654321';
	private static String mail = 'user@mail.invalid';
	private static String clientRole8NoAccess = '8';
	private static String clientRole1 = '1';
	private static String clientRole2 = '2';
	private static String closedBy = createUser('Mr.Tester', 'uGlobId', 'closedBy1234').CommissionAccountNr__c;
	private static String globalId = '01234';
	private static Account client = createAccount('TestAcc', globalId);

	private static String externalId1 = 'ext1';
	private static String externalId2 = 'ext2';
	private static String externalId3 = 'ext3';

	private static Date validTo1 = Date.today().addMonths(12);
	private static Date validTo2 = Date.today().addMonths(13);
	private static Date validTo3 = Date.today().addMonths(14);

	@IsTest
	static void createClientZoneTest() {
		List<ClientZone__c> clientZonesEmpty = [SELECT Id FROM ClientZone__c WHERE Account__c = :client.Id LIMIT 1];
		System.assert(clientZonesEmpty.isEmpty());

		User user = createUser('MrTester', 'mrTesterGlobal', 'closedBy9876');
		List<SF_PersonManagementSOAPService.ClientRelationType> clientRelationTypes = new List<SF_PersonManagementSOAPService.ClientRelationType>();
		clientRelationTypes.add(prepareAccountRelationType(validTo1, client.GlobalId__c, externalId1));
		clientRelationTypes.add(prepareAccountRelationType(validTo2, client.GlobalId__c, externalId2));
		clientRelationTypes.add(prepareAccountRelationType(validTo3, client.GlobalId__c, externalId3));
		SF_PersonManagementSOAPService.CreateCZContractRequestType clientZoneRequest = prepareCreateClientRequest(clientRelationTypes, globalId, clientRole8NoAccess, user.CommissionAccountNr__c);

		Test.startTest();
		SF_PersonManagementSOAPService.CreateCZContractResponseType czContractResponseType = SF_PersonManagementSOAPService.createCZContract(clientZoneRequest);
		Test.stopTest();

		System.assertEquals(false, czContractResponseType.isFault);
		System.assertNotEquals(null, czContractResponseType.responseBody.clientZoneId);

		List<ClientZone__c> clientZones = [SELECT Id, Name, Username__c, VerificationPhone__c, Email__c, Role__c, ClosedBy__c, ExternalId__c, Account__c FROM ClientZone__c WHERE Id = :czContractResponseType.responseBody.clientZoneId];
		System.assertEquals(1, clientZones.size());
		ClientZone__c clientZone = clientZones.get(0);
		System.assertEquals(clientZone.Name, contractNumber);
		System.assertEquals(clientZone.Username__c, userName);
		System.assertEquals(clientZone.VerificationPhone__c, verPhone);
		System.assertEquals(clientZone.Email__c, mail);
		System.assertEquals(clientZone.Role__c, clientRole8NoAccess);
		System.assertEquals(clientZone.ClosedBy__c, user.Id);
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
			System.assertEquals('1501', accountRelation.RelatedAccountRole__c);
			System.assertEquals('1502', accountRelation.AccountRole__c);
			if (validTo1 == accountRelation.ValidTo__c || validTo2 == accountRelation.ValidTo__c || validTo3 == accountRelation.ValidTo__c) {
				correctValidToCount++;
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

		SF_PersonManagementSOAPService.CreateCZContractRequestType clientZoneRequest = prepareCreateClientRequest(null, globalIdUpdate, clientRole1, closedBy);
		Test.startTest();
		SF_PersonManagementSOAPService.CreateCZContractResponseType czContractResponseType = SF_PersonManagementSOAPService.createCZContract(clientZoneRequest);
		Test.stopTest();

		System.assertEquals(clientZone.Id, czContractResponseType.responseBody.clientZoneId);
	}

	@IsTest
	static void updateClientZoneTestFromLower() {
		String globalIdUpdate = 'globalIdUpdate';
		Account account = createAccount('updateAcc', globalIdUpdate);
		ClientZone__c clientZone = new ClientZone__c(Status__c = '1', Account__c = account.Id, Role__c = '1');
		insert clientZone;

		SF_PersonManagementSOAPService.CreateCZContractRequestType clientZoneRequest = prepareCreateClientRequest(null, globalIdUpdate, clientRole2, closedBy);
		Test.startTest();
		SF_PersonManagementSOAPService.CreateCZContractResponseType czContractResponseType = SF_PersonManagementSOAPService.createCZContract(clientZoneRequest);
		Test.stopTest();

		System.assertEquals(false, czContractResponseType.isFault);
		System.assertEquals(clientZone.Id, czContractResponseType.responseBody.clientZoneId);
	}

	@IsTest
	static void updateClientZoneTestSameLevel() {
		String globalIdUpdate = 'globalIdUpdate';
		Account account = createAccount('updateAcc', globalIdUpdate);
		ClientZone__c clientZone = new ClientZone__c(Status__c = '1', Account__c = account.Id, Role__c = '1');
		insert clientZone;

		SF_PersonManagementSOAPService.CreateCZContractRequestType clientZoneRequest = prepareCreateClientRequest(null, globalIdUpdate, clientRole1, closedBy);
		Test.startTest();
		SF_PersonManagementSOAPService.CreateCZContractResponseType czContractResponseType = SF_PersonManagementSOAPService.createCZContract(clientZoneRequest);
		Test.stopTest();

		System.assertEquals(false, czContractResponseType.isFault);
		System.assertEquals(clientZone.Id, czContractResponseType.responseBody.clientZoneId);
	}

	@IsTest
	static void updateClientZoneTestSameLevelWhen8() {
		String globalIdUpdate = 'globalIdUpdate';
		Account account = createAccount('updateAcc', globalIdUpdate);
		ClientZone__c clientZone = new ClientZone__c(Status__c = '1', Account__c = account.Id, Role__c = '8');
		insert clientZone;

		SF_PersonManagementSOAPService.CreateCZContractRequestType clientZoneRequest = prepareCreateClientRequest(null, globalIdUpdate, clientRole8NoAccess, closedBy);
		Test.startTest();
		SF_PersonManagementSOAPService.CreateCZContractResponseType czContractResponseType = SF_PersonManagementSOAPService.createCZContract(clientZoneRequest);
		Test.stopTest();

		System.assertEquals(false, czContractResponseType.isFault);
		System.assertEquals(clientZone.Id, czContractResponseType.responseBody.clientZoneId);
	}

	@IsTest
	static void updateClientZoneTestToLower() {
		String globalIdUpdate = 'globalIdUpdate';
		Account account = createAccount('updateAcc', globalIdUpdate);
		ClientZone__c clientZone = new ClientZone__c(Status__c = '1', Account__c = account.Id, Role__c = '6');
		insert clientZone;

		SF_PersonManagementSOAPService.CreateCZContractRequestType clientZoneRequest = prepareCreateClientRequest(null, globalIdUpdate, clientRole2, closedBy);
		Test.startTest();
		SF_PersonManagementSOAPService.CreateCZContractResponseType czContractResponseType = SF_PersonManagementSOAPService.createCZContract(clientZoneRequest);
		Test.stopTest();

		System.assert(czContractResponseType.isFault);
		System.assert(czContractResponseType.fault.message.contains('Record already exists:'));
	}

	@IsTest
	static void createClientZoneClosedByUserDoesntExistTest() {
		List<ClientZone__c> clientZonesEmpty = [SELECT Id FROM ClientZone__c WHERE Account__c = :client.Id LIMIT 1];
		System.assert(clientZonesEmpty.isEmpty());

		SF_PersonManagementSOAPService.CreateCZContractRequestType clientZoneRequest = prepareCreateClientRequest(null, globalId, clientRole8NoAccess, 'closedBy9876');

		Test.startTest();
		SF_PersonManagementSOAPService.CreateCZContractResponseType czContractResponseType = SF_PersonManagementSOAPService.createCZContract(clientZoneRequest);
		Test.stopTest();
		System.assert(czContractResponseType.isFault);
		System.assert(czContractResponseType.fault.message.contains('Record not found: User - CPU:'));
	}

	@IsTest
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

	@IsTest
	static void mixedInsertUpdateOfAccountRelation() {
		String startGlobalId = 'startGlobalId';
		String globalIdAnother = 'globalIdAnother';
		Account account = createAccount('updateAcc', startGlobalId);
		Account anotherAcc = createAccount('anotherAcc', globalIdAnother);
		ClientZone__c clientZone = new ClientZone__c(Status__c = '1', Account__c = account.Id, Role__c = '1');
		insert clientZone;
		AccountRelation__c accountRelation = new AccountRelation__c(IsActive__c = true, Account__c = account.Id, RelatedAccount__c = account.Id, AccountRole__c = '5', ClientZoneID__c = clientZone.Id, ExternalId__c = externalId1);
		insert accountRelation;

		List<SF_PersonManagementSOAPService.ClientRelationType> clientRelationTypes = new List<SF_PersonManagementSOAPService.ClientRelationType>();
		clientRelationTypes.add(prepareAccountRelationType(validTo1, client.GlobalId__c, externalId1));
		clientRelationTypes.add(prepareAccountRelationType(validTo2, anotherAcc.GlobalId__c, externalId2));

		SF_PersonManagementSOAPService.CreateCZContractRequestType clientZoneRequest = prepareCreateClientRequest(clientRelationTypes, startGlobalId, clientRole2, closedBy);

		Test.startTest();
		SF_PersonManagementSOAPService.CreateCZContractResponseType czContractResponseType = SF_PersonManagementSOAPService.createCZContract(clientZoneRequest);
		Test.stopTest();

		System.assertEquals(false, czContractResponseType.isFault);
		System.assertEquals(2, [SELECT COUNT() FROM AccountRelation__c]);
	}

	@IsTest
	static void updateCZTest() {
		Date aDate = Date.today();
		Account account = createAccount('test', 'globalId');
		ClientZone__c clientZone = TestDataFactory.getClientZone(new ClientZone__c(
			Name = 'testCZ',
			Account__c = account.Id
		));
		insert clientZone;

		SF_PersonManagementSOAPService.ClientZoneUpdateType cz = new SF_PersonManagementSOAPService.ClientZoneUpdateType();
		cz.id = clientZone.ExternalId__c;
		cz.userName = 'usrnm';
		cz.verificationPhone = '123123123';
		cz.email = 'test@test.test';
		cz.role = '1';
		cz.signatureDate = aDate;
		cz.agreementDate = aDate;
		cz.status = '1';
		SF_PersonManagementSOAPService.UpdateCZRequestType req = new SF_PersonManagementSOAPService.UpdateCZRequestType();
		req.requestBody = cz;
		req.requestHeader = new SOAPCommonTypes.CommonHeader();

		Test.startTest();
		SF_PersonManagementSOAPService.UpdateCZResponseType res = SF_PersonManagementSOAPService.updateCZ(req);
		Test.stopTest();

		System.assert(!res.isFault, '' + res.fault);
		clientZone = [SELECT Username__c, VerificationPhone__c, Email__c, Role__c, SignatureDate__c, AgreementDate__c, Status__c FROM ClientZone__c WHERE Id = :clientZone.Id];
		System.assertEquals(cz.userName, clientZone.Username__c);
		System.assertEquals(cz.verificationPhone, clientZone.VerificationPhone__c);
		System.assertEquals(cz.email, clientZone.Email__c);
		System.assertEquals(cz.role, clientZone.Role__c);
		System.assertEquals(cz.signatureDate, clientZone.SignatureDate__c);
		System.assertEquals(cz.agreementDate, clientZone.AgreementDate__c);
		System.assertEquals(cz.status, clientZone.Status__c);
	}

	@IsTest
	static void updateCZTestErrors() {
		Account account = createAccount('test', 'globalId');
		ClientZone__c clientZone = new ClientZone__c(
			Name = 'testCZ',
			Account__c = account.Id
		);
		insert clientZone;
		delete clientZone;

		SF_PersonManagementSOAPService.ClientZoneUpdateType cz = new SF_PersonManagementSOAPService.ClientZoneUpdateType();
		cz.id = clientZone.Id;
		SF_PersonManagementSOAPService.UpdateCZRequestType req = new SF_PersonManagementSOAPService.UpdateCZRequestType();
		req.requestBody = cz;
		req.requestHeader = new SOAPCommonTypes.CommonHeader();

		Test.startTest();
		SF_PersonManagementSOAPService.UpdateCZResponseType res = SF_PersonManagementSOAPService.updateCZ(req);
		System.assert(res.isFault);
		System.assertEquals(201, res.fault.errorNumber);

		cz.id = null;
		res = SF_PersonManagementSOAPService.updateCZ(req);
		System.assert(res.isFault);
		System.assertEquals(101, res.fault.errorNumber);
		Test.stopTest();
	}

	@IsTest
	static void testGetNextCZAmendment() {
		ClientZone__c clientZone1 = TestDataFactory.getClientZone(new ClientZone__c(
			NumberOfAnnexes__c = null
		));
		ClientZone__c clientZone2 = TestDataFactory.getClientZone(new ClientZone__c(
			NumberOfAnnexes__c = 2
		));
		insert new List<ClientZone__c>{
			clientZone1, clientZone2
		};

		SF_PersonManagementSOAPService.GetNextCZAmendmentRequestBody request = new SF_PersonManagementSOAPService.GetNextCZAmendmentRequestBody();
		request.clientZoneId = clientZone1.ExternalId__c;
		System.assertEquals(1, ClientZoneService.getNextCZAmendment(request));

		request = new SF_PersonManagementSOAPService.GetNextCZAmendmentRequestBody();
		request.clientZoneId = clientZone2.ExternalId__c;
		System.assertEquals(3, ClientZoneService.getNextCZAmendment(request));
	}

	private static SF_PersonManagementSOAPService.CreateCZContractRequestType prepareCreateClientRequest(List<SF_PersonManagementSOAPService.ClientRelationType> clientRelationTypes, String globalId, String chosenRole, String closedBy) {
		SF_PersonManagementSOAPService.CreateCZContractRequestType request = new SF_PersonManagementSOAPService.CreateCZContractRequestType();
		SF_PersonManagementSOAPService.CreateCZContractRequestBody requestBody = new SF_PersonManagementSOAPService.CreateCZContractRequestBody();
		SF_PersonManagementSOAPService.ClientZoneType clientZoneType = new SF_PersonManagementSOAPService.ClientZoneType();
		requestBody.clientZone = clientZoneType;

		requestBody.clientZone.contractNumber = contractNumber;
		requestBody.clientZone.userName = userName;
		requestBody.clientZone.verificationPhone = verPhone;
		requestBody.clientZone.email = mail;
		requestBody.clientZone.role = chosenRole;
		requestBody.clientZone.closedBy = closedBy;
		requestBody.clientZone.globalId = globalId;

		requestBody.clientRelations = clientRelationTypes;

		request.requestBody = requestBody;

		return request;
	}

	private static SF_PersonManagementSOAPService.ClientRelationType prepareAccountRelationType(Date validTo, String clientGlobalId, String externalId) {
		SF_PersonManagementSOAPService.ClientRelationType accountRelationType = new SF_PersonManagementSOAPService.ClientRelationType();
		accountRelationType.relatedClientId = clientGlobalId;
		accountRelationType.validTo = validTo;
		accountRelationType.externalId = externalId;

		return accountRelationType;
	}

	private static Account createAccount(String lastName, String globalId) {
		Account account = new Account();
		account.LastName = lastName;
		account.GlobalId__c = globalId;
		insert account;
		return account;
	}

	private static User createUser(String userName, String globalIdUser, String commissionAccountNr) {
		Id standardProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id;
		User user = new User();
		user.FirstName = 'FirstName';
		user.LastName = userName;
		user.Username = userName + '@mail.invalid';
		user.Email = userName.trim() + '@mail.invalid';
		user.GlobalId__c = globalIdUser;
		user.CommissionAccountNr__c = commissionAccountNr;

		user.ProfileId = standardProfileId;
		user.Alias = 'tstU';
		user.TimeZoneSidKey = 'Europe/Prague';
		user.LocaleSidKey = 'cs_CZ';
		user.EmailEncodingKey = 'UTF-8';
		user.LanguageLocaleKey = 'en_US';
		insert user;
		return user;
	}
}
