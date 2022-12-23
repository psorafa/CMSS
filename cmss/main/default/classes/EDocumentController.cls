global with sharing class EDocumentController {
    public String base64Data { get; set; }
    public Boolean showPDF { get; set; }
    public Boolean isError { get; set; }
    public String recordId { get; set; }

    public EDocumentController(ApexPages.StandardController controller){
        recordId = Apexpages.currentPage().getParameters().get('recordId');
        isError = false;
        showPDF = false;
    }

    public PageReference loadDocument() {
        Task sourceTask;
        try{
            sourceTask = [SELECT Id, LetterId__c, LetterType__c
                      FROM Task
                      WHERE Id = :recordId];

            CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
            EDocumentSOAPService.GetDocumentBySBIdRequestBody body = new EDocumentSOAPService.GetDocumentBySBIdRequestBody();
            body.documentSBId = sourceTask.LetterId__c;
            EDocumentSOAPService.EDocumentServicePort stub = new EDocumentSOAPService.EDocumentServicePort();
            base64Data = stub.getDocumentBySBId_Http(header, body);
            showPDF = true;
        } catch (Exception e){
            Logger.error('Error in EDocumentController', e);
            isError = true;
            showPDF = false;
        } finally{
            createAccessLogRecord(sourceTask.LetterId__c, sourceTask.LetterType__c, sourceTask.Id);
            Logger.saveLogs();
        }
        return null;
    }

    @TestVisible
    private void createAccessLogRecord(String letterId, String letterType, String taskId){
        Access_Log__c log = new Access_Log__c();
        log.RequestedBy__c = UserInfo.getUserId();
        log.TaskLetterId__c = letterId;
        log.TaskLetterType__c = letterType;
        log.TaskId__c = taskId;
        insert log;
    }

}