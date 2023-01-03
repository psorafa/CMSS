public without sharing class CommissionPdfGeneratorController {
	public String html { get; set; }
	public String selectedReportName { get; set; }
	public String selectedPeriod { get; set; }
	public String commissionAccount { get; set; }
	public String combinedName { get; set; }
	public String address { get; set; }
	public String footerTimestamp { get; set; }
	public String cpu { get; set; }
	public String filterReport { get; set; }
	public String filterRecordRange { get; set; }

	public void insertAccessLog() {
		Access_Log__c accessLog = new Access_Log__c();
		accessLog.RequestedBy__c = UserInfo.getUserId();
		accessLog.Type__c = 'PV PDF Export';
		if (cpu.deleteWhitespace().isNumeric()) {
			accessLog.FilterCPUSuffix__c = Integer.valueOf(cpu.deleteWhitespace());
		}
		accessLog.FilterPeriod__c = selectedPeriod;
		accessLog.FilterStatementType__c = filterReport;
		accessLog.FilterRecordNumber__c = filterRecordRange;
		accessLog.FilterOwnerCommissionAccountBase__c = commissionAccount;
		accessLog.RecordTypeId = Schema.sObjectType.Access_Log__c.getRecordTypeInfosByDeveloperName()
			.get('PVPDFExport')
			.getRecordTypeId();
		insert accessLog;
	}

	public CommissionPdfGeneratorController() {
		html = ApexPages.currentPage().getParameters().get('html');
		selectedReportName = ApexPages.currentPage().getParameters().get('selectedReportName');
		selectedPeriod = ApexPages.currentPage().getParameters().get('selectedPeriod');
		commissionAccount = ApexPages.currentPage().getParameters().get('commissionAccount');
		combinedName = ApexPages.currentPage().getParameters().get('combinedName');
		address = ApexPages.currentPage().getParameters().get('address');
		footerTimestamp = ApexPages.currentPage().getParameters().get('footerTimestamp');
		cpu = ApexPages.currentPage().getParameters().get('cpu');
		filterReport = ApexPages.currentPage().getParameters().get('filterReport');
		filterRecordRange = ApexPages.currentPage().getParameters().get('filterRecordRange');
	}
}
