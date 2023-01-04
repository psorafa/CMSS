@IsTest
public without sharing class CommissionPdfGeneratorControllerTest {
	public static testMethod void testCommissionPdfGeneratorController() {
		PageReference pageRef = Page.CommissionPdfGenerator;
		Test.setCurrentPage(pageRef);

		String filterReport = 'CommissionReport1020';
		String html = '<table><thead><tr><th></th></tr></thead></table>';
		String selectedReportName = 'CommissionReport1020';
		String selectedPeriod = '01.01.2022 - ';
		String commissionAccount = 'commission account';
		String combinedName = 'combined name';
		String address = 'address';
		String footerTimestamp = '01.01.2022';
		String cpu = '2';
		String filterRecordRange = '1234';

		ApexPages.currentPage().getParameters().put('filterReport', filterReport);
		ApexPages.currentPage().getParameters().put('html', html);
		ApexPages.currentPage().getParameters().put('selectedReportName', selectedReportName);
		ApexPages.currentPage().getParameters().put('selectedPeriod', selectedPeriod);
		ApexPages.currentPage().getParameters().put('commissionAccount', commissionAccount);
		ApexPages.currentPage().getParameters().put('combinedName', combinedName);
		ApexPages.currentPage().getParameters().put('address', address);
		ApexPages.currentPage().getParameters().put('footerTimestamp', footerTimestamp);
		ApexPages.currentPage().getParameters().put('cpu', cpu);
		ApexPages.currentPage().getParameters().put('filterRecordRange', filterRecordRange);
		CommissionPdfGeneratorController controller = new CommissionPdfGeneratorController();
		controller.insertAccessLog();
		Integer checkAccessLog = [
			SELECT COUNT()
			FROM Access_Log__c
			WHERE Type__c = 'PV PDF Export' AND FilterStatementType__c = :filterReport
		];
		System.Assert(checkAccessLog > 0);
	}
}
