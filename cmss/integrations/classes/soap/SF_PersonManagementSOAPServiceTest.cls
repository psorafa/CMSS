@IsTest
private class SF_PersonManagementSOAPServiceTest {

	private static String clientPersonNumber = '0123';
	private static String clientPersonalIdentityNumber = '012345';
	private static String prefixTitle = 'prefix';
	private static String suffixTitle = 'suffix';
	private static String clientGlobalId = '0123456789';
	private static Date birthDate = Date.today().addYears(-20);
	private static String gender = 'male';
	private static Boolean isPoliticallyExposed = false;
	private static Boolean isResident = false;

	private static String city = 'Prague';
	private static String country = '16';
	private static String streetName = 'StreetName';
	private static String houseNumber = '123';
	private static String zipCode = '110000';
	private static Date validFrom = Date.today().addMonths(-3);
	private static Date validTo = Date.today();

	private static String phone = '987654321';
	private static String dataBoxA = 'a1b2c3d4';
	private static String dataBoxZ = 'z9y8x7w6';
	private static String email = 'test@mail.invalid';

	@IsTest
	static void createClientPersonTest() {
		User userSpaA = createUser('testUserSpaA', 'spsA');
		User userSpaC = createUser('testUserSpaC', 'spsC');

		SF_PersonManagementSOAPService.CreateClientRequestType clientRequest = prepareCreateClientRequest(true, true);

		Test.startTest();
		SF_PersonManagementSOAPService.CreateClientResponseType response = SF_PersonManagementSOAPService.createClient(clientRequest);
		Test.stopTest();
		System.assert(!response.isFault, 'Error occurred: ' + JSON.serialize(response.fault));

		Account account = [
			SELECT
				Id, SbId__c, PortfolioMngmtA__c, PortfolioMngmtC__c, RecordType.DeveloperName, PersonalIdentificationNr__c,
				PersonTitle, Suffix, GlobalId__c, Birthdate__c, Gender__c, IsPoliticallyExposed__c, IsResident__c
			FROM Account
			WHERE Id = :response.responseBody.clientId
		];
		System.assertEquals(clientPersonNumber, account.SbId__c);
		System.assertEquals(clientPersonalIdentityNumber, account.PersonalIdentificationNr__c);
		System.assertEquals(userSpaA.Id, account.PortfolioMngmtA__c);
		System.assertEquals(userSpaC.Id, account.PortfolioMngmtC__c);
		System.assertEquals('PersonAccount', account.RecordType.DeveloperName);
		System.assertEquals(prefixTitle, account.PersonTitle);
		System.assertEquals(suffixTitle, account.Suffix);
		System.assertEquals(clientGlobalId, account.GlobalId__c);
		System.assertEquals(birthDate, account.Birthdate__c);
		System.assertEquals(gender, account.Gender__c);
		System.assertEquals(isPoliticallyExposed, account.IsPoliticallyExposed__c);
		System.assertEquals(isResident, account.IsResident__c);

		List<ContactInformation__c> contactInfos = [SELECT Id, PhoneNumber__c, Email__c, DataBoxNumber__c, PostalCode__c, HouseNumber__c, Street__c, StreetAndHouseNumber__c, Country__c, City__c, Value__c, ValidFrom__c, ValidTo__c, Type__c FROM ContactInformation__c];
		System.assertEquals(5, contactInfos.size());
		for (ContactInformation__c contactInfo : contactInfos) {
			if ('1'.equals(contactInfo.Type__c)) {
				System.assertEquals(city, contactInfo.City__c);
				System.assertEquals(streetName, contactInfo.Street__c);
				System.assertEquals(houseNumber, contactInfo.HouseNumber__c);
				System.assertEquals(zipCode, contactInfo.PostalCode__c);
				System.assertEquals(validFrom, contactInfo.ValidFrom__c);
				System.assertEquals(validTo, contactInfo.ValidTo__c);
				System.assertEquals(country, contactInfo.Country__c);
			} else if ('2'.equals(contactInfo.Type__c)) {
				System.assertEquals(phone, contactInfo.PhoneNumber__c);
			} else if ('3'.equals(contactInfo.Type__c)) {
				if (contactInfo.Email__c != null) {
					System.assertEquals(email, contactInfo.Email__c);
				} else {
					System.assertEquals(dataBoxA, contactInfo.DataBoxNumber__c);
				}
			} else if ('4'.equals(contactInfo.Type__c)) {
				System.assertEquals(dataBoxZ, contactInfo.DataBoxNumber__c);
			}
		}
	}

	@IsTest
	static void createClientBusinessTest() {
		User userSpaA = createUser('testUserSpaA', 'spsA');
		User userSpaC = createUser('testUserSpaC', 'spsC');

		SF_PersonManagementSOAPService.CreateClientRequestType clientRequest = prepareCreateClientRequest(false, true);

		Test.startTest();
		SF_PersonManagementSOAPService.CreateClientResponseType response = SF_PersonManagementSOAPService.createClient(clientRequest);
		Test.stopTest();

		Account account = [
			SELECT
				Id, SbId__c, PortfolioMngmtA__c, PortfolioMngmtC__c, RecordType.DeveloperName, PersonalIdentificationNr__c,
				PersonTitle, Suffix, GlobalId__c, Birthdate__c, Gender__c, IsPoliticallyExposed__c, IsResident__c
			FROM Account
			WHERE Id = :response.responseBody.clientId
		];
		System.assertEquals('Business_Account', account.RecordType.DeveloperName);
		System.assertEquals(userSpaA.Id, account.PortfolioMngmtA__c);
		System.assertEquals(userSpaC.Id, account.PortfolioMngmtC__c);
	}

	@IsTest
	static void createClientWithEmptyContactInfoTest() {
		createUser('testUserSpaA', 'spsA');
		createUser('testUserSpaC', 'spsC');
		SF_PersonManagementSOAPService.CreateClientRequestType clientRequest = prepareCreateClientRequest(true, false);

		Test.startTest();
		SF_PersonManagementSOAPService.createClient(clientRequest);
		Test.stopTest();
	}

	@IsTest
	static void createClient_unknownCPU() {
		createUser('testUserSpaA', 'spsA');
		SF_PersonManagementSOAPService.CreateClientRequestType clientRequest = prepareCreateClientRequest(false, false);

		Test.startTest();
		SF_PersonManagementSOAPService.CreateClientResponseType response = SF_PersonManagementSOAPService.createClient(clientRequest);
		Test.stopTest();

		System.assert(response.isFault);
		System.assertEquals(201, response.fault.errorNumber);
		System.assertEquals('Record not found: User - CAN (čpú): spsC', response.fault.message);
	}

	@IsTest
	static void createClient_alreadyExists() {
		insert new Account(
			Name = 'existing',
			GlobalId__c = clientGlobalId
		);
		createUser('testUserSpaA', 'spsA');
		createUser('testUserSpaC', 'spsC');
		SF_PersonManagementSOAPService.CreateClientRequestType clientRequest = prepareCreateClientRequest(false, false);

		Test.startTest();
		SF_PersonManagementSOAPService.CreateClientResponseType response = SF_PersonManagementSOAPService.createClient(clientRequest);
		Test.stopTest();

		System.assert(response.isFault);
		System.assertEquals(202, response.fault.errorNumber);
		System.assertEquals('Record already exists: Client - Global ID: ' + clientGlobalId, response.fault.message);
	}

	private static SF_PersonManagementSOAPService.CreateClientRequestType prepareCreateClientRequest(Boolean personAccount, Boolean createPersonCommunications) {
		SF_PersonManagementSOAPService.CreateClientRequestBody requestBody = new SF_PersonManagementSOAPService.CreateClientRequestBody();
		SF_PersonManagementSOAPService.ClientType clientType = new SF_PersonManagementSOAPService.ClientType();
		requestBody.client = clientType;
		if (createPersonCommunications) {
			requestBody.personCommunications = new List<SF_PersonManagementSOAPService.PersonCommunicationType>();
		}
		requestBody.client.personNumber = clientPersonNumber;
		requestBody.client.personalIdentityNumber = clientPersonalIdentityNumber;
		requestBody.client.name = 'ClientName';
		if (personAccount) {
			requestBody.client.firstName = 'FirstName';
			requestBody.client.lastName = 'LastName';
		} else {
			requestBody.client.name = 'justName';
		}
		requestBody.client.prefixTitle = prefixTitle;
		requestBody.client.suffixTitle = suffixTitle;
		requestBody.client.clientGlobalId = clientGlobalId;
		requestBody.client.birthDate = birthDate;
		requestBody.client.gender = gender;
		requestBody.client.spSa = 'spsA';
		requestBody.client.spSc = 'spsC';
		requestBody.client.isPoliticallyExposed = isPoliticallyExposed;
		requestBody.client.isCrResident = isResident;

		if (createPersonCommunications) {
			requestBody.personCommunications.add(createCommType(1, ''));
			requestBody.personCommunications.add(createCommType(2, '987654321'));
			requestBody.personCommunications.add(createCommType(3, 'a1b2c3d4'));
			requestBody.personCommunications.add(createCommType(3, 'test@mail.invalid'));
			requestBody.personCommunications.add(createCommType(4, 'z9y8x7w6'));
		}
		SF_PersonManagementSOAPService.CreateClientRequestType request = new SF_PersonManagementSOAPService.CreateClientRequestType();
		request.requestBody = requestBody;
		return request;
	}

	private static SF_PersonManagementSOAPService.PersonCommunicationType createCommType(Integer contactType, String contactValue) {
		SF_PersonManagementSOAPService.PersonCommunicationType commType = new SF_PersonManagementSOAPService.PersonCommunicationType();
		commType.extCommunicationId = '0123';
		commType.contactType = String.valueOf(contactType);

		if (contactType == 1) {
			commType.address = createAddressType();
			System.debug('LTE ret commType add: ' + commType);
			return commType;
		}

		commType.contactValue = contactValue;
		System.debug('LTE ret commType: ' + commType);
		return commType;
	}

	private static SF_PersonManagementSOAPService.AddressType createAddressType() {
		SF_PersonManagementSOAPService.AddressType addressType = new SF_PersonManagementSOAPService.AddressType();
		addressType.city = city;
		addressType.country = country;
		addressType.streetName = streetName;
		addressType.houseNumber = houseNumber;
		addressType.zipCode = zipCode;
		addressType.validFrom = validFrom;
		addressType.validTo = validTo;
		return addressType;
	}

	private static User createUser(String userName, String commissionAccountNr) {
		Id standardProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id;
		System.debug(standardProfileId);
		User user = new User();
		user.LastName = userName;
		user.Username = userName + '@mail.invalid';
		user.Email = userName + '@mail.invalid';
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