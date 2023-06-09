public without sharing class ClientService {
	private static List<ContactInformation__c> contactInfoList = new List<ContactInformation__c>();

	public static Id createClientAndContactInfos(
		SF_PersonManagementSOAPService.ClientType client,
		List<SF_PersonManagementSOAPService.PersonCommunicationType> personCommunications
	) {
		Id accountId = ClientService.insertAccount(client);
		ClientService.createContactInfos(personCommunications, accountId);
		return accountId;
	}

	public static Id insertAccount(SF_PersonManagementSOAPService.ClientType clientType) {
		Account client = new Account(
			SbId__c = clientType.personNumber,
			PersonalIdentificationNr__c = clientType.personalIdentityNumber,
			GlobalId__c = clientType.clientGlobalId,
			ExternalId__c = clientType.externalId,
			Birthdate__c = clientType.birthDate,
			Nationality__c = clientType.citizenship,
			Gender__c = clientType.gender,
			IsPoliticallyExposed__c = clientType.isPoliticallyExposed,
			IsResident__c = clientType.isCrResident
		);
		if (clientType.spSa != null) {
			client.PortfolioMngmtA__c = ReferenceUtility.getUserByCPU(clientType.spSa).Id;
		}
		if (clientType.spSc != null) {
			client.PortfolioMngmtC__c = ReferenceUtility.getUserByCPU(clientType.spSc).Id;
		}
		if (clientType.lastName != null) {
			client.FirstName = clientType.firstName;
			client.LastName = clientType.lastName;
			client.PersonTitle = clientType.prefixTitle;
			client.Suffix = clientType.suffixTitle;
			client.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('PersonAccount')
				.getRecordTypeId();
		} else {
			client.Name = clientType.name;
			client.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
				.get('Business_Account')
				.getRecordTypeId();
		}
		SObjectUtil.stripNullFields(client);

		try {
			DmlUtility.insertRecord(client);
		} catch (SOAPCommonTypes.BusinessException ex) {
			DmlException e = (DmlException) ex.getCause();
			if (e.getDmlType(0) == StatusCode.DUPLICATE_VALUE) {
				if (accountAlreadyExists(clientType.clientGlobalId, 'GlobalId__c')) {
					throw new SOAPCommonTypes.BusinessException(
						202,
						'Record already exists: Client - Global ID: ' + clientType.clientGlobalId
					);
				}
				if (accountAlreadyExists(clientType.externalId, 'ExternalId__c')) {
					throw new SOAPCommonTypes.BusinessException(
						202,
						'Record already exists: Client - External ID: ' + clientType.externalId
					);
				}
			}
			throw ex;
		}
		Logger.debug('Inserted account', JSON.serialize(client));
		return client.Id;
	}

	public static void createContactInfos(
		List<SF_PersonManagementSOAPService.PersonCommunicationType> communicationTypes,
		Id accountId
	) {
		if (communicationTypes == null || communicationTypes.isEmpty()) {
			return;
		}
		for (SF_PersonManagementSOAPService.PersonCommunicationType commType : communicationTypes) {
			createContactInformation(commType, accountId);
		}
		SObjectUtil.stripNullFields(contactInfoList);
		DmlUtility.insertRecords(contactInfoList);
		Logger.debug('Inserted ContactInformation__c list', JSON.serialize(contactInfoList));
	}

	private static void createContactInformation(
		SF_PersonManagementSOAPService.PersonCommunicationType commType,
		Id accountId
	) {
		ContactInformation__c contactInfo = new ContactInformation__c(
			Account__c = accountId,
			Type__c = commType.contactType,
			SubType__c = commType.contactSubType
		);
		if ('1'.equals(commType.contactType)) {
			contactInfo.City__c = commType.address.city;
			contactInfo.Country__c = commType.address.country;
			contactInfo.Street__c = commType.address.streetName;
			contactInfo.HouseNumber__c = commType.address.houseNumber;
			contactInfo.PostalCode__c = commType.address.zipCode;
			contactInfo.ValidFrom__c = commType.address.validFrom;
			contactInfo.ValidTo__c = commType.address.validTo;
		} else if ('2'.equals(commType.contactType)) {
			contactInfo.PhoneNumber__c = commType.contactValue;
		} else if ('3'.equals(commType.contactType)) {
			if (commType.contactValue.contains('@')) {
				contactInfo.Email__c = commType.contactValue;
			} else {
				contactInfo.DataBoxNumber__c = commType.contactValue;
			}
		} else if ('4'.equals(commType.contactType)) {
			contactInfo.DataBoxNumber__c = commType.contactValue;
		}
		contactInfoList.add(contactInfo);
	}

	private static Boolean accountAlreadyExists(String id, String uniqueFieldName) {
		List<Account> duplicates = Database.query(
			'SELECT Id FROM Account WHERE ' +
				uniqueFieldName +
				' = ' +
				'\'' +
				id +
				'\'' +
				' LIMIT 1'
		);
		if (duplicates.isEmpty()) {
			return false;
		}
		return true;
	}
}
