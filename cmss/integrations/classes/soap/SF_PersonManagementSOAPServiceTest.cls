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

		SF_PersonManagementSOAPService.CreateClientRequest clientRequest = prepareData(true, true);

		Test.startTest();
		Id accountId = SF_PersonManagementSOAPService.createClient(clientRequest);
		Test.stopTest();

		List<Account> accounts = [SELECT Id, SbId__c, PortfolioMngmtA__c, PortfolioMngmtC__c, RecordTypeId, PersonalIdentificationNr__c, PersonTitle, Suffix, GlobalId__c, Birthdate__c, Gender__c, IsPoliticallyExposed__c, IsResident__c FROM Account WHERE Id = :accountId];
		System.assertEquals(1, accounts.size());
		System.assertEquals(clientPersonNumber, accounts.get(0).SbId__c);
		System.assertEquals(clientPersonalIdentityNumber, accounts.get(0).PersonalIdentificationNr__c);
		System.assertEquals(userSpaA.Id, accounts.get(0).PortfolioMngmtA__c);
		System.assertEquals(userSpaC.Id, accounts.get(0).PortfolioMngmtC__c);
		System.assertEquals(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId(), accounts.get(0).RecordTypeId);
		System.assertEquals(prefixTitle, accounts.get(0).PersonTitle);
		System.assertEquals(suffixTitle, accounts.get(0).Suffix);
		System.assertEquals(clientGlobalId, accounts.get(0).GlobalId__c);
		System.assertEquals(birthDate, accounts.get(0).Birthdate__c);
		System.assertEquals(gender, accounts.get(0).Gender__c);
		System.assertEquals(isPoliticallyExposed, accounts.get(0).IsPoliticallyExposed__c);
		System.assertEquals(isResident, accounts.get(0).IsResident__c);

		List<ContactInformation__c> contactInfos = [SELECT Id, PhoneNumber__c, Email__c, DataBoxNumber__c, PostalCode__c, HouseNumber__c, Street__c, StreetAndHouseNumber__c, Country__c, City__c, Value__c, ValidFrom__c, ValidTo__c, Type__c FROM ContactInformation__c];
		System.assertEquals(5, contactInfos.size());
		for (ContactInformation__c contactInfo : contactInfos) {
			System.debug('LTE conInfo: ' + contactInfo);
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
				System.debug('LTE is type 3: ' + contactInfo);
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

		SF_PersonManagementSOAPService.CreateClientRequest clientRequest = prepareData(false, true);

		Test.startTest();
		Id accountId = SF_PersonManagementSOAPService.createClient(clientRequest);
		Test.stopTest();

		List<Account> accounts = [SELECT Id, SbId__c, PortfolioMngmtA__c, PortfolioMngmtC__c, RecordTypeId, PersonalIdentificationNr__c, PersonTitle, Suffix, GlobalId__c, Birthdate__c, Gender__c, IsPoliticallyExposed__c, IsResident__c FROM Account WHERE Id = :accountId];
		System.assertEquals(1, accounts.size());
		System.assertEquals(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId(), accounts.get(0).RecordTypeId);
	}

	@IsTest
	static void createClientWithEmptyContactInfoTest() {
		User userSpaA = createUser('testUserSpaA', 'spsA');
		User userSpaC = createUser('testUserSpaC', 'spsC');

		SF_PersonManagementSOAPService.CreateClientRequest clientRequest = prepareData(true, false);
		System.debug('LTE request with empty contactInfos: ' + clientRequest);

		Test.startTest();
		Id accountId = SF_PersonManagementSOAPService.createClient(clientRequest);
		Test.stopTest();

		List<Account> accounts = [
				SELECT Id, SbId__c, PortfolioMngmtA__c, PortfolioMngmtC__c, RecordTypeId, PersonalIdentificationNr__c, PersonTitle, Suffix, GlobalId__c, Birthdate__c, Gender__c, IsPoliticallyExposed__c, IsResident__c
				FROM Account
				WHERE Id = :accountId
		];
		System.assertEquals(1, accounts.size());
		System.assertEquals(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId(), accounts.get(0).RecordTypeId);
	}

	private static SF_PersonManagementSOAPService.CreateClientRequest prepareData(Boolean personAccount, Boolean createPersonCommunications) {
		SF_PersonManagementSOAPService.CreateClientRequest request = new SF_PersonManagementSOAPService.CreateClientRequest();
		SF_PersonManagementSOAPService.ClientType clientType = new SF_PersonManagementSOAPService.ClientType();
		request.client = clientType;
		if (createPersonCommunications) {
			request.personCommunications = new List<SF_PersonManagementSOAPService.PersonCommunicationType>();
		}
		request.client.personNumber = clientPersonNumber;
		request.client.personalIdentityNumber = clientPersonalIdentityNumber;
		request.client.name = 'ClientName';
		if (personAccount) {
			request.client.firstName = 'FirstName';
			request.client.lastName = 'LastName';
		} else {
			request.client.name = 'justName';
		}
		request.client.prefixTitle = prefixTitle;
		request.client.suffixTitle = suffixTitle;
		request.client.clientGlobalId = clientGlobalId;
		request.client.birthDate = birthDate;
		request.client.gender = gender;
		request.client.spSa = 'spsA';
		request.client.spSc = 'spsC';
		request.client.isPoliticallyExposed = String.valueOf(isPoliticallyExposed);
		request.client.isCrResident = String.valueOf(isResident);

		if (createPersonCommunications) {
			request.personCommunications.add(createCommType(1, ''));
			request.personCommunications.add(createCommType(2, '987654321'));
			request.personCommunications.add(createCommType(3, 'a1b2c3d4'));
			request.personCommunications.add(createCommType(3, 'test@mail.invalid'));
			request.personCommunications.add(createCommType(4, 'z9y8x7w6'));
		}

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