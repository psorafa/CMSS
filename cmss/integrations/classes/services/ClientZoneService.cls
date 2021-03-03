public with sharing class ClientZoneService {

	public static String createClientZone(SF_PersonManagementSOAPService.ClientZoneType clientZoneData) {
		Validation.requireAttribute(clientZoneData.globalId, 'GlobalId');
		Id clientSfId = ReferenceUtility.getAccountByGlobalId(clientZoneData.globalId).Id;
		Id closedById = null;
		if (clientZoneData.closedBy != null) {
			closedById = ReferenceUtility.getUserByCPU(clientZoneData.closedBy).Id;
		}
		ClientZone__c createdClientZone = insertClientZone(clientSfId, clientZoneData, closedById);
		return createdClientZone.ExternalId__c;
	}

	public static String createClientZoneContract(
		SF_PersonManagementSOAPService.ClientZoneType clientZone,
		List<SF_PersonManagementSOAPService.ClientRelationType> clientRelations
	) {
		String clientZoneId;
		Validation.requireAttribute(clientZone.globalId, 'GlobalId');
		Id clientSfId = ReferenceUtility.getAccountByGlobalId(clientZone.globalId).Id;
		List<ClientZone__c> clientZones = [SELECT Id, ExternalId__c, Role__c FROM ClientZone__c WHERE Account__c = :clientSfId AND Status__c = '1'];
		ClientZone__c clZone;
		Validation.requireAttribute(clientZone.closedBy, 'closedBy');
		Id closedById = ReferenceUtility.getUserByCPU(clientZone.closedBy).Id;
		if (clientZones.isEmpty()) {
			clZone = insertClientZone(clientSfId, clientZone, closedById);
			clientZoneId = clZone.ExternalId__c;
		} else if (clientZones.size() > 1) {
			throw new SOAPCommonTypes.BusinessException(203, 'More than 1 ClientZone exist for Client GlobalId: ' + clientZone.globalId);
		} else {
			clZone = clientZones.get(0);
			if (Integer.valueOf(clientZone.role) >= Integer.valueOf(clZone.Role__c) || clZone.Role__c == '8') {
				updateClientZone(clZone, clientZone, closedById);
				clientZoneId = clZone.ExternalId__c;
			} else {
				throw new SOAPCommonTypes.BusinessException(202, 'Record already exists: ClientZone - SF ID: ' + clZone.Id);
			}
		}
		if (clientRelations != null) {
			if (!clientRelations.isEmpty()) {
				upsertAccountRelations(clientRelations, clZone, clientSfId);
			}
		}
		return clientZoneId;
	}

	private static ClientZone__c insertClientZone(Id accountId, SF_PersonManagementSOAPService.ClientZoneType clientZoneRequest, Id closedBySfId) {
		ClientZone__c clientZone = new ClientZone__c();
		clientZone.Name = clientZoneRequest.contractNumber;
		clientZone.ContractNumber__c = clientZoneRequest.contractNumber;
		clientZone.VerificationPhone__c = clientZoneRequest.verificationPhone;
		clientZone.Username__c = clientZoneRequest.userName;
		clientZone.ClosedBy__c = closedBySfId;
		clientZone.Email__c = clientZoneRequest.email;
		clientZone.Role__c = clientZoneRequest.role;
		clientZone.Account__c = accountId;
		clientZone.ExternalId__c = UUIDUtil.generateUUID();
		clientZone.NumberOfAnnexes__c = 0;
		clientZone.Status__c = '1';
		clientZone.ContractStatus__c = '1';
		clientZone.CreatedDate__c = Datetime.now();
		clientZone.ModifiedDate__c = Datetime.now();
		SObjectUtil.stripNullFields(clientZone);
		DmlUtility.insertRecord(clientZone);
		return clientZone;
	}

	public static Decimal getNewCZContractID() {
		//From custom settings get Last Issued Contract Number and add 1
		NumericalSeriesSettings__c lastIssuedContractNumber = NumericalSeriesSettings__c.getOrgDefaults();
		if (lastIssuedContractNumber.ContractNumber__c == null) {
			lastIssuedContractNumber.ContractNumber__c = 0;
		}
		lastIssuedContractNumber.ContractNumber__c += 1;
		System.debug('New value in Custom settings ' + lastIssuedContractNumber.ContractNumber__c);

		upsert lastIssuedContractNumber;
		return lastIssuedContractNumber.ContractNumber__c;
	}

	public static void updateClientZone(SF_PersonManagementSOAPService.ClientZoneUpdateType clientZoneUpdate) {
		Validation.requireAttribute(clientZoneUpdate.id, 'id');
		ClientZone__c existingClientZone = ReferenceUtility.getClientZoneByExternalId(clientZoneUpdate.id);
		existingClientZone.Username__c = clientZoneUpdate.userName;
		existingClientZone.VerificationPhone__c = clientZoneUpdate.verificationPhone;
		existingClientZone.Email__c = clientZoneUpdate.email;
		existingClientZone.Role__c = clientZoneUpdate.role;
		existingClientZone.SignatureDate__c = clientZoneUpdate.signatureDate;
		existingClientZone.AgreementDate__c = clientZoneUpdate.agreementDate;
		existingClientZone.Status__c = clientZoneUpdate.status;
		SObjectUtil.stripNullFields(existingClientZone);
		DmlUtility.updateRecord(existingClientZone);
	}

	public static void changeCZContractRelations(SF_PersonManagementSOAPService.ChangeCZContractRelationsRequestBody request) {
		Validation.requireAttribute(request.clientZoneId, 'clientZoneId');
		Validation.requireAttribute(request.amendmentNumber, 'amendmentNumber');
		ChangeCZContractRelationsHandler handler = new ChangeCZContractRelationsHandler(request);
		handler.handle();
	}

	public static void activateCZContractRelations(SF_PersonManagementSOAPService.ActivateCZContractRelationsRequestBody request) {
		Validation.requireAttribute(request.clientZoneId, 'clientZoneId');
		ActivateCZContractRelationsHandler handler = new ActivateCZContractRelationsHandler(request.clientZoneId, request.amendmentNumber);
		handler.handle();
	}

	public static void signCZContractRelations(SF_PersonManagementSOAPService.SignCZContractRelationsRequestBody request) {
		Validation.requireAttribute(request.clientZoneId, 'clientZoneId');
		Validation.requireAttribute(request.relatedClientGlobalId, 'relatedClientGlobalId');
		Validation.requireAttribute(request.signDate, 'signDate');
		SignCZContractRelationHandler handler = new SignCZContractRelationHandler(request);
		handler.handle();
	}

	public static Integer getNextCZAmendment(SF_PersonManagementSOAPService.GetNextCZAmendmentRequestBody request) {
		Validation.requireAttribute(request.clientZoneId, 'clientZoneId');
		ClientZone__c clientZone = ReferenceUtility.getClientZoneByExternalId(request.clientZoneId);
		if (clientZone.NumberOfAnnexes__c == null) {
			return 1;
		}
		return Integer.valueOf(clientZone.NumberOfAnnexes__c) + 1;
	}

	private static void updateClientZone(ClientZone__c clientZone, SF_PersonManagementSOAPService.ClientZoneType clientZoneRequest, Id closedById) {
		clientZone.Name = clientZoneRequest.contractNumber;
		clientZone.ContractNumber__c = clientZoneRequest.contractNumber;
		clientZone.Username__c = clientZoneRequest.userName;
		clientZone.VerificationPhone__c = clientZoneRequest.verificationPhone;
		clientZone.Email__c = clientZoneRequest.email;
		clientZone.Role__c = clientZoneRequest.role;
		clientZone.NumberOfAnnexes__c = 0;
		clientZone.Status__c = '1';
		clientZone.ContractStatus__c = '1';
		clientZone.ModifiedDate__c = Datetime.now();
		clientZone.ClosedBy__c = closedById;
		SObjectUtil.stripNullFields(clientZone);
		DmlUtility.updateRecord(clientZone);
	}

	private static SF_PersonManagementSOAPService.CreateCZContractResponseType upsertAccountRelations(List<SF_PersonManagementSOAPService.ClientRelationType> clientRelations, ClientZone__c clZone, Id clientSfId) {
		SF_PersonManagementSOAPService.CreateCZContractResponseType response = new SF_PersonManagementSOAPService.CreateCZContractResponseType();

		List<AccountRelation__c> accountRelationsToInsert = new List<AccountRelation__c>();
		List<AccountRelation__c> accountRelationsToUpdate = new List<AccountRelation__c>();

		Map<String, Id> accountIdsByGlobalIds = ReferenceUtility.getAccountIdsByGlobalIds(clientRelations);

		Set<String> externalIdsSet = buildExternalIdsSet(clientRelations);
		List<AccountRelation__c> relations = [SELECT Id, ExternalId__c FROM AccountRelation__c WHERE ExternalId__c IN :externalIdsSet];
		Map<String, AccountRelation__c> clientToRelateWithRelationMap = buildExistingRelationsMap(relations);

		for (SF_PersonManagementSOAPService.ClientRelationType requestRelation : clientRelations) {
			if (clientToRelateWithRelationMap.containsKey(requestRelation.externalId)) {
				AccountRelation__c toUpdate = clientToRelateWithRelationMap.get(requestRelation.externalId);
				accountRelationsToUpdate.add(updateAccountRelation(toUpdate, requestRelation, clZone, clientSfId));
			} else {
				accountRelationsToInsert.add(insertAccountRelation(requestRelation, accountIdsByGlobalIds.get(requestRelation.relatedClientId), clZone, clientSfId));
			}
		}
		SObjectUtil.stripNullFields(accountRelationsToInsert);
		DmlUtility.insertRecords(accountRelationsToInsert);
		SObjectUtil.stripNullFields(accountRelationsToUpdate);
		DmlUtility.updateRecords(accountRelationsToUpdate);
		return response;
	}

	private static AccountRelation__c updateAccountRelation(AccountRelation__c toUpdate, SF_PersonManagementSOAPService.ClientRelationType requestRelation, ClientZone__c clZone, Id clientSfId) {
		toUpdate.ExternalId__c = requestRelation.externalId;
		toUpdate.RelationTypeNEL__c = '5';
		toUpdate.AccountRole__c = '1502';
		toUpdate.RelatedAccountRole__c = '1501';
		toUpdate.ClientZoneID__c = clZone.Id;
		toUpdate.ValidTo__c = requestRelation.validTo;
		toUpdate.ValidFrom__c = Date.today();
		toUpdate.IsActive__c = true;
		toUpdate.RelatedAccount__c = clientSfId;
		return toUpdate;
	}

	private static AccountRelation__c insertAccountRelation(SF_PersonManagementSOAPService.ClientRelationType requestRelation, Id relatedAccountId, ClientZone__c clZone, Id clientSfId) {
		AccountRelation__c accountRelation = new AccountRelation__c();
		accountRelation.ExternalId__c = requestRelation.externalId;
		accountRelation.RelationTypeNEL__c = '5';
		accountRelation.AccountRole__c = '1502';
		accountRelation.RelatedAccountRole__c = '1501';
		accountRelation.ClientZoneID__c = clZone.Id;
		accountRelation.ValidTo__c = requestRelation.validTo;
		accountRelation.ValidFrom__c = Date.today();
		accountRelation.IsActive__c = true;
		accountRelation.RelatedAccount__c = clientSfId;
		if (relatedAccountId == null) {
			throw new SOAPCommonTypes.BusinessException(201, 'Record not found: Client - globalId: ' + requestRelation.relatedClientId);
		}
		accountRelation.Account__c = relatedAccountId;
		return accountRelation;
	}

	public static Map<String, AccountRelation__c> buildExistingRelationsMap(List<AccountRelation__c> existingRelations) {
		Map<String, AccountRelation__c> clientToRelateWithRelationMap = new Map<String, AccountRelation__c>();
		for (AccountRelation__c relation : existingRelations) {
			clientToRelateWithRelationMap.put(relation.ExternalId__c, relation);
		}
		return clientToRelateWithRelationMap;
	}

	public static Set<String> buildExternalIdsSet(List<SF_PersonManagementSOAPService.ClientRelationType> clientRelations) {
		Set<String> externalIdsSet = new Set<String>();
		for (SF_PersonManagementSOAPService.ClientRelationType clientRelation : clientRelations) {
			externalIdsSet.add(clientRelation.externalId);
		}
		return externalIdsSet;
	}
}
