global with sharing class SF_PersonManagementSOAPService {

	webService static Id createClient(CreateClientRequest request) {
		try {
			return ClientService.createClientAndContactInfos(request.client, request.personCommunications);
		} catch (Exception exc) {
			Logger.error('SF_PersonManagementSOAPService.createClient createClient operation failed', exc, JSON.serialize(request));
			throw exc;
		} finally {
			Logger.saveLogs();
		}
	}

	webService static CreateCZContractResponseType createClientZone(CreateClientZoneRequest request) {
		try {
			return ClientZoneService.createClientZone(request);
		} catch (Exception exc) {
			Logger.error('SF_PersonManagementSOAPService.createClientZone createClientZone operation failed, exc message: ' + exc.getMessage(), exc, JSON.serialize(request));
			throw exc;
		} finally {
			Logger.saveLogs();
		}
	}

	global class CreateClientRequest {
		webService ClientType client;
		webService List<PersonCommunicationType> personCommunications;
	}

	global class CreateClientZoneRequest {
		webService ClientZoneType clientZone;
		webService List<AccountRelationType> accountRelations;
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
		webService Boolean isPoliticallyExposed;
		webService Boolean isCrResident;
	}

	global class PersonCommunicationType {
		webService String contactType;
		webService String contactSubType;
		webService String contactValue;
		webService AddressType address;
		webService String extCommunicationId;
	}

	global class AddressType {
		webService String city;
		webService String country;
		webService String streetName;
		webService String houseNumber;
		webService String zipCode;
		webService Date validFrom;
		webService Date validTo;
	}

	global class ClientZoneType {
		webService String contractNumber;
		webService String userName;
		webService String verificationPhone;
		webService String email;
		webService String role;
		webService String closedBy;
		webService String globalId;
		webService String clientId;
	}

	global class AccountRelationType {
		webService String relatedClientId;
		webService String clientRole;
		webService Date validTo;
		webService String externalId;
	}

	global class CreateCZContractResponseType {
		webService Boolean isSuccess;
		webService Integer errorNumber;
		webService String errorMessage;
		webService String clientZoneId;
	}
}