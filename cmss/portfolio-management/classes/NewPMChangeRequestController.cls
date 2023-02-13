public with sharing class NewPMChangeRequestController {

	@TestVisible
	private static Selector selector = new Selector();
	@TestVisible
	private static DmlUtil dml = new DmlUtil();

	private final Data userInput;
	private final Boolean canCreateEmptyRequest = FeatureManagement.checkPermission('CreateEmptyPortfolioManagementCases');
	private final Id recordType = Case.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('PortfolioManagementChangeRequest').getRecordTypeId();
	private Id regionalManagerId;
	private Id regionalManagerAssistantId;
	private Id createdCaseId;

	@AuraEnabled
	public static SaveResult createCase(String jsonData) {
		try {
			NewPMChangeRequestController controller = new NewPMChangeRequestController(jsonData);
			controller.insertCase();
			return new SaveResult(controller.getCreatedCaseId());
		} catch (ProcessingException e) {
			Logger.warn('Cannot process data', e);
			throw getAuraHandledException(e.getMessage());
		} catch (Exception e) {
			Logger.error('Unexpected error occurred', e);
			throw getAuraHandledException('Unexpected error occurred: ' + e.getMessage());
		} finally {
			Logger.saveLogs();
		}
	}

	@AuraEnabled
	public static SaveResult saveRequests(String jsonData) {
		try {
			NewPMChangeRequestController controller = new NewPMChangeRequestController(jsonData);
			controller.insertRequests();
			return new SaveResult();
		} catch (ProcessingException e) {
			Logger.warn('Cannot process data', e);
			throw getAuraHandledException(e.getMessage());
		} catch (Exception e) {
			Logger.error('Unexpected error occurred', e);
			throw getAuraHandledException('Unexpected error occurred: ' + e.getMessage());
		} finally {
			Logger.saveLogs();
		}
	}

	@AuraEnabled
	public static SaveResult finalize(String jsonData) {
		try {
			NewPMChangeRequestController controller = new NewPMChangeRequestController(jsonData);
			controller.finalizeCase();
			return new SaveResult();
		} catch (ProcessingException e) {
			Logger.warn('Cannot process data', e);
			throw getAuraHandledException(e.getMessage());
		} catch (Exception e) {
			Logger.error('Unexpected error occurred', e);
			throw getAuraHandledException('Unexpected error occurred: ' + e.getMessage());
		} finally {
			Logger.saveLogs();
		}
	}

	private NewPMChangeRequestController(String jsonData) {
		userInput = (Data) JSON.deserialize(jsonData, Data.class);
		prepareManagerAndAssistantIds();
	}

	private Id getCreatedCaseId() {
		return createdCaseId;
	}

	private void insertCase() {
		validateUserInput();
		Case changeRequest = new Case(
			NewPortfolioManager__c = userInput.manager,
			PortfolioManagementType__c = userInput.type,
			ChangeReason__c = userInput.reason,
			Comments = userInput.comments,
			RecordTypeId = recordType,
			Status = '25',
			RegionalManager__c = regionalManagerId,
			RegionalManagerAssistant__c = regionalManagerAssistantId,
			Type = '4'
		);
		try {
			dml.insertData(changeRequest);
			createdCaseId = changeRequest.Id;
		} catch (DmlException e) {
			Logger.warn('Cannot save case.', e);
			throw new ProcessingException(Label.Cannot_save_data + ': ' + e.getMessage(), e);
		}
	}

	private void insertRequests() {
		List<PortfolioManagementRequest__c> requestItems = new List<PortfolioManagementRequest__c>();
		if (userInput.ids != null) {
			for (Id accountId : userInput.ids) {
				requestItems.add(new PortfolioManagementRequest__c(
					Account__c = accountId,
					PortfolioManager__c = userInput.manager,
					PortfolioManagementType__c = userInput.type,
					Case__c = userInput.caseId
				));
			}
		}
		try {
			dml.insertData(requestItems);
		} catch (DmlException e) {
			Logger.error('Cannot save requests.', e);
			throw new ProcessingException(Label.Cannot_save_data + ': ' + e.getMessage(), e);
		}
	}

	private void finalizeCase() {
		Case changeRequest = new Case(
			Id = userInput.caseId,
			Status = '21',
			ValidationsBypass__c = 1
		);
		Savepoint savepoint = Database.setSavepoint();
		try {
			dml.updateData(changeRequest);
			if (userInput.isEmptyCase != true) {
				submitForApproval(changeRequest);
			}
		} catch (DmlException e) {
			Database.rollback(savepoint);
			Logger.error('Cannot finalize case.', e);
			throw new ProcessingException(Label.Cannot_save_data + ': ' + e.getMessage(), e);
		} catch (Exception e) {
			Database.rollback(savepoint);
			Logger.error('Cannot finalize case.', e);
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

	private void validateUserInput() {
		if (!canCreateEmptyRequest) {
			if (userInput.ids == null || userInput.ids.isEmpty()) {
				throw new ProcessingException(Label.No_permission_to_create_empty_PM_requests);
			}
			if (String.isEmpty(userInput.manager)) {
				throw new ProcessingException(Label.Please_fill_in_New_Portfolio_Manager);
			}
			if (String.isEmpty(userInput.type)) {
				throw new ProcessingException(Label.Please_fill_in_Change_Type);
			}
			if (userInput.type != 'A') {
				throw new ProcessingException(Label.Only_Change_Type_of_A_allowed);
			}
		}
		if (String.isEmpty(userInput.reason)) {
			throw new ProcessingException(Label.Please_fill_in_Change_Reason);
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

	private static AuraHandledException getAuraHandledException(String message) {
		AuraHandledException ex = new AuraHandledException(message);
		ex.setMessage(message);
		return ex;
	}

	public class ProcessingException extends Exception {}

	public class Data {
		@AuraEnabled public String manager;
		@AuraEnabled public String type;
		@AuraEnabled public String reason;
		@AuraEnabled public String comments;
		@AuraEnabled public String caseId;
		@AuraEnabled public List<Id> ids;
		@AuraEnabled public Boolean isEmptyCase;
	}

	public class SaveResult {
		@AuraEnabled public Id caseId;

		public SaveResult() {
		}
		public SaveResult(Id caseId) {
			this.caseId = caseId;
		}
	}

	@TestVisible
	private virtual class Selector {
		public virtual List<User> selectRegionalManagerAndAssistant(Id rmRole) {
			if (rmRole != null) {
				return [
					SELECT Id, UserRole.DeveloperName
					FROM User
					WHERE (UserRoleId = :rmRole OR UserRole.ParentRoleId = :rmRole) AND IsActive = TRUE
				];
			}
			return null;
		}
	}
}