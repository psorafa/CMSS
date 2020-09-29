global with sharing class SF_PersonManagementSOAPService {

	webService static Id createClient(CreateClientRequest request) {
		return ClientService.createClientAndContactInfos(request);
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