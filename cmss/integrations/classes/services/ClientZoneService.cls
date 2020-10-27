public with sharing class ClientZoneService {

	public static Id createClientZone(
		SF_PersonManagementSOAPService.ClientZoneType clientZone,
		List<SF_PersonManagementSOAPService.ClientRelationType> clientRelations
	) {
		Id createdClientZoneId;
		if (clientZone.globalId == null) {
			throw new SOAPCommonTypes.BusinessException(101, 'Attribute globalId is required');
		}
		List<Account> accounts = [SELECT Id FROM Account WHERE GlobalId__c = :clientZone.globalId LIMIT 1];
		if (accounts.isEmpty()) {
			throw new SOAPCommonTypes.BusinessException(201, 'Record not found: Client - Global ID: ' + clientZone.globalId);
		}
		List<ClientZone__c> clientZones = [SELECT Id, Role__c FROM ClientZone__c WHERE Account__c = :accounts.get(0).Id AND Status__c = '1' ORDER BY LastModifiedDate DESC];
		if (clientZones.isEmpty()) {
			createdClientZoneId = insertClientZone(accounts.get(0).Id, clientZone);
		} else {
			clZone = clientZones.get(0);

			if (Integer.valueOf(clientZone.role) >= Integer.valueOf(clZone.Role__c) || clZone.Role__c == '8') {
				updateClientZone(clZone, clientZone);
				createdClientZoneId = clZone.Id;
			} else {
				throw new SOAPCommonTypes.BusinessException(202, 'Record already exists: ClientZone - SF ID: ' + clZone.Id);
			}
		}
		if (clientRelations != null) {
			if (!clientRelations.isEmpty()) {
				createAccountRelations(clientRelations);
			}
		}
		return createdClientZoneId;
	}

	private static ClientZone__c insertClientZone(Id accountId, SF_PersonManagementSOAPService.ClientZoneType clientZoneRequest) {
		List<User> closedByUserId = [SELECT Id FROM User WHERE GlobalId__c = :clientZoneRequest.closedBy];
		Id closedById;
		if (!closedByUserId.isEmpty()) {
			closedById = closedByUserId.get(0).Id;
		} else {
			return null;
		}
		ClientZone__c clientZone = new ClientZone__c(
			Name = clientZoneRequest.contractNumber,
			VerificationPhone__c = clientZoneRequest.verificationPhone,
			Username__c = clientZoneRequest.userName,
			ClosedBy__c = clientZoneRequest.closedBy,
			Email__c = clientZoneRequest.email,
			Role__c = clientZoneRequest.role,
			Account__c = accountId,
			ExternalId__c = clientZoneRequest.globalId,
			NumberOfAnnexes__c = 0,
			Status__c = '1',
			ContractStatus__c = '1',
			CreatedDate__c = Datetime.now()
		);
		insert clientZone;
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

	private static void updateClientZone(ClientZone__c clientZone, SF_PersonManagementSOAPService.ClientZoneType clientZoneRequest) {
		clientZone.ClosedBy__c = clientZoneRequest.closedBy;
		clientZone.Name = clientZoneRequest.contractNumber;
		clientZone.Username__c = clientZoneRequest.userName;
		clientZone.VerificationPhone__c = clientZoneRequest.verificationPhone;
		clientZone.Email__c = clientZoneRequest.email;
		clientZone.Role__c = clientZoneRequest.role;
		clientZone.NumberOfAnnexes__c = 0;
		clientZone.Status__c = '1';
		clientZone.ContractStatus__c = '1';
		clientZone.ModifiedDate__c = Datetime.now();
		update clientZone;
		return clientZone;
	}

	private static SF_PersonManagementSOAPService.CreateCZContractResponseType upsertAccountRelations(SF_PersonManagementSOAPService.CreateClientZoneRequest request, ClientZone__c clZone) {
		SF_PersonManagementSOAPService.CreateCZContractResponseType response = new SF_PersonManagementSOAPService.CreateCZContractResponseType();

		List<AccountRelation__c> upsertAccountRelations = new List<AccountRelation__c>();
		List<AccountRelation__c> accountRelationsToInsert = new List<AccountRelation__c>();
		List<AccountRelation__c> accountRelationsToUpdate = new List<AccountRelation__c>();

		Map<String, Id> relatedClientGlobalIdsByIds = getRelatedClientIds(request.clientRelations);
		List<AccountRelation__c> relations = [
				SELECT Id, Account__c, Account__r.GlobalId__c, RelatedAccount__c, RelatedAccountRole__c
				FROM AccountRelation__c
				WHERE RelatedAccount__r.GlobalId__c = :request.clientZone.globalId AND Account__r.GlobalId__c IN :relatedClientGlobalIdsByIds.keySet()
		];
		if (relations.isEmpty()) {
			for (SF_PersonManagementSOAPService.ClientRelationType clientRelation : request.clientRelations) {
				AccountRelation__c accountRel = new AccountRelation__c();
				accountRel.ExternalId__c = clientRelation.externalId;
				accountRel.RelationTypeNEL__c = '5';
				accountRel.AccountRole__c = '1502';
				accountRel.RelatedAccountRole__c = '1501';
				accountRel.ClientZoneID__c = clZone.Id;
				accountRel.ValidTo__c = clientRelation.validTo;
				accountRel.ValidFrom__c = Date.today();
				accountRel.IsActive__c = true;
				accountRel.RelatedAccount__c = client.Id;
				accountRel.Account__c = relatedClientGlobalIdsByIds.get(clientRelation.relatedClientId);

				accountRelationsToInsert.add(accountRel);
			}
		} else {

			for (SF_PersonManagementSOAPService.ClientRelationType clientRelation : request.clientRelations) {
				if (clientRelation.relatedClientId == request.clientZone.globalId) {
					for (AccountRelation__c sfRelation : relations) {
						if (clientRelation.relatedClientId == sfRelation.Account__r.GlobalId__c) {
							sfRelation.ExternalId__c = clientRelation.externalId;
							sfRelation.RelationTypeNEL__c = '5';
							sfRelation.AccountRole__c = '1502';
							sfRelation.RelatedAccountRole__c = '1501';
							sfRelation.ClientZoneID__c = clZone.Id;
							sfRelation.ValidTo__c = clientRelation.validTo;
							sfRelation.ValidFrom__c = Date.today();
							sfRelation.IsActive__c = true;
							sfRelation.RelatedAccount__c = client.Id;
							sfRelation.Account__c = relatedClientGlobalIdsByIds.get(clientRelation.relatedClientId);
							accountRelationsToUpdate.add(sfRelation);
						}
					}
				} else {
					response.isSuccess = false;
					response.errorNumber = -6;
					response.errorMessage = 'Client id specified in representing client list does not equal account relation id. ';
					return response;
				}
			}
		}

		if (!accountRelationsToInsert.isEmpty()) {
			insert accountRelationsToInsert;
			response.isSuccess = true;
		}

		if (!accountRelationsToUpdate.isEmpty()) {
			insert accountRelationsToUpdate;
			response.isSuccess = true;
		}

		return response;
	}

	private static Map<String, Id> getRelatedClientIds(List<SF_PersonManagementSOAPService.ClientRelationType> clientRelations) {
		Map<String, Id> relatedClientGlobalIdsByIds = new Map<String, Id>();
		List<String> globalIds = new List<String>();
		for (SF_PersonManagementSOAPService.ClientRelationType relation : clientRelations) {
			globalIds.add(relation.relatedClientId);
		}
		List<Account> clients = [SELECT Id, GlobalId__c FROM Account WHERE GlobalId__c IN :globalIds];
		for (Account client : clients) {
			relatedClientGlobalIdsByIds.put(client.GlobalId__c, client.Id);
		}
		return relatedClientGlobalIdsByIds;
	}
}
