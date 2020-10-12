@IsTest
private class ClientZoneServiceTest {

	private static String contractNumber = '012345';
	private static String userName = 'user@name.invalid';
	private static String verPhone = '987654321';
	private static String mail = 'user@mail.invalid';
	private static String clientRole = '7';
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
		SF_PersonManagementSOAPService.CreateClientZoneRequest clientZoneRequest = prepareData(accountRelationTypes);
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
		System.assertEquals(clientZone.Role__c, clientRole);
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
			System.assertEquals(clientRole, accountRelation.RelatedAccountRole__c);
			System.assertEquals(clientRole, accountRelation.AccountRole__c);
			if (validTo1 == accountRelation.ValidTo__c || validTo2 == accountRelation.ValidTo__c || validTo3 == accountRelation.ValidTo__c) {
				correctValidToCount ++;
				System.debug('LTEST validTo upped: ' + correctValidToCount);
			}
		}
		System.assertEquals(3, correctValidToCount);
	}

	private static SF_PersonManagementSOAPService.CreateClientZoneRequest prepareData(List<SF_PersonManagementSOAPService.ClientRelationType> accountRelationTypes) {
		SF_PersonManagementSOAPService.CreateClientZoneRequest request = new SF_PersonManagementSOAPService.CreateClientZoneRequest();
		SF_PersonManagementSOAPService.ClientZoneType clientZoneType = new SF_PersonManagementSOAPService.ClientZoneType();
		request.clientZone = clientZoneType;

		request.clientZone.contractNumber = contractNumber;
		request.clientZone.userName = userName;
		request.clientZone.verificationPhone = verPhone;
		request.clientZone.email = mail;
		request.clientZone.role = clientRole;
		request.clientZone.closedBy = closedBy.Id;
		request.clientZone.globalId = globalId;
		request.clientZone.clientId = client.Id;

		request.accountRelations = accountRelationTypes;

		return request;
	}

	private static SF_PersonManagementSOAPService.ClientRelationType prepareAccountRelationType(Date validTo) {
		SF_PersonManagementSOAPService.ClientRelationType accountRelationType = new SF_PersonManagementSOAPService.ClientRelationType();
		accountRelationType.relatedClientId = client.Id;
		accountRelationType.clientRole = clientRole;
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