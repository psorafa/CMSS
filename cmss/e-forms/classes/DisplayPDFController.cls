/**
 * Created by lukas.krbec on 05.05.2022.
 */

public without sharing class DisplayPDFController {
    public String displayText {get; set;}
    //public String displayBar {get; set;}
    private static final Map<String, String> imgCheckBoxMap = new Map<String, String>{'checked' => '/img/checkbox_checked.gif', 'unchecked' => '/img/checkbox_unchecked.gif'};

    private static Map<String, String> checkboxTranslationMap {
        get {
            if (checkboxTranslationMap == null) {
                checkboxTranslationMap = new Map<String, String>();
                List<EformsCheckboxTranslation__c> checkboxTranslationList = EformsCheckboxTranslation__c.getall().values();
                for (EformsCheckboxTranslation__c echt : checkboxTranslationList) {
                    checkboxTranslationMap.put(echt.SyncElemName__c + ':' + echt.SyncElemValue__c, echt.PlaceholderNameValuePair__c);
                }
            }
            return checkboxTranslationMap;
        }
        private set;
    }

    public DisplayPDFController() {
        String caseId = ApexPages.currentPage().getParameters().get('caseId');
        String templateTitle = ApexPages.currentPage().getParameters().get('template');
        // displayBar = EncodingUtil.urlDecode(String.escapeSingleQuotes(
        //         ApexPages.currentPage().getParameters().get('displayBar')), 'UTF-8');
        // system.debug(displayBar);

        List<Case> c = [SELECT Id, Template__c FROM Case WHERE id = :caseId];
        List<ContentVersion> templateList = new List<ContentVersion>();
        if(Test.isRunningTest()){
            templateList = [SELECT VersionData FROM ContentVersion];
        } else{
            templateList = [SELECT VersionData FROM ContentVersion WHERE ContentDocumentId IN (SELECT ContentDocumentId FROM ContentWorkspaceDoc WHERE ContentWorkspace.Name = 'PDF Templates' AND ContentDocument.Title =: templateTitle) AND IsLatest = true];
        }
        System.debug('templateList: ' + templateList);
        if (!templateList.isEmpty()) {
            Map<String, String> placeholderMap = buildPlaceholderMap((List<MigrationPremiumTypes.PdfTemplateItem>) JSON.deserialize(c[0].Template__c.unescapeHtml4(), List<MigrationPremiumTypes.PdfTemplateItem>.class));
            String template = templateList.get(0).VersionData.toString();
            displayText = buildPdfData(template, placeholderMap);
        }
    }

    @TestVisible
    private static Map<String, String> buildPlaceholderMap(List<MigrationPremiumTypes.PdfTemplateItem> data) {
        Map<String, String> retMap = new Map<String, String>();
        for (MigrationPremiumTypes.PdfTemplateItem item : data) {
            if (checkboxTranslationMap.containsKey(item.title + ':' + item.value)) {
                for (String placeholderValuePair : checkboxTranslationMap.get(item.title + ':' + item.value).split(',')){
                    retMap.put(placeholderValuePair.split(':').get(0), imgCheckBoxMap.get(placeholderValuePair.split(':').get(1)));
                    System.debug(placeholderValuePair);
                }
            } else {
                retMap.put(item.title, item.value);
            }
        }
        return retMap;
    }

    @TestVisible
    private static String buildPdfData(String template, Map<String, String> placeholderMap) {
        String pdfData = template;
        for (String placeholder : placeholderMap.keySet()) {
            pdfData = pdfData.replaceAll('@@' + placeholder + '@@', placeholderMap.get(placeholder));
            System.debug('replacing: ' + placeholder + ' by: ' + placeholderMap.get(placeholder));
        }
        //System.debug(pdfData);
        pdfData = pdfData.replaceAll('src="(?!\\/img)\\S*"', 'src="' + imgCheckBoxMap.get('unchecked') + '"');
        //System.debug(pdfData);
        pdfData = pdfData.replaceAll('\\@\\@\\S+\\@\\@', '&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;');
        //System.debug(pdfData);
        return pdfData;
    }

}