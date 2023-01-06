public with sharing class PMRequestRetryCalloutSchedule implements Schedulable {
    public Set<Id> pmrIds;
    public String batchId;
    public Double attemptsCount;
    public PMRequestRetryCalloutSchedule(Set<Id> pmrIds, String batchId, Double attemptsCount) {
        this.pmrIds = pmrIds;
        this.batchId = batchId;
        this.attemptsCount = attemptsCount;
    }
    public void execute(SchedulableContext oSchCxt) {     
        ScheduleCalloutQueueable sCalloutQueueable = new ScheduleCalloutQueueable(pmrIds, batchId, attemptsCount);
        System.enqueueJob(sCalloutQueueable);
    }     
    
    public class ScheduleCalloutQueueable implements Queueable, Database.AllowsCallouts {
        public Set<Id> pmrIds;
        public String batchId;
        public Double attemptsCount;
        public ScheduleCalloutQueueable(Set<Id> pmrIds, String batchId, Double attemptsCount) {
            this.pmrIds = pmrIds;
            this.batchId = batchId;          
            this.attemptsCount = attemptsCount;  
        }
        public void execute(QueueableContext context) { 
            PortfolioManagementRequestService.changeCPEClientStateFuture(pmrIds, batchId, attemptsCount);
        }
    }
} 