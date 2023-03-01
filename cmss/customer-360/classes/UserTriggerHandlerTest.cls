@IsTest(isParallel=false)
private class UserTriggerHandlerTest {
	@IsTest
	static void contactInfoUpdatedTest() {
		UserRole userRole = new UserRole(Name = 'TestRole');
		insert userRole;
		Profile adminProfile = [SELECT id, Name FROM Profile WHERE name = 'System Administrator'].get(0);
		//UserRole userRole = [SELECT Id FROM UserRole WHERE Name = 'TestRole'];

		User runningUser = TestDataFactory.getUser(
			new User(
				profileId = adminProfile.id,
				UserRoleId = userRole.Id,
				LastName = 'Jackson',
				Username = 'samuelel@jackson.com'
			)
		);
		insert runningUser;

		User communityUser;
		Contact portalContact;
		System.runAs(runningUser) {
			Account portalAccount = new Account(Name = 'Test');
			insert portalAccount;

			portalContact = new contact(LastName = 'Test', AccountId = portalAccount.Id);
			insert portalContact;

			Id communityProfileId = [SELECT Id FROM Profile WHERE Name = 'CMSS Experience User'].Id;

			communityUser = TestDataFactory.getUser(
				new User(
					AgentId__c = '12355',
					AgentActivityType__c = '2',
					CommissionAccountBase__c = '2',
					IsAgentActive__c = true,
					FirstName = 'Kamil',
					LastName = 'Testovič',
					Email = 'kamil@test.cz',
					Phone1__c = '123456789',
					ProfileId = communityProfileId,
					ContactId = portalContact.Id,
					IsActive = true
				)
			);
			insert communityUser;
		}

		Test.startTest();
		UserTriggerHandler.updateCommunityUsersContacts(new Set<Id>{ communityUser.Id });
		Test.stopTest();

		portalContact = [
			SELECT AgentActivityType__c, CommissionAccountBase__c, IsAgentActive__c, FirstName, LastName, Email, Phone
			FROM Contact
			WHERE Id = :portalContact.Id
		];

		System.assertEquals(portalContact.LastName, 'Testovič');
		System.assertEquals(portalContact.FirstName, 'Kamil');
		System.assertEquals(portalContact.Email, 'kamil@test.cz');
		System.assertEquals(portalContact.Phone, '123456789');
		System.assertEquals(portalContact.IsAgentActive__c, true);
		System.assertEquals(portalContact.CommissionAccountBase__c, '2');
		System.assertEquals(portalContact.AgentActivityType__c, '2');
	}
}
