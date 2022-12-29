public with sharing class CommissionPdfGeneratorController {
	public String html { get; set; }
	public String selectedReportName { get; set; }
	public String selectedPeriod { get; set; }
	public String commissionAccount { get; set; }
	public String combinedName { get; set; }
	public String address { get; set; }
	public String footerTimestamp { get; set; }

	public CommissionPdfGeneratorController() {
		html = ApexPages.currentPage().getParameters().get('html');
		selectedReportName = ApexPages.currentPage().getParameters().get('selectedReportName');
		selectedPeriod = ApexPages.currentPage().getParameters().get('selectedPeriod');
		commissionAccount = ApexPages.currentPage().getParameters().get('commissionAccount');
		combinedName = ApexPages.currentPage().getParameters().get('combinedName');
		address = ApexPages.currentPage().getParameters().get('address');
		footerTimestamp = ApexPages.currentPage().getParameters().get('footerTimestamp');
	}
}
