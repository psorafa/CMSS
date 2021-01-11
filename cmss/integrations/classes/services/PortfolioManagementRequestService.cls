public with sharing class PortfolioManagementRequestService {

    public static final String NO_USER_WITH_SUCH_CPU_ERR = 'No user exists with this CPU. Please insert a different user\'s CPU.';
    public static final String MULTIPLE_BATCH_IDS_ERR = 'All created requests must contain identical Batch ID.';

    public static void setPortfolioManager(PortfolioManagementRequest__c[] newPMRs, Map<Id, PortfolioManagementRequest__c> oldPMRs) {
        Map<String, PortfolioManagementRequest__c[]> portfolioManagerCPUsToPMRs = new Map<String, PortfolioManagementRequest__c[]>();
        Set<String> pmCPUs = new Set<String>();

        if (oldPMRs == null) {
            for (PortfolioManagementRequest__c newPMR : newPMRs) {
                if (newPMR.PortfolioManagerCPU__c != null) {
                    setupPortfolioManagerCPUsToPMRs(portfolioManagerCPUsToPMRs, newPMR);
                    pmCPUs.add(newPMR.PortfolioManagerCPU__c);
                }
            }
        } else {
            for (PortfolioManagementRequest__c newPMR : newPMRs) {
                PortfolioManagementRequest__c oldPMR = oldPMRs.get(newPMR.Id);
                if (newPMR.PortfolioManagerCPU__c != null && newPMR.PortfolioManagerCPU__c != oldPMR.PortfolioManagerCPU__c) {
                    setupPortfolioManagerCPUsToPMRs(portfolioManagerCPUsToPMRs, newPMR);
                    pmCPUs.add(newPMR.PortfolioManagerCPU__c);
                }
            }
        }
        
        for (User u : [
            SELECT CommissionAccountNr__c 
            FROM User 
            WHERE CommissionAccountNr__c IN :portfolioManagerCPUsToPMRs.keySet()
        ]) {
            PortfolioManagementRequest__c[] pmrs = portfolioManagerCPUsToPMRs.get(u.CommissionAccountNr__c);
            pmCPUs.remove(u.CommissionAccountNr__c);

            for (PortfolioManagementRequest__c pmr : pmrs) {
                pmr.PortfolioManager__c = u.Id;
            }
        }

        if (pmCPUs.size() > 0) {
            throw new NoUserWithSuchCPUException(NO_USER_WITH_SUCH_CPU_ERR);
        }
    }

    public static void changeCPEClientState(PortfolioManagementRequest__c[] newPMRs) {
        String batchId = newPMRs[0].BatchID__c;

        for (PortfolioManagementRequest__c pmr : newPMRs) {
            if (batchId != pmr.BatchID__c) {
                throw new MultipleBatchIdsException(MULTIPLE_BATCH_IDS_ERR);
            }
        }

        changeCPEClientStateFuture(new Map<Id, PortfolioManagementRequest__c>(newPMRs).keySet(), batchId);
    }

    @future(callout=true)
    private static void changeCPEClientStateFuture(Set<Id> pmrIds, String batchId) {
        PortfolioManagementRequest__c[] pmrs = [
            SELECT Account__c, PortfolioManChangeReason__c, ValidFrom__c, PortfolioManagementType__c, PortfolioManagerCPU__c
            FROM PortfolioManagementRequest__c
            WHERE Id IN :pmrIds
        ];

        PortfolioManagementCalloutService.ListOfClientsStatesType clientStates = new PortfolioManagementCalloutService.ListOfClientsStatesType();
        clientStates.listOfClientsStatesItem = new PortfolioManagementCalloutService.ListOfClientsStatesItemType[]{};

        for (PortfolioManagementRequest__c pmr : pmrs) {
            if (pmr.PortfolioManagerCPU__c != null &&
                pmr.Account__c != null &&
                pmr.PortfolioManChangeReason__c != null &&
                pmr.ValidFrom__c != null &&
                pmr.PortfolioManagementType__c != null) {

                PortfolioManagementCalloutService.ListOfClientsStatesItemType item = new PortfolioManagementCalloutService.ListOfClientsStatesItemType();
                item.stateChangeRequestId = pmr.Id;
                item.accountId = pmr.Account__c;
                item.stateChangeReason = pmr.PortfolioManChangeReason__c;
                item.validFrom = pmr.ValidFrom__c;
                item.portfolioManagementType = pmr.PortfolioManagementType__c;
                if (pmr.PortfolioManagementType__c == 'A') {
                    item.spS_A = pmr.PortfolioManagerCPU__c;
                } else if (pmr.PortfolioManagementType__c == 'C') {
                    item.spS_C = pmr.PortfolioManagerCPU__c;
                }

                clientStates.listOfClientsStatesItem.add(item);
            }
        }

        if (clientStates.listOfClientsStatesItem.size() > 0) {
            CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
            PortfolioManagementCalloutService.ChangeCPEClientStateRequestBody body = new PortfolioManagementCalloutService.ChangeCPEClientStateRequestBody();
            body.batchId = batchId;
            body.listOfClientStates = clientStates;

            PortfolioManagementCalloutService.PortfolioManagementServicePort stub = new PortfolioManagementCalloutService.PortfolioManagementServicePort();
            PortfolioManagementCalloutService.ChangeCPEClientStateResponseBody response = stub.changeCPEClientState_Http(header, body);

            Logger.saveLogs();
        }
    }

    private static void setupPortfolioManagerCPUsToPMRs(Map<String, PortfolioManagementRequest__c[]> portfolioManagerCPUsToPMRs, PortfolioManagementRequest__c pmr) {
        PortfolioManagementRequest__c[] pmrs = portfolioManagerCPUsToPMRs.get(pmr.PortfolioManagerCPU__c);
        if (pmrs == null) {
            portfolioManagerCPUsToPMRs.put(pmr.PortfolioManagerCPU__c, new PortfolioManagementRequest__c[]{ pmr });
        } else {
            pmrs.add(pmr);
            portfolioManagerCPUsToPMRs.put(pmr.PortfolioManagerCPU__c, pmrs);
        }
    }

    public class MultipleBatchIdsException extends Exception {}
    public class NoUserWithSuchCPUException extends Exception {}
}
