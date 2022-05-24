public class UpdateLoanAssetsFlowController {
    
    @invocablemethod(Label = 'LoanServicesCallout')
    public static List<List<String>>   updateloanAssetsFlowHelper(List<Request> requests) {
        List<List<String>> flowOutput = new List<List<String>>();
        List<String> errorMessages = new List<String>();
        List<LoanDetailInfoResult> resultsForLoanDetailInfoResult = new List<LoanDetailInfoResult>();
        List<List<LoadPackagesCalloutResult>> resultsForLoadPackagesCalloutResult = new List<List<LoadPackagesCalloutResult>>();
        List<List<LoanDocumentsCalloutResult>> resultsForLoanDocumentsCalloutResult = new List<List<LoanDocumentsCalloutResult>>();
        
        try{
            HTTPResponse loanDetailInfoRawResponse = LoanDetailInfoServiceController.loanDetailInfoRawResponse(requests[0].assetName);
            HTTPResponse loadPackagesListRawResponse = LoanServiceController.loadPackagesListRawResponse(requests[0].assetName);
            HTTPResponse loanDocumentsRawResponse = LoanDocumentsServiceController.loanDocumentsRawResponse(requests[0].assetName);
            
            String loadPackagesListErrorMessage = LoanServiceController.loadPackagesListErrorMessage(loadPackagesListRawResponse);
            String loanDetailInfoErrorMessage = LoanDetailInfoServiceController.loanDetailInfoErrorMessage(loanDetailInfoRawResponse);
            String loanDocumentsErrorMessage = LoanDocumentsServiceController.loanDocumentsErrorMessage(loanDocumentsRawResponse);
                
            resultsForLoadPackagesCalloutResult.add(LoanServiceController.loadPackagesResult(loadPackagesListRawResponse));
            resultsForLoanDetailInfoResult.add( LoanDetailInfoServiceController.loanDetailInfoResult(loanDetailInfoRawResponse));
            resultsForLoanDocumentsCalloutResult.add(LoanDocumentsServiceController.loanDocumentsResult(loanDocumentsRawResponse));
            
            if(loanDetailInfoErrorMessage != null){
                errorMessages.add(loanDetailInfoErrorMessage);
            }
            if(loanDocumentsErrorMessage != null){
                errorMessages.add(loanDocumentsErrorMessage);
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
                if(resultsForLoanDocumentsCalloutResult[0] != null) {
                String errorLoanDocumentsErrorMessage = LoanAssetsServices.upsertLoanCaseDoc(resultsForLoanDocumentsCalloutResult[0],requests[0]);
                if(errorLoanDocumentsErrorMessage != null){
                    errorMessages.add(errorLoanDocumentsErrorMessage);
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
    }
    
    public class LoanDetailInfoResult{  
        public Decimal variableAmount;
        public String loanUsageCode;
        public String loanUsage2Code;
        public Date signDate;    
        public Date approvalDate2;
        public String loanStateCode;
        public String personNumber;
        public String aquisitionChannelCode;
		public String loanCaseAdministrator;
		public String establishmentTypeCode;
		public String creditConditions; 
		public Date lastDrawdownReminder;
		public Date lastChangeDate;
		public String restObligAmount;
		public Decimal requestedAmount;
        public Date contractBeginDate;
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
        public String group_x;
        public String phase;  
        public String number_x;
        public String status;
        public String text;
        public Date incomingDate;
        public Date tillWhenDate; 
        public String id;
    }
    
    
    
}