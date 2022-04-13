public class CustomSearchFilterResponseDto {
	@AuraEnabled
	public Integer totalCount { get; set; }
	@AuraEnabled
	public List<SObject> data { get; set; }

	public CustomSearchFilterResponseDto(List<SObject> data, Integer totalCount) {
		this.totalCount = totalCount;
		this.data = data;
	}
}
