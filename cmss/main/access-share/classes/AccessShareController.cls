/*
 * AccessShareController is responsible for processing incoming requests to AccessShare
 * Invokes business logic from AccessShareService
 */
public without sharing class AccessShareController {
	/*
	 * @description: Grant access to user with Type 'Search', this function will be called from FE with @AuraEnabled annotation
	 */
	// @AuraEnabled
	// public static void assignTypeAccess(String accountId) {
	// 	User currentUser = UserDao.getUserById(UserInfo.getUserId());
	// 	String sObjectName = Utils.getObjectNameByRecordId(accountId);

	// 	getSearchAccess(currentUser, accountId, sObjectName);
	// }

	/*
	 * @description: Check if recordid is Asset, Account or Claim, then grant access
	 */
	public static void getSearchAccess(User currentUser, Id accountId, String type) {
		if (type == 'Account') {
			grantAccessToAccountAndAssetAndClaimByAccountId(accountId, currentUser);
		}
	}

	/*
	 * @description: Grant access to Account, Asset and Claim
	 */
	public static void grantAccessToAccountAndAssetAndClaimByAccountId(Id accountId, User currentUser) {
		Set<AccessShareDTO> accessShareDtos = new Set<AccessShareDTO>();
		AccessShareController.addAccessShareDtoToSet(
			currentUser,
			accountId,
			Datetime.now().addDays(1),
			'CustomerSearch',
			accessShareDtos
		);
		assignAccess(accessShareDtos, 'Search');
	}

	// /*
	//  * @description: Grant access to user with Type 'Tandem'
	//  */
	// public static void assignTandemAccountAccessBulk(List<TandemAccount__c> tandemAccountList) {
	// 	if (tandemAccountList != null && !tandemAccountList.isEmpty()) {

	// 		Set<Id> tandemIds = new Set<Id>();
	// 		for (TandemAccount__c tandemAccount : tandemAccountList) {
	// 			tandemIds.add(tandemAccount.TandemId__c);
	// 		}

	// 		Map<Id, Tandem__c> tandemMap= new Map<Id, Tandem__c>(TandemDao.getTandemByIds(tandemIds));
	// 		Set<Id> userIds = new Set<Id>();

	// 		for (Tandem__c tandem : tandemMap.values()) {
	// 			userIds.add(tandem.TandemUserId2__c);
	// 		}

	// 		Map<Id, User> usersMap = new Map<Id, User>(UserDao.getUsersById(userIds));
	// 		Set<AccessShareDTO> accessShareDtos = new Set<AccessShareDTO>();
	// 		for (TandemAccount__c tandemAccount : tandemAccountList){
	// 			if (usersMap.get(tandemMap.get(tandemAccount.TandemId__c).TandemUserId2__c).IsActive == true) {
	// 				AccessShareController.addAccessShareDtoToSet(usersMap.get(tandemMap.get(tandemAccount.TandemId__c).TandemUserId2__c), tandemAccount.Account__c, tandemAccount.ValidTo2__c, tandemAccount.Id, AccessShareDtos);
	// 			}
	// 		}
	// 		assignAccess(accessShareDtos, 'Tandem');
	// 	}
	// }

	/*
	 * @description: Grant access to user with Type 'Opportunity'
	 */
	public static void assignOpportunityAccessBulk(List<Opportunity> opportunityList) {
		if (opportunityList != null && !opportunityList.isEmpty()) {
			Set<Id> userIds = new Set<Id>();

			for (Opportunity opportunity : opportunityList) {
				userIds.add(opportunity.OwnerId);
			}

			Map<Id, User> usersMap = new Map<Id, User>(UserDao.getUsersById(userIds));

			Set<AccessShareDTO> accessShareDtos = new Set<AccessShareDTO>();
			for (Opportunity opp : opportunityList) {
				if (usersMap.get(opp.OwnerId).IsActive == true) {
					AccessShareController.addAccessShareDtoToSet(
						usersMap.get(opp.OwnerId),
						opp.AccountId,
						opp.CloseDate,
						opp.Id,
						AccessShareDtos
					);
				}
			}
			assignAccess(accessShareDtos, 'Opportunity');
		}
	}

	/*
	 * @description: Grant access to user with Type 'Task'
	 */
	public static void assignTaskAccessBulk(List<Task> taskList) {
		if (taskList != null && !taskList.isEmpty()) {
			Set<Id> whatIds = new Set<Id>();
			Set<Id> userIds = new Set<Id>();

			for (Task task : taskList) {
				whatIds.add(task.WhatId);
				userIds.add(task.OwnerId);
			}

			Map<Id, User> usersMap = new Map<Id, User>(UserDao.getUsersById(userIds));
			Map<Id, Asset> assetMap = new Map<Id, Asset>([SELECT Id, AccountId FROM Asset WHERE Id IN :whatIds]);

			Set<AccessShareDTO> accessShareDtos = new Set<AccessShareDTO>();
			for (Task task : taskList) {
				if (usersMap.get(task.OwnerId).IsActive == true) {
					String accId;
					if (task.AccountId != null) {
						accId = task.AccountId;
					} else if (task.WhatId != null) {
						accId = assetMap.get(task.WhatId).AccountId;
					} else {
						continue;
					}

					AccessShareController.addAccessShareDtoToSet(
						usersMap.get(task.OwnerId),
						accId,
						// task.ActivityDate.addDays(1), //TODO proc to tam neni?
						System.today().addDays(1),
						task.Id,
						AccessShareDtos
					);
				}
			}

			assignAccess(accessShareDtos, 'Task');
		}
	}

	// /*
	//  * @description: Grant access to user with Type 'Owner'
	//  */
	// public static void assignAssetAgentAccessBulk(List<Asset_Agent__c> assetAgentList) {
	// 	if (assetAgentList != null && !assetAgentList.isEmpty()) {
	// 		Set<String> roleSet = new Set<String>{
	// 			'Pečující',
	// 			'Hlavní pečující',
	// 			'Pečující hlavní (BAL)',
	// 			'Pečující vedlejší (BAL)',
	// 			'Pečující hlavní (ŽP+OPV)',
	// 			'Pečující vedlejší (ŽP+OPV)'
	// 		};

	// 		//check and remove invalid asset_agent
	// 		List<Asset_Agent__c> verifiedAssetAgentList = AssetAgentService.removeInvalidAssetAgent(assetAgentList);

	// 		if (verifiedAssetAgentList != null && !verifiedAssetAgentList.isEmpty()) {
	// 			Set<Id> assetIds = new Set<Id>();
	// 			Set<Id> userIds = new Set<Id>();

	// 			for (Asset_Agent__c assetAgent : verifiedAssetAgentList) {
	// 				assetIds.add(assetAgent.iContract__c);
	// 				userIds.add(assetAgent.User__c);
	// 			}

	// 			Map<Id, User> usersMap = new Map<Id, User>(UserDao.getUsersById(userIds));
	// 			Map<Id, Asset> assetMap = new Map<Id, Asset>(AssetDao.getAssetByIds(assetIds));

	// 			Set<AccessShareDTO> accessShareDtos = new Set<AccessShareDTO>();
	// 			for (Asset_Agent__c assetAgent : verifiedAssetAgentList) {
	// 				if (usersMap.get(assetAgent.User__c).IsActive == true) {
	// 					AccessShareController.addAccessShareDtoToSet(
	// 						usersMap.get(assetAgent.User__c),
	// 						assetMap.get(assetAgent.iContract__c).AccountId,
	// 						Date.today().addYears(15),
	// 						assetAgent.Id,
	// 						AccessShareDtos
	// 					);
	// 				}
	// 			}

	// 			assignAccess(accessShareDtos, 'Owner');
	// 		}
	// 	}
	// }

	/*
	 * @description: Grant access to user
	 */
	public static void assignAccess(Set<AccessShareDTO> accessShareDtos, String type) {
		AccessShareService.assignAccess(accessShareDtos, type);
	}

	/*
	 * @description: Remove access to account
	 */
	public static void removeAccess(
		Set<AccessShareDTO.Remove> accessShareDtoRemoves,
		List<AccessShare__c> accessShareList,
		String type
	) {
		AccessShareService.removeAccess(accessShareDtoRemoves, accessShareList, type);
	}

	// /*
	//  * @description: Remove TandemAccount__c from AccessShare table
	//  */
	// public static void removeTandemAccountAccessBulk(List<TandemAccount__c> tandemAccountList, List<Tandem__c> tandemList) {
	// 	if (tandemAccountList != null && tandemList != null && !tandemAccountList.isEmpty() && !tandemList.isEmpty()) {
	// 		Map<Id, Tandem__c> tandemById = new Map<Id, Tandem__c>(tandemList);

	// 		Map<Id, Set<Id>> accountIdByUser = new Map<Id,Set<id>>();
	// 		Set<Id> accountIds = new Set<Id>();
	// 		for (TandemAccount__c tandemAccount : tandemAccountList) {
	// 			Tandem__c tandem = tandemById.get(tandemAccount.TandemId__c);
	// 			Utils.addToMapsSet(accountIdByUser, tandem.TandemUserId2__c, tandemAccount.Account__c);
	// 			accountIds.add(tandemAccount.Account__c);
	// 		}

	// 		//all manual account share
	// 		Set<AccessShareDTO.Remove> accessShareDtoRemoves = new Set<AccessShareDTO.Remove>();
	// 		List<AccountShare> accountShareListToRemove = new List<AccountShare>();
	// 		for (AccountShare accountSh : AccountShareDao.getAccountShareByUserAndAccountIds(accountIdByUser.keyset(), accountIds)) {
	// 			for (TandemAccount__c tandemAccount : tandemAccountList) {
	// 				if (tandemById.get(tandemAccount.TandemId__c).TandemUserId2__c == accountSh.UserOrGroupId && tandemAccount.Account__c == accountSh.AccountId) {
	// 					addAccessShareDtoRemoveToSet(accountSh, String.valueOf(tandemAccount.Id), accessShareDtoRemoves);
	// 				}
	// 			}
	// 		}

	// 		//all accessShares with all types
	// 		List<AccessShare__c> accessSharesToConsider = new List<AccessShare__C>();
	// 		for (AccessShare__c AccessSh : AccessShareDao.getAccessShareByUserAndAccountIds(accountIdByUser.keyset(), accountIds)) {
	// 			if (accountIdByUser.get(AccessSh.RequestedBy__c).contains(AccessSh.AccessTo__c)) {
	// 				accessSharesToConsider.add(accessSh);
	// 			}
	// 		}

	// 		AccessShareService.removeAccess(accessShareDtoRemoves, accessSharesToConsider, 'Tandem');
	// 	}
	// }

	/*
	 * @description: Remove Task from AccessShare table
	 */
	public static void removeTaskAccessBulk(List<Task> taskList) {
		if (taskList != null & !taskList.isEmpty()) {
			Set<Id> taskWhatIds = new Set<Id>();
			for (Task t : taskList) {
				taskWhatIds.add(t.WhatId);
			}

			List<Asset> assetList = [SELECT Id, AccountId FROM Asset WHERE Id IN :taskWhatIds];

			Map<Id, Set<Id>> accountIdByUser = new Map<Id, Set<id>>();
			Set<Id> accountIds = new Set<Id>();

			for (Task task : taskList) {
				if (task.AccountId != null) {
					Utils.addToMapsSet(accountIdByUser, task.OwnerId, task.AccountId);
					accountIds.add(task.AccountId);
				}
				for (Asset asset : assetList) {
					if (asset.Id.equals(task.WhatId)) {
						Utils.addToMapsSet(accountIdByUser, task.OwnerId, asset.AccountId);
						accountIds.add(asset.AccountId);
					}
				}
			}

			//all manual account share
			Set<AccessShareDTO.Remove> accessShareDtoRemoves = new Set<AccessShareDTO.Remove>();
			List<AccountShare> accountShareListToRemove = new List<AccountShare>();
			for (
				AccountShare accountSh : AccountShareDao.getAccountShareByUserAndAccountIds(
					accountIdByUser.keyset(),
					accountIds
				)
			) {
				for (Task task : taskList) {
					if (task.ownerId == accountSh.UserOrGroupId) {
						if (task.AccountId != null && task.AccountId == accountSh.AccountId) {
							addAccessShareDtoRemoveToSet(accountSh, String.valueOf(task.Id), accessShareDtoRemoves);
						}
						Asset asset = new Map<Id, Asset>(assetList).get(task.WhatId);
						if (asset != null) {
							if (asset.AccountId == accountSh.AccountId)
								addAccessShareDtoRemoveToSet(accountSh, String.valueOf(task.Id), accessShareDtoRemoves);
						}
					}
				}
			}
			//all accessShares with all types
			List<AccessShare__c> accessSharesToConsider = new List<AccessShare__C>();
			for (
				AccessShare__c AccessSh : AccessShareDao.getAccessShareByUserAndAccountIds(
					accountIdByUser.keyset(),
					accountIds
				)
			) {
				if (accountIdByUser.get(AccessSh.RequestedBy__c).contains(AccessSh.AccessTo__c)) {
					accessSharesToConsider.add(accessSh);
				}
			}

			AccessShareService.removeAccess(accessShareDtoRemoves, accessSharesToConsider, 'Task');
		}
	}

	/*
	 * @description: Remove tandem from AccessShare table
	 */
	public static void removeOpportunityAccessBulk(List<Opportunity> opportunityList) {
		if (opportunityList != null && !opportunityList.isEmpty()) {
			Map<Id, Set<Id>> accountIdByUser = new Map<Id, Set<id>>();
			Set<Id> accountIds = new Set<Id>();

			for (Opportunity opportunity : opportunityList) {
				Utils.addToMapsSet(accountIdByUser, opportunity.OwnerId, opportunity.accountId);
				accountIds.add(opportunity.AccountId);
			}

			//all manual account share
			Set<AccessShareDTO.Remove> accessShareDtoRemoves = new Set<AccessShareDTO.Remove>();
			List<AccountShare> accountShareListToRemove = new List<AccountShare>();
			for (
				AccountShare accountSh : AccountShareDao.getAccountShareByUserAndAccountIds(
					accountIdByUser.keyset(),
					accountIds
				)
			) {
				for (Opportunity opp : opportunityList) {
					if (opp.OwnerId == accountSh.UserOrGroupId && opp.AccountId == accountSh.AccountId) {
						addAccessShareDtoRemoveToSet(accountSh, String.valueOf(opp.Id), accessShareDtoRemoves);
					}
				}
			}

			//all accessShares with all types
			List<AccessShare__c> accessSharesToConsider = new List<AccessShare__C>();
			for (
				AccessShare__c AccessSh : AccessShareDao.getAccessShareByUserAndAccountIds(
					accountIdByUser.keyset(),
					accountIds
				)
			) {
				if (accountIdByUser.get(AccessSh.RequestedBy__c).contains(AccessSh.AccessTo__c)) {
					accessSharesToConsider.add(accessSh);
				}
			}

			AccessShareService.removeAccess(accessShareDtoRemoves, accessSharesToConsider, 'Opportunity');
		}
	}

	// /*
	//  * @description: Remove assetAgent from AccessShare table
	//  */
	// public static void removeAssetAgentAccessBulk(List<Asset_Agent__c> assetAgentList) {
	// 	if (assetAgentList != null && !assetAgentList.isEmpty()) {
	// 		Set<Id> assetIds = new Set<Id>();
	// 		for (Asset_Agent__c assetAgent : assetAgentList) {
	// 			assetIds.add(assetAgent.iContract__c);
	// 		}
	// 		Map<Id, Asset> assetsMap = new Map<Id, Asset>(AssetDao.getAssetByIds(assetIds));

	// 		Map<Id, Set<Id>> accountIdByUser = new Map<Id, Set<id>>();
	// 		Set<Id> accountIds = new Set<Id>();

	// 		for (Asset_Agent__c assetAgent : assetAgentList) {
	// 			Utils.addToMapsSet(
	// 				accountIdByUser,
	// 				assetAgent.User__c,
	// 				assetsMap.get(assetAgent.iContract__c).AccountId
	// 			);
	// 			accountIds.add(assetsMap.get(assetAgent.iContract__c).AccountId);
	// 		}

	// 		//all manual account share
	// 		Set<AccessShareDTO.Remove> accessShareDtoRemoves = new Set<AccessShareDTO.Remove>();
	// 		List<AccountShare> accountShareListToRemove = new List<AccountShare>();
	// 		for (
	// 			AccountShare accountSh : AccountShareDao.getAccountShareByUserAndAccountIds(
	// 				accountIdByUser.keyset(),
	// 				accountIds
	// 			)
	// 		) {
	// 			for (Asset_Agent__c assetAgent : assetAgentList) {
	// 				if (
	// 					assetAgent.User__c == accountSh.UserOrGroupId &&
	// 					assetsMap.get(assetAgent.iContract__c).AccountId == accountSh.AccountId
	// 				) {
	// 					addAccessShareDtoRemoveToSet(accountSh, String.valueOf(assetAgent.Id), accessShareDtoRemoves);
	// 				}
	// 			}
	// 		}
	// 		//all accessShares with all types
	// 		List<AccessShare__c> accessSharesToConsider = new List<AccessShare__C>();
	// 		for (
	// 			AccessShare__c AccessSh : AccessShareDao.getAccessShareByUserAndAccountIds(
	// 				accountIdByUser.keyset(),
	// 				accountIds
	// 			)
	// 		) {
	// 			if (accountIdByUser.get(AccessSh.RequestedBy__c).contains(AccessSh.AccessTo__c)) {
	// 				accessSharesToConsider.add(accessSh);
	// 			}
	// 		}

	// 		AccessShareService.removeAccess(accessShareDtoRemoves, accessSharesToConsider, 'Owner');
	// 	}
	// }

	public static void addAccessShareDtoRemoveToSet(
		AccountShare accountSh,
		String reason,
		Set<AccessShareDTO.Remove> AccessShareDtoRemoves
	) {
		AccessShareDTO.Remove accessShareDtoRemove = new AccessShareDTO.Remove();
		accessShareDtoRemove.userId = accountSh.UserOrGroupId;
		accessShareDtoRemove.accountId = accountSh.AccountId;
		accessShareDtoRemove.reason = reason;
		accessShareDtoRemove.accountShare = accountSh;

		if (accountSh.rowCause == 'Manual') {
			accessShareDtoRemove.isManual = true;
		} else {
			accessShareDtoRemove.isManual = false;
		}

		accessShareDtoRemove.toBeDeleted = true;
		accessShareDtoRemoves.add(accessShareDtoRemove);
	}

	public static void addAccessShareDtoToSet(
		User deputyUser,
		Id accountId,
		Datetime dt,
		String reason,
		Set<AccessShareDTO> AccessShareDtos
	) {
		AccessShareDTO accessShareDto = new AccessShareDTO();
		accessShareDto.accountIdToShare = accountId;
		accessShareDto.userToShareWith = deputyUser;
		accessShareDto.expirationDate = dt;
		accessShareDto.reason = reason;
		accessShareDtos.add(accessShareDto);
	}

	public static void addAccessShareDtoToSet(
		User deputyUser,
		Id accountId,
		Datetime dt,
		String reason,
		Id roleId,
		Set<AccessShareDTO> AccessShareDtos
	) {
		AccessShareDTO accessShareDto = new AccessShareDTO();
		accessShareDto.accountIdToShare = accountId;
		accessShareDto.userToShareWith = deputyUser;
		accessShareDto.expirationDate = dt;
		accessShareDto.reason = reason;
		accessShareDto.roleId = roleId;

		accessShareDtos.add(accessShareDto);
	}
}
