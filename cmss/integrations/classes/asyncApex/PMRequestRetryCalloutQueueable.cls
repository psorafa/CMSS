public with sharing class PMRequestRetryCalloutQueueable implements Queueable {
    public Set<Id> pmrIds;
    public PMRequestRetryCalloutQueueable(Set<Id> pmrIds) {
        this.pmrIds = pmrIds;
    }
    public void execute(QueueableContext context) { 
        PortfolioManagementRequestService.callCPEClientStateFuture(pmrIds);
    }
}