public with sharing class PMRequestRetryCalloutSchedule implements Schedulable {
    public Set<Id> pmrIds;
    public PMRequestRetryCalloutSchedule(Set<Id> pmrIds) {
        this.pmrIds = pmrIds;
    }
    public void execute(SchedulableContext oSchCxt) {     
        PMRequestRetryCalloutQueueable callout = new PMRequestRetryCalloutQueueable(pmrIds);
        System.enqueueJob(callout);
    }     
} 