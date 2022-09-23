public without sharing class LoanDetailInfoServiceController {
	public static HTTPResponse loanDetailInfoRawResponse(String assetName) {

		CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
		LoanDetailInfoServiceDataTypes.GetLoanDetailInfoRequestBodyType requestBody = new LoanDetailInfoServiceDataTypes.GetLoanDetailInfoRequestBodyType();

		BasicTypesService.AccountNumberType loanIdNumber = new BasicTypesService.AccountNumberType();

		loanIdNumber.basicNumber = Long.valueOf(assetName.left(7));
		loanIdNumber.checkNumber = Long.valueOf(assetName.substring(7, 8));
		loanIdNumber.endNumber = Long.valueOf(assetName.right(2));
		requestBody.loanIdNumber = loanIdNumber;
		LoanDetailInfoService.LoanDetailInfoServicePort stub = new LoanDetailInfoService.LoanDetailInfoServicePort();

		HTTPResponse rawResponse = stub.getLoanDetailInfo_Http(header, requestBody);
		System.debug('rawResponse ' + rawResponse.getBody());
		return rawResponse;
	}
	public static String loanDetailInfoErrorMessage(HTTPResponse rawResponse) {
		Integer responseStatusCode = rawResponse.getStatusCode();
		if (responseStatusCode == 500) {
			String responseBody = rawResponse.getBody();
			String error = responseBody.substringAfter('<ns2:message>').substringBefore('</ns2:message>');
			String errorMessage = 'loanDetailInfoServiceErrorMessage: ' + error ;
			return errorMessage;
		} else {
			return null;
		}


	}
	public static UpdateLoanAssetsFlowController.LoanDetailInfoResult loanDetailInfoResult(HTTPResponse rawResponse) {
		if (rawResponse.getStatusCode() != 500) {
			Dom.Document responseDoc = rawResponse.getBodyDocument();
			Dom.XmlNode rootNode = responseDoc.getRootElement();
			Dom.XmlNode bodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
			Dom.XmlNode GetLoanDetailInfoResponseNode = bodyNode.getChildElement('GetLoanDetailInfoResponse', 'http://service.cmss.cz/loan/LoanDetailInfoService/v05/datatypes');
			LoanDetailInfoServiceDataTypes.GetLoanDetailInfoResponseType response_x = new LoanDetailInfoServiceDataTypes.GetLoanDetailInfoResponseType(GetLoanDetailInfoResponseNode);
			LoanDetailInfoServiceDataTypes.GetLoanDetailInfoResponseBodyType responseBody = response_x.responseBody;
			LoanDetailInfoServiceDataTypes.LoanDetailInfoType response = responseBody.loanDetailInfo;
			UpdateLoanAssetsFlowController.LoanDetailInfoResult result = new UpdateLoanAssetsFlowController.LoanDetailInfoResult();
			result.variableAmount = response.variableAmount;
			result.loanUsageCode = response.loanUsageCode;
			result.loanUsage2Code = response.loanUsage2Code;
			result.signDate = response.signDate;
			result.approvalDate2 = response.approvalDate2;
			result.loanStateCode = response.loanStateCode;
			result.aquisitionChannelCode = response.aquisitionChannelCode ;
			result.loanCaseAdministrator = response.loanCaseAdministrator;
			result.establishmentTypeCode = response.establishmentTypeCode;
			result.creditConditions = response.creditConditions;
			result.lastDrawdownReminder = response.lastDrawdownReminder;
			result.lastChangeDate = response.lastChangeDate;
			result.restObligAmount = response.restObligAmount;
			result.requestedAmount = response.requestedAmount;
			result.signDateOwner = response.signDateOwner;
			return result;
		} else {
			return null;
		}

	}
}