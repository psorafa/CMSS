global with sharing class SF_PersonManagementSOAP {

	webService static String createClient(CreateClientRequest request) {
		return MockServicesUtil.generateRandomString(18);
	}

	global class CreateClientRequest {
		webService ClientType clientType;
		webService List<PersonCommunicationType> personCommunicationType;
		webService String personNumber;
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
		webService ClientNumberType spSa;
		webService ClientNumberType spSc;
		webService String ico;
		webService String clientZone;
		webService String loginKz;
		webService String activatedKz;
		webService String isPoliticallyExposed;
		webService String isCrResident;
		webService String loyaltyProgram;
	}

	global class ClientNumberType {
		webService Long basicNumber;
		webService Long checkNumber;
		webService Long endNumber;
	}

	global class PersonCommunicationType {
		webService String contactType;
		webService String contactSubType;
		webService String contactValue;
		webService ExtendedAddressType address;
		webService ExtendedWebEmailType email;
		webService ExtendedPhoneType phone;
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

	global class ExtendedAddressType {
		webService String city;
		webService String country;
		webService Integer streetNumber;
		webService String zipCode;
		webService String streetName;
		webService String poBox;
		webService String addNameInfo;
		webService String addAddressInfo;
		webService String note;
		webService String tinTaxNumber;
		webService String tinNote;
		webService String contactFlag;
		webService String contactId;
	}

	global class ExtendedWebEmailType {
		webService String value;
		webService String note;
		webService String contactFlag;
		webService String contactId;
	}

	global class ExtendedPhoneType {
		webService String phone;
		webService String note;
		webService String contactFlag;
		webService String contactId;
	}
}