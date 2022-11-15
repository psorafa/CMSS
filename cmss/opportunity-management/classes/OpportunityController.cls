/**
 * Created by J. Birka on 10.11.2022
 */
public without sharing class OpportunityController {
	@AuraEnabled
	public static Id createOpportunity(String objectIdString) {
		try {
			Id objectId;
			String commAccntNr = [SELECT CommissionAccountNr__c FROM User WHERE Id = :UserInfo.getUserId()][0]
			.CommissionAccountNr__c;
			Opportunity oppty = new Opportunity();
			oppty.Description = 'Sjednání úvěru ze stavebního spoření';
			oppty.Name = 'eÚvěry';
			oppty.StageName = '1';
			oppty.Author__c = commAccntNr;
			oppty.OwnerId = UserInfo.getUserId();
			oppty.ValidFrom__c = System.today();
			oppty.ValidTo__c = System.today().addDays(60);
			oppty.CloseDate = System.today().addDays(60);
			oppty.Category__c = '5';

			if (String.isBlank(objectIdString)) {
				//HomePage context
				insert oppty;
				return oppty.Id;
			} else {
				objectId = Id.valueOf(objectIdString);

				if (objectId.getSobjectType() == Account.SObjectType) {
					//Account context
					oppty.AccountId = objectId;
					insert oppty;
					return oppty.Id;
				} else if (objectId.getSobjectType() == Task.SObjectType) {
					//Task context
					oppty.AccountId = [SELECT AccountId FROM Task WHERE Id = :objectId LIMIT 1][0].AccountId;
					insert oppty;
					return oppty.Id;
				} else if (objectId.getSobjectType() == Opportunity.SObjectType) {
					//Opportunity context
					return objectId;
				} else {
					return null;
				}
			}
		} catch (Exception e) {
			//end Try
			throw new AuraHandledException(e.getMessage());
		}
	}
}
