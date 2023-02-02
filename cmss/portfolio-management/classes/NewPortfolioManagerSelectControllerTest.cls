@IsTest
private class NewPortfolioManagerSelectControllerTest {
	private static Id rmAssistRoleId;
	private static Id otherRmAssistRoleId;
	private static Id rmManagerRoleId;
	private static Id otherRmManagerRoleId;
	private static Id ozRoleId;

	@IsTest
	static void testBehavior_regularUser() {
		insertRoles();
		User user = TestDataFactory.getCmssUser(new User(UserRoleId = ozRoleId));
		TestSelector selector = new TestSelector();
		selector.searchResults.add(
			(User) JSON.deserialize(
				'{' +
				'"Id" : "00300000000fake",' +
				'"Name" : "fake user",' +
				'"CommissionAccountNrAll__c" : "fake cpu"' +
				'}',
				User.class
			)
		);
		NewPortfolioManagerSelectController.selector = selector;
		System.runAs(user) {
			List<NewPortfolioManagerSelectController.SearchResult> results = NewPortfolioManagerSelectController.search(
				'term'
			);

			System.assertEquals(1, results.size());
			System.assertEquals('00300000000fake', results.get(0).id);
			System.assertEquals('fake user', results.get(0).name);
			System.assertEquals('fake cpu', results.get(0).cpu);

			System.assertEquals(3, selector.rolesIds.size());
			System.assert(selector.rolesIds.contains(ozRoleId));
			System.assert(selector.rolesIds.contains(rmManagerRoleId));
			System.assert(selector.rolesIds.contains(rmAssistRoleId));
			System.assertEquals('%term%', selector.value);
		}
	}

	@IsTest
	static void testBehavior_rmUser() {
		insertRoles();
		User user = TestDataFactory.getCmssUser(new User(UserRoleId = rmManagerRoleId));
		TestSelector selector = new TestSelector();
		selector.searchResults.add(
			(User) JSON.deserialize(
				'{' +
				'"Id" : "00300000000fake",' +
				'"Name" : "fake user",' +
				'"CommissionAccountNrAll__c" : "fake cpu"' +
				'}',
				User.class
			)
		);
		NewPortfolioManagerSelectController.selector = selector;
		System.runAs(user) {
			List<NewPortfolioManagerSelectController.SearchResult> results = NewPortfolioManagerSelectController.search(
				'term'
			);

			System.assertEquals(1, results.size());
			System.assertEquals('00300000000fake', results.get(0).id);
			System.assertEquals('fake user', results.get(0).name);
			System.assertEquals('fake cpu', results.get(0).cpu);

			//System.assertEquals(5, selector.rolesIds.size());
			System.assert(selector.rolesIds.contains(ozRoleId));
			System.assert(selector.rolesIds.contains(rmManagerRoleId));
			System.assert(selector.rolesIds.contains(rmAssistRoleId));
			System.assert(selector.rolesIds.contains(otherRmManagerRoleId));
			System.assert(selector.rolesIds.contains(otherRmAssistRoleId));
			System.assertEquals('%term%', selector.value);
		}
	}

	@IsTest
	static void testBehavior_noRoleUser() {
		insertRoles();
		User user = TestDataFactory.getCmssUser(new User());
		TestSelector selector = new TestSelector();
		NewPortfolioManagerSelectController.selector = selector;
		System.runAs(user) {
			List<NewPortfolioManagerSelectController.SearchResult> results = NewPortfolioManagerSelectController.search(
				'term'
			);
			System.assertEquals(0, results.size());
			System.assertEquals(1, selector.rolesIds.size());
			System.assert(selector.rolesIds.contains(null));
			System.assertEquals('%term%', selector.value);
		}
	}

	@IsTest
	static void testBehavior_hqUser() {
		insertRoles();
		User user = TestDataFactory.getCmssUser(new User());
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'PortfolioManagementAdministrator'];
		insert new PermissionSetAssignment(PermissionSetId = ps.Id, AssigneeId = user.Id);
		TestSelector selector = new TestSelector();
		selector.searchResults.add(
			(User) JSON.deserialize(
				'{' +
				'"Id" : "00300000000fake",' +
				'"Name" : "fake user",' +
				'"CommissionAccountNrAll__c" : "fake cpu"' +
				'}',
				User.class
			)
		);
		NewPortfolioManagerSelectController.selector = selector;

		System.runAs(user) {
			List<NewPortfolioManagerSelectController.SearchResult> results = NewPortfolioManagerSelectController.search(
				'term'
			);

			System.assertEquals(1, results.size());
			System.assertEquals('00300000000fake', results.get(0).id);
			System.assertEquals('fake user', results.get(0).name);
			System.assertEquals('fake cpu', results.get(0).cpu);

			System.assertEquals(null, selector.rolesIds);
			System.assertEquals('%term%', selector.value);
		}
	}

	@IsTest
	static void testBehavior_error() {
		insertRoles();
		User user = TestDataFactory.getCmssUser(new User());
		NewPortfolioManagerSelectController.selector = new ErrorThrowingSelector();
		System.runAs(user) {
			try {
				NewPortfolioManagerSelectController.search('term');
				System.assert(false, 'should have failed');
			} catch (AuraHandledException e) {
				// ok
			}
		}
	}

	@IsTest
	static void coverSelector() {
		NewPortfolioManagerSelectController.Selector selector = new NewPortfolioManagerSelectController.Selector();
		selector.searchUsers('');
		selector.searchUsersWithRole('', new Set<Id>());
	}

	private class TestSelector extends NewPortfolioManagerSelectController.Selector {
		public String value;
		public Set<Id> rolesIds;
		public List<User> searchResults = new List<User>();

		public override List<User> searchUsersWithRole(String value, Set<Id> rolesIds) {
			this.value = value;
			this.rolesIds = rolesIds;
			return searchResults;
		}

		public override List<User> searchUsers(String value) {
			this.value = value;
			return searchResults;
		}
	}

	public class ErrorThrowingSelector extends NewPortfolioManagerSelectController.Selector {
		public override List<User> searchUsersWithRole(String value, Set<Id> rolesIds) {
			String x = null;
			x.toLowerCase();
			return null;
		}
	}

	private static void insertRoles() {
		UserRole top = new UserRole(DeveloperName = 'TopRole', Name = 'TopRole');
		insert top;

		List<UserRole> lvlAssist = new List<UserRole>{
			new UserRole(DeveloperName = 'X110_RM_1_assist', Name = 'X110_RM_1_assist', ParentRoleId = top.Id),
			new UserRole(DeveloperName = 'X110_RM_2_assist', Name = 'X110_RM_2_assist', ParentRoleId = top.Id)
		};
		insert lvlAssist;
		rmAssistRoleId = lvlAssist.get(0).Id;
		otherRmAssistRoleId = lvlAssist.get(1).Id;

		List<UserRole> lvlManager = new List<UserRole>{
			new UserRole(DeveloperName = 'X110_RM_1_mng', Name = 'X110_RM_1_mng', ParentRoleId = lvlAssist.get(0).Id),
			new UserRole(DeveloperName = 'X110_RM_2_mng', Name = 'X110_RM_2_mng', ParentRoleId = lvlAssist.get(1).Id)
		};
		insert lvlManager;
		rmManagerRoleId = lvlManager.get(0).Id;
		otherRmManagerRoleId = lvlManager.get(1).Id;

		List<UserRole> lvlOz = new List<UserRole>{
			new UserRole(DeveloperName = 'some_role', Name = 'some_role', ParentRoleId = lvlManager.get(0).Id),
			new UserRole(
				DeveloperName = 'some_other_role',
				Name = 'some_other_role',
				ParentRoleId = lvlManager.get(1).Id
			)
		};
		insert lvlOz;
		ozRoleId = lvlOz.get(0).Id;
	}
}
