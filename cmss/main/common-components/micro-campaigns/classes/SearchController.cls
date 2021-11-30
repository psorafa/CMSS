public without sharing class SearchController {
	private static final Integer MAX_NUMBER_OF_QUERIED_OBJS = 20;
	private static Integer offset = 0;

	@AuraEnabled
	public static List<SObject> search(String objectName, List<String> fields, String searchTerm) {
		return search(objectName, fields, searchTerm, null);
	}

	@AuraEnabled
	public static List<SObject> search(
		String objectName,
		List<String> fields,
		String searchTerm,
		String searchCondition
	) {
		String searchKeyword = searchTerm + '*';
		String returningQuery = '';
		String condition = String.isEmpty(searchCondition) ? '' : ' WHERE ' + searchCondition;
		returningQuery = objectName + ' ( Id, ' + String.join(fields, ',') + condition;
		String query =
			'FIND :searchKeyword IN ALL FIELDS RETURNING ' +
			returningQuery +
			' LIMIT ' +
			String.valueOf(MAX_NUMBER_OF_QUERIED_OBJS) +
			' OFFSET ' +
			String.valueOf(offset) +
			')';
		System.debug('Query ' + query);
		List<List<SObject>> searchRecords = Search.query(query);
		return searchRecords.get(0);
	}

	@AuraEnabled
	public static List<SObject> search(
		String objectName,
		List<String> fields,
		String searchTerm,
		String searchCondition,
		Boolean subordinateOnly
	) {
		if (subordinateOnly == false || objectName != 'User') {
			return search(objectName, fields, searchTerm, searchCondition);
		}

		Map<Id, UserRole> userRolesMap = new Map<Id, UserRole>([SELECT Id, ParentRoleId FROM UserRole]);
		String actualUserRoleId = UserInfo.getUserRoleId();
		Boolean isAdmin = isActualUserAdmin();
		fields.add('UserRole.ParentRoleId');
		List<SObject> queriedObjects = new List<SObject>();
		List<User> subordinateUsers = new List<User>();
		Boolean doQuery = true;
		Integer limitCounter = 0;

		while (doQuery) {
			queriedObjects = search(objectName, fields, searchTerm, searchCondition);
			limitCounter++;
			for (User user : (List<User>) queriedObjects) {
				if (isAdmin || isUserSubordinate(actualUserRoleId, user.UserRole?.ParentRoleId, userRolesMap)) {
					subordinateUsers.add(user);
				}
			}
			if (
				subordinateUsers.size() > 4 ||
				queriedObjects.size() < MAX_NUMBER_OF_QUERIED_OBJS ||
				limitCounter >= 10
			) {
				doQuery = false;
			} else {
				offset += MAX_NUMBER_OF_QUERIED_OBJS;
			}
		}
		return subordinateUsers;
	}

	private static Boolean isActualUserAdmin() {
		Id actualUserProfileId = UserInfo.getProfileId();
		String actualUserProfileName = [SELECT Name FROM Profile WHERE Id = :actualUserProfileId].Name;
		return actualUserProfileName == 'System Administrator';
	}

	@testVisible
	private static Boolean isUserSubordinate(
		Id superiorRoleId,
		Id subordinateParentRoleId,
		Map<Id, UserRole> rolesMap
	) {
		Id actualParentRoleId = subordinateParentRoleId;
		UserRole actualUserRole;

		while (actualParentRoleId != null) {
			if (actualParentRoleId == superiorRoleId) {
				return true;
			}
			actualUserRole = rolesMap.get(actualParentRoleId);
			actualParentRoleId = actualUserRole?.ParentRoleId;
		}

		return false;
	}

	@AuraEnabled
	public static Campaign getCampaign(Id campaignId, String fields) {
		return Database.query('SELECT ' + fields + ' FROM Campaign WHERE Id = :campaignId');
	}
}
