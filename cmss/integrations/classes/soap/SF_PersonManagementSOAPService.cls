global with sharing class SF_PersonManagementSOAPService {

	private static List<ContactInformation__c> contactInfoList = new List<ContactInformation__c>();

	webService static Id createClient(CreateClientRequest request) {
		DmlException ex = new DmlException();
		Logger.info('createClient request data', ex, request.toString());
		Id accountId = insertAccount(request);

		for (SF_PersonManagementSOAPService.PersonCommunicationType commType : request.personCommunications) {
			createContactInformation(commType, accountId);
		}
		try {
			insert contactInfoList;
		} catch (Exception exc) {
			System.debug('SF_PersonManagementSOAPService.createClient ContactInformation insert failed: ' + exc);
			Logger.error('SF_PersonManagementSOAPService.createClient ContactInformation insert failed', exc, request.toString());
		}
		return accountId;
	}

	private static Id insertAccount(CreateClientRequest request) {
		Account client = new Account(
				SbId__c = request.client.personNumber,
				PersonalIdentificationNr__c = request.client.personalIdentityNumber,
				PersonTitle = request.client.prefixTitle,
				Suffix = request.client.suffixTitle,
				GlobalId__c = request.client.clientGlobalId,
				Birthdate__c = request.client.birthDate,
				Gender__c = request.client.gender,
//				PortfolioManagementA__r = request.client.spSa,
//				PortfolioManagementC__r = request.client.spSc,
//				loyalty program ??
				IsPoliticallyExposed__c = Boolean.valueOf(request.client.isPoliticallyExposed),
				IsResident__c = Boolean.valueOf(request.client.isCrResident)
		);

		if (request.client.firstName != null && request.client.lastName != null) {
			client.FirstName = request.client.firstName;
			client.LastName = request.client.lastName;
		} else {
			client.Name = request.client.name;
		}

		try {
			insert client;
		} catch (Exception ex) {
			System.debug('SF_PersonManagementSOAPService.createClient Account insert failed: ' + ex);
			Logger.error('SF_PersonManagementSOAPService.createClient Account insert failed', ex, request.toString());
		}
		return client.Id;
	}

	private static void createContactInformation(PersonCommunicationType commType, Id accountId) {
		ContactInformation__c contactInfo = new ContactInformation__c(
				Account__c = accountId,
				Type__c = commType.contactType,
				SubType__c = commType.contactSubType,
				Email__c = commType.email,
				PhoneNumber__c = commType.phone,
//				Fax__c = commType.??,
//				DataBoxNumber__c = commType.??,
				City__c = commType.address.city,
				Country__c = commType.address.country,
				Street__c = commType.address.streetName,
				HouseNumber__c = commType.address.houseNumber,
				PostalCode__c = commType.address.zipCode,
				ValidFrom__c = commType.address.validFrom,
				ValidTo__c = commType.address.validTo
		);
		contactInfoList.add(contactInfo);
	}

	global class CreateClientRequest {
		webService ClientType client;
		webService List<PersonCommunicationType> personCommunications;
	}

	global class ClientType {
		webService String personNumber;
		webService String personalIdentityNumber;
		webService String name;
		webService String firstName;
		webService String lastName;
		webService String prefixTitle;
		webService String suffixTitle;
		webService String clientGlobalId;
		webService Date birthDate;
		webService String gender;
		webService String spSa;
		webService String spSc;
		webService String isPoliticallyExposed;
		webService String isCrResident;
		webService String loyaltyProgram;
	}

	global class PersonCommunicationType {
		webService String contactType;
		webService String contactSubType;
		webService String contactValue;
		webService AddressType address;
		webService String email;
		webService String phone;
		webService String extCommunicationId;
		webService String sourceApp;
	}

	global class AddressType {
		webService String city;
		webService String country;
		webService String streetName;
		webService String houseNumber;
		webService String zipCode;
		webService Date validFrom;
		webService Date validTo;
		webService String type;
		webService String subType;
	}
}