public class UserHierarchyTreeDto {
	@AuraEnabled
	public String userId { get; set; }

	@AuraEnabled
	public String name { get; set; }

	@AuraEnabled
	public String functionType { get; set; }

	@AuraEnabled
	public List<UserHierarchyTreeDto> children { get; set; }
}
