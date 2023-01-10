public class HierarchyUtil {

	private final Map<Id, UserRole> allRolesMap = new Map<Id, UserRole>([SELECT Id, DeveloperName, ParentRoleId FROM UserRole]);

	/**
	 * Will return highest superior of given role, that is Regional Manager or Regional Manager Assistant (role
	 * DeveloperName starts with 'X110_'. Will ignore 'team' roles even if they start with X110. If there are multiple
	 * X110 roles, the highest is returned (eg. if there is Assistant superior to RM, Assistant role is returned).
	 *
	 * @param roleId Id of role from which to start searching.
	 *
	 * @return Highest 'X100' role, see description.
	 */
	public Id getRegionalManagerOrAssistantRoleOf(Id roleId) {
		if (roleId == null) {
			return null;
		}
		UserRole parentRole = allRolesMap.get(roleId);
		Id x100Role;
		while (parentRole.ParentRoleId != null) {
			parentRole = allRolesMap.get(parentRole.ParentRoleId);
			if (parentRole.DeveloperName.startsWith('X100_') && !parentRole.DeveloperName.endsWith('team')) {
				x100Role = parentRole.Id;
			}
		}
		return x100Role;
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
}