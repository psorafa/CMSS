global with sharing class SF_PersonManagementSOAPService {

	webService static CreateClientResponse createClient(CreateClientRequest request) {
		Savepoint sp = Database.setSavepoint();
		Logger.debug('Incoming request', JSON.serialize(request));
		try {
			CreateClientResponse response = (CreateClientResponse) SOAPResponseFactory.constructResponse(CreateClientResponse.class, request.requestHeader);
			Id result = ClientService.createClientAndContactInfos(request.requestBody.client, request.requestBody.personCommunications);
			response.responseBody = new CreateClientResponseBody(result);
			Logger.debug('Returning success response', JSON.serialize(response));
			return response;
		} catch (SOAPCommonTypes.BusinessException e) {
			Database.rollback(sp);
			Logger.warn('Business error occurred', e);
			CreateClientResponse response = (CreateClientResponse) SOAPResponseFactory.constructFaultResponse(CreateClientResponse.class, request.requestHeader, e);
			Logger.debug('Returning error response', JSON.serialize(response));
			return response;
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	webService static CreateCZContractResponseType createClientZone(CreateClientZoneRequest request) {
		try {
			Logger.debug('SF_PersonManagementSOAPService.createClientZone started.', JSON.serialize(request));
			CreateCZContractResponseType result = ClientZoneService.createClientZone(request);
			Logger.debug('SF_PersonManagementSOAPService.createClientZone finished.', JSON.serialize(result));
			return result;
		} catch (Exception exc) {
			Logger.error('SF_PersonManagementSOAPService.createClientZone operation failed: ' + exc.getMessage(), exc);
			throw exc;
		} finally {
			Logger.saveLogs();
		}
	}

	webService static Decimal getNewCZContractID() {
		try {
			Logger.info('getNewCZContractID');
			return ClientZoneService.getNewCZContractID();
		} catch (Exception exc) {
			Logger.error('SF_PersonManagementSOAPService.ClientZoneService getNewCZContractID operation failed', exc);
			throw exc;
		} finally {
			Logger.saveLogs();
		}
	}

	global class CreateClientRequest  {
		webService SOAPCommonTypes.CommonHeader requestHeader;
		webService CreateClientRequestBody requestBody;
	}

	global class CreateClientRequestBody {
		webService ClientType client;
		webService List<PersonCommunicationType> personCommunications;
	}

	global class CreateClientResponse {
		webService SOAPCommonTypes.CommonHeader responseHeader;
		webService Boolean isFault = false;
		webService SOAPCommonTypes.Fault fault;
		webService CreateClientResponseBody responseBody;
	}

	global class CreateClientResponseBody {
		webService Id clientId;

		CreateClientResponseBody(Id accountId) {
			this.clientId = accountId;
		}
	}

	global class CreateClientZoneRequest {
		webService ClientZoneType clientZone;
		webService List<ClientRelationType> accountRelations;
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

	global class ClientRelationType {
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