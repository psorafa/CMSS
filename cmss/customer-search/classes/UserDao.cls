public class UserDao {
	public static User getUserById(Id userId) {
		return [
			SELECT Email, LastName, Name, ProfileId, IsActive, UserRoleId, UserRole.Name, UserRole.ParentRoleId
			FROM User
			WHERE Id = :userId
			LIMIT 1
		];
	}

	public static User[] getUsersByIds(Set<Id> userIds) {
		return [
			SELECT Name, ProfileId, IsActive, UserRoleId, UserRole.Name, UserRole.ParentRoleId
			FROM User
			WHERE Id IN :userIds
		];
	}

	public static User[] getActiveUsersByIds(Set<Id> userIds) {
		return [
			SELECT Name, ProfileId, IsActive, UserRoleId, UserRole.Name, UserRole.ParentRoleId
			FROM User
			WHERE Id IN :userIds AND IsActive = TRUE
		];
	}

	public static User getCurrentUser() {
		return [
			SELECT EmployeeNumber, Name, ProfileId, IsActive, UserRoleId, UserRole.Name
			FROM User
			WHERE Id = :UserInfo.getUserId()
		];
	}

	public static User[] getUsersById(Set<Id> userIds) {
		return [SELECT LastName, Name, ProfileId, IsActive, UserRoleId, UserRole.Name FROM User WHERE Id IN :userIds];
	}
}