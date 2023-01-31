@IsTest
private class NewPMChangeRequestControllerTest {

	private static final String jsonDataComplete = '{' +
		'"manager" : "003000000000001",' +
		'"type" : "type1",' +
		'"reason" : "reason1",' +
		'"comments" : "comments1",' +
		'"ids" : [' +
		'	"001000000000001", "001000000000002", "001000000000003"' +
		']'+
		'}';
	private static final String jsonDataNoManager = '{' +
		'"manager" : null,' +
		'"type" : "type1",' +
		'"reason" : "reason1",' +
		'"comments" : "comments1",' +
		'"ids" : ["001000000000001", "001000000000002", "001000000000003"]'+
		'}';
	private static final String jsonDataNoChangeType = '{' +
		'"manager" : "003000000000001",' +
		'"type" : null,' +
		'"reason" : "reason1",' +
		'"comments" : "comments1",' +
		'"ids" : ["001000000000001", "001000000000002", "001000000000003"]'+
		'}';
	private static final String jsonDataNoReason = '{' +
		'"manager" : "003000000000001",' +
		'"type" : "type1",' +
		'"reason" : null,' +
		'"comments" : "comments1",' +
		'"ids" : ["001000000000001", "001000000000002", "001000000000003"]'+
		'}';
	private static final String jsonDataEmpty = '{' +
		'"manager" : null,' +
		'"type" : "type1",' +
		'"reason" : "reason1",' +
		'"comments" : "comments1",' +
		'"ids" : []'+
		'}';
	private static final String jsonDataNoIds = '{' +
		'"manager" : "003000000000001",' +
		'"type" : "type1",' +
		'"reason" : "reason1",' +
		'"comments" : "comments1",' +
		'"ids" : []'+
		'}';

	private static Id rmAssistRoleId;
	private static Id rmManagerRoleId;
	private static Id ozRoleId;
	private static final Id pmChangeRTId = Case.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('PortfolioManagementChangeRequest').getRecordTypeId();

	@IsTest
	static void testBehavior_regularUser() {
		insertRoles();
		User user = TestDataFactory.getCmssUser(new User(UserRoleId = ozRoleId));
		TestSelector selector = new TestSelector();
		selector.assistantRoleId = rmAssistRoleId;
		NewPMChangeRequestController.selector = selector;
		DmlUtilMock dml = new DmlUtilMock();
		dml.idsToAssign.add('500000000000001');
		dml.idsToAssign.addAll(new List<Id>{ null, null, null });
		NewPMChangeRequestController.dml = dml;
		System.runAs(user) {
			NewPMChangeRequestController.SaveResult result = NewPMChangeRequestController.saveData(jsonDataComplete);
			System.debug(result);
			System.assertEquals(true, result.isSuccess);
			System.assertEquals('500000000000001', result.caseId);

			System.assertEquals('insert', dml.operations.get(0).type);
			Case inserted = (Case) dml.operations.get(0).singleRecord;
			System.assert(inserted != null);
			System.assertEquals('003000000000001', inserted.NewPortfolioManager__c);
			System.assertEquals('type1', inserted.PortfolioManagementType__c);
			System.assertEquals('reason1', inserted.ChangeReason__c);
			System.assertEquals('comments1', inserted.Comments);
			System.assertEquals(pmChangeRTId, inserted.RecordTypeId);
			System.assertEquals('21', inserted.Status);
			System.assertEquals('0030000000000rm', inserted.RegionalManager__c);
			System.assertEquals('003000000assist', inserted.RegionalManagerAssistant__c);
			System.assertEquals('4', inserted.Type);

			System.assertEquals('insert', dml.operations.get(1).type);
			for (Integer i = 0; i < 3; i++) {
				PortfolioManagementRequest__c pmc = (PortfolioManagementRequest__c) dml.operations.get(1).listData.get(i);
				System.assertEquals('500000000000001', pmc.Case__c);
				System.assertEquals('00100000000000' + (i+1), pmc.Account__c);
			}
		}
	}

	@IsTest
	static void testBehavior_regularUser_errors() {
		insertRoles();
		User user = TestDataFactory.getCmssUser(new User(UserRoleId = ozRoleId));
		TestSelector selector = new TestSelector();
		selector.assistantRoleId = rmAssistRoleId;
		NewPMChangeRequestController.selector = selector;
		DmlUtilMock dml = new DmlUtilMock();
		dml.idsToAssign.add('500000000000001');
		dml.idsToAssign.addAll(new List<Id>{ null, null, null });
		NewPMChangeRequestController.dml = dml;
		System.runAs(user) {
			NewPMChangeRequestController.SaveResult result = NewPMChangeRequestController.saveData(jsonDataNoManager);
			System.assertEquals(false, result.isSuccess);
			System.assertEquals(Label.Please_fill_in_New_Portfolio_Manager, result.error);

			result = NewPMChangeRequestController.saveData(jsonDataNoIds);
			System.assertEquals(false, result.isSuccess);
			System.assertEquals(Label.No_permission_to_create_empty_PM_requests, result.error);

			result = NewPMChangeRequestController.saveData(jsonDataNoChangeType);
			System.assertEquals(false, result.isSuccess);
			System.assertEquals(Label.Please_fill_in_Change_Type, result.error);

			result = NewPMChangeRequestController.saveData(jsonDataNoReason);
			System.assertEquals(false, result.isSuccess);
			System.assertEquals(Label.Please_fill_in_Change_Reason, result.error);
		}
	}

	@IsTest
	static void testBehavior_dmlError() {
		insertRoles();
		User user = TestDataFactory.getCmssUser(new User(UserRoleId = ozRoleId));
		TestSelector selector = new TestSelector();
		selector.assistantRoleId = rmAssistRoleId;
		NewPMChangeRequestController.selector = selector;
		System.runAs(user) {
			NewPMChangeRequestController.SaveResult result = NewPMChangeRequestController.saveData(jsonDataComplete);
			System.assertEquals(false, result.isSuccess);
			System.debug(result.error);
			System.assert(
				result.error.startsWith('Cannot save data: Insert failed. First exception on row 0; first error:'),
				result.error
			);
		}
	}

	@IsTest
	static void testBehavior_otherError() {
		insertRoles();
		User user = TestDataFactory.getCmssUser(new User(UserRoleId = ozRoleId));
		TestSelector selector = new TestSelector();
		selector.assistantRoleId = rmAssistRoleId;
		NewPMChangeRequestController.selector = selector;
		DmlUtilMock dml = new DmlUtilMock();
		dml.idsToAssign.add('001000notCaseID');
		NewPMChangeRequestController.dml = dml;
		System.runAs(user) {
			try {
				NewPMChangeRequestController.saveData(jsonDataComplete);
				System.assert(false, 'should have failed');
			} catch (AuraHandledException e) {
				// ok
			}
		}
	}

	@IsTest
	static void testBehavior_userWithoutRM() {
		insertRoles();
		User user = TestDataFactory.getCmssUser(new User());
		System.runAs(user) {
			NewPMChangeRequestController.SaveResult result = NewPMChangeRequestController.saveData(jsonDataComplete);
			System.assertEquals(false, result.isSuccess);
			System.assertEquals(Label.Cannot_find_any_Regional_Manager_of_current_user, result.error);
		}
	}

	@IsTest
	static void testBehavior_userIsRM() {
		insertRoles();
		User user = TestDataFactory.getCmssUser(new User(UserRoleId = rmAssistRoleId));
		TestSelector selector = new TestSelector();
		selector.assistantRoleId = rmAssistRoleId;
		NewPMChangeRequestController.selector = selector;
		DmlUtilMock dml = new DmlUtilMock();
		dml.idsToAssign.add('500000000000001');
		dml.idsToAssign.addAll(new List<Id>{ null, null, null });
		NewPMChangeRequestController.dml = dml;
		System.runAs(user) {
			NewPMChangeRequestController.SaveResult result = NewPMChangeRequestController.saveData(jsonDataComplete);
			System.debug(result);
			System.assertEquals(true, result.isSuccess, '' + result.error);
			System.assertEquals('500000000000001', result.caseId);

			System.assertEquals('insert', dml.operations.get(0).type);
			Case inserted = (Case) dml.operations.get(0).singleRecord;
			System.assert(inserted != null);
			System.assertEquals('003000000000001', inserted.NewPortfolioManager__c);
			System.assertEquals('type1', inserted.PortfolioManagementType__c);
			System.assertEquals('reason1', inserted.ChangeReason__c);
			System.assertEquals('comments1', inserted.Comments);
			System.assertEquals(pmChangeRTId, inserted.RecordTypeId);
			System.assertEquals('21', inserted.Status);
			System.assertEquals('0030000000000rm', inserted.RegionalManager__c);
			System.assertEquals('003000000assist', inserted.RegionalManagerAssistant__c);
			System.assertEquals('4', inserted.Type);

			System.assertEquals('insert', dml.operations.get(1).type);
			for (Integer i = 0; i < 3; i++) {
				PortfolioManagementRequest__c pmc = (PortfolioManagementRequest__c) dml.operations.get(1).listData.get(i);
				System.assertEquals('500000000000001', pmc.Case__c);
				System.assertEquals('00100000000000' + (i+1), pmc.Account__c);
			}
		}
	}

	@IsTest
	static void testBehavior_HqUser() {
		insertRoles();
		User user = TestDataFactory.getCmssUser(new User());
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'PortfolioManagementAdministrator'];
		insert new PermissionSetAssignment(
			PermissionSetId = ps.Id,
			AssigneeId = user.Id
		);
		TestSelector selector = new TestSelector();
		selector.assistantRoleId = rmAssistRoleId;
		NewPMChangeRequestController.selector = selector;
		DmlUtilMock dml = new DmlUtilMock();
		dml.idsToAssign.add('500000000000001');
		dml.idsToAssign.addAll(new List<Id>{ null, null, null });
		NewPMChangeRequestController.dml = dml;
		System.runAs(user) {
			NewPMChangeRequestController.SaveResult result = NewPMChangeRequestController.saveData(jsonDataEmpty);
			System.debug(result);
			System.assertEquals(true, result.isSuccess);
			System.assertEquals('500000000000001', result.caseId);

			System.assertEquals('insert', dml.operations.get(0).type);
			Case inserted = (Case) dml.operations.get(0).singleRecord;
			System.assert(inserted != null);
			System.assertEquals(null, inserted.NewPortfolioManager__c);
			System.assertEquals('type1', inserted.PortfolioManagementType__c);
			System.assertEquals('reason1', inserted.ChangeReason__c);
			System.assertEquals('comments1', inserted.Comments);
			System.assertEquals(pmChangeRTId, inserted.RecordTypeId);
			System.assertEquals('21', inserted.Status);
			System.assertEquals(user.Id, inserted.RegionalManager__c);
			System.assertEquals(null, inserted.RegionalManagerAssistant__c);
			System.assertEquals('4', inserted.Type);
		}
	}

	@IsTest
	static void coverSelector() {
		new NewPMChangeRequestController.Selector().selectRegionalManagerAndAssistant(null);
		new NewPMChangeRequestController.Selector().selectRegionalManagerAndAssistant('00E000000000001');
	}

	private static void insertRoles() {
		UserRole top = new UserRole(
			DeveloperName = 'TopRole',
			Name = 'TopRole'
		);
		insert top;

		List<UserRole> lvlAssist = new List<UserRole>{
			new UserRole(
				DeveloperName = 'X100_RM_1_assist',
				Name = 'X100_RM_1_assist',
				ParentRoleId = top.Id
			),
			new UserRole(
				DeveloperName = 'X100_RM_2_assist',
				Name = 'X100_RM_2_assist',
				ParentRoleId = top.Id
			)
		};
		insert lvlAssist;
		rmAssistRoleId = lvlAssist.get(0).Id;

		List<UserRole> lvlManager = new List<UserRole>{
			new UserRole(
				DeveloperName = 'X100_RM_1_mng',
				Name = 'X100_RM_1_mng',
				ParentRoleId = lvlAssist.get(0).Id
			),
			new UserRole(
				DeveloperName = 'X100_RM_2_mng',
				Name = 'X100_RM_2_mng',
				ParentRoleId = lvlAssist.get(1).Id
			)
		};
		insert lvlManager;
		rmManagerRoleId = lvlManager.get(0).Id;

		List<UserRole> lvlOz = new List<UserRole>{
			new UserRole(
				DeveloperName = 'some_role',
				Name = 'some_role',
				ParentRoleId = lvlManager.get(0).Id
			),
			new UserRole(
				DeveloperName = 'some_other_role',
				Name = 'some_other_role',
				ParentRoleId = lvlManager.get(1).Id
			)
		};
		insert lvlOz;
		ozRoleId = lvlOz.get(0).Id;
	}

	public class TestSelector extends NewPMChangeRequestController.Selector {

		public Id assistantRoleId;

		public override List<User> selectRegionalManagerAndAssistant(Id rmRole) {
			System.assertEquals(assistantRoleId, rmRole);
			String usersToReturn = '[' +
				'{' +
				'"Id" : "003000000assist",' +
				'"UserRole" : {' +
				'	"Id" : "' + rmRole + '",' +
				'	"DeveloperName" : "X100_RM_1_assist"' +
				'	}' +
				'},' +
				'{' +
				'"Id" : "0030000000000rm",' +
				'"UserRole" : {' +
				'	"ParentRoleId" : "' + rmRole + '",' +
				'	"DeveloperName" : "X100_RM_1_mng"' +
				'	}' +
				'}' +
				']';
			return (List<User>)JSON.deserialize(usersToReturn, List<User>.class);
		}
	}
}