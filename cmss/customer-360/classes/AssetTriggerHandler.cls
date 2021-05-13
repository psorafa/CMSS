public with sharing class AssetTriggerHandler extends TriggerHandler {
	public static void pairOpportunity(List<Asset> assetsList) {
       Set<Id> clientIds = new Set<Id>();
       for (Asset asset: assetsList){
           clientIds.add(asset.AccountId);
       }

       List<Opportunity> oppsToUpsert = new List<Opportunity>();

       List<Opportunity> oppsToCheck = [SELECT 
            Id, AccountId, Amount, Author__c, Category__c, CloseDate, CreatedDateTime__c, Description, DueDate__c, ExternalId__c, 
            Name, OriginalAsset__c, OwnerId, Probability, ProductType__c, Reason__c, StageName, UpdateDate__c,
            ValidFrom__c, ValidTo__c, StateCode__c FROM Opportunity 
            WHERE AccountId IN: clientIds];

            for (Asset asset: assetsList){
                List<Opportunity> currentOppsToUpdate = new List<Opportunity>();
                for (Opportunity opp: oppsToCheck){
                    if (opp.AccountId == asset.AccountId &&
                        opp.OwnerId == asset.ClosingAgentId__c &&
                        opp.ProductType__c == Asset.ProductType__c &&
                        asset.ProductCloseDate__c >= opp.ValidFrom__c &&
                        asset.ProductCloseDate__c <= opp.ValidTo__c.addDays(30)
                    ) {
                        currentOppsToUpdate.add(addOpportunityInfo(opp, asset));                      
                    } 
                }
                if (currentOppsToUpdate.size() > 0) { //if opp (or more opps) was found, add it to the upsert list
                    oppsToUpsert.addAll(currentOppsToUpdate);
                } else { //if no opp was paired, we will create a new one
                    Opportunity newOpp = new Opportunity();
                    oppsToUpsert.add(addOpportunityInfo(newOpp,asset));
                }                   
            }  
            
        upsert oppsToUpsert;
        }

    private static Opportunity addOpportunityInfo(Opportunity opp, Asset asset){
        opp.Reason__c = '3';
        opp.StageName = '7';

        // all other fields in this function are changed only if they don't have any value already
        opp.AccountId = String.isEmpty(opp.AccountId) ? asset.AccountId : opp.AccountId;
        opp.Amount = opp.Amount == NULL ? getOppAmount(asset) : opp.Amount;
        opp.Author__c = 'Integrace'; //TODO integration user?? je to jenom string
        opp.Category__c = String.isEmpty(opp.Category__c) ? '2' : opp.Category__c;
        opp.CloseDate = opp.CloseDate == NULL ? Asset.ProductCloseDate__c : opp.CloseDate; //TODO cannot be empty
        opp.CreatedDateTime__c = opp.CreatedDateTime__c == NULL ? System.now() : opp.CreatedDateTime__c ;
        opp.Description = String.isEmpty(opp.Description) ? 'Příležitost automaticky založena při vzniku smlouvy': opp.Description;
        opp.DueDate__c = opp.DueDate__c == NULL ? System.today() : opp.DueDate__c; 
        List<String> oppNameList = new List<String>{'Sjednání smlouvy', asset.ProductType__c, asset.Name};
        opp.Name = String.isEmpty(opp.Name) ? String.join(oppNameList,' ') : opp.Name;
        opp.OriginalAsset__c = String.isEmpty(opp.OriginalAsset__c) ? asset.Id : opp.OriginalAsset__c;
        opp.OwnerId = String.isEmpty(opp.OwnerId) ? asset.ClosingAgentId__c : opp.OwnerId; //TODO cannot be empty!
        opp.Probability = opp.Probability == NULL ? 100 : opp.Probability; //TODO nema to byt vzdycky 100?
        opp.ProductType__c = opp.ProductType__c == NULL ? asset.ProductType__c : opp.ProductType__c; 
        opp.UpdateDate__c = opp.UpdateDate__c == NULL ? System.now() : opp.UpdateDate__c; 
        opp.ValidFrom__c = opp.ValidFrom__c == NULL ? System.now().addMinutes(-30) : opp.ValidFrom__c; 
        opp.ValidTo__c = opp.ValidTo__c == NULL ? System.now() : opp.ValidTo__c; 
        opp.StateCode__c = String.isEmpty(opp.StateCode__c) ? '1' : opp.StateCode__c;

    return opp;     
    }

    private static Double getOppAmount(Asset asset){
        if (asset.RecordTypeId == Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('BuildingSavings').getRecordTypeId()){
            return asset.TargetAmount__c;
        } else if (asset.RecordTypeId == Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CreditCases').getRecordTypeId()){
            return asset.CreditAmount__c;
        } 

        return asset.LoanAmount__c;
    }
}
