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
			ClientZone__c clZone = clientZones.get(0);

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

	private static Id insertClientZone(Id accountId, SF_PersonManagementSOAPService.ClientZoneType clientZoneRequest) {
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
		return clientZone.Id;
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
		if (clientZoneUpdate.id == null) {
			throw new SOAPCommonTypes.BusinessException(101, 'Missing required attribute: id');
		}
		ClientZone__c existingClientZone = getClientZone(clientZoneUpdate.Id);
		existingClientZone.Username__c = clientZoneUpdate.userName;
		existingClientZone.VerificationPhone__c = clientZoneUpdate.verificationPhone;
		existingClientZone.Email__c = clientZoneUpdate.email;
		existingClientZone.Role__c = clientZoneUpdate.role;
		existingClientZone.SignatureDate__c = clientZoneUpdate.signatureDate;
		existingClientZone.AgreementDate__c = clientZoneUpdate.agreementDate;
		existingClientZone.Status__c = clientZoneUpdate.status;
		PermissionUtility.checkForInsert(existingClientZone);
		try {
			update existingClientZone;
		} catch (DmlException e) {
			throw new SOAPCommonTypes.BusinessException(301, 'Cannot update record: ' + e.getMessage(), e);
			// todo tohle otestovat... treba nejakou validaci, co to zarizne
		}
	}

	private static ClientZone__c getClientZone(Id clientZoneId) {
		for (ClientZone__c cz : [SELECT Id FROM ClientZone__c WHERE Id = :clientZoneId LIMIT 1]) {
			return cz;
		}
		throw new SOAPCommonTypes.BusinessException(201, 'Record not found: ClientZone - Id: ' + clientZoneId);
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
	}

	private static void createAccountRelations(List<SF_PersonManagementSOAPService.ClientRelationType> accountRelations) {
		List<AccountRelation__c> accountRelationsToInsert = new List<AccountRelation__c>();
		for (SF_PersonManagementSOAPService.ClientRelationType accountRelation : accountRelations) {
			AccountRelation__c accountRel = new AccountRelation__c(
				Account__c = accountRelation.relatedClientId,
				RelatedAccount__c = accountRelation.relatedClientId,
				RelatedAccountRole__c = accountRelation.clientRole,
				AccountRole__c = accountRelation.clientRole,
				ValidTo__c = accountRelation.validTo,
				ValidFrom__c = Date.today(),
				IsActive__c = true,
				ExternalId__c = accountRelation.externalId,
				RelationTypeNEL__c = '5'
			);
			accountRelationsToInsert.add(accountRel);
		}
		insert accountRelationsToInsert;
	}
}