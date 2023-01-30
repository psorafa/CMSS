public with sharing class NewPortfolioManagerSelectController {

	@TestVisible
	private static Selector selector = new Selector();

	@AuraEnabled(Cacheable=true)
	public static List<SearchResult> search(String term) {
		try {
			List<SearchResult> results = new List<SearchResult>();
			term = '%' + term.replace('%', '').replace('_', '') + '%';
			for (User user : searchUsers(term)) {
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

	private static List<User> searchUsers(String searchTerm) {
		if (FeatureManagement.checkPermission('CreateEmptyPortfolioManagementCases')) {
			return selector.searchUsers(searchTerm);
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
			return selector.searchUsersWithRole(searchTerm, rolesToSearch);
		}
	}

	public class SearchResult {
		@AuraEnabled public Id id;
		@AuraEnabled public String name;
		@AuraEnabled public String cpu;

		public SearchResult(User user) {
			id = user.Id;
			name = user.Name;
			cpu = user.CommissionAccountNrAll__c;
		}
	}

	@TestVisible
	private virtual class Selector {

		public virtual List<User> searchUsersWithRole(String value, Set<Id> rolesIds) {
			return [
				SELECT Id, Name, CommissionAccountNrAll__c FROM User
				WHERE
					(Name LIKE :value OR CommissionAccountNr__c LIKE :value OR CommissionAccountNrAll__c LIKE :value)
				AND IsAgentActive__c = TRUE AND PortfolioManType__c = 'A' AND UserRoleId IN :rolesIds
				ORDER BY Name LIMIT 5
			];
		}

		public virtual List<User> searchUsers(String value) {
			return [
				SELECT Id, Name, CommissionAccountNrAll__c FROM User
				WHERE
					(Name LIKE :value OR CommissionAccountNr__c LIKE :value OR CommissionAccountNrAll__c LIKE :value)
				ORDER BY Name LIMIT 5
			];
		}
	}
}