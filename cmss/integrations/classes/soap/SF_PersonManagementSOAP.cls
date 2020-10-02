global with sharing class SF_PersonManagementSOAP {

	webService static String createClient(CreateClientRequest request) {
		try {
			Logger.info('createClient request data', JSON.serialize(request));
			SF_PersonManagementSOAPService.CreateClientRequest newRequest = convertRequestToNewerVersion(request);
			return ClientService.createClientAndContactInfos(newRequest.client, newRequest.personCommunications);
		} catch (Exception exc) {
			Logger.error('SF_PersonManagementSOAP.createClient operation failed', exc, request.toString());
			throw exc;
		} finally {
			Logger.saveLogs();
		}
	}

	private static SF_PersonManagementSOAPService.CreateClientRequest convertRequestToNewerVersion(CreateClientRequest old) {
		SF_PersonManagementSOAPService.CreateClientRequest r = new SF_PersonManagementSOAPService.CreateClientRequest();
		SF_PersonManagementSOAPService.ClientType c = new SF_PersonManagementSOAPService.ClientType();
		c.personNumber = old.client.personNumber;
		c.personalIdentityNumber = old.client.personalIdentityNumber;
		c.name = old.client.name;
		c.firstName = old.client.firstName;
		c.lastName = old.client.lastName;
		c.prefixTitle = old.client.prefixTitle;
		c.suffixTitle = old.client.suffixTitle;
		c.clientGlobalId = old.client.clientGlobalId;
		c.birthDate = old.client.birthDate;
		c.gender = old.client.gender;
		c.spSa = old.client.spSa;
		c.spSc = old.client.spSc;
		c.isPoliticallyExposed = old.client.isPoliticallyExposed;
		c.isCrResident = old.client.isCrResident;
		r.client = c;
		if (old.personCommunications != null) {
			r.personCommunications = new List<SF_PersonManagementSOAPService.PersonCommunicationType>();
			for (PersonCommunicationType com : old.personCommunications) {
				SF_PersonManagementSOAPService.PersonCommunicationType p = new SF_PersonManagementSOAPService.PersonCommunicationType();
				p.contactType = com.contactType;
				p.contactSubType = com.contactSubType;
				p.contactValue = com.contactValue;
				p.extCommunicationId = com.extCommunicationId;
				if (com.address != null) {
					SF_PersonManagementSOAPService.AddressType a = new SF_PersonManagementSOAPService.AddressType();
					a.city = com.address.city;
					a.country = com.address.country;
					a.streetName = com.address.streetName;
					a.houseNumber = '' + com.address.houseNumber;
					a.zipCode = com.address.zipCode;
					a.validFrom = com.address.validFrom;
					a.validTo = com.address.validTo;
					p.address = a;
				}
				r.personCommunications.add(p);
			}
		}
		return r;
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
		webService Integer houseNumber;
		webService String zipCode;
		webService Date validFrom;
		webService Date validTo;
		webService String type;
		webService String subType;
	}
}