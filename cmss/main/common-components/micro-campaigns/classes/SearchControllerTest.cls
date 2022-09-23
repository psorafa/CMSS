@IsTest
private class SearchControllerTest {
	@IsTest
	static void testBehavior() {
		SearchController.search('User', new List<String>{'Name', 'Email'}, 'test');
	}

	@IsTest
	static void testSearchWithSubordinates() {
		UserRole role1 = new UserRole(DeveloperName = 'High', Name = 'High Role', ParentRoleId = null);
		insert role1;
		UserRole role2 = new UserRole(DeveloperName = 'Medium', Name = 'Medium Role', ParentRoleId = role1.Id);
		insert role2;
		UserRole role3 = new UserRole(DeveloperName = 'Low', Name = 'Low Role', ParentRoleId = role2.Id);
		insert role3;

		List<User> usersInHierarchyLow = new List<User>();
		List<User> usersInHierarchyMedium = new List<User>();
		List<User> usersInHierarchyHigh = new List<User>();
		Id profileId = [SELECT Id, Name FROM Profile WHERE Name = 'CMSS User'].Id;

		for (Integer i = 0; i < 10; i++) {
			usersInHierarchyLow.add(
				TestDataFactory.getUser(
					new User(UserRoleId = role3.Id, FirstName = 'Karel' + i, LastName = 'Low', ProfileId = profileId)
				)
			);
		}
		for (Integer i = 0; i < 10; i++) {
			usersInHierarchyMedium.add(
				TestDataFactory.getUser(
					new User(UserRoleId = role2.Id, FirstName = 'Karel' + i, LastName = 'Medium', ProfileId = profileId)
				)
			);
		}
		for (Integer i = 0; i < 10; i++) {
			usersInHierarchyHigh.add(
				TestDataFactory.getUser(
					new User(UserRoleId = role1.Id, FirstName = 'Karel' + i, LastName = 'High', ProfileId = profileId)
				)
			);
		}
		List<User> usersInHierarchy = new List<User>();
		usersInHierarchy.addAll(usersInHierarchyLow);
		usersInHierarchy.addAll(usersInHierarchyMedium);
		usersInHierarchy.addAll(usersInHierarchyHigh);
		insert usersInHierarchy;

		List<User> subordinates1;
		List<User> subordinates2;
		List<User> subordinates3;
		List<User> nonSubordinates3;
		List<User> subordinates4;

		Test.startTest();
		List<Id> fixedSearchResults = new List<Id>();
		for (User u : usersInHierarchy) {
			if (u.FirstName.contains('1')) {
				fixedSearchResults.add(u.Id);
			}
		}
		Test.setFixedSearchResults(fixedSearchResults);
		System.runAs(usersInHierarchyHigh[0]) {
			subordinates1 = SearchController.search('User', new List<String>{'Name', 'Email'}, '1', '', true);
		}
		System.runAs(usersInHierarchyLow[0]) {
			subordinates2 = SearchController.search('User', new List<String>{'Name', 'Email'}, '1', '', true);
		}
		for (User u : usersInHierarchy) {
			if (u.FirstName.startsWith('Karel')) {
				fixedSearchResults.add(u.Id);
			}
		}
		Test.setFixedSearchResults(fixedSearchResults);
		System.runAs(usersInHierarchyLow[0]) {
			subordinates3 = SearchController.search('User', new List<String>{'Name', 'Email'}, 'Karel', '', true);
			nonSubordinates3 = SearchController.search('User', new List<String>{'Name', 'Email'}, 'Karel', '', false);
		}
		System.runAs(usersInHierarchyMedium[0]) {
			subordinates4 = SearchController.search('User', new List<String>{'Name', 'Email'}, 'Karel', '', true);
		}
		Test.stopTest();
		System.assertEquals(2, subordinates1.size());
		System.assertEquals(0, subordinates2.size());
		System.assertEquals(0, subordinates3.size());
		System.assertEquals(10, nonSubordinates3.size());
		System.assertEquals(0, subordinates4.size());
	}
}
