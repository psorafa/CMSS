/**
 * Created by J. Birka on 10.11.2022
 */
public without sharing class OpportunityController {
    public without sharing class OpportunityControllerDTO {
        @AuraEnabled
        public String OpportunityId { get; set; }
        @AuraEnabled
        public String ErrorMessage { get; set; }

        public OpportunityControllerDTO(
            String OpportunityId,
            String ErrorMessage
        ) {
            this.OpportunityId = OpportunityId;
            this.ErrorMessage = ErrorMessage;
        }
    }	
    
    @AuraEnabled
	public static OpportunityController.OpportunityControllerDTO createOpportunity(String objectIdString) {
         Try {           
             	Id objectId;
                String commAccntNr = [Select CommissionAccountNr__c From User Where Id = :UserInfo.getUserId()][0].CommissionAccountNr__c;
                Opportunity oppty = new Opportunity();            
                oppty.Description = 'Sjednání úvěru ze stavebního spoření';
                oppty.Name = 'eÚvěry';
                oppty.StageName = '1';
                oppty.Author__c =	commAccntNr;
                oppty.OwnerId = UserInfo.getUserId();
                oppty.ValidFrom__c = System.today();
                oppty.ValidTo__c = System.today().addDays(60);
                oppty.CloseDate = System.today().addDays(60);
                oppty.Category__c = '5';
                
             	if(String.isBlank(objectIdString)) //HomePage
                { 
                    insert oppty;                
                    return new OpportunityController.OpportunityControllerDTO(oppty.Id, null);                                       
                }
             	else { 
                	objectId = Id.valueOf(objectIdString);
                    
                    if (objectId.getSobjectType() == Account.SObjectType) {
                        oppty.AccountId = objectId;
                        insert oppty;
                        return new OpportunityController.OpportunityControllerDTO(oppty.Id, null);
                    }
                    else if (objectId.getSobjectType() == Task.SObjectType) {
                        oppty.AccountId = [Select AccountId From Task Where Id = :objectId Limit 1][0].AccountId;
                        insert oppty;
                        return new OpportunityController.OpportunityControllerDTO(oppty.Id, null);                
                    }
                    else if (objectId.getSobjectType() == Opportunity.SObjectType) {
                        return new OpportunityController.OpportunityControllerDTO(objectId, null);                
                    }
                    else {
                        return null;
                    }
                }
         } //end Try
         catch (Exception e) {
            return new OpportunityController.OpportunityControllerDTO(null, e.getMessage()); 		 
         }
    }
}