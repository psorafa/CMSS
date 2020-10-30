public with sharing class OpportunityService {

	public static Id createOpportunity(SF_OpportunitySOAPService.OpportunityType data) {
		if (data.id != null) {
			throw new SOAPCommonTypes.BusinessException(102, 'Invalid attribute specified: cannot specifiy "id" in createOpporunity');
		}
		Validation.requireAttribute(data.customerGlobalId, 'customerGlobalId');
		Opportunity opportunity = prepareOpportunity(data);
		if (data.validFrom == null) {
			opportunity.CreatedDateTime__c = System.now();
			opportunity.ValidFrom__c = System.now();
		}
		if (data.validTo == null) {
			opportunity.CloseDate = data.validTo.addDays(90).date();
			opportunity.ValidTo__c = data.validTo.addDays(120);
		}
		opportunity.DueDate__c = Date.today().addDays(90);
		try {
			insert opportunity;
			return opportunity.Id;
		} catch (DmlException e) {
			throw new SOAPCommonTypes.BusinessException(301, 'Cannot insert record: ' + e.getMessage(), e);
		}
	}

	public static void updateOpportunity(SF_OpportunitySOAPService.OpportunityType data) {
		Validation.requireAttribute(data.id, 'id');
		Opportunity opportunity = prepareOpportunity(data);
		try {
			update opportunity;
		} catch (DmlException e) {
			throw new SOAPCommonTypes.BusinessException(301, 'Cannot insert record: ' + e.getMessage(), e);
		}
	}

	private static Opportunity prepareOpportunity(SF_OpportunitySOAPService.OpportunityType data) {
		Opportunity o = new Opportunity();
		o.Id = data.id;
		if (data.customerGlobalId != null) {
			o.AccountId = ReferenceUtility.getAccountByGlobalId(data.customerGlobalId).Id;
		}
		o.Description = data.description;
		o.Name = data.subject;
		o.StageName = data.stateReason == null ? '1' : data.stateReason;
		o.Reason__c = data.result;
		o.Author__c = data.author;
		if (data.statusManagerCPU != null) {
			o.OwnerId = ClientService.getUserIdByCommissionAccountNr(data.statusManagerCPU);
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
}