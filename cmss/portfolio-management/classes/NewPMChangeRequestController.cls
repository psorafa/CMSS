public with sharing class NewPMChangeRequestController {

	private Data userInput;
	private Boolean canCreateEmptyRequest = FeatureManagement.checkPermission('CreateEmptyPortfolioManagementCases');
	private String validationError;

	@AuraEnabled
	public static SaveResult saveData(String jsonData) {
		try {
			NewPMChangeRequestController controller = new NewPMChangeRequestController(jsonData);
			controller.process();
			if (controller.hasError()) {
				return new SaveResult(controller.getErrorMessage());
			}
			return new SaveResult();
		} catch (Exception e) {
			Logger.error('Unexpected error occurred', e);
			throw new AuraHandledException('Unexpected error occurred: ' + e.getMessage());
		} finally {
			Logger.saveLogs();
		}
	}

	private NewPMChangeRequestController(String jsonData) {
		userInput = (Data) JSON.deserialize(jsonData, Data.class);
	}

	private Boolean hasError() {
		return String.isNotBlank(validationError);
	}
	private String getErrorMessage() {
		return validationError;
	}
	private void process() {
		// todo samotna logika:
		// validace
		if (isUserInputValid()) {
			// doplneni ostatnich pole
			// vlozeni dat
		}
	}
	private Boolean isUserInputValid() {
		if (!canCreateEmptyRequest) {
			if (userInput.ids == null || userInput.ids.isEmpty()) {
				validationError = '[LBL] You don\'t have permission to create empty Portfolio Management Change Requests.';
				return false;
			}
			if (String.isEmpty(userInput.manager)) {
				validationError = '[LBL] Please fill in New Portfolio Manager';
				return false;
			}
			// todo: zkontrolovat, ze manager je validni - bude jina classa
			if (String.isEmpty(userInput.type)) {
				validationError = '[LBL] Please fill in Change Type';
				return false;
			}
		}
		if (String.isEmpty(userInput.reason)) {
			validationError = '[LBL] Please fill in Change Reason.';
			return false;
		}
		return true;
	}

	public class Data {
		@AuraEnabled public String manager;
		@AuraEnabled public String type;
		@AuraEnabled public String reason;
		@AuraEnabled public String comments;
		@AuraEnabled public List<Id> ids;
	}

	public class SaveResult {
		@AuraEnabled public Boolean isSuccess;
		@AuraEnabled public String error;

		public SaveResult() {
			isSuccess = true;
		}
		public SaveResult(String error) {
			isSuccess = false;
			this.error = error;
		}
	}
}