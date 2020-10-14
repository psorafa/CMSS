public with sharing class ClientZoneService {

	public static SF_PersonManagementSOAPService.CreateCZContractResponseType createClientZone(SF_PersonManagementSOAPService.CreateClientZoneRequest request) {
		SF_PersonManagementSOAPService.CreateCZContractResponseType response = new SF_PersonManagementSOAPService.CreateCZContractResponseType();
		if (request.clientZone.globalId == null) {
			response.isSuccess = false;
			response.errorMessage = 'GlobalId specified in request was null!';
			response.errorNumber = -5;
			return response;
		}
		List<Account> accounts = [SELECT Id FROM Account WHERE GlobalId__c = :request.clientZone.globalId LIMIT 1];
		if (accounts.isEmpty()) {
			//			throw new ClientZoneServiceException('GlobalId in request was null!');
			response.isSuccess = false;
			response.errorMessage = 'No client found for globalId specified in request!';
			response.errorNumber = -5;
			return response;
//			throw new ClientZoneServiceException('No client found for globalId specified in request or globalId was null!');
		}

		List<ClientZone__c> clientZones = [SELECT Id, Role__c FROM ClientZone__c WHERE Account__c = :accounts.get(0).Id AND Status__c = '1' ORDER BY LastModifiedDate DESC];
		if (clientZones.isEmpty()) {
			response.clientZoneId = insertClientZone(accounts.get(0).Id, request.clientZone);
			response.isSuccess = true;
		} else {
			ClientZone__c clZone = clientZones.get(0);

			if (Integer.valueOf(request.clientZone.role) >= Integer.valueOf(clZone.Role__c) || clZone.Role__c == '8') {
				updateClientZone(clZone, request.clientZone);
				response.isSuccess = true;
			} else {
				response.errorNumber = -3;
				response.isSuccess = false;
			}
		}
		if (request.accountRelations != null) {
			if (!request.accountRelations.isEmpty()) {
				createAccountRelations(request.accountRelations);
			}
		}

		return response;
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