public with sharing class ActivateCZContractRelationsHandler {

	private ClientZone__c clientZone;
	private Integer amendmentNumber;
	private List<AccountRelation__c> relationsToDeactivate = new List<AccountRelation__c>();
	private List<AccountRelation__c> relationsToActivate = new List<AccountRelation__c>();

	public ActivateCZContractRelationsHandler(String clientZoneId, Integer amendmentNumber) {
		this.clientZone = ReferenceUtility.getClientZoneByExternalId(clientZoneId);
		this.amendmentNumber = amendmentNumber;
	}

	public void handle() {
		queryRelations();
		if (relationsToActivate.isEmpty()) {
			throw new SOAPCommonTypes.BusinessException(204, 'There are no relations to be activated. AmendmentNumber: ' + amendmentNumber);
		}
		deactivateRelations();
		activateRelations();
	}

	private void queryRelations() {
		List<AccountRelation__c> relations;
		if (amendmentNumber == null) {
			relations = [SELECT Id, AmendmentNumber__c FROM AccountRelation__c WHERE RelationTypeNEL__c = '5' AND AmendmentNumber__c = NULL AND (ClientZoneID__c = :clientZone.Id OR RelatedAccount__c = :clientZone.Account__c)];
		} else {
			relations = [SELECT Id, AmendmentNumber__c FROM AccountRelation__c WHERE RelationTypeNEL__c = '5' AND AmendmentNumber__c <= :amendmentNumber AND (ClientZoneID__c = :clientZone.Id OR RelatedAccount__c = :clientZone.Account__c)];
		}
		for (AccountRelation__c relation : relations) {
			if (amendmentNumber == null || relation.AmendmentNumber__c == amendmentNumber) {
				relationsToActivate.add(relation);
			} else {
				relationsToDeactivate.add(relation);
			}
		}
	}

	private void deactivateRelations() {
		for (AccountRelation__c relation : relationsToDeactivate) {
			relation.IsActive__c = false;
		}
		DmlUtility.updateRecords(relationsToDeactivate);
	}

	private void activateRelations() {
		for (AccountRelation__c relation : relationsToActivate) {
			relation.IsActive__c = true;
		}
		DmlUtility.updateRecords(relationsToActivate);
	}
}