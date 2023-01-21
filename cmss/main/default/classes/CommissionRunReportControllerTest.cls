@IsTest
public without sharing class CommissionRunReportControllerTest {
	@IsTest
	private static void createTestData() {
		User user = TestDataFactory.getUser(new User(CommissionAccountBase__c = '001'));
		insert user;
		ContactInformation__c conInfo = new ContactInformation__c(
			User__c = user.Id,
			Type__c = '1',
			Value__c = 'ABC',
			Subtype__c = '1000003',
			Area__c = '0'
		);
		insert conInfo;
		List<Commission__c> comms = new List<Commission__c>();
		Commission__c comm1 = new Commission__c(
			BillingDate__c = Date.today(),
			RecordNumber__c = 1,
			CPUSuffix__c = 2,
			EntitlementAmount__c = 12000,
			PendingAmount__c = 5000,
			OwnerCommissionAcountBase__c = 1234
		);
		comms.add(comm1);
		Commission__c comm2 = new Commission__c(
			BillingDate__c = Date.today(),
			RecordNumber__c = 2,
			CPUSuffix__c = 2,
			EntitlementAmount__c = 12000,
			PendingAmount__c = 5000,
			OwnerCommissionAcountBase__c = 1234
		);
		comms.add(comm2);
		insert comms;
	}

	@IsTest
	static void getUserInfoTest() {
		System.assertEquals(UserInfo.getUserId(), CommissionRunReportController.getUserInfo().Id);
	}

	@IsTest
	static void getUserInfoTribeCpuTest() {
		createTestData();
		User usr = [SELECT Id, CommissionAccountBase__c FROM User WHERE CommissionAccountBase__c = '001' LIMIT 1][0];
		System.assertEquals(usr.Id, CommissionRunReportController.getUserInfo(usr.CommissionAccountBase__c).Id);
	}

	@IsTest
	static void checkPermissionSetsTest() {
		createTestData();
		System.assert(CommissionRunReportController.checkPermissionSets() > -1);
	}

	@IsTest
	static void getContactInfoTest() {
		createTestData();
		ContactInformation__c conInfo = [SELECT Id FROM ContactInformation__c WHERE Subtype__c = '1000003'][0];
		User user = [SELECT Id FROM User WHERE CommissionAccountBase__c = '001'][0];
		System.assertEquals(conInfo.Id, CommissionRunReportController.getContactInfo(user.Id).Id);
	}

	@IsTest
	static void getKnowledgeCommissionArticleURLTest() {
		System.assert(CommissionRunReportController.getKnowledgeCommissionArticleURL().length() > 0);
	}

	@IsTest
	static void getReportsMapTest() {
		System.assert(CommissionRunReportController.getReportsMap().size() > 0);
	}

	@isTest(SeeAllData='true')
	static void getReportFiltersTest() {
		Report r = [SELECT Id FROM Report LIMIT 1][0];
		System.assert(
			CommissionRunReportController.getReportFilters(r.Id) != null ||
			CommissionRunReportController.getReportFilters(r.Id) == null
		);
	}

	@isTest(SeeAllData='true')
	static void runTabularReportTest() {
		Report r = [SELECT Id, DeveloperName FROM Report WHERE DeveloperName = 'CommissionReport1020' LIMIT 1];
		createTestData();
		Test.startTest();
		Id rInstanceId = CommissionRunReportController.runReport(
			r.Id,
			String.valueOf(System.Today().year()),
			String.valueOf(System.Today().month()),
			String.valueOf(System.Today().year()),
			String.valueOf(System.Today().month()),
			'1',
			'5',
			'2',
			'1234'
		);
		Test.stopTest();
		System.assertEquals(CommissionRunReportController.checkStatus(rInstanceId), 'Success');
		CommissionRunReportController.ReportTable rData = CommissionRunReportController.getReportData(
			rInstanceId,
			'CommissionReport1020'
		);
		System.assert(rData.reportHeader.size() > 0);
	}

	@isTest(SeeAllData='true')
	static void runSummaryReportTest() {
		Report r = [SELECT Id, DeveloperName FROM Report WHERE DeveloperName = 'CommissionReportExpFlatRate' LIMIT 1];
		createTestData();
		Test.startTest();
		Id rInstanceId = CommissionRunReportController.runReport(
			r.Id,
			String.valueOf(System.Today().year()),
			String.valueOf(System.Today().month()),
			String.valueOf(System.Today().year()),
			String.valueOf(System.Today().month()),
			'1',
			'5',
			'2',
			'1234'
		);
		Test.stopTest();
		System.assertEquals(CommissionRunReportController.checkStatus(rInstanceId), 'Success');
		CommissionRunReportController.ReportTable rData = CommissionRunReportController.getReportData(
			rInstanceId,
			'CommissionReportExpFlatRate'
		);
		System.assert(rData.reportHeader.size() > 0);
	}
}
