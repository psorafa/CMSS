public without sharing class AccessSharingUtils {
	public static List<AccessShare__c> getNewAccessShareList(
		Map<User, Map<Datetime, Set<Id>>> userIdAndExpirationDateAndAccountIds,
		String type,
		String reason
	) {
		Set<AccessShare__c> accessShareSet = new Set<AccessShare__c>();
		if (userIdAndExpirationDateAndAccountIds != null && userIdAndExpirationDateAndAccountIds.isEmpty()) {
			return new List<AccessShare__c>(accessShareSet);
		} else {
			for (User user : userIdAndExpirationDateAndAccountIds.keySet()) {
				for (Datetime expirationDate : userIdAndExpirationDateAndAccountIds.get(user).keySet()) {
					for (Id accountId : userIdAndExpirationDateAndAccountIds.get(user).get(expirationDate)) {
						accessShareSet.add(
							new AccessShare__c(
								AccessTo__c = accountId,
								RequestedBy__c = user.Id,
								StartDate__c = datetime.now(),
								Type__c = type,
								Reason__c = reason,
								ExpirationDate__c = expirationDate
							)
						);
					}
				}
			}

			return new List<AccessShare__c>(accessShareSet);
		}
	}

	//in development
	public static List<AccessShare__c> getNewAccessShareList2(Set<AccessShareDTO> accessSharesDtos, String type) {
		Set<AccessShare__c> accessShareSet = new Set<AccessShare__c>();

		if (accessSharesDtos != null && accessSharesDtos.isEmpty()) {
			return new List<AccessShare__c>(accessShareSet);
		} else {
			for (AccessShareDTO accessShareDto : accessSharesDtos) {
				accessShareSet.add(
					new AccessShare__c(
						AccessTo__c = accessShareDto.accountIdToShare,
						RequestedBy__c = accessShareDto.userToShareWith.Id,
						StartDate__c = datetime.now(),
						Type__c = type,
						Reason__c = accessShareDto.reason,
						ExpirationDate__c = accessShareDto.expirationDate,
						RoleId__c = accessShareDto.roleId
					)
				);
			}

			return new List<AccessShare__c>(accessShareSet);
		}
	}
}