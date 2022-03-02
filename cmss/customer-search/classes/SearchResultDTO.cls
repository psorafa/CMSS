public with sharing class SearchResultDTO {
    @AuraEnabled
	public Boolean accessToRecord { get; set; }
	@AuraEnabled
	public String recordId { get; set; }
	@AuraEnabled
	public String childRecordId { get; set; }
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
	public String email { get; set; }
	@AuraEnabled
	public String globalId { get; set; }
	@AuraEnabled
	public String sObjectType { get; set; }

	public SearchResultDTO(
        Boolean accessToRecord,
		String recordId,
		String childRecordId,
		String name,
		String birthNumber,
		String compRegNum,
		String assetNumber,
		String city,
		String postalCode,
		String email,
		String globalId,
		String sObjectType
	) {
        this.accessToRecord = accessToRecord;
		this.recordId = recordId;
		this.childRecordId = childRecordId;
		this.name = name;
		this.birthNumber = birthNumber;
		this.compRegNum = compRegNum;
		this.assetNumber = assetNumber;
		this.city = city;
		this.postalCode = postalCode;
		this.email = email;
		this.globalId = globalId;
		this.sObjectType = sObjectType;
	}
}