public class LoanAssetsServices {
    
    public static String  updateLoanDetailInfo(UpdateLoanAssetsFlowController.LoanDetailInfoResult result,UpdateLoanAssetsFlowController.Request request){
        try{
            List<Asset> assetsToUpdate = new List<Asset>();
            String errorMessage;
            assetsToUpdate.add(getAsset(result, request.assetId));  
            List<Database.SaveResult> updateResults = Database.update(assetsToUpdate, false);
            for (Database.SaveResult updateResult : updateResults) {
                if (!updateResult.isSuccess()) {
                    for (Database.Error err : updateResult.getErrors()) {
                        errorMessage = 'Update erorr message: ' + err.getMessage() + ' Fields:' + err.getFields();
                        Logger.error('Update erorr message: ' + err.getMessage() + ' Fields:' + err.getFields());
                    }
                    return errorMessage;
                }
            }
            return null;
        }catch(Exception ex){
            
            if(ex.getLineNumber() == 80){
                return 'Update erorr message: Nepodařilo se najít usera s tímto TipsterId__c';
            }else{
                return 'Update erorr message: ' + ex.getMessage();}
        }
        
    }
    public static String  updateLoadPackages(List<UpdateLoanAssetsFlowController.LoadPackagesCalloutResult> results,UpdateLoanAssetsFlowController.Request request){
        try{
            String errorMessage;
            List<LoanSurchargeDiscount__c> loanSurchargeDiscountToUpdate = new   List<LoanSurchargeDiscount__c>();
            loanSurchargeDiscountToUpdate = getLoanSurchargeDiscount(results, request.assetId);
            List<Database.SaveResult> updateResults = Database.update(loanSurchargeDiscountToUpdate, false);
            for (Database.SaveResult updateResult : updateResults) {
                if (!updateResult.isSuccess()) {
                    for (Database.Error err : updateResult.getErrors()) {
                        errorMessage = 'Update erorr message: ' + err.getMessage() + ' Fields:' + err.getFields();
                        Logger.error('Update erorr message: ' + err.getMessage() + ' Fields:' + err.getFields());
                    }
                    return errorMessage;
                }
            }return null;
            
        }
        
        catch(Exception ex){
            return 'Update erorr message: ' + ex.getMessage();
            
        }}
    
    private static List<LoanSurchargeDiscount__c> getLoanSurchargeDiscount(List<UpdateLoanAssetsFlowController.LoadPackagesCalloutResult> results, String assetId){
        LoanSurchargeDiscount__c[] loanSurchargeDiscount = [Select Id,ExternalId__c, SurchargeDiscountAmount__c, SurchargeDiscountId__c,ValidFrom__c,ValidTo__c FROM LoanSurchargeDiscount__c WHERE Asset__c =: assetId];
        List<LoanSurchargeDiscount__c> loanSurchargeDiscountToUpdate = new   List<LoanSurchargeDiscount__c>();
        if (loanSurchargeDiscount.size() > 0 ){ 
            for(LoanSurchargeDiscount__c lsd : loanSurchargeDiscount){
                for(UpdateLoanAssetsFlowController.LoadPackagesCalloutResult result: results){
                    if(lsd.ExternalId__c == result.packageId){
                        lsd.ExternalId__c = result.packageId;
                        lsd.SurchargeDiscountId__c = result.packageType;
                        lsd.ValidTo__c = result.validTo;
                        lsd.ValidFrom__c = result.validFrom;
                        if(result.fee != null){
                            result.fee = result.fee.replace(',', '.');
                            lsd.SurchargeDiscountAmount__c = Decimal.valueOf(result.fee);
                        }
                        else{
                            result.discount = result.discount.replace(',', '.');
                            lsd.SurchargeDiscountAmount__c = Decimal.valueOf(result.discount);
                        }
                        loanSurchargeDiscountToUpdate.add(lsd);  
                        break;
                    }
                    
                }
            }
        }return loanSurchargeDiscountToUpdate;
    }
    private static Asset getAsset(UpdateLoanAssetsFlowController.LoanDetailInfoResult result, String assetId){
        String personNumber = result.personNumber;
        String userId = [Select Id from User WHERE CommissionAccountBase__c =: personNumber LIMIT 1].Id;
        Asset asset = new Asset(Id = assetId);
        asset.CreditAmount__c = result.variableAmount;
        asset.PurposeOfUse__c = result.loanUsageCode;
        asset.PurposeOfUse2__c = result.loanUsage2Code;
        asset.RequestSignDate__c = result.signDate;
        asset.SecondDecissionDate__c = result.approvalDate2;
        asset.Status__c = result.loanStateCode;
        asset.TipsterId__c = userId;
        
        return asset;
    }
}