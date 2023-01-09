public with sharing class NewPMChangeRequestController {

	@TestVisible
	private static Selector selector = new Selector();
	@TestVisible
	private static DmlUtil dml = new DmlUtil();

	private final Data userInput;
	private final Boolean canCreateEmptyRequest = FeatureManagement.checkPermission('CreateEmptyPortfolioManagementCases');
	private final Id recordType = Case.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('PortfolioManagementChangeRequest').getRecordTypeId();
	private String errorMessage;
	private Id regionalManagerId;
	private Id regionalManagerAssistantId;
	private Id createdCaseId;

	@AuraEnabled
	public static SaveResult saveData(String jsonData) {
		try {
			NewPMChangeRequestController controller = new NewPMChangeRequestController(jsonData);
			controller.process();
			if (controller.hasError()) {
				return new SaveResult(controller.getErrorMessage());
			}
			return new SaveResult(controller.getCreatedCaseId());
		} catch (ProcessingException e) {
			Logger.warn('Cannot process data', e);
			return new SaveResult(e.getMessage());
		} catch (Exception e) {
			Logger.error('Unexpected error occurred', e);
			throw new AuraHandledException('Unexpected error occurred: ' + e.getMessage());
		} finally {
			Logger.saveLogs();
		}
	}

	private NewPMChangeRequestController(String jsonData) {
		userInput = (Data) JSON.deserialize(jsonData, Data.class);
		prepareManagerAndAssistantIds();
	}

	private Boolean hasError() {
		return String.isNotBlank(errorMessage);
	}
	private String getErrorMessage() {
		return errorMessage;
	}
	private Id getCreatedCaseId() {
		return createdCaseId;
	}
	private void process() {
		if (isUserInputValid()) {
			Case changeRequest = new Case(
				NewPortfolioManager__c = userInput.manager,
				PortfolioManagementType__c = userInput.type,
				ChangeReason__c = userInput.reason,
				Comments = userInput.comments,
				RecordTypeId = recordType,
				Status = '21',
				RegionalManager__c = regionalManagerId,
				RegionalManagerAssistant__c = regionalManagerAssistantId,
				Type = '4'
			);
			List<PortfolioManagementRequest__c> requestItems = new List<PortfolioManagementRequest__c>();
			if (userInput.ids != null) {
				for (Id accountId : userInput.ids) {
					requestItems.add(new PortfolioManagementRequest__c(
						Account__c = accountId
					));
				}
			}
			insertData(changeRequest, requestItems);
		}
	}

	private void prepareManagerAndAssistantIds() {
		if (canCreateEmptyRequest) {
			// if user has permission to create empty requests, he will act as a RM of himself
			regionalManagerId = UserInfo.getUserId();
		} else {
			HierarchyUtil hierarchyUtil = new HierarchyUtil();
			Id rmRoleId = hierarchyUtil.getRegionalManagerOrAssistantRoleOf(UserInfo.getUserRoleId());
			if (rmRoleId == null) {
				throw new ProcessingException('[LBL] Cannot find any Regional Manager of current user.');
			}
			for (User u : selector.selectRegionalManagerAndAssistant(rmRoleId)) {
				if (u.UserRole.DeveloperName.endsWith('ASSIST')) {
					regionalManagerAssistantId = u.Id;
				} else {
					regionalManagerId = u.Id;
				}
			}
		}
	}

	private Boolean isUserInputValid() {
		if (!canCreateEmptyRequest) {
			if (userInput.ids == null || userInput.ids.isEmpty()) {
				errorMessage = '[LBL] You don\'t have permission to create empty Portfolio Management Change Requests.';
				return false;
			}
			if (String.isEmpty(userInput.manager)) {
				errorMessage = '[LBL] Please fill in New Portfolio Manager';
				return false;
			}
			if (String.isEmpty(userInput.type)) {
				errorMessage = '[LBL] Please fill in Change Type';
				return false;
			}
		}
		if (String.isEmpty(userInput.reason)) {
			errorMessage = '[LBL] Please fill in Change Reason.';
			return false;
		}
		return true;
	}

	private void insertData(Case changeRequest, List<PortfolioManagementRequest__c> requestItems) {
		Savepoint savepoint = Database.setSavepoint();
		try {
			dml.insertData(changeRequest);
			createdCaseId = changeRequest.Id;
			for (PortfolioManagementRequest__c item : requestItems) {
				item.Case__c = changeRequest.Id;
			}
			dml.insertData(requestItems);
		} catch (DmlException e) {
			Database.rollback(savepoint);
			Logger.warn('Cannot save data.', e);
			throw new ProcessingException('[LBL] Cannot save data: ' + e.getMessage(), e);
		} catch (Exception e) {
			Database.rollback(savepoint);
			throw e;
		}
	}

	public class ProcessingException extends Exception {}

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
		@AuraEnabled public Id caseId;

		public SaveResult(Id caseId) {
			isSuccess = true;
			this.caseId = caseId;
		}
		public SaveResult(String error) {
			isSuccess = false;
			this.error = error;
		}
	}

	@TestVisible
	private class Selector {
		public List<User> selectRegionalManagerAndAssistant(Id rmRole) {
			return [SELECT Id, UserRole.DeveloperName FROM User WHERE UserRoleId = :rmRole OR UserRole.ParentRoleId = :rmRole];
		}
	}
}