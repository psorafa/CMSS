public with sharing class OpportunityService {

	public static Id createOpportunity(SF_OpportunitySOAPService.OpportunityType data) {
		if (data.id != null) {
			throw new SOAPCommonTypes.BusinessException(102, 'Invalid attribute specified: cannot specify "id" in createOpportunity');
		}
		Validation.requireAttribute(data.customerGlobalId, 'customerGlobalId');
		Opportunity opportunity = prepareOpportunity(data);
		if (data.validFrom == null) {
			opportunity.CreatedDateTime__c = System.now();
			opportunity.ValidFrom__c = System.now();
		}
		if (data.validTo == null) {
			opportunity.CloseDate = Date.today().addDays(90);
			opportunity.ValidTo__c = Date.today().addDays(120);
		}
		opportunity.DueDate__c = Date.today().addDays(90);
		opportunity.UpdateDate__c = System.now();
		SObjectUtil.stripNullFields(opportunity);
		DmlUtility.insertRecord(opportunity);
		return opportunity.Id;
	}

	public static void updateOpportunity(SF_OpportunitySOAPService.OpportunityType data) {
		Validation.requireAttribute(data.id, 'id');
		Opportunity opportunity = prepareOpportunity(data);
		opportunity.UpdateDate__c = System.now();
		SObjectUtil.stripNullFields(opportunity);
		DmlUtility.updateRecord(opportunity);
	}

	private static Opportunity prepareOpportunity(SF_OpportunitySOAPService.OpportunityType data) {
		Opportunity o = new Opportunity();
		if (!String.isBlank(data.id)) {
			o.Id = findOpportunityByExternalId(data.id).Id;
		}
		if (data.customerGlobalId != null) {
			o.AccountId = ReferenceUtility.getAccountByGlobalId(data.customerGlobalId).Id;
		}
		o.Description = data.description;
		o.Name = data.subject;
		o.StageName = data.stateReason == null ? '1' : data.stateReason;
		o.Reason__c = data.result;
		o.Author__c = data.author;
		if (data.statusManagerCPU != null) {
			o.OwnerId = ReferenceUtility.getUserByCPU(data.statusManagerCPU).Id;
		}
		if (data.validFrom != null) {
			o.CreatedDateTime__c = data.validFrom;
			o.ValidFrom__c = data.validFrom;
		}
		if (data.validTo != null) {
			o.CloseDate = data.validTo.date();
			o.ValidTo__c = data.validTo;
		}
		o.Category__c = data.category;
		if (data.contractNumber != null) {
			o.OriginalAsset__c = ReferenceUtility.getAssetByNumber(data.contractNumber).Id;
		}
		o.DelegatedDate__c = data.delegatedDate;
		return o;
	}

	private static Opportunity findOpportunityByExternalId(String externalId) {
		for (Opportunity o : [SELECT Id FROM Opportunity WHERE ExternalId__c = :externalId LIMIT 1]) {
			return o;
		}
		throw new SOAPCommonTypes.BusinessException(201, 'Record not found: Opportunity - External ID: ' + externalId);
	}
}