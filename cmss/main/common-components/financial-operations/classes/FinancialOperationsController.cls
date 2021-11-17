public without sharing class FinancialOperationsController {
	public static FinancialOperationDataTypesService.GetFinancialOperationInfoResponseBodyType financialOperationsCallout(
		Long basicNumber,
		Long endNumber,
		//Long checkNumber, checkNumber is not  required
		Date dateTo,
		Date dateFrom
	) {
		try {
			CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
			FinancialOperationDataTypesService.GetFinancialOperationInfoRequestBodyType body = new FinancialOperationDataTypesService.GetFinancialOperationInfoRequestBodyType();
			body.contractFinancialOperationInfoRequest = new FinancialOperationDataTypesService.ContractFinancialOperationInfoRequestType();
			BasicTypesService.AccountNumberType contractIdNumber = new BasicTypesService.AccountNumberType();
			contractIdNumber.basicNumber = basicNumber;
			contractIdNumber.endNumber = endNumber;
			//contractIdNumber.checkNumber = checkNumber;  checkNumber is not required
			FinancialOperationDataTypesService.ContractFinancialOperationInfoRequestType info = new FinancialOperationDataTypesService.ContractFinancialOperationInfoRequestType();
			info.contractIdNumber = contractIdNumber;
			info.dateFrom = dateFrom;
			info.dateTo = dateTo;
			body.contractFinancialOperationInfoRequest = info;
			FinancialOperationService.FinancialOperationServicePort stub = new FinancialOperationService.FinancialOperationServicePort();

			return stub.getFinancialOperationInfo_Http(header, body);
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	@AuraEnabled(cacheable=true)
	public static String getData(Date dateTo, Date dateFrom, Id recordId) {
		String assetName = [SELECT Name FROM Asset WHERE Id = :recordId].Name;
		Long adjustedAssetName = Long.valueOf(assetName.substring(0, assetName.length() - 3));

		try {
			FinancialOperationDataTypesService.GetFinancialOperationInfoResponseBodyType stub = financialOperationsCallout(
				adjustedAssetName,
				1,
				dateTo,
				dateFrom
			);
			FinancialOperationDataTypesService.ContractFinancialOperationInfoType[] response = stub.contractFinancialOperationInfoList.contractFinancialOperationInfo;

			List<DataWrapper> data = new List<DataWrapper>();
			for (FinancialOperationDataTypesService.ContractFinancialOperationInfoType fc : response) {
				data.add(getDataWrapperRecord(fc));
			}
			return JSON.serialize(data);
		} catch (Exception e) {
			system.debug('Handled exception thrown ' + e);
			throw new AuraHandledException(e.getMessage());
		}
	}
	private static DataWrapper getDataWrapperRecord(
		FinancialOperationDataTypesService.ContractFinancialOperationInfoType fc
	) {
		DataWrapper dw = new DataWrapper();
		dw.valueDate = fc.valueDate;
		dw.bookingCode = fc.bookingCode;
		dw.senderReceiverName = fc.senderReceiverName;
		dw.senderReceiverAccountPrefix = fc.senderReceiverAccountPrefix;
		dw.senderReceiverAccountNumber = fc.senderReceiverAccountNumber;
		dw.senderReceiverBankIdNumber = fc.senderReceiverBankIdNumber;
		dw.amount = fc.amount;
		dw.variableSymbol = fc.variableSymbol;
		dw.constantSymbol = fc.constantSymbol;
		dw.specificSymbol = fc.specificSymbol;
		dw.avField = fc.avField;
		dw.bookingDate = fc.bookingDate;
		dw.IBAN = fc.IBAN;
		dw.transactionDateTime = fc.transactionDateTime;
		dw.transactionDescription = fc.transactionDescription;
		return dw;
	}
	public class DataWrapper {
		public Date valueDate;
		public Long bookingCode;
		public String senderReceiverName;
		public String senderReceiverAccountPrefix;
		public String senderReceiverAccountNumber;
		public String senderReceiverBankIdNumber;
		public String amount;
		public String variableSymbol;
		public String constantSymbol;
		public String specificSymbol;
		public String avField;
		public Date bookingDate;
		public String IBAN;
		public DateTime transactionDateTime;
		public String transactionDescription;
	}
}
