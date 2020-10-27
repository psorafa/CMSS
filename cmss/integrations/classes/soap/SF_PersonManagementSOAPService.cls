global with sharing class SF_PersonManagementSOAPService {

	webService static CreateClientResponseType createClient(CreateClientRequestType request) {
		Savepoint sp = Database.setSavepoint();
		Logger.debug('Incoming request', JSON.serialize(request));
		try {
			CreateClientResponseType response = (CreateClientResponseType) SOAPResponseFactory.constructResponse(CreateClientResponseType.class, request.requestHeader);
			Id result = ClientService.createClientAndContactInfos(request.requestBody.client, request.requestBody.personCommunications);
			response.responseBody = new CreateClientResponseBody(result);
			Logger.debug('Returning success response', JSON.serialize(response));
			return response;
		} catch (SOAPCommonTypes.BusinessException e) {
			Database.rollback(sp);
			Logger.warn('Business error occurred', e);
			CreateClientResponseType response = (CreateClientResponseType) SOAPResponseFactory.constructFaultResponse(CreateClientResponseType.class, request.requestHeader, e);
			Logger.debug('Returning error response', JSON.serialize(response));
			return response;
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	webService static CreateCZContractResponseType createCZContract(CreateCZContractRequestType request) {
		Savepoint sp = Database.setSavepoint();
		Logger.debug('Incoming request', JSON.serialize(request));
		try {
			CreateCZContractResponseType response = (CreateCZContractResponseType) SOAPResponseFactory.constructResponse(CreateCZContractResponseType.class, request.requestHeader);
			Id createdClientZoneId = ClientZoneService.createClientZone(request.requestBody.clientZone, request.requestBody.clientRelations);
			response.responseBody = new CreateCZContractResponseBody(createdClientZoneId);
			Logger.debug('Returning success response', JSON.serialize(response));
			return response;
		} catch (SOAPCommonTypes.BusinessException e) {
			Database.rollback(sp);
			Logger.warn('Business error occurred', e);
			CreateCZContractResponseType response = (CreateCZContractResponseType) SOAPResponseFactory.constructFaultResponse(CreateCZContractResponseType.class, request.requestHeader, e);
			Logger.debug('Returning error response', JSON.serialize(response));
			return response;
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	webService static GetNewCZContractIDResponseType getNewCZContractID(GetNewCZContractIDRequestType request) {
		Savepoint sp = Database.setSavepoint();
		Logger.debug('Incoming request', JSON.serialize(request));
		try {
			GetNewCZContractIDResponseType response = (GetNewCZContractIDResponseType) SOAPResponseFactory.constructResponse(GetNewCZContractIDResponseType.class, request.requestHeader);
			Long contractId = ClientZoneService.getNewCZContractID().longValue();
			response.responseBody = new GetNewCZContractIDResponseBody(contractId);
			Logger.debug('Returning success response', JSON.serialize(response));
			return response;
		} catch (SOAPCommonTypes.BusinessException e) {
			Database.rollback(sp);
			Logger.warn('Business error occurred', e);
			GetNewCZContractIDResponseType response = (GetNewCZContractIDResponseType) SOAPResponseFactory.constructFaultResponse(GetNewCZContractIDResponseType.class, request.requestHeader, e);
			Logger.debug('Returning error response', JSON.serialize(response));
			return response;
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	webService static UpdateCZResponseType updateCZ(UpdateCZRequestType request) {
		Savepoint sp = Database.setSavepoint();
		Logger.debug('Incoming request', JSON.serialize(request));
		try {
			UpdateCZResponseType response = (UpdateCZResponseType) SOAPResponseFactory.constructResponse(UpdateCZResponseType.class, request.requestHeader);
			ClientZoneService.updateClientZone(request.requestBody);
			Logger.debug('Returning success response', JSON.serialize(response));
			return response;
		} catch (SOAPCommonTypes.BusinessException e) {
			Database.rollback(sp);
			Logger.warn('Business error occurred', e);
			UpdateCZResponseType response = (UpdateCZResponseType) SOAPResponseFactory.constructFaultResponse(UpdateCZResponseType.class, request.requestHeader, e);
			Logger.debug('Returning error response', JSON.serialize(response));
			return response;
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	/*
	 * ----------------    createClient request and response types    ----------------
	 */
	global class CreateClientRequestType {
		webService SOAPCommonTypes.CommonHeader requestHeader;
		webService CreateClientRequestBody requestBody;
	}

	global class CreateClientRequestBody {
		webService ClientType client;
		webService List<PersonCommunicationType> personCommunications;
	}

	global class CreateClientResponseType {
		webService SOAPCommonTypes.CommonHeader responseHeader;
		webService Boolean isFault;
		webService SOAPCommonTypes.Fault fault;
		webService CreateClientResponseBody responseBody;
	}

	global class CreateClientResponseBody {
		webService Id clientId;

		CreateClientResponseBody(Id accountId) {
			this.clientId = accountId;
		}
	}

	/*
	 * ----------------    createCZContract request and response types    ----------------
	 */
	global class CreateCZContractRequestType {
		webService SOAPCommonTypes.CommonHeader requestHeader;
		webService CreateCZContractRequestBody requestBody;
	}

	global class CreateCZContractRequestBody {
		webService ClientZoneType clientZone;
		webService List<ClientRelationType> clientRelations;
	}

	global class CreateCZContractResponseType {
		webService SOAPCommonTypes.CommonHeader responseHeader;
		webService Boolean isFault;
		webService SOAPCommonTypes.Fault fault;
		webService CreateCZContractResponseBody responseBody;
	}

	global class CreateCZContractResponseBody {
		webService String clientZoneId;

		CreateCZContractResponseBody(Id clientZoneId) {
			this.clientZoneId = clientZoneId;
		}
	}

	/*
	 * ----------------    getNewCZContractID request & response types    ----------------
	 */
	global class GetNewCZContractIDRequestType {
		webService SOAPCommonTypes.CommonHeader requestHeader;
	}

	global class GetNewCZContractIDResponseType {
		webService SOAPCommonTypes.CommonHeader responseHeader;
		webService Boolean isFault;
		webService SOAPCommonTypes.Fault fault;
		webService GetNewCZContractIDResponseBody responseBody;
	}

	global class GetNewCZContractIDResponseBody {
		webService Long contractId;

		GetNewCZContractIDResponseBody(Long contractId) {
			this.contractId = contractId;
		}
	}

	/*
	 * ----------------    updateCZ request & response types    ----------------
	 */
	global class UpdateCZRequestType {
		webService SOAPCommonTypes.CommonHeader requestHeader;
		webService ClientZoneUpdateType requestBody;
	}

	global class UpdateCZResponseType {
		webService SOAPCommonTypes.CommonHeader responseHeader;
		webService Boolean isFault;
		webService SOAPCommonTypes.Fault fault;
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
	}

	global class ClientZoneUpdateType {
		webService Id id;
		webService String userName;
		webService String verificationPhone;
		webService String email;
		webService String role;
		webService Date signatureDate;
		webService Date agreementDate;
		webService String status;
	}

	global class ClientRelationType {
		webService String relatedClientId;
		webService String clientRole;
		webService Date validTo;
		webService String externalId;
	}
}
