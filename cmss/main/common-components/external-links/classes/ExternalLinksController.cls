public with sharing class ExternalLinksController {

	@AuraEnabled(Cacheable=true)
	public static String getClientGlobalId(Id accountOrTaskOrOpportunityId) {
		if (accountOrTaskOrOpportunityId == null) {
			return null;
		}
		if (accountOrTaskOrOpportunityId.getSobjectType() == Account.SObjectType) {
			for (Account a : [SELECT GlobalId__c FROM Account WHERE Id = :accountOrTaskOrOpportunityId]) {
				return a.GlobalId__c;
			}
		}
		if (accountOrTaskOrOpportunityId.getSobjectType() == Task.SObjectType) {
			for (Task t : [SELECT Account.GlobalId__c FROM Task WHERE Id = :accountOrTaskOrOpportunityId]) {
				return t.Account.GlobalId__c;
			}
		}
		if (accountOrTaskOrOpportunityId.getSobjectType() == Opportunity.SObjectType) {
			for (Opportunity o : [SELECT Account.GlobalId__c FROM Opportunity WHERE Id = :accountOrTaskOrOpportunityId]) {
				return o.Account.GlobalId__c;
			}
		}
		return null;
	}

	@AuraEnabled(Cacheable=true)
	public static IntegrationSettings__c getIntegrationSettings() {
		return IntegrationSettings__c.getInstance();
	}
}