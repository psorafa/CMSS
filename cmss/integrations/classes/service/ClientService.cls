public with sharing class ClientService {

	private static List<ContactInformation__c> contactInfoList = new List<ContactInformation__c>();

	public static Id createClientAndContactInfos(SF_PersonManagementSOAPService.CreateClientRequest request) {
		try {
			Logger.info('createClient request data', null, request.toString());
			Id accountId = ClientService.insertAccount(request);
			ClientService.createContactInfos(request.personCommunications, accountId);
			return accountId;
		} catch (Exception exc) {
			Logger.error('SF_PersonManagementSOAPService.createClient ContactInformation insert failed', exc, request.toString());
			throw exc;
		} finally {
			Logger.saveLogs();
		}
	}

	public static Id insertAccount(SF_PersonManagementSOAPService.CreateClientRequest request) {
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

		if (request.client.lastName != null) {
			client.FirstName = request.client.firstName;
			client.LastName = request.client.lastName;
		} else {
			client.Name = request.client.name;
		}

		try {
			insert client;
		} catch (Exception ex) {
			Logger.error('SF_PersonManagementSOAPService.createClient Account insert failed', ex, request.toString());
		}
		return client.Id;
	}

	public static void createContactInfos(List<SF_PersonManagementSOAPService.PersonCommunicationType> communicationTypes, Id accountId) {
		for (SF_PersonManagementSOAPService.PersonCommunicationType commType : communicationTypes) {
			createContactInformation(commType, accountId);
		}
		if (!contactInfoList.isEmpty()) {
			try {
				System.debug('contactInfoList toString(): ' + contactInfoList.toString());
				insert contactInfoList;
			} catch (Exception ex) {
				Logger.error('SF_PersonManagementSOAPService.createContactInfos Contact info list insert failed', ex, contactInfoList.toString());
				throw ex;
			}
		}
	}

	private static void createContactInformation(SF_PersonManagementSOAPService.PersonCommunicationType commType, Id accountId) {
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
}