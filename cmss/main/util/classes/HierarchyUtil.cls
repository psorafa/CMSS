public class HierarchyUtil {

	@TestVisible
	private static Selector selector = new Selector();

	private final Map<Id, UserRole> allRolesMap = new Map<Id, UserRole>(selector.selectRoles());

	/**
	 * Will return highest superior of given role, that is Regional Manager or Regional Manager Assistant (role
	 * DeveloperName starts with 'X110_'. Will ignore 'team' roles even if they start with X110. If there are multiple
	 * X110 roles, the highest is returned (eg. if there is Assistant superior to RM, Assistant role is returned).
	 *
	 * @param roleId Id of role from which to start searching.
	 *
	 * @return Highest 'X110' role, see description.
	 */
	public Id getRegionalManagerOrAssistantRoleOf(Id roleId) {
		if (roleId == null) {
			return null;
		}
		UserRole parentRole = allRolesMap.get(roleId);
		Id x110Role;
		if (parentRole.DeveloperName.startsWith('X110_') && !parentRole.DeveloperName.endsWith('team')) {
			x110Role = parentRole.Id;
		}
		while (parentRole.ParentRoleId != null) {
			parentRole = allRolesMap.get(parentRole.ParentRoleId);
			if (parentRole.DeveloperName.startsWith('X110_') && !parentRole.DeveloperName.endsWith('team')) {
				x110Role = parentRole.Id;
			}
		}
		return x110Role;
	}

	public Set<Id> getSubordinateRolesOf(Id parentRoleId) {
		Set<Id> childRolesSet = new Set<Id>{parentRoleId};
		if (parentRoleId == null) {
			return childRolesSet;
		}
		List<UserRole> allRoles = allRolesMap.values();
		Boolean childAdded = true;
		while (childAdded) {
			childAdded = false;
			for (Integer i = allRoles.size() - 1; i >= 0; i--) {
				UserRole role = allRoles.get(i);
				if (childRolesSet.contains(role.ParentRoleId)) {
					childRolesSet.add(role.Id);
					allRoles.remove(i);
					childAdded = true;
				}
			}
		}
		childRolesSet.remove(parentRoleId);
		return childRolesSet;
	}

	public Boolean roleIsRegionalManagerOrAssistant(Id roleId) {
		UserRole role = allRolesMap.get(roleId);
		return (
			role != null && role.DeveloperName.startsWithIgnoreCase('X110_') &&
			(role.DeveloperName.endsWithIgnoreCase('ASSIST') || role.DeveloperName.endsWithIgnoreCase('MNG'))
		);
	}

	public Set<Id> getRmRoles() {
		Set<Id> rmRoles = new Set<Id>();
		for (Id roleId : allRolesMap.keySet()) {
			if (roleIsRegionalManagerOrAssistant(roleId)) {
				rmRoles.add(roleId);
			}
		}
		return rmRoles;
	}

	@TestVisible
	private without sharing virtual class Selector {
		public virtual List<UserRole> selectRoles() {
			return [SELECT Id, DeveloperName, ParentRoleId FROM UserRole];
		}
	}
}