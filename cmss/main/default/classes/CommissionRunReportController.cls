public with sharing class CommissionRunReportController {
	@AuraEnabled
	public static User getUserInfo() {
		User usr = [
			SELECT Id, Name, CombinedName__c, CommissionAccountNr__c, CommissionAccountBase__c, Profile.Name
			FROM User
			WHERE Id = :UserInfo.getUserId()
		][0];
		return usr;
	}

	@AuraEnabled
	public static ContactInformation__c getContactInfo(Id userId) {
		try {
			ContactInformation__c conInfo = [
				SELECT Id, Value__c
				FROM ContactInformation__c
				WHERE User__c = :userId AND Type__c = '1' AND Subtype__c = '1000003' AND Area__c = '0'
				ORDER BY LastModifiedDate DESC
			][0];
			return conInfo;
		} catch (Exception e) {
			Logger.error('Error in CommissionRunReportController.getContactInfo', e);
			throw new AuraHandledException(e.getMessage());
		} finally {
			Logger.saveLogs();
		}
	}

	@AuraEnabled
	public static Map<String, ReportWrap> getReportsMap() {
		Map<String, CommissionReports__mdt> result = CommissionReports__mdt.getAll();
		Set<String> restultSet = result.keySet();
		Map<String, ReportWrap> reportMap = new Map<String, ReportWrap>();
		for (Report report : [
			SELECT Id, Name, FolderName, DeveloperName, Description
			FROM Report
			WHERE DeveloperName IN :restultSet
			ORDER BY Name
		]) {
			if (!reportMap.containsKey(report.DeveloperName)) {
				reportMap.put(
					report.DeveloperName,
					new ReportWrap(report.DeveloperName, report.Name, report.Id, report.Description)
				);
			}
		}

		if (reportMap.isEmpty()) {
			for (String report : restultSet) {
				if (!reportMap.containsKey(report)) {
					reportMap.put(report, new ReportWrap(report, result.get(report).ReportName__c, '', ''));
				}
			}
		}

		List<String> resultList = new List<String>(restultSet);
		resultList.sort();
		Map<String, ReportWrap> resultSorted = new Map<String, ReportWrap>();
		for (String reportDevName : resultList) {
			resultSorted.put(reportDevName, reportMap.get(reportDevName));
		}
		return resultSorted;
	}

	public class ReportWrap {
		@AuraEnabled
		public String reportDeveloperName;
		@AuraEnabled
		public String reportName;
		@AuraEnabled
		public String reportId;
		@AuraEnabled
		public String reportDescription;

		public ReportWrap(String rDevName, String rLabel, String rId, String rDesc) {
			this.reportDeveloperName = rDevName;
			this.reportName = rLabel;
			this.reportId = rId;
			this.reportDescription = rDesc;
		}
	}

	@AuraEnabled
	public static List<Reports.ReportFilter> getReportFilters(Id reportId) {
		Reports.ReportDescribeResult repDesc = Reports.ReportManager.describeReport(reportId);
		Reports.ReportMetadata repMd = repDesc.getReportMetadata();
		List<Reports.ReportFilter> repFilters = repMd.getReportFilters();
		Reports.StandardDateFilter standardDateFilters = repMd.getStandardDateFilter();
		List<Reports.StandardFilter> standardFilters = repMd.getStandardFilters();

		for (Reports.ReportFilter repFilter : repFilters) {
			System.debug('Filter column: ' + repFilter);
		}
		System.debug('standardDateFilters: ' + standardDateFilters);

		for (Reports.StandardFilter standardFilter : standardFilters) {
			System.debug('standardFilter: ' + standardFilter);
		}

		return repFilters;
	}

	@AuraEnabled
	public static Id runReport(
		Id reportId,
		String fromYear,
		String fromMonth,
		String toYear,
		String toMonth,
		String fromRecord,
		String toRecord,
		String cpu,
		String tribeCpu
	) {
		Reports.ReportDescribeResult repDesc = Reports.ReportManager.describeReport(reportId);
		Reports.ReportMetadata repMd = repDesc.getReportMetadata();
		Reports.StandardDateFilter standardDateFilter = new Reports.StandardDateFilter();
		standardDateFilter.setColumn('Commission__c.BillingDate__c');
		standardDateFilter.setDurationValue('CUSTOM');
		if (!String.isBlank(fromYear) && !String.isBlank(fromMonth)) {
			standardDateFilter.setStartDate(fromYear + '-' + fromMonth + '-' + '01');
		} else {
			standardDateFilter.setStartDate('null');
		}

		if (!String.isBlank(toYear) && !String.isBlank(toMonth)) {
			standardDateFilter.setEndDate(
				toYear +
				'-' +
				toMonth +
				'-' +
				Date.daysInMonth(Integer.valueOf(toYear), Integer.valueOf(toMonth))
			);
		} else {
			standardDateFilter.setEndDate(
				fromYear +
				'-' +
				fromMonth +
				'-' +
				Date.daysInMonth(Integer.valueOf(fromYear), Integer.valueOf(fromMonth))
			);
		}

		//set custom filters
		List<Reports.ReportFilter> repFilters = repMd.getReportFilters();
		if (!String.isBlank(fromRecord)) {
			Reports.ReportFilter fromRecordFilter = new Reports.ReportFilter();
			fromRecordFilter.setColumn('Commission__c.RecordNumber__c');
			fromRecordFilter.setOperator('greaterOrEqual');
			fromRecordFilter.setValue(fromRecord);
			fromRecordFilter.setFilterType('fieldValue');
			repFilters.add(fromRecordFilter);
		}
		if (!String.isBlank(toRecord)) {
			Reports.ReportFilter toRecordFilter = new Reports.ReportFilter();
			toRecordFilter.setColumn('Commission__c.RecordNumber__c');
			toRecordFilter.setOperator('lessOrEqual');
			toRecordFilter.setValue(toRecord);
			toRecordFilter.setFilterType('fieldValue');
			repFilters.add(toRecordFilter);
		}
		if (!String.isBlank(tribeCpu)) {
			Reports.ReportFilter tribeCPUFilter = new Reports.ReportFilter();
			tribeCPUFilter.setColumn('Commission__c.OwnerCommissionAcountBase__c');
			tribeCPUFilter.setOperator('equals');
			tribeCPUFilter.setValue(tribeCpu);
			tribeCPUFilter.setFilterType('fieldValue');
			repFilters.add(tribeCPUFilter);
		}
		if (!String.isBlank(cpu)) {
			Reports.ReportFilter cpuFilter = new Reports.ReportFilter();
			cpuFilter.setColumn('Commission__c.CPUSuffix__c');
			cpuFilter.setOperator('equals');
			cpuFilter.setValue(cpu);
			cpuFilter.setFilterType('fieldValue');
			repFilters.add(cpuFilter);
		}

		repMd.setStandardDateFilter(standardDateFilter);
		repMd.setReportFilters(repFilters);
		Reports.ReportInstance instance = Reports.ReportManager.runAsyncReport(reportId, repMd, true);
		return instance.getId();
	}

	@AuraEnabled
	public static String checkStatus(Id instanceId) {
		Reports.ReportInstance instance = Reports.ReportManager.getReportInstance(instanceId);
		return instance.getStatus();
	}

	public class ReportHeader {
		@AuraEnabled
		public String columnLabel;
		@AuraEnabled
		public String columnDevName;
		@AuraEnabled
		public Integer columnIndex;

		public ReportHeader(String colLabel, String colDevName, Integer colIdx) {
			this.columnLabel = colLabel;
			this.columnDevName = colDevName;
			this.columnIndex = colIdx;
		}
	}

	public class ReportTable {
		@AuraEnabled
		public Map<String, ReportHeader> reportHeader;
		@AuraEnabled
		public List<List<String>> reportData;
		@AuraEnabled
		public String entitlementAmount;
		@AuraEnabled
		public String pendingAmount;
		@AuraEnabled
		public String rowCount;
		public ReportTable(
			Map<String, ReportHeader> header,
			List<List<String>> data,
			String entitlementAmount,
			String pendingAmount,
			String rowCount
		) {
			this.reportHeader = header;
			this.reportData = data;
			this.entitlementAmount = entitlementAmount;
			this.pendingAmount = pendingAmount;
			this.rowCount = rowCount;
		}
	}

	@AuraEnabled
	//public static List<List<String>> getReportData(Id instanceId) {
	public static ReportTable getReportData(Id instanceId, String reportDevName) {
		//prepare header columns from metadata
		//getInstance method cannot be used because it truncates columns to 255 chars
		List<String> reportMdtColumns = [
				SELECT Columns__c
				FROM CommissionReports__mdt
				WHERE DeveloperName = :reportDevName
				LIMIT 1
			][0]
			.Columns__c.split(',');
		Map<String, String> reportMdtColumnsMap = new Map<String, String>();
		for (String rep : reportMdtColumns) {
			String localRep = rep.deleteWhitespace();
			if (!reportMdtColumnsMap.containsKey(localRep)) {
				reportMdtColumnsMap.put(localRep, localRep);
			}
		}

		Reports.ReportResults results = Reports.ReportManager.getReportInstance(instanceId).getReportResults();
		if (results == null) {
			return null;
		}

		//get report header
		Reports.ReportExtendedMetadata repExtendedMetadata = results.getReportExtendedMetadata();
		Map<String, Reports.DetailColumn> repDetailColumnInfo = repExtendedMetadata.getDetailColumnInfo();
		Map<String, ReportHeader> header = new Map<String, ReportHeader>();
		for (String key : reportMdtColumnsMap.keySet()) {
			Integer i = 0; //position of column in repDetailColumnInfo is needed
			for (String keyColumn : repDetailColumnInfo.keySet()) {
				if (key == keyColumn) {
					header.put(
						repDetailColumnInfo.get(key).getName(),
						new ReportHeader(
							repDetailColumnInfo.get(key).getLabel(),
							repDetailColumnInfo.get(key).getName(),
							i
						)
					);
				}
				i++;
			}
		}

		// get report rows.
		Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails) results.getFactMap().get('T!T');
		List<String> result = new List<String>();
		List<List<String>> resultTable = new List<List<String>>();
		for (Reports.ReportDetailRow detailRow : factDetails.getRows()) {
			List<String> row = new List<String>();
			for (String key : header.keySet()) {
				row.add('' + detailRow.getDataCells()[header.get(key).columnIndex].getLabel());
			}
			resultTable.add(row);
			System.debug('Row: ' + row);
		}

		//get aggregates metadata and data
		Reports.ReportMetadata repMetadata = results.getReportMetadata();
		List<String> repAggregates = repMetadata.getAggregates();
		List<Reports.SummaryValue> repAggregatesData = factDetails.getAggregates();
		String entitlementAmount;
		String pendingAmount;
		String rowCount;
		Integer j = 0;
		for (String aggregate : repAggregates) {
			switch on aggregate {
				when 's!Commission__c.PendingAmount__c' {
					PendingAmount = repAggregatesData[j].getLabel();
				}
				when 's!Commission__c.EntitlementAmount__c' {
					EntitlementAmount = repAggregatesData[j].getLabel();
				}
				when 'RowCount' {
					RowCount = repAggregatesData[j].getLabel();
				}
			}
			j++;
		}

		return new ReportTable(header, resultTable, entitlementAmount, pendingAmount, rowCount);
	}
}
