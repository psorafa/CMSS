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

	public static Set<AccessShareDTO> getRelatedAccessShareDTOs(Set<AccessShareDTO> accessShareDtos) {
		Set<Id> accountIds = new Set<Id>();
		for (AccessShareDTO dto : accessShareDtos) {
			accountIds.add(dto.accountIdToShare);
		}

		List<AssetAccountRelation__c> assetAccountRelations = [
			SELECT Id, Asset__c, Asset__r.Id, Asset__r.EndDate__c, Asset__r.AccountId, Account__c
			FROM AssetAccountRelation__c
			WHERE Account__c IN :accountIds AND RelationType__c != '1'
		];

		Map<Id, Set<Id>> accountAssetsMap = new Map<Id, Set<Id>>();
		Map<Id, Id> assetsToParentAccountsMap = new Map<Id, Id>();

		for (AssetAccountRelation__c relation : assetAccountRelations) {
			if (!assetsToParentAccountsMap.containsKey(relation.Asset__c)) {
				assetsToParentAccountsMap.put(relation.Asset__c, relation.Asset__r.AccountId);
			}
			Set<Id> assetIds = new Set<Id>();
			if (accountAssetsMap.containsKey(relation.Account__c)) {
				assetIds = accountAssetsMap.get(relation.Account__c);
			}
			assetIds.add(relation.Asset__c);
			accountAssetsMap.put(relation.Account__c, assetIds);
		}

		Set<AccessShareDTO> newShareDtos = new Set<AccessShareDTO>();
		for (AccessShareDTO assessShareDto : accessShareDtos) {
			Set<Id> assetIdsForActualAccount = accountAssetsMap.get(assessShareDto.accountIdToShare);
			if (assetIdsForActualAccount != null) {
				for (Id assetId : assetIdsForActualAccount) {
					AccessShareDTO newAccessShareDto = new AccessShareDTO();
					newAccessShareDto.accountIdToShare = assetsToParentAccountsMap.get(assetId);
					newAccessShareDto.expirationDate = assessShareDto.expirationDate;
					newAccessShareDto.reason = assessShareDto.reason;
					newAccessShareDto.userToShareWith = assessShareDto.userToShareWith;
					newAccessShareDto.roleId = assessShareDto.roleId;

					newShareDtos.add(newAccessShareDto);
				}
			}
		}
		return newShareDtos;
	}
}
