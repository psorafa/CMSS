public class UpdateLoanAssetsFlowController {
    
    @invocablemethod(Label = 'LoanServicesCallout')
    public static List<List<String>>   updateloanAssetsFlowHelper(List<Request> requests) {
        List<List<String>> flowOutput = new List<List<String>>();
        List<String> errorMessages = new List<String>();
        List<LoanDetailInfoResult> resultsForLoanDetailInfoResult = new List<LoanDetailInfoResult>();
        List<List<LoadPackagesCalloutResult>> resultsForLoadPackagesCalloutResult = new List<List<LoadPackagesCalloutResult>>();
        
        
        try{
            HTTPResponse loanDetailInfoRawResponse = LoanDetailInfoServiceController.loanDetailInfoRawResponse(requests[0].assetName);
            HTTPResponse loadPackagesListRawResponse = LoanServiceController.loadPackagesListRawResponse(requests[0].assetName);
            
            String loadPackagesListErrorMessage = LoanServiceController.loadPackagesListErrorMessage(loadPackagesListRawResponse);
            String loanDetailInfoErrorMessage = LoanDetailInfoServiceController.loanDetailInfoErrorMessage(loanDetailInfoRawResponse);
            
            resultsForLoadPackagesCalloutResult.add(LoanServiceController.loadPackagesResult(loadPackagesListRawResponse));
            resultsForLoanDetailInfoResult.add( LoanDetailInfoServiceController.loanDetailInfoResult(loanDetailInfoRawResponse));
            
            if(loanDetailInfoErrorMessage != null){
                errorMessages.add(loanDetailInfoErrorMessage);
            }
            if(loadPackagesListErrorMessage != null){
                errorMessages.add(loadPackagesListErrorMessage);
            }
            if(resultsForLoanDetailInfoResult[0] != null) {
                String errorFromUpdateLoanDetailInfo = LoanAssetsServices.updateLoanDetailInfo(resultsForLoanDetailInfoResult[0],requests[0]);
                if(errorFromUpdateLoanDetailInfo != null){
                    errorMessages.add(errorFromUpdateLoanDetailInfo);
                }
            }
            if(resultsForLoadPackagesCalloutResult[0] != null){
                String errorFromUpdateLoadPackages = LoanAssetsServices.updateLoadPackages(resultsForLoadPackagesCalloutResult[0], requests[0]);
                if(errorFromUpdateLoadPackages != null){
                    errorMessages.add(errorFromUpdateLoadPackages);
                }
            }
            
        }
        catch (Exception e) {
            
            Logger.error('An unhandled exception thrown', e);
            throw e;
            
        } finally {
            Logger.saveLogs();
        }
        
        flowOutput.add(errorMessages);
        
        return flowOutput; 
    } 
    
    
    public class Request {
        @InvocableVariable
        public String assetName;
        @InvocableVariable
        public String assetId;
        @InvocableVariable
        public Long phase;
        @InvocableVariable
        public Long status;
    }
    
    public class LoanDetailInfoResult{  
        public Decimal variableAmount;
        public String loanUsageCode;
        public String loanUsage2Code;
        public Date signDate;    
        public Date approvalDate2;
        public String loanStateCode;
        public String personNumber;
    }
    
    
    public class LoadPackagesCalloutResult{
        public String packageId;
        public String packageType;
        public String fee;
        public String discount;
        public Date validFrom;
        public Date validTo;
    }
    
    
    public class LoanDocumentsCalloutResult{
        public Long group_x;
        public String phase;  
        public Long number_x;
        public String status;
        public String text;
        public Date incomingDate;
        public Date tillWhenDate; 
    }
    
    
    
}