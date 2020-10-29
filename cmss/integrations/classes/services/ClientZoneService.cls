public with sharing class ClientZoneService {

	public static Id createClientZone(
			SF_PersonManagementSOAPService.ClientZoneType clientZone,
			List<SF_PersonManagementSOAPService.ClientRelationType> clientRelations
	) {
		Id clientZoneId;
		Id clientSfId;
		if (clientZone.globalId == null) {
			throw new SOAPCommonTypes.BusinessException(101, 'Attribute globalId is required');
		}
		List<Account> accounts = [SELECT Id FROM Account WHERE GlobalId__c = :clientZone.globalId LIMIT 1];
		if (accounts.isEmpty()) {
			throw new SOAPCommonTypes.BusinessException(201, 'Record not found: Client - Global ID: ' + clientZone.globalId);
		} else {
			clientSfId = accounts.get(0).Id;
		}
		List<ClientZone__c> clientZones = [SELECT Id, Role__c FROM ClientZone__c WHERE Account__c = :accounts.get(0).Id AND Status__c = '1'];
		ClientZone__c clZone;
		Id closedById;
		if (clientZones.isEmpty()) {
			closedById = getClosedByUser(clientZone.closedBy);
			clZone = insertClientZone(clientSfId, clientZone, closedById);
			clientZoneId = clZone.Id;
		} else if (clientZones.size() > 1) {
			throw new SOAPCommonTypes.BusinessException(202, 'More than 1 ClientZone exist: Client GlobalId: ' + clientZone.globalId);
		} else {
			clZone = clientZones.get(0);
			closedById = getClosedByUser(clientZone.closedBy);
			if (Integer.valueOf(clientZone.role) >= Integer.valueOf(clZone.Role__c) || clZone.Role__c == '8') {
				clientZoneId = updateClientZone(clZone, clientZone, closedById);
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
		clientZone.VerificationPhone__c = clientZoneRequest.verificationPhone;
		clientZone.Username__c = clientZoneRequest.userName;
		clientZone.ClosedBy__c = closedBySfId;
		clientZone.Email__c = clientZoneRequest.email;
		clientZone.Role__c = clientZoneRequest.role;
		clientZone.Account__c = accountId;
		clientZone.ExternalId__c = clientZoneRequest.globalId;
		clientZone.NumberOfAnnexes__c = 0;
		clientZone.Status__c = '1';
		clientZone.ContractStatus__c = '1';
		clientZone.CreatedDate__c = Datetime.now();
		clientZone.ModifiedDate__c = Datetime.now();

		insert clientZone;
		return clientZone;
	}

	private static Id getClosedByUser(String closedByRequest) {
		List<User> closedByUserId = [SELECT Id FROM User WHERE CommissionAccountNr__c = :closedByRequest];
		Id closedById;
		if (!closedByUserId.isEmpty()) {
			closedById = closedByUserId.get(0).Id;
			return closedById;
		} else {
			throw new SOAPCommonTypes.BusinessException(202, 'No user found for specified account commision number: ' + closedByRequest);
		}
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
		ClientZone__c existingClientZone = ReferenceUtility.getClientZoneById(clientZoneUpdate.Id);
		existingClientZone.Username__c = clientZoneUpdate.userName;
		existingClientZone.VerificationPhone__c = clientZoneUpdate.verificationPhone;
		existingClientZone.Email__c = clientZoneUpdate.email;
		existingClientZone.Role__c = clientZoneUpdate.role;
		existingClientZone.SignatureDate__c = clientZoneUpdate.signatureDate;
		existingClientZone.AgreementDate__c = clientZoneUpdate.agreementDate;
		existingClientZone.Status__c = clientZoneUpdate.status;
		PermissionUtility.checkForUpdate(existingClientZone);
		try {
			update existingClientZone;
		} catch (DmlException e) {
			throw new SOAPCommonTypes.BusinessException(302, 'Cannot update record: ' + e.getMessage(), e);
		}
	}

	private static Id updateClientZone(ClientZone__c clientZone, SF_PersonManagementSOAPService.ClientZoneType clientZoneRequest, Id closedById) {
		clientZone.Name = clientZoneRequest.contractNumber;
		clientZone.Username__c = clientZoneRequest.userName;
		clientZone.VerificationPhone__c = clientZoneRequest.verificationPhone;
		clientZone.Email__c = clientZoneRequest.email;
		clientZone.Role__c = clientZoneRequest.role;
		clientZone.NumberOfAnnexes__c = 0;
		clientZone.Status__c = '1';
		clientZone.ContractStatus__c = '1';
		clientZone.ModifiedDate__c = Datetime.now();
		clientZone.ClosedBy__c = closedById;
		update clientZone;
		return clientZone.Id;
	}

	private static SF_PersonManagementSOAPService.CreateCZContractResponseType upsertAccountRelations(List<SF_PersonManagementSOAPService.ClientRelationType> clientRelations, ClientZone__c clZone, Id clientSfId) {
		SF_PersonManagementSOAPService.CreateCZContractResponseType response = new SF_PersonManagementSOAPService.CreateCZContractResponseType();

		List<AccountRelation__c> accountRelationsToInsert = new List<AccountRelation__c>();
		List<AccountRelation__c> accountRelationsToUpdate = new List<AccountRelation__c>();

		Map<String, Id> relatedClientGlobalIdsByIds = getRelatedClientIds(clientRelations);

		Set<String> externalIdsSet = buildExternalIdsSet(clientRelations);
		List<AccountRelation__c> relations = [SELECT Id, ExternalId__c FROM AccountRelation__c WHERE ExternalId__c IN :externalIdsSet];
		Map<String, AccountRelation__c> clientToRelateWithRelationMap = buildExistingRelationsMap(relations);

		for (SF_PersonManagementSOAPService.ClientRelationType requestRelation : clientRelations) {
			if (clientToRelateWithRelationMap.containsKey(requestRelation.externalId)) {
				AccountRelation__c toUpdate = clientToRelateWithRelationMap.get(requestRelation.externalId);
				accountRelationsToUpdate.add(updateAccountRelation(toUpdate, requestRelation, clZone, clientSfId));
			} else {
				accountRelationsToInsert.add(insertAccountRelation(requestRelation, relatedClientGlobalIdsByIds.get(requestRelation.relatedClientId), clZone, clientSfId));
			}
		}

		if (!accountRelationsToInsert.isEmpty()) {
			insert accountRelationsToInsert;
			response.isFault = false;
		}

		if (!accountRelationsToUpdate.isEmpty()) {
			update accountRelationsToUpdate;
			response.isFault = false;
		}

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
			throw new SOAPCommonTypes.BusinessException(201, 'No related client found for speficied globalId.');
		}
		accountRelation.Account__c = relatedAccountId;
		return accountRelation;
	}

	private static Map<String, Id> getRelatedClientIds(List<SF_PersonManagementSOAPService.ClientRelationType> clientRelations) {
		Map<String, Id> relatedClientGlobalIdsByIds = new Map<String, Id>();
		List<String> globalIds = new List<String>();
		for (SF_PersonManagementSOAPService.ClientRelationType relation : clientRelations) {
			globalIds.add(relation.relatedClientId);
		}
		List<Account> clients = [SELECT Id, GlobalId__c FROM Account WHERE GlobalId__c IN :globalIds];
		if (!clients.isEmpty()) {
			for (Account client : clients) {
				relatedClientGlobalIdsByIds.put(client.GlobalId__c, client.Id);
			}
		} else {
			throw new SOAPCommonTypes.BusinessException(201, 'Upsert account relation failed, no clients found for specified related client.');
		}
		return relatedClientGlobalIdsByIds;
	}

	private static Map<String, AccountRelation__c> buildExistingRelationsMap(List<AccountRelation__c> existingRelations) {
		Map<String, AccountRelation__c> clientToRelateWithRelationMap = new Map<String, AccountRelation__c>();
		for (AccountRelation__c relation : existingRelations) {
			clientToRelateWithRelationMap.put(relation.ExternalId__c, relation);
		}
		return clientToRelateWithRelationMap;
	}

	private static Set<String> buildExternalIdsSet(List<SF_PersonManagementSOAPService.ClientRelationType> clientRelations) {
		Set<String> externalIdsSet = new Set<String>();
		for (SF_PersonManagementSOAPService.ClientRelationType clientRelation : clientRelations) {
			externalIdsSet.add(clientRelation.externalId);
		}
		return externalIdsSet;
	}
}
