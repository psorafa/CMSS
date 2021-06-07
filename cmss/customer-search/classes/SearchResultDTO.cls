public with sharing class SearchResultDTO {
    @AuraEnabled
	public String recordId { get; set; }
    @AuraEnabled
	public String name { get; set; }
    @AuraEnabled
	public String birthNumber { get; set; }
    @AuraEnabled
	public String compRegNum { get; set; }
    @AuraEnabled
	public String assetNumber { get; set; }
    @AuraEnabled
	public String city { get; set; }
    @AuraEnabled
	public String postalCode { get; set; }
    @AuraEnabled
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
