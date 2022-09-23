public class LoanAssetsServices {

	public static String updateLoanDetailInfo(UpdateLoanAssetsFlowController.LoanDetailInfoResult result, UpdateLoanAssetsFlowController.Request request) {
		try {
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
		} catch (Exception ex) {


			return 'Update erorr message: ' + ex.getMessage();
		}


	}
	public static String updateLoadPackages(List<UpdateLoanAssetsFlowController.LoadPackagesCalloutResult> results, UpdateLoanAssetsFlowController.Request request) {
		try {
			String errorMessage;
			List<LoanSurchargeDiscount__c> loanSurchargeDiscountToUpdate = new List<LoanSurchargeDiscount__c>();
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
			} return null;

		}

		catch (Exception ex) {
			return 'Update erorr message: ' + ex.getMessage();

		}
	}

	public static String upsertLoanCaseDoc(List<UpdateLoanAssetsFlowController.LoanDocumentsCalloutResult> results, UpdateLoanAssetsFlowController.Request request) {
		try {
			String errorMessage;
			List<LoanCaseDoc__c> loanCaseDocsToUpdate = new List<LoanCaseDoc__c>();
			loanCaseDocsToUpdate = getLoanCaseDoc(results, request.assetId);
			List<Database.upsertResult> upsertResults = Database.upsert(loanCaseDocsToUpdate, LoanCaseDoc__c.ExternalId__c, false);

			for (Database.upsertResult upsertResult : upsertResults) {
				if (!upsertResult.isSuccess()) {
					for (Database.Error err : upsertResult.getErrors()) {
						errorMessage = 'Update erorr message: ' + err.getMessage() + ' Fields:' + err.getFields();
						Logger.error('Update erorr message: ' + err.getMessage() + ' Fields:' + err.getFields());
					}
					return errorMessage;
				}
			} return null;

		}

		catch (Exception ex) {
			return 'Update erorr message: ' + ex.getMessage();

		}
	}

	private static List<LoanSurchargeDiscount__c> getLoanSurchargeDiscount(List<UpdateLoanAssetsFlowController.LoadPackagesCalloutResult> results, String assetId) {
		LoanSurchargeDiscount__c[] loanSurchargeDiscount = [Select Id, ExternalId__c, SurchargeDiscountAmount__c, SurchargeDiscountId__c, ValidFrom__c, ValidTo__c FROM LoanSurchargeDiscount__c WHERE Asset__c = :assetId];
		List<LoanSurchargeDiscount__c> loanSurchargeDiscountToUpdate = new List<LoanSurchargeDiscount__c>();
		if (loanSurchargeDiscount.size() > 0) {
			for (LoanSurchargeDiscount__c lsd : loanSurchargeDiscount) {
				for (UpdateLoanAssetsFlowController.LoadPackagesCalloutResult result : results) {
					if (lsd.SurchargeDiscountId__c == result.packageId) {
						lsd.SurchargeDiscountId__c = result.packageId;
						lsd.ValidTo__c = result.validTo;
						lsd.ValidFrom__c = result.validFrom;
						if (result.fee != null) {
							result.fee = result.fee.replace(',', '.');
							lsd.SurchargeDiscountAmount__c = Decimal.valueOf(result.fee);
						} else {
							result.discount = result.discount.replace(',', '.');
							lsd.SurchargeDiscountAmount__c = Decimal.valueOf(result.discount);
						}
						loanSurchargeDiscountToUpdate.add(lsd);
						break;
					}

				}
			}
		} return loanSurchargeDiscountToUpdate;
	}
	private static Asset getAsset(UpdateLoanAssetsFlowController.LoanDetailInfoResult result, String assetId) {

		Decimal restObligAmount = Decimal.valueOf(result.restObligAmount.replace(',', '.'));
		String status;
		if (result.loanStateCode.length() == 1) {
			status = '1000' + result.loanStateCode;
		} else if (result.loanStateCode.length() == 2) {
			status = '100' + result.loanStateCode;
		}
		Asset asset = new Asset(Id = assetId);
		asset.CreditAmount__c = result.variableAmount;
		asset.PurposeOfUse__c = result.loanUsageCode;
		asset.PurposeOfUse2__c = result.loanUsage2Code;
		asset.RequestSignDate__c = result.signDate;
		asset.SecondDecissionDate__c = result.approvalDate2;
		asset.Status__c = status;
		asset.LastDrawdownReminder__c = result.lastDrawdownReminder;
		asset.AcquisitionMethod__c = result.aquisitionChannelCode;
		asset.ClosureMethod__c = result.establishmentTypeCode;
		asset.LastChangeDate__c = result.lastChangeDate;
		asset.ProductCloseDate__c = result.signDateOwner;
		asset.CreditCondition__c = result.creditConditions;
		asset.RemainingDraw__c = restObligAmount;

		if (result.requestedAmount != null) {
			result.requestedAmount = result.requestedAmount.replace(',', '.');
			asset.TotalRequiedAmount__c = Decimal.valueOf(result.requestedAmount);
		}
		asset.ActualSolver__c = result.loanCaseAdministrator;

		return asset;
	}

	private static List<LoanCaseDoc__c> getLoanCaseDoc(List<UpdateLoanAssetsFlowController.LoanDocumentsCalloutResult> results, String assetId) {

		List<LoanCaseDoc__c> loanCaseDocToUpdate = new List<LoanCaseDoc__c>();
		String newText;
		for (UpdateLoanAssetsFlowController.LoanDocumentsCalloutResult result : results) {
			if (result.text.substring(0, 1) == '-') {
				newText = result.text.substring(1);
			} else newText = result.text;
			LoanCaseDoc__c lcd = new LoanCaseDoc__c();
			lcd.Asset__c = assetId;
			lcd.Group__c = result.group_x;
			lcd.Phase__c = result.phase;
			lcd.Number__c = result.number_x;
			lcd.Status__c = result.status;
			lcd.Text__c = newText;
			lcd.ReceiveDate__c = result.incomingDate;
			lcd.DueDate__c = result.tillWhenDate;
			lcd.ExternalId__c = result.id;
			loanCaseDocToUpdate.add(lcd);
		}

		return loanCaseDocToUpdate;
	}
}