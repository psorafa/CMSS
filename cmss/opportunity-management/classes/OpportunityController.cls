/**
 * Created by J. Birka on 10.11.2022
 */
public without sharing class OpportunityController {
	@AuraEnabled
	public static String createOpportunity(Id objectId) {
		Opportunity opty = [SELECT Id, Name FROM Opportunity WHERE AccountId = '0015E00002nc02HQAQ'];

		return opty.Id;
	}
}
