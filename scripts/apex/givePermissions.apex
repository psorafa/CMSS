List<PermissionSet> permissionSets = [
	SELECT Id
	FROM PermissionSet
	WHERE Name IN ('EditAllData', 'ReadAllData', 'CustomSearchConfiguration', 'CustomSearchFilter')
];

List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>();
for (PermissionSet permissionSet : permissionSets) {
	assignments.add(new PermissionSetAssignment(
		AssigneeId = UserInfo.getUserId(),
		PermissionSetId = permissionSet.Id
	));
}
insert assignments;