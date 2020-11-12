public with sharing class ChangeCZContractRelationsHandler {

	private SF_PersonManagementSOAPService.ChangeCZContractRelationsRequestBody request;
	private ClientZone__c existingClientZone;
	private List<AccountRelation__c> newRelations = new List<AccountRelation__c>();
	private Map<String, AccountRelation__c> existingRelationsByExternalId;

	public ChangeCZContractRelationsHandler(SF_PersonManagementSOAPService.ChangeCZContractRelationsRequestBody request) {
		this.request = request;
		existingClientZone = ReferenceUtility.getClientZoneById(request.clientZoneId);
		Set<String> relationsExternalIds = ClientZoneService.buildExternalIdsSet(request.relations);
		existingRelationsByExternalId = ClientZoneService.buildExistingRelationsMap([
			SELECT Id, ExternalId__c
			FROM AccountRelation__c
			WHERE ExternalId__c IN :relationsExternalIds
		]);
	}

	public void handle() {
		updateExistingClientZone();
		processRelations();
		DmlUtility.insertRecords(newRelations);
		DmlUtility.updateRecords(existingRelationsByExternalId.values());
	}

	private void updateExistingClientZone() {
		User closedByUser = ReferenceUtility.getUserByCPU(request.closedByCPU);
		existingClientZone.ClosedBy__c = closedByUser.Id;
		existingClientZone.NumberOfAnnexes__c = request.amendmentNumber;
		DmlUtility.updateRecord(existingClientZone);

	}

	private void processRelations() {
		Map<String, Id> accountIdsByGlobalIds = ReferenceUtility.getAccountIdsByGlobalIds(request.relations);
		for (SF_PersonManagementSOAPService.ClientRelationType clientRelation : request.relations) {
			AccountRelation__c relation = existingRelationsByExternalId.get(clientRelation.externalId);
			if (relation == null) {
				relation = new AccountRelation__c(
					Account__c = accountIdsByGlobalIds.get(clientRelation.relatedClientId),
					ExternalId__c = clientRelation.externalId,
					RelatedAccount__c = existingClientZone.Account__c
				);
				newRelations.add(relation);
			}
			relation.ValidFrom__c = Date.today();
			relation.RelatedAccountRole__c = '1502';
			relation.AccountRole__c = '1501';
			relation.RelationTypeNEL__c = '5';
			relation.AmendmentNumber__c = request.amendmentNumber;
			relation.ValidTo__c = clientRelation.validTo;
		}
	}
}