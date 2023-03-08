public class UpdateLoanAssetsFlowController {

	@InvocableMethod(Label='LoanServicesCallout')
	public static List<List<String>> updateloanAssetsFlowHelper(List<Request> requests) {
		List<List<String>> flowOutput = new List<List<String>>();
		List<String> errorMessages = new List<String>();

		loanDetailInfoCallout(requests, errorMessages);
		loadPackagesCallout(requests, errorMessages);
		loanDocumentsCallout(requests, errorMessages);

		flowOutput.add(errorMessages);
		return flowOutput;
	}

	private static void loanDocumentsCallout(List<Request> requests, List<String> errorMessages) {
		List<List<LoanDocumentsCalloutResult>> resultsForLoanDocumentsCalloutResult = new List<List<LoanDocumentsCalloutResult>>();
		try {
			HTTPResponse loanDocumentsRawResponse = LoanDocumentsServiceController.loanDocumentsRawResponse(requests[0].assetName);
			resultsForLoanDocumentsCalloutResult.add(LoanDocumentsServiceController.loanDocumentsResult(loanDocumentsRawResponse));
			if (resultsForLoanDocumentsCalloutResult[0] != null) {
				String errorLoanDocumentsErrorMessage = LoanAssetsServices.upsertLoanCaseDoc(resultsForLoanDocumentsCalloutResult[0], requests[0]);
				if (errorLoanDocumentsErrorMessage != null) {
					errorMessages.add(errorLoanDocumentsErrorMessage);
				}
			}
		} catch (Callout.HttpResponseException e) {
			errorMessages.add(e.getMessage());
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	private static void loadPackagesCallout(List<Request> requests, List<String> errorMessages) {
		List<List<LoadPackagesCalloutResult>> resultsForLoadPackagesCalloutResult = new List<List<LoadPackagesCalloutResult>>();
		try {
			HTTPResponse loadPackagesListRawResponse = LoanServiceController.loadPackagesListRawResponse(requests[0].assetName);
			resultsForLoadPackagesCalloutResult.add(LoanServiceController.loadPackagesResult(loadPackagesListRawResponse));
			if (resultsForLoadPackagesCalloutResult[0] != null) {
				String errorFromUpdateLoadPackages = LoanAssetsServices.updateLoadPackages(resultsForLoadPackagesCalloutResult[0], requests[0]);
				if (errorFromUpdateLoadPackages != null) {
					errorMessages.add(errorFromUpdateLoadPackages);
				}
			}
		} catch (Callout.HttpResponseException e) {
			errorMessages.add(e.getMessage());
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	private static void loanDetailInfoCallout(List<Request> requests, List<String> errorMessages) {
		List<LoanDetailInfoResult> resultsForLoanDetailInfoResult = new List<LoanDetailInfoResult>();
		try {
			HTTPResponse loanDetailInfoRawResponse = LoanDetailInfoServiceController.loanDetailInfoRawResponse(requests[0].assetName);
			resultsForLoanDetailInfoResult.add(LoanDetailInfoServiceController.loanDetailInfoResult(loanDetailInfoRawResponse));
			if (resultsForLoanDetailInfoResult[0] != null) {
				String errorFromUpdateLoanDetailInfo = LoanAssetsServices.updateLoanDetailInfo(resultsForLoanDetailInfoResult[0], requests[0]);
				if (errorFromUpdateLoanDetailInfo != null) {
					errorMessages.add(errorFromUpdateLoanDetailInfo);
				}
			}
		} catch (Callout.HttpResponseException e) {
			errorMessages.add(e.getMessage());
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}


	public class Request {
		@InvocableVariable
		public String assetName;
		@InvocableVariable
		public String assetId;
	}

	public class LoanDetailInfoResult {
		public Decimal variableAmount;
		public String loanUsageCode;
		public String loanUsage2Code;
		public Date signDate;
		public Date approvalDate2;
		public String loanStateCode;
		public String aquisitionChannelCode;
		public String loanCaseAdministrator;
		public String establishmentTypeCode;
		public String creditConditions;
		public Date lastDrawdownReminder;
		public Date lastChangeDate;
		public String restObligAmount;
		public String requestedAmount;
		public Date signDateOwner;
	}


	public class LoadPackagesCalloutResult {
		public String packageId;
		public String packageType;
		public String fee;
		public String discount;
		public Date validFrom;
		public Date validTo;
	}


	public class LoanDocumentsCalloutResult {
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