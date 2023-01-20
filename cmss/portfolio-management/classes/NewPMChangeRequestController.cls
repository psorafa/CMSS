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
				throw new ProcessingException(Label.Cannot_find_any_Regional_Manager_of_current_user);
			}
			for (User u : selector.selectRegionalManagerAndAssistant(rmRoleId)) {
				if (u.UserRole.DeveloperName.endsWithIgnoreCase('ASSIST')) {
					regionalManagerAssistantId = u.Id;
				}
				if (u.UserRole.DeveloperName.endsWithIgnoreCase('MNG')) {
					regionalManagerId = u.Id;
				}
			}
		}
	}

	private Boolean isUserInputValid() {
		if (!canCreateEmptyRequest) {
			if (userInput.ids == null || userInput.ids.isEmpty()) {
				errorMessage = Label.No_permission_to_create_empty_PM_requests;
				return false;
			}
			if (String.isEmpty(userInput.manager)) {
				errorMessage = Label.Please_fill_in_New_Portfolio_Manager;
				return false;
			}
			if (String.isEmpty(userInput.type)) {
				errorMessage = Label.Please_fill_in_Change_Type;
				return false;
			}
		}
		if (String.isEmpty(userInput.reason)) {
			errorMessage = Label.Please_fill_in_Change_Reason;
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
			if (!requestItems.isEmpty()) {
				submitForApproval(changeRequest);
			}
		} catch (DmlException e) {
			Database.rollback(savepoint);
			Logger.warn('Cannot save data.', e);
			throw new ProcessingException(Label.Cannot_save_data + ': ' + e.getMessage(), e);
		} catch (Exception e) {
			Database.rollback(savepoint);
			throw e;
		}
	}

	private void submitForApproval(Case record) {
		if (!Test.isRunningTest()) {
			Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
			request.setObjectId(record.Id);
			Approval.ProcessResult result = Approval.process(request);
			if (!result.isSuccess()) {
				Logger.warn('Cannot submit for approval', JSON.serialize(result));
				throw new ProcessingException(Label.Cannot_save_data + ': ' + result.getErrors().get(0).getMessage());
			}
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
	private virtual class Selector {
		public virtual List<User> selectRegionalManagerAndAssistant(Id rmRole) {
			return [SELECT Id, UserRole.DeveloperName FROM User WHERE UserRoleId = :rmRole OR UserRole.ParentRoleId = :rmRole];
		}
	}
}