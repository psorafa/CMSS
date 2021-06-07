public with sharing class SearchCriteriaDTO {
    @AuraEnabled
	public String firstName { get; set; }
    @AuraEnabled
	public String lastName { get; set; }
    @AuraEnabled
	public String birthNumber { get; set; }
    @AuraEnabled
	public String compRegNum { get; set; }
    @AuraEnabled
	public String assetNumber { get; set; }
    @AuraEnabled
	public String searchAmong { get; set; }

	public SearchCriteriaDTO() {
		//empty constructor used for serialisation
	}

	public SearchCriteriaDTO(
		String firstName,
		String lastName,
		String birthNumber,
		String compRegNum,
		String assetNumber,
		String searchAmong
	) {
		this.firstName = firstName;
		this.lastName = lastName;
		this.birthNumber = birthNumber;
		this.compRegNum = compRegNum;
		this.assetNumber = assetNumber;
		this.searchAmong = String.isBlank(searchAmong) ? CustomerSearchController.CLIENTS : searchAmong;
	}
}
