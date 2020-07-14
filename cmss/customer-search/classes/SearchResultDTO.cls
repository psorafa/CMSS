public with sharing class SearchResultDTO {
	public String recordId { get; set; }
	public String name { get; set; }
	public String birthNumber { get; set; }
	public String compRegNum { get; set; }
	public String assetNumber { get; set; }
	public String city { get; set; }
	public String postalCode { get; set; }
	public String sObjectType { get; set; }

	public SearchResultDTO(
		String recordId,
		String name,
		String birthNumber,
		String compRegNum,
		String assetNumber,
		String city,
		String postalCode,
		String sObjectType
	) {
		this.recordId = recordId;
		this.name = name;
		this.birthNumber = birthNumber;
		this.compRegNum = compRegNum;
		this.assetNumber = assetNumber;
		this.city = city;
		this.postalCode = postalCode;
		this.sObjectType = sObjectType;
	}
}
