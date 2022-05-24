public class LoanDocumentsServiceController {
    public static HTTPResponse loanDocumentsRawResponse(String assetName){
        CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
        LoanDocumentsServiceDataTypes.GetLoanDocumentsListRequestBodyType requestBody = new  LoanDocumentsServiceDataTypes.GetLoanDocumentsListRequestBodyType();
        
        BasicTypesService.AccountNumberType loanIdNumber = new BasicTypesService.AccountNumberType(); 
     
        loanIdNumber.basicNumber = Long.valueOf(assetName.left(7));
        loanIdNumber.checkNumber = Long.valueOf(assetName.substring(7, 8));
        loanIdNumber.endNumber = Long.valueOf(assetName.right(2));
        
        
        requestBody.loanIdNumber  = loanIdNumber;
        LoanDocumentsService.LoanDocumentsServicePort stub = new LoanDocumentsService.LoanDocumentsServicePort();
        HTTPResponse rawResponse = stub.getLoanDocumentsList_Http(header,requestBody);
        return rawResponse;
    }
    public static String  loanDocumentsErrorMessage(HTTPResponse rawResponse){
        Integer responseStatusCode = rawResponse.getStatusCode();
        if(responseStatusCode == 500){
            String responseBody = rawResponse.getBody();
            String error = responseBody.substringAfter('<ns2:message>').substringBefore('</ns2:message>');
            String errorMessage = 'loanService.LoanDocumentsErrorMessage: '+ error ;
            return errorMessage;               
        }else{
            return null;
        }
    }
    public static List<UpdateLoanAssetsFlowController.LoanDocumentsCalloutResult>  loanDocumentsResult(HTTPResponse rawResponse){
        if(rawResponse.getStatusCode() != 500){
            Dom.Document responseDoc = rawResponse.getBodyDocument();
            Dom.XmlNode rootNode = responseDoc.getRootElement();
            Dom.XmlNode bodyNode = rootNode.getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/');
            Dom.XmlNode GetLoanDocumentsListResponseNode = bodyNode.getChildElement('GetLoanDocumentsListResponse', 'http://service.cmss.cz/loan/LoanService/v06');
            
            LoanDocumentsServiceDataTypes.GetLoanDocumentsListResponseType response_x = new LoanDocumentsServiceDataTypes.GetLoanDocumentsListResponseType(GetLoanDocumentsListResponseNode);
            
            LoanDocumentsServiceDataTypes.GetLoanDocumentsListResponseBodyType responseBody = response_x.responseBody;
            
            LoanDocumentsServiceDataTypes.ListOfDocumentsType response = responseBody.listOfDocuments;
            
            List<UpdateLoanAssetsFlowController.LoanDocumentsCalloutResult> resultList = new List<UpdateLoanAssetsFlowController.LoanDocumentsCalloutResult>();
            if(response.documentsItem != null) {
            for(LoanDocumentsServiceDataTypes.DocumentsItemType documentsItem : response.documentsItem){
                UpdateLoanAssetsFlowController.LoanDocumentsCalloutResult result = new UpdateLoanAssetsFlowController.LoanDocumentsCalloutResult();
                result.group_x = documentsItem.group_x;
                result.phase =   documentsItem.phase;
                result.number_x = documentsItem.number_x;
                result.status = documentsItem.status;
                result.text = documentsItem.text;
                result.incomingDate = documentsItem.incomingDate;
                result.tillWhenDate = documentsItem.tillWhenDate;
                result.id =   documentsItem.id;
                resultList.add(result);
            }}
           
            return resultList;
        } else{
            return null;
        }
        
    }
}