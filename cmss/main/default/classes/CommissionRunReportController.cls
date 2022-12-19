public with sharing class CommissionRunReportController {

    @AuraEnabled
    public static Map<String, ReportWrap> getReportsMap() {
       Map<String, CommissionReports__mdt> result = CommissionReports__mdt.getAll();
       Set<String> restultSet = result.keySet();
       Map<String, ReportWrap> reportMap = new Map<String, ReportWrap>();
        for (Report report : [SELECT Id, Name, FolderName, DeveloperName FROM Report where DeveloperName IN :restultSet ORDER BY Name]) {
            if (!reportMap.containsKey(report.DeveloperName)) {
                reportMap.put(report.DeveloperName, new ReportWrap(report.DeveloperName, report.Name, report.Id));
            }
        }
        
        if(reportMap.isEmpty()){
            for(String report : restultSet){
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
        
        /*Map<String, List<ReportWrap>> result = new Map<String, List<ReportWrap>>();
        for (Report report : [SELECT Id, Name, FolderName FROM Report ORDER BY Name]) {
            if (!result.containsKey(report.FolderName)) {
                result.put(report.FolderName, new List<ReportWrap>());
            }
            result.get(report.FolderName).add(new ReportWrap(report.Name, report.Id));
        }
        return result;*/
    }

    public class ReportWrap {
        @AuraEnabled public String reportDeveloperName;
        @AuraEnabled public String ReportName;
        @AuraEnabled public String reportId;

        public ReportWrap(String rDevName, String rLabel, String rId) {
            this.reportDeveloperName = rDevName;
            this.ReportName = rLabel;
            this.reportId = rId;
        }
    }
    
    public class ReportWrapTezi {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        //@AuraEnabled public String developername;
        //@AuraEnabled public String columns;

        public ReportWrapTezi(String name, Id id) {
            this.label = name;
            this.value = id;
            //this.developername = developername;
            //this.columns = columns;
        }
    }

    @AuraEnabled
    public static Id runReport(Id reportId) {
        Reports.ReportInstance instance = Reports.ReportManager.runAsyncReport(reportId, true);
        return instance.getId();
    }

    @AuraEnabled
    public static String checkStatus(Id instanceId) {
        System.debug('Check status: ' + instanceId);
        Reports.ReportInstance instance = Reports.ReportManager.getReportInstance(instanceId);
        return instance.getStatus();
    }

    @AuraEnabled
    public static List<String> getReportData(Id instanceId) {
        System.debug('Check status: ' + instanceId);

        // Run a report synchronously
        Reports.ReportResults results = Reports.ReportManager.getReportInstance(instanceId).getReportResults();
        if (results == null) {
            return null;
        }

        // Get the fact map from the report results
        Reports.ReportFactWithDetails factDetails =
                (Reports.ReportFactWithDetails) results.getFactMap().get('T!T');

        List<String> result = new List<String>();
        for (Reports.ReportDetailRow detailRow : factDetails.getRows()) {
            result.add('' + detailRow.getDataCells()[0].getValue());
        }
        return result;
    }

}