public with sharing class NewPortfolioManagerSelectController {
	@TestVisible
	private static Selector selector = new Selector();

	@AuraEnabled(Cacheable=true)
	public static List<SearchResult> search(String term) {
		try {
			List<SearchResult> results = new List<SearchResult>();
			term = term.replace('%', '').replace('_', '');
			String likeTerm = '%' + term + '%';
			for (User user : searchUsers(term, likeTerm)) {
				results.add(new SearchResult(user));
			}
			return results;
		} catch (Exception e) {
			Logger.error('Unexpected error', e);
			throw new AuraHandledException('Unexpected error: ' + e.getMessage());
		} finally {
			Logger.saveLogs();
		}
	}

	private static List<User> searchUsers(String searchTerm, String searchLikeTerm) {
		if (FeatureManagement.checkPermission('CreateEmptyPortfolioManagementCases')) {
			return selector.searchUsers(searchTerm, searchLikeTerm);
		} else {
			HierarchyUtil hierarchyUtil = new HierarchyUtil();
			Id rmRole = hierarchyUtil.getRegionalManagerOrAssistantRoleOf(UserInfo.getUserRoleId());
			if (rmRole == null) {
				rmRole = UserInfo.getUserRoleId();
			}
			Set<Id> rolesToSearch = hierarchyUtil.getSubordinateRolesOf(rmRole);
			rolesToSearch.add(rmRole);
			if (hierarchyUtil.roleIsRegionalManagerOrAssistant(UserInfo.getUserRoleId())) {
				rolesToSearch.addAll(hierarchyUtil.getRmRoles());
			}
			return selector.searchUsersWithRole(searchTerm, searchLikeTerm, rolesToSearch);
		}
	}

	public class SearchResult {
		@AuraEnabled
		public Id id;
		@AuraEnabled
		public String name;
		@AuraEnabled
		public String cpu;

		public SearchResult(User user) {
			id = user.Id;
			name = user.Name;
			cpu = user.CommissionAccountNrAll__c;
		}
	}

	@TestVisible
	private virtual class Selector {
		public virtual List<User> searchUsersWithRole(String value, String likeValue, Set<Id> rolesIds) {
			return [
				SELECT Id, Name, CommissionAccountNrAll__c
				FROM User
				WHERE
					(Name LIKE :likeValue
					OR CommissionAccountBase__c = :value)
					AND IsAgentActive__c = TRUE
					AND PortfolioManType__c = 'A'
					AND UserRoleId IN :rolesIds
				ORDER BY Name
				LIMIT 5
			];
		}

		public virtual List<User> searchUsers(String value, String likeValue) {
			return [
				SELECT Id, Name, CommissionAccountNrAll__c
				FROM User
				WHERE (Name LIKE :likeValue OR CommissionAccountBase__c = :value) AND IsAgentActive__c = TRUE
				ORDER BY Name
				LIMIT 5
			];
		}
	}
}
