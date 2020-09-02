global with sharing class SF_PersonManagementSOAP {

	webService static String createClient(CreateClientRequest request) {
		return MockServicesUtil.generateRandomString(18);
	}

	global class CreateClientRequest {
		webService ClientType clientType;
		webService List<PersonCommunicationType> personCommunicationType;
	}

	global class ClientType {
		webService String personNumber;
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
		webService String ico;
		webService String clientZone;
		webService String loginKz;
		webService String activatedKz;
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
		webService Date validFrom;
		webService Date validTo;
		webService Date agenda;
		webService Date role;
		webService Date roleObjectId;
		webService Date objectType;
		webService Boolean priority;
		webService Boolean nonConfirm;
		webService String communicationMcsbGuid;
		webService String extCommunicationId;
		webService String sourceApp;
	}

	global class AddressType {
		webService String city;
		webService String country;
		webService String streetName;
		webService Integer houseNumber;
		webService String zipCode;
	}
}