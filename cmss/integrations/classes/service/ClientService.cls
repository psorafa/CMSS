public with sharing class ClientService {

	private static List<ContactInformation__c> contactInfoList = new List<ContactInformation__c>();

	public static Id createClientAndContactInfos(SF_PersonManagementSOAPService.CreateClientRequest request) {
		Logger.info('createClient request data', null, JSON.serialize(request));
		Id accountId = ClientService.insertAccount(request);
		ClientService.createContactInfos(request.personCommunications, accountId);
		return accountId;
	}

	public static Id insertAccount(SF_PersonManagementSOAPService.CreateClientRequest request) {
		Account client = new Account(
				SbId__c = request.client.personNumber,
				PersonalIdentificationNr__c = request.client.personalIdentityNumber,
				GlobalId__c = request.client.clientGlobalId,
				Birthdate__c = request.client.birthDate,
				Gender__c = request.client.gender,
				PortfolioMngmtA__c = getUserIdByCommissionAccountNr(request.client.spSa),
				PortfolioMngmtC__c = getUserIdByCommissionAccountNr(request.client.spSc),
				IsPoliticallyExposed__c = Boolean.valueOf(request.client.isPoliticallyExposed),
				IsResident__c = Boolean.valueOf(request.client.isCrResident)
		);

		if (request.client.lastName != null) {
			client.FirstName = request.client.firstName;
			client.LastName = request.client.lastName;
			client.PersonTitle = request.client.prefixTitle;
			client.Suffix = request.client.suffixTitle;
			client.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
		} else {
			client.Name = request.client.name;
			client.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
		}
		insert client;
		Logger.info('ClientService inserted account.', 'accountId:' + client.Id);
		return client.Id;
	}

	public static void createContactInfos(List<SF_PersonManagementSOAPService.PersonCommunicationType> communicationTypes, Id accountId) {
		for (SF_PersonManagementSOAPService.PersonCommunicationType commType : communicationTypes) {
			createContactInformation(commType, accountId);
		}
		insert contactInfoList;
		Logger.info('ClientService inserted ContactInformation__c list.', String.join(contactInfoList, ','));
	}

	private static void createContactInformation(SF_PersonManagementSOAPService.PersonCommunicationType commType, Id accountId) {
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

	private static Id getUserIdByCommissionAccountNr(String clientGlobalId) {
		if (clientGlobalId == null) {
			return null;
		}
		List<User> users = [SELECT Id FROM User WHERE CommissionAccountNr__c = :clientGlobalId LIMIT 1];
		if (!users.isEmpty()) {
			return users.get(0).Id;
		}
		throw new ClientServiceException('Unknown commission account number: ' + clientGlobalId);
	}

	private class ClientServiceException extends Exception {

	}
}