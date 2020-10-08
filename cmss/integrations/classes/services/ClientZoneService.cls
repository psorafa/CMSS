public with sharing class ClientZoneService {

	public static SF_PersonManagementSOAPService.CreateCZContractResponseType createClientZone(String globalId, SF_PersonManagementSOAPService.CreateClientZoneRequest request) {
		if (globalId == null) {
			throw new ClientZoneServiceException('GlobalId in request was null!');
		}
		List<Account> accounts = [SELECT Id FROM Account WHERE GlobalId__c = :globalId LIMIT 1];
		if (accounts.isEmpty()) {
			throw new ClientZoneServiceException('No client found for globalId specified in request!');
		}
		SF_PersonManagementSOAPService.CreateCZContractResponseType response = new SF_PersonManagementSOAPService.CreateCZContractResponseType();

		List<ClientZone__c> clientZones = [SELECT Id FROM ClientZone__c WHERE Account__c = :accounts.get(0).Id AND Status__c = ''];
		if (clientZones.isEmpty()) {
			response.clientZoneId = insertClientZone(request.clientZone);
			response.isSuccess = true;
		} else {
			updateClientZone(clientZones.get(0), request.clientZone);
			response.isSuccess = true;
		}
		if (request.accountRelations != null || !request.accountRelations.isEmpty()) {
			createAccountRelations(request.accountRelations);
		}

		return response;
	}

	private static Id insertClientZone(SF_PersonManagementSOAPService.ClientZoneType clientZoneRequest) {
		ClientZone__c clientZone = new ClientZone__c(
				Name = clientZoneRequest.contractNumber,
				VerificationPhone__c = clientZoneRequest.verificationPhone,
				Username__c = clientZoneRequest.userName,
				ClosedBy__c = clientZoneRequest.closedBy
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
		for (SF_PersonManagementSOAPService.AccountRelationType accountRelation : accountRelations) {

		}
	}

	private class ClientZoneServiceException extends Exception {
	}
}