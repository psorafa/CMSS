public class UserTriggerHandler extends TriggerHandler {
	public override void afterInsert() {
		updateCommunityUsersContacts(Trigger.newMap.keySet());
	}

	public override void afterUpdate() {
		if (!System.isBatch()) {
			updateCommunityUsersContacts(Trigger.newMap.keySet());
		}
	}

	@TestVisible
	@Future
	private static void updateCommunityUsersContacts(Set<Id> userIds) {
		Map<Id, User> contactsToUsersMap = getContactsToUsersMap(userIds);

		if (contactsToUsersMap.size() > 0) {
			updateContacts(contactsToUsersMap);
		}
	}

	private static Map<Id, User> getContactsToUsersMap(Set<Id> userIds) {
		List<User> users = [
			SELECT
				AgentActivityType__c,
				CommissionAccountBase__c,
				CooperationPartnerType__c,
				IsAgentActive__c,
				FirstName,
				LastName,
				Email,
				Phone1__c,
				IsActive,
				ContactId
			FROM User
			WHERE Id IN :userIds
		];

		Map<Id, User> contactsToUsersMap = new Map<Id, User>();

		for (User u : users) {
			if (u.ContactId != null && u.IsActive) {
				contactsToUsersMap.put(u.ContactId, u);
			}
		}
		return contactsToUsersMap;
	}

	private static void updateContacts(Map<Id, User> contactsToUsersMap) {
		List<Contact> contacts = [
			SELECT
				AgentActivityType__c,
				CommissionAccountBase__c,
				CooperationPartnerType__c,
				IsAgentActive__c,
				User__c,
				FirstName,
				LastName,
				Email,
				Phone
			FROM Contact
			WHERE Id IN :contactsToUsersMap.keySet()
		];

		User actualUser;
		for (Contact c : contacts) {
			actualUser = contactsToUsersMap.get(c.Id);
			c.AgentActivityType__c = actualUser.AgentActivityType__c;
			c.CommissionAccountBase__c = actualUser.CommissionAccountBase__c;
			c.CooperationPartnerType__c = actualUser.CooperationPartnerType__c;
			c.IsAgentActive__c = actualUser.IsAgentActive__c;
			c.User__c = actualUser.Id;
			c.FirstName = actualUser.FirstName;
			c.LastName = actualUser.LastName;
			c.Email = actualUser.Email;
			c.Phone = actualUser.Phone1__c;
		}
		update contacts;
	}
}
