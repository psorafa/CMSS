public with sharing class ClientZoneService {

	public static SF_PersonManagementSOAPService.CreateCZContractResponseType createClientZone(String globalId, SF_PersonManagementSOAPService.CreateClientZoneRequest request) {
		SF_PersonManagementSOAPService.CreateCZContractResponseType response = new SF_PersonManagementSOAPService.CreateCZContractResponseType();

		List<Account> accounts = [SELECT Id FROM Account WHERE GlobalId__c = :globalId LIMIT 1];
		if (globalId == null || accounts.isEmpty()) {
			//			throw new ClientZoneServiceException('GlobalId in request was null!');
			response.isSuccess = false;
			response.errorMessage = 'No client found for globalId specified in request or globalId was null!';
			response.errorNumber = -5;
			return response;
//			throw new ClientZoneServiceException('No client found for globalId specified in request or globalId was null!');
		}

		List<ClientZone__c> clientZones = [SELECT Id, Role__c FROM ClientZone__c WHERE Account__c = :accounts.get(0).Id AND Status__c = '1'];
		if (clientZones.isEmpty()) {
			response.clientZoneId = insertClientZone(accounts.get(0).Id, request.clientZone);
			response.isSuccess = true;
		} else {
			ClientZone__c clZone = clientZones.get(0);
			if (request.clientZone.role == '7') {
				response.errorNumber = -3;
				response.isSuccess = false;
			} else if (Integer.valueOf(request.clientZone.role) <= Integer.valueOf(clZone.Role__c) && clZone.Role__c != '8') {
				response.errorNumber = -3;
				response.isSuccess = false;
			} else if (Integer.valueOf(request.clientZone.role) <= Integer.valueOf(clZone.Role__c) && clZone.Role__c != '8') {
				updateClientZone(clientZones.get(0), request.clientZone);
			}
		}
		if (request.accountRelations != null || !request.accountRelations.isEmpty()) {
			createAccountRelations(request.accountRelations);
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
				Account__c = accountId
		);
		insert clientZone;
		return clientZone.Id;
	}

	private static void updateClientZone(ClientZone__c clientZone, SF_PersonManagementSOAPService.ClientZoneType clientZoneRequest) {
		clientZone.ClosedBy__c = clientZoneRequest.closedBy;
		clientZone.Name = clientZoneRequest.contractNumber;
		clientZone.Username__c = clientZoneRequest.userName;
		clientZone.VerificationPhone__c = clientZoneRequest.verificationPhone;
		clientZone.Email__c = clientZoneRequest.email;
		update clientZone;
	}

	private static void createAccountRelations(List<SF_PersonManagementSOAPService.AccountRelationType> accountRelations) {
		List<AccountRelation__c> accountRelationsToInsert = new List<AccountRelation__c>();
		for (SF_PersonManagementSOAPService.AccountRelationType accountRelation : accountRelations) {
			AccountRelation__c accountRel = new AccountRelation__c(
					RelatedAccount__c = accountRelation.relatedClientId,
					RelatedAccountRole__c = accountRelation.clientRole,
					ValidTo__c = accountRelation.validTo,
					ExternalId__c = accountRelation.externalId
			);
			accountRelationsToInsert.add(accountRel);
		}
		insert accountRelationsToInsert;
	}

	private class ClientZoneServiceException extends Exception {
	}
}