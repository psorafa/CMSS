public with sharing class CommissionRunReportController {
	@AuraEnabled
	public static Map<String, ReportWrap> getReportsMap() {
		Map<String, CommissionReports__mdt> result = CommissionReports__mdt.getAll();
		Set<String> restultSet = result.keySet();
		Map<String, ReportWrap> reportMap = new Map<String, ReportWrap>();
		for (Report report : [
			SELECT Id, Name, FolderName, DeveloperName
			FROM Report
			WHERE DeveloperName IN :restultSet
			ORDER BY Name
		]) {
			if (!reportMap.containsKey(report.DeveloperName)) {
				reportMap.put(report.DeveloperName, new ReportWrap(report.DeveloperName, report.Name, report.Id));
			}
		}

		if (reportMap.isEmpty()) {
			for (String report : restultSet) {
				if (!reportMap.containsKey(report)) {
					reportMap.put(report, new ReportWrap(report, result.get(report).ReportName__c, ''));
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
		public String ReportName;
		@AuraEnabled
		public String reportId;

		public ReportWrap(String rDevName, String rLabel, String rId) {
			this.reportDeveloperName = rDevName;
			this.ReportName = rLabel;
			this.reportId = rId;
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
			System.debug('Filter: ' + repFilter);
		}
		System.debug('standardDateFilters: ' + standardDateFilters);

		for (Reports.StandardFilter standardFilter : standardFilters) {
			System.debug('standardFilter: ' + standardFilter);
		}

		return repFilters;
	}

	@AuraEnabled
	public static Id runReport(Id reportId, String fromYear, String fromMonth, String toYear, String toMonth) {
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

		Reports.ReportDescribeResult repDesc = Reports.ReportManager.describeReport(reportId);
		Reports.ReportMetadata repMd = repDesc.getReportMetadata();
		repMd.setStandardDateFilter(standardDateFilter);
		Reports.ReportInstance instance = Reports.ReportManager.runAsyncReport(reportId, repMd, true);
		return instance.getId();
	}

	@AuraEnabled
	public static String checkStatus(Id instanceId) {
		System.debug('Check status: ' + instanceId);
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
		public ReportTable(Map<String, ReportHeader> header, List<List<String>> data) {
			this.reportHeader = header;
			this.reportData = data;
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

		// Prepare report rows.
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
		return new ReportTable(header, resultTable);
	}
}
