public without sharing class AccountShareDao {
	public static List<AccountShare> getAccountShares(Set<Id> userIds) {
		return [SELECT AccountAccessLevel,AccountId,CaseAccessLevel,ContactAccessLevel,Id,IsDeleted,LastModifiedById,LastModifiedDate,OpportunityAccessLevel,RowCause,UserOrGroupId FROM AccountShare
		WHERE UserOrGroupId IN: userIds];
	}

	public static List<AccountShare> getAllRecordsFromAccountShare() {
		return [SELECT AccountAccessLevel, AccountId, CaseAccessLevel, ContactAccessLevel, Id,
		IsDeleted, LastModifiedById, LastModifiedDate, OpportunityAccessLevel, RowCause, UserOrGroupId
		FROM AccountShare];
	}
	/*
	 * Select current user and current account from AccountShare table
	 *
	 * @return List<AccountShare>
	 */
	public static List<AccountShare> getAccountShareByUserIdAndAccountId(Id userId, Id accountId) {
		return [SELECT AccountAccessLevel,AccountId,CaseAccessLevel,ContactAccessLevel,Id,IsDeleted,LastModifiedById,LastModifiedDate,OpportunityAccessLevel,RowCause,UserOrGroupId FROM AccountShare WHERE UserOrGroupId =:userId AND AccountId =:accountId];
	}

	public static List<AccountShare> getAccountShareByUserAndAccountIds(Set<Id> userIds, Set<Id> accountIds) {
		return [SELECT AccountAccessLevel, AccountId, CaseAccessLevel, ContactAccessLevel, Id, IsDeleted, LastModifiedById, LastModifiedDate, OpportunityAccessLevel, RowCause, UserOrGroupId FROM AccountShare
		WHERE UserOrGroupId IN: userIds AND AccountId IN: accountIds];
	}

    public static List<AccountShare> getAccountShareByUserAndAccountIds(id userId, Set<Id> accountIds) {
        return [SELECT AccountAccessLevel, AccountId, CaseAccessLevel, ContactAccessLevel, Id, IsDeleted, LastModifiedById, LastModifiedDate, OpportunityAccessLevel, RowCause, UserOrGroupId FROM AccountShare
        WHERE UserOrGroupId = :userId AND AccountId IN: accountIds];
    }
    
    public static List<AccountShare> getAccountSharesByUserId(id userId) {
        return [SELECT AccountAccessLevel,AccountId,CaseAccessLevel,ContactAccessLevel,Id,IsDeleted,LastModifiedById,LastModifiedDate,OpportunityAccessLevel,RowCause,UserOrGroupId FROM AccountShare
        WHERE UserOrGroupId = :userId];
    }

    public static List<AccountShare> getAccountSharesByUserIds(Set<id> userIds) {
        return [SELECT AccountAccessLevel,AccountId,CaseAccessLevel,ContactAccessLevel,Id,IsDeleted,LastModifiedById,LastModifiedDate,OpportunityAccessLevel,RowCause,UserOrGroupId FROM AccountShare
        WHERE UserOrGroupId IN :userIds];
    }

	public static List<AccountShare> getSharesByUserIdAccountIdsRowCause(id userId, Set<Id> accountIds, String rowCause){
		return [SELECT AccountId, UserOrGroupId, RowCause 
				FROM AccountShare
				WHERE UserOrGroupId = :userId AND AccountId IN :accountIds AND RowCause = :rowCause];
	}
	public static List<AccountShare> getSharesByUserIdAccountIdsRowCause(Set<id> userIds, Set<Id> accountIds, String rowCause){
		return [SELECT AccountId, UserOrGroupId, RowCause 
				FROM AccountShare
				WHERE UserOrGroupId IN :userIds AND AccountId IN :accountIds AND RowCause = :rowCause];
	}
}