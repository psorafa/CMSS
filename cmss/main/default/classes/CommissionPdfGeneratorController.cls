public with sharing class CommissionPdfGeneratorController {

    public String html {get; set;}

    public CommissionPdfGeneratorController() {
        System.debug(ApexPages.currentPage().getParameters());
        html = ApexPages.currentPage().getParameters().get('html');
    }
}