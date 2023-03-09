public class LoanServiceController {
	public static HTTPResponse loadPackagesListRawResponse(String assetName) {
		CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
		LoanServiceDataTypes.LoadPackagesListRequestBodyType requestBody = new LoanServiceDataTypes.LoadPackagesListRequestBodyType();

		BasicTypesService.AccountNumberType loanIdNumber = new BasicTypesService.AccountNumberType();

		loanIdNumber.basicNumber = Long.valueOf(assetName.left(7));
		loanIdNumber.checkNumber = Long.valueOf(assetName.substring(7, 8));
		loanIdNumber.endNumber = Long.valueOf(assetName.right(2));

		requestBody.loanIdNumber = loanIdNumber;
		HTTPResponse rawResponse = new LoanService().loadPackagesList_Http(header, requestBody);
		return rawResponse;
	}
	public static String loadPackagesListErrorMessage(HTTPResponse rawResponse) {
		Integer responseStatusCode = rawResponse.getStatusCode();
		if (responseStatusCode == 500) {
			String responseBody = rawResponse.getBody();
			String error = responseBody.substringAfter('<io7:message>').substringBefore('</io7:message>');
			String errorMessage = 'loanService.LoadPackagesListErrorMessage: ' + error;
			return errorMessage;
		} else {
			return null;
		}
	}
	public static List<UpdateLoanAssetsFlowController.LoadPackagesCalloutResult> loadPackagesResult(
		HTTPResponse rawResponse
	) {
		if (rawResponse.getStatusCode() != 500) {
			Dom.Document responseDoc = rawResponse.getBodyDocument();
			Dom.XmlNode rootNode = responseDoc.getRootElement();
			Dom.XmlNode bodyNode = rootNode.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
			Dom.XmlNode LoadPackagesListResponseNode = bodyNode.getChildElement(
				'LoadPackagesListResponse',
				'http://service.cmss.cz/loan/LoanService/v05/datatypes'
			);

			LoanServiceDataTypes.LoadPackagesListResponseType response_x = new LoanServiceDataTypes.LoadPackagesListResponseType(
				LoadPackagesListResponseNode
			);
			LoanServiceDataTypes.LoadPackagesListResponseBodyType responseBody = response_x.responseBody;

			LoanServiceDataTypes.ListOfPackagesType response = responseBody.listOfPackages;

			List<UpdateLoanAssetsFlowController.LoadPackagesCalloutResult> resultList = new List<UpdateLoanAssetsFlowController.LoadPackagesCalloutResult>();
			if (response.packagesItem != null) {
				for (LoanServiceDataTypes.PackagesItemType packagesItem : response.packagesItem) {
					UpdateLoanAssetsFlowController.LoadPackagesCalloutResult result = new UpdateLoanAssetsFlowController.LoadPackagesCalloutResult();
					result.packageId = packagesItem.packageId;
					result.packageType = packagesItem.packageType;
					result.fee = packagesItem.fee;
					result.discount = packagesItem.discount;
					result.validFrom = packagesItem.validFrom;
					result.validTo = packagesItem.validTo;
					resultList.add(result);
				}
			}
			return resultList;
		} else {
			return null;
		}
	}
}
