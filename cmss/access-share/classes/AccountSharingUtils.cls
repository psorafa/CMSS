public without sharing class AccountSharingUtils {
	/*
	 * @description: Check if current user is Admin, if no grant full access to account (AccountShare)
	 *
	 * @methodName: grantFullAccessOfAccShareToUser
	 */
	public static List<AccountShare> getNewAccountShareWithFullAccessList(
		Map<User, Map<Datetime, Set<Id>>> userIdAndExpirationDateAndAccountIds
	) {
		List<AccountShare> accountShareList = new List<AccountShare>();
		if (userIdAndExpirationDateAndAccountIds != null && userIdAndExpirationDateAndAccountIds.isEmpty()) {
			return accountShareList;
		} else {
			for (User user : userIdAndExpirationDateAndAccountIds.keySet()) {
				for (Datetime expirationDate : userIdAndExpirationDateAndAccountIds.get(user).keySet()) {
					for (Id accountId : userIdAndExpirationDateAndAccountIds.get(user).get(expirationDate)) {
						AccountShare newAccountShare = new AccountShare();
						newAccountShare.AccountId = accountId;
						newAccountShare.UserOrGroupId = user.Id;
						newAccountShare.AccountAccessLevel = 'edit';
						newAccountShare.OpportunityAccessLevel = 'edit';

						accountShareList.add(newAccountShare);
					}
				}
			}

			return accountShareList;
		}
	}
	//in development
	public static List<AccountShare> getNewAccountShareWithFullAccessList2(Set<AccessShareDTO> accessSharesDtos) {
		List<AccountShare> accountShareList = new List<AccountShare>();
		if (accessSharesDtos != null && accessSharesDtos.isEmpty()) {
			return accountShareList;
		} else {
			for (AccessShareDTO accessSharesDto : accessSharesDtos) {
				AccountShare newAccountShare = new AccountShare();
				newAccountShare.AccountId = accessSharesDto.accountIdToShare;
				newAccountShare.UserOrGroupId = accessSharesDto.userToShareWith.Id;
				newAccountShare.AccountAccessLevel = 'edit';
				newAccountShare.OpportunityAccessLevel = 'edit';
				accountShareList.add(newAccountShare);
			}
			return accountShareList;
		}
	}
}