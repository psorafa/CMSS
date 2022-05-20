public with sharing class UserHierarchyTreeService {
	private Id userId;

	public UserHierarchyTreeService(Id userId) {
		this.userId = userId;
	}

	public UserHierarchyTreeDto loadUserHierarchyTree() {
		String userId15 = String.valueOf(this.userId).substring(0, 15);
		String queryUserId = '%' + userId15 + '%';
		List<User> userList = [
			SELECT Id, Name, ManagerId, AgentActivityType__c
			FROM User
			WHERE ManagerIds__c LIKE :queryUserId AND IsActive = TRUE
		];

		Map<Id, List<User>> userMap = new Map<Id, List<User>>();

		for (User user : userList) {
			if (userMap.containsKey(user.ManagerId)) {
				userMap.get(user.ManagerId).add(user);
			} else {
				List<User> tmpList = new List<User>();
				tmpList.add(user);
				userMap.put(user.ManagerId, tmpList);
			}
		}

		User currentUser = [SELECT Id, Name, AgentActivityType__c, ManagerId FROM User WHERE Id = :this.userId];
		return userToDto(currentUser, userMap);
	}

	private UserHierarchyTreeDto userToDto(User u, Map<Id, List<User>> userMap) {
		UserHierarchyTreeDto dto = new UserHierarchyTreeDto();
		dto.userId = u.Id;
		dto.name = u.Name;
		dto.functionType = u.AgentActivityType__c;
		dto.children = prepareRecord(u, userMap);
		return dto;
	}

	private List<UserHierarchyTreeDto> prepareRecord(User parentUser, Map<Id, List<User>> userMap) {
		List<UserHierarchyTreeDto> result = null;
		if (userMap.containsKey(parentUser.Id)) {
			result = new List<UserHierarchyTreeDto>();
			UserHierarchyTreeDto parentUserDto = userToDto(parentUser, new Map<Id, List<User>>());
			parentUserDto.userId = parentUser.Id + '_copy';
			result.add(parentUserDto);
			for (User user : userMap.get(parentUser.Id)) {
				UserHierarchyTreeDto dto = userToDto(user, userMap);
				result.add(dto);
			}
		}

		return result;
	}
}
