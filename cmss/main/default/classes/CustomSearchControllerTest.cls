@IsTest
private class CustomSearchControllerTest {
	@TestSetup
	static void beforeTest() {
		Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
		User user1 = createUser(null, 'user1', profile.Id);
		insert user1;
		User user2 = createUser(user1.Id, 'user2', profile.Id);
		insert user2;
		User user3 = createUser(user1.Id, 'user3', profile.Id);
		insert user3;
		User user4 = createUser(user2.Id, 'user4', profile.Id);
		insert user4;

		List<CustomSearchFilter__c> csfList = new List<CustomSearchFilter__c>();
		CustomSearchFilter__c csf = new CustomSearchFilter__c(
			FieldApiName__c = 'Name',
			RecordTypeId = RecordTypeUtils.getRecordTypeIdByDeveloperName('Text', 'CustomSearchFilter__c'),
			RelatedObject__c = 'Account',
			ProductType__c = 'PersonAccount',
			Filter__c = 'contains'
		);
		csfList.add(csf);
		CustomSearchFilter__c csfPortfolio = new CustomSearchFilter__c(
			FieldApiName__c = 'Case__r.Account.PortfolioMngmtC__r.CommissionAccountBase__c',
			RecordTypeId = RecordTypeUtils.getRecordTypeIdByDeveloperName('Text', 'CustomSearchFilter__c'),
			RelatedObject__c = 'PortfolioManagementRequest__c',
			ProductType__c = 'PortfolioManagementRequest__c',
			Filter__c = 'contains'
		);
		csfList.add(csfPortfolio);
		insert csfList;
	}

	@IsTest
	static void loadUserHierarchyTreeAsCurrentUserTest() {
		User user1 = [SELECT Id FROM User WHERE LastName = 'user1'];
		System.runAs(user1) {
			Test.startTest();
			List<UserHierarchyTreeDto> result = CustomSearchController.loadUserHierarchyTree(null);
			Test.stopTest();

			System.assertEquals(UserInfo.getUserId(), result.get(0).userId);
			System.assertEquals(3, result.get(0).children.size());
		}
	}

	@IsTest
	static void loadUserHierarchyTreeTest() {
		User user1 = [SELECT Id FROM User WHERE LastName = 'user1'];
		Test.startTest();
		List<UserHierarchyTreeDto> result = CustomSearchController.loadUserHierarchyTree(user1.Id);
		Test.stopTest();

		System.assertEquals(user1.Id, result.get(0).userId);
		System.assertEquals(3, result.get(0).children.size());
	}

	@IsTest
	static void getCustomFilterTest() {
		Test.startTest();
		List<CustomFilterItemDto> result = CustomSearchController.getCustomFilterMap('Account', 'PersonAccount');
		Test.stopTest();

		System.assertEquals(1, result.size());
	}

	@IsTest
	static void getCustomFilterGetPicklistOptionsTest() {
		CustomFilterService cfs = new CustomFilterService(
			'PortfolioManagementRequest__c',
			'PortfolioManagementRequest__c'
		);
		Test.startTest();
		List<SelectOption> result = cfs.getPicklistOptions('Case__r.ChangeReason__c', 'PortfolioManagementRequest__c');
		Test.stopTest();

		System.assert(result.size() > 0);
	}

	private static User createUser(Id managerId, String roleName, Id profileId) {
		User user = new User();
		user.FirstName = 'firstName ' + roleName;
		user.LastName = roleName;
		user.Email = 'email_' + roleName + '@email.com';
		user.ManagerId = managerId;
		user.Username = 'email_' + roleName + '@email.com';
		user.Alias = roleName;
		user.ProfileId = profileId;
		user.TimeZoneSidKey = 'GMT';
		user.LocaleSidKey = 'en_US';
		user.EmailEncodingKey = 'UTF-8';
		user.LanguageLocaleKey = 'en_US';
		return user;
	}
}
