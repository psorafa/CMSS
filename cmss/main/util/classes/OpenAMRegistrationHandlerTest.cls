@IsTest
private class OpenAMRegistrationHandlerTest {
	@IsTest
	static void testCreateUser_loginName() {
		User u = TestDataFactory.getUser(new User(
			LoginName__c = 'test0001'
		));
		insert u;

		Auth.UserData userData1 = new Auth.UserData('test0001', null, null, null, null, null, null, null, null, null, null);
		Auth.UserData userData2 = new Auth.UserData('another', null, null, null, null, null, null, null, null, null, null);

		OpenAMRegistrationHandler registrationHandler = new OpenAMRegistrationHandler();
		User returnedUser = registrationHandler.createUser(null, userData1);
		registrationHandler.updateUser(null, null, null);
		System.assertEquals(u.Id, returnedUser.Id);

		System.assertEquals(null, registrationHandler.createUser(null, userData2));
	}

	@IsTest
	static void testCreateUser_glow() {
		User u = TestDataFactory.getUser(new User(
			GlowID__c = 'test0001'
		));
		insert u;

		Auth.UserData userData1 = new Auth.UserData('test0001', null, null, null, null, null, null, null, null, null, null);
		Auth.UserData userData2 = new Auth.UserData('another', null, null, null, null, null, null, null, null, null, null);

		OpenAMRegistrationHandler registrationHandler = new OpenAMRegistrationHandler();
		User returnedUser = registrationHandler.createUser(null, userData1);
		registrationHandler.updateUser(null, null, null);
		System.assertEquals(u.Id, returnedUser.Id);

		System.assertEquals(null, registrationHandler.createUser(null, userData2));
	}
}