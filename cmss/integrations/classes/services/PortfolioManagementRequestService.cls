public with sharing class PortfolioManagementRequestService {

    public static void changeCPEClientState(PortfolioManagementRequest__c[] newPMRs) {
        String batchId = newPMRs[0].BatchID__c;

        for (PortfolioManagementRequest__c pmr : newPMRs) {
            if (batchId != pmr.BatchID__c) {
                throw new MultipleBatchIdsException('All created requests must contain identical Batch ID.');
            }
        }

        changeCPEClientStateFuture(new Map<Id, PortfolioManagementRequest__c>(newPMRs).keySet(), batchId);
    }

    @future(callout=true)
    private static void changeCPEClientStateFuture(Set<Id> pmrIds, String batchId) {
        PortfolioManagementRequest__c[] pmrs = [
            SELECT Account__c, PortfolioManChangeReason__c, ValidFrom__c, PortfolioManagementType__c, PortfolioManagerCPU__c
            FROM PortfolioManagementRequest__c
            WHERE Id IN: pmrIds
        ];

        PortfolioManagementService.ListOfClientsStatesType clientStates = new PortfolioManagementService.ListOfClientsStatesType();
        clientStates.listOfClientsStatesItem = new PortfolioManagementService.ListOfClientsStatesItemType[]{};

        for (PortfolioManagementRequest__c pmr : pmrs) {
            PortfolioManagementService.ListOfClientsStatesItemType item = new PortfolioManagementService.ListOfClientsStatesItemType();
            item.stateChangeRequestId = pmr.Id;
            item.accountId_x = pmr.Account__c;
            item.stateChangeReason = pmr.PortfolioManChangeReason__c;
            item.validFrom = String.valueOfGmt(pmr.ValidFrom__c);
            item.portfolioManagementType = pmr.PortfolioManagementType__c;
            if (pmr.PortfolioManagementType__c == 'A') {
                item.spS_A = pmr.PortfolioManagerCPU__c;
            } else if (pmr.PortfolioManagementType__c == 'C') {
                item.spS_C = pmr.PortfolioManagerCPU__c;
            }

            clientStates.listOfClientsStatesItem.add(item);
        }

        PortfolioManagementService.ChangeCPEClientStateRequestBody body = new PortfolioManagementService.ChangeCPEClientStateRequestBody();
        body.batchId = batchId;
        body.listOfClientStates = clientStates;

        PortfolioManagementService.PortfolioManagementServicePort stub = new PortfolioManagementService.PortfolioManagementServicePort();
        PortfolioManagementService.ChangeCPEClientStateResponseBody response = stub.changeCPEClientState(body);
    }

    public class MultipleBatchIdsException extends Exception {}
}
