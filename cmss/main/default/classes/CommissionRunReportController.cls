public without sharing class CommissionRunReportController {
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
	public static User getUserInfoTribeCpu(String tribeCpu) {
		User usr = [
			SELECT Id, Name, CombinedName__c, CommissionAccountNr__c, CommissionAccountBase__c, Profile.Name
			FROM User
			WHERE CommissionAccountBase__c = :tribeCpu
		][0];
		return usr;
	}

	@AuraEnabled
	public static Integer checkPermissionSets() {
		Integer adminPermSetCount = [
			SELECT COUNT()
			FROM PermissionSetAssignment
			WHERE PermissionSet.Name = 'CommissionStatementAdministrator' AND AssigneeId = :UserInfo.getUserId()
		];
		return adminPermSetCount;
	}

	@AuraEnabled
	public static ContactInformation__c getContactInfo(Id userId) {
		try {
			List<ContactInformation__c> conInfo = [
				SELECT Id, Value__c
				FROM ContactInformation__c
				WHERE User__c = :userId AND Type__c = '1' AND Subtype__c = '1000003' AND Area__c = '0'
				ORDER BY LastModifiedDate DESC
				LIMIT 1
			];
			if (conInfo.size() > 0) {
				return conInfo[0];
			} else {
				return new ContactInformation__c();
			}
		} catch (Exception e) {
			Logger.error('Error in CommissionRunReportController.getContactInfo', e);
			throw new AuraHandledException(e.getMessage());
		} finally {
			Logger.saveLogs();
		}
	}

	@AuraEnabled
	public static String getKnowledgeCommissionArticleURL() {
		String url = Configuration__mdt.getInstance('Knowledge_CommissionArticleURL').Value__c;
		return url;
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
	public static Reports.StandardDateFilter getReportFilters(Id reportId) {
		Reports.ReportDescribeResult repDesc = Reports.ReportManager.describeReport(reportId);
		Reports.ReportMetadata repMd = repDesc.getReportMetadata();
		List<Reports.ReportFilter> repFilters = repMd.getReportFilters();
		Reports.StandardDateFilter standardDateFilters = repMd.getStandardDateFilter();
		List<Reports.StandardFilter> standardFilters = repMd.getStandardFilters();
		String scope = repMd.getScope();
		System.debug('scope: ' + scope);

		for (Reports.ReportFilter repFilter : repFilters) {
			System.debug('Filter column: ' + repFilter);
		}
		System.debug('standardDateFilters: ' + standardDateFilters);

		for (Reports.StandardFilter standardFilter : standardFilters) {
			System.debug('standardFilter: ' + standardFilter);
		}

		return standardDateFilters;
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
		if (String.isNotBlank(fromYear) && String.isNotBlank(fromMonth)) {
			fromMonth = fromMonth.length() == 1 ? '0' + fromMonth : fromMonth;
			standardDateFilter.setStartDate(fromYear + '-' + fromMonth + '-' + '01');
		} else {
			standardDateFilter.setStartDate('null');
		}

		if (String.isNotBlank(toYear) && String.isNotBlank(toMonth)) {
			toMonth = toMonth.length() == 1 ? '0' + toMonth : toMonth;
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
		if (String.isNotBlank(fromRecord)) {
			Reports.ReportFilter fromRecordFilter = new Reports.ReportFilter();
			fromRecordFilter.setColumn('Commission__c.RecordNumber__c');
			fromRecordFilter.setOperator('greaterOrEqual');
			fromRecordFilter.setValue(fromRecord);
			fromRecordFilter.setFilterType('fieldValue');
			repFilters.add(fromRecordFilter);
		}
		if (String.isNotBlank(toRecord)) {
			Reports.ReportFilter toRecordFilter = new Reports.ReportFilter();
			toRecordFilter.setColumn('Commission__c.RecordNumber__c');
			toRecordFilter.setOperator('lessOrEqual');
			toRecordFilter.setValue(toRecord);
			toRecordFilter.setFilterType('fieldValue');
			repFilters.add(toRecordFilter);
		}
		if (String.isNotBlank(tribeCpu)) {
			Reports.ReportFilter tribeCPUFilter = new Reports.ReportFilter();
			tribeCPUFilter.setColumn('Commission__c.OwnerCommissionAcountBase__c');
			tribeCPUFilter.setOperator('equals');
			tribeCPUFilter.setValue(tribeCpu);
			tribeCPUFilter.setFilterType('fieldValue');
			repMd.setScope('organization');
			repFilters.add(tribeCPUFilter);
		}
		if (String.isNotBlank(cpu)) {
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
		//public Map<String, ReportHeader> reportHeader;
		public List<ReportHeader> reportHeader;
		@AuraEnabled
		public List<List<String>> reportData;
		@AuraEnabled
		public String entitlementAmount;
		@AuraEnabled
		public String pendingAmount;
		@AuraEnabled
		public String rowCount;
		@AuraEnabled
		public Boolean showFooter;
		@AuraEnabled
		public Boolean showPendingAmount;

		public ReportTable(
			//Map<String, ReportHeader> header,
			List<ReportHeader> header,
			List<List<String>> data,
			String entitlementAmount,
			String pendingAmount,
			String rowCount,
			Boolean showFooter,
			Boolean showPendingAmount
		) {
			this.reportHeader = header;
			this.reportData = data;
			this.entitlementAmount = entitlementAmount;
			this.pendingAmount = pendingAmount;
			this.rowCount = rowCount;
			this.showFooter = showFooter;
			this.showPendingAmount = showPendingAmount;
		}
	}

	@AuraEnabled
	public static ReportTable getReportData(Id instanceId, String reportDevName) {
		if (reportDevName == 'CommissionReportExpFlatRate') {
			return getSummaryReportData(instanceId, reportDevName);
		} else {
			return getTabularReportData(instanceId, reportDevName);
		}
	}

	@AuraEnabled
	public static ReportTable getTabularReportData(Id instanceId, String reportDevName) {
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
		List<ReportHeader> headerList = new List<ReportHeader>();
		for (String key : reportMdtColumnsMap.keySet()) {
			Integer i = 0; //position of column in repDetailColumnInfo is needed
			for (String keyColumn : repDetailColumnInfo.keySet()) {
				if (key == keyColumn) {
					ReportHeader h = new ReportHeader(
						repDetailColumnInfo.get(key).getLabel(),
						repDetailColumnInfo.get(key).getName(),
						i
					);
					header.put(repDetailColumnInfo.get(key).getName(), h);
					headerList.add(h);
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
			//System.debug('Row: ' + row);
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

		Boolean showFooter = CommissionReports__mdt.getInstance(reportDevName).Show_Footer__c;
		Boolean showPendingAmount = CommissionReports__mdt.getInstance(reportDevName).Show_Pending_Amount__c;
		return new ReportTable(
			headerList,
			resultTable,
			entitlementAmount,
			pendingAmount,
			rowCount,
			showFooter,
			showPendingAmount
		);
	}

	@AuraEnabled
	public static ReportTable getSummaryReportData(Id instanceId, String reportDevName) {
		Reports.ReportResults results = Reports.ReportManager.getReportInstance(instanceId).getReportResults();
		if (results == null) {
			return null;
		}

		//build report header
		Reports.ReportExtendedMetadata repResultMetadata = results.getReportExtendedMetadata();
		List<ReportHeader> header = new List<ReportHeader>();
		Integer i = 0;
		MAP<String, Reports.GroupingColumn> groupingColumnInfo = repResultMetadata.getGroupingColumnInfo();
		for (String groupColInfo : groupingColumnInfo.keySet()) {
			ReportHeader h = new ReportHeader(
				groupingColumnInfo.get(groupColInfo).getLabel(),
				groupingColumnInfo.get(groupColInfo).getName(),
				i
			);
			header.add(h);
			i++;
		}
		MAP<String, Reports.DetailColumn> detailColumnInfo = repResultMetadata.getDetailColumnInfo();
		for (String detailColInfo : detailColumnInfo.keySet()) {
			//iterate all columns (correct order)
			MAP<String, Reports.AggregateColumn> aggregateColumnInfo = repResultMetadata.getAggregateColumnInfo();
			for (String agrColInfo : aggregateColumnInfo.keySet()) {
				//iterate aggregated columns
				if (
					('s!' + detailColumnInfo.get(detailColInfo).getName()) ==
					aggregateColumnInfo.get(agrColInfo).getName()
				) {
					ReportHeader h = new ReportHeader(
						aggregateColumnInfo.get(agrColInfo).getLabel(),
						aggregateColumnInfo.get(agrColInfo).getName(),
						i
					);
					header.add(h);
					i++;
				}
			}
		}

		// get report cells.
		List<List<String>> resultTable = new List<List<String>>();
		Integer rowCount = 0;
		Reports.Dimension groupingsDown = results.getGroupingsDown();
		List<Reports.GroupingValue> ListOfGroupingValuesL0 = groupingsDown.getGroupings();
		for (Reports.GroupingValue groupingValueL0 : ListOfGroupingValuesL0) {
			//keys 0, 1...
			List<String> rowL0 = new List<String>();
			List<String> rowL1 = new List<String>();
			List<String> rowSum = new List<String>();

			rowL0.add(groupingValueL0.getLabel()); //40, 60...;

			List<Reports.GroupingValue> ListOfGroupingValuesL1 = groupingValueL0.getGroupings();
			for (Reports.GroupingValue groupingValueL1 : ListOfGroupingValuesL1) {
				//keys 0_0, 1_0, 1_1...
				if (rowL0.size() > 0) {
					rowL0.add(groupingValueL1.getLabel()); //Test 3, Test 1...
				} else {
					rowL1.clear();
					rowL1.add('');
					rowL1.add(groupingValueL1.getLabel());
				}

				Reports.ReportFactWithDetails factDetailsL1 = (Reports.ReportFactWithDetails) results.getFactMap()
					.get(groupingValueL1.getKey() + '!T'); //get summaries for L1
				for (Reports.SummaryValue aggregatesRowL1 : factDetailsL1.getAggregates()) {
					//iterate fact columns for white cells
					if (rowL0.size() > 0) {
						rowL0.add(aggregatesRowL1.getLabel());
					} else {
						rowL1.add(aggregatesRowL1.getLabel());
					}
				}
				if (rowL0.size() > 0) {
					resultTable.add(rowL0.Clone());
					rowCount++;
				} else {
					resultTable.add(rowL1.Clone());
					rowCount++;
				}
				rowL0.clear();
				rowL1.clear();
			} //L1

			rowSum.add('');
			rowSum.add('Mezisoučet');
			Reports.ReportFactWithDetails factDetailsL0 = (Reports.ReportFactWithDetails) results.getFactMap()
				.get(groupingValueL0.getKey() + '!T'); //get summaries for L0
			for (Reports.SummaryValue aggregatesRowL0 : factDetailsL0.getAggregates()) {
				//iterate fact columns for summaries
				rowSum.add(aggregatesRowL0.getLabel());
			}
			resultTable.add(rowSum.Clone());
			rowCount++;
			rowSum.clear();
		} //L0

		//get last summary row
		List<String> rowSumLast = new List<String>();
		rowSumLast.add('Celkem');
		rowSumLast.add('');
		Reports.ReportMetadata repMetadata = results.getReportMetadata();
		List<String> repAggregates = repMetadata.getAggregates();
		Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails) results.getFactMap().get('T!T');
		List<Reports.SummaryValue> repAggregatesData = factDetails.getAggregates();
		String entitlementAmount;
		String pendingAmount;
		Integer j = 0;
		for (String aggregate : repAggregates) {
			rowSumLast.add(repAggregatesData[j].getLabel());
			switch on aggregate {
				when 's!Commission__c.PendingAmount__c' {
					PendingAmount = repAggregatesData[j].getLabel();
				}
				when 's!Commission__c.EntitlementAmount__c' {
					EntitlementAmount = repAggregatesData[j].getLabel();
				}
			}
			j++;
		}
		resultTable.add(rowSumLast);
		rowCount++;
		Boolean showFooter = CommissionReports__mdt.getInstance(reportDevName).Show_Footer__c;
		Boolean showPendingAmount = CommissionReports__mdt.getInstance(reportDevName).Show_Pending_Amount__c;
		return new ReportTable(
			header,
			resultTable,
			entitlementAmount,
			pendingAmount,
			String.valueOf(rowCount),
			showFooter,
			showPendingAmount
		);
	}
}
