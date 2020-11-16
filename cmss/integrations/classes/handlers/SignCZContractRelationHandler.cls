public with sharing class SignCZContractRelationHandler {

	private String relatedClientGlobalId;
	private ClientZone__c clientZone;
	private Integer amendmentNumber;
	private Date signDate;

	public SignCZContractRelationHandler(SF_PersonManagementSOAPService.SignCZContractRelationsRequestBody request) {
		clientZone = ReferenceUtility.getClientZoneById(request.clientZoneId);
		relatedClientGlobalId = request.relatedClientGlobalId;
		amendmentNumber = request.amendmentNumber;
		signDate = request.signDate;
	}

	public void handle() {
		AccountRelation__c relation = getRelationToBeSigned();
		relation.AmendmentSignDate__c = signDate;
		DmlUtility.updateRecord(relation);
	}

	private AccountRelation__c getRelationToBeSigned() {
		for (AccountRelation__c relation : [
			SELECT Id
			FROM AccountRelation__c
			WHERE RelatedAccount__c = :clientZone.Account__c
			AND Account__r.GlobalId__c = :relatedClientGlobalId
			AND RelationTypeNEL__c = '5'
			AND AmendmentNumber__c = :amendmentNumber
		]) {
			return relation;
		}
		throw new SOAPCommonTypes.BusinessException(205, 'There are no relations to be signed.');
	}
}