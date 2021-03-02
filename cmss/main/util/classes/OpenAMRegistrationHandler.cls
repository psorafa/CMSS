public class OpenAMRegistrationHandler implements Auth.RegistrationHandler{

	public User createUser(Id portalId, Auth.UserData data){
		System.debug('SSO login attempt: ' + JSON.serializePretty(data));
		for (User u : [SELECT Id FROM User WHERE LoginName__c = :data.identifier]) {
			System.debug('User found: ' + u.Id);
			return u;
		}
		System.debug('Unknown user');
		return null;
	}

	public void updateUser(Id userId, Id portalId, Auth.UserData data){
	}
}