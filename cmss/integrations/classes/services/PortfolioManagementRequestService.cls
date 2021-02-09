public without sharing class PortfolioManagementRequestService {

	public static final String MULTIPLE_BATCH_IDS_ERR = 'All created requests must contain identical Batch ID.';

	public static void setPortfolioManager(List<PortfolioManagementRequest__c> newList, Map<Id, PortfolioManagementRequest__c> oldMap) {
		Set<String> userCPUs = new Set<String>();
		for (PortfolioManagementRequest__c pmr : newList) {
			if (oldMap == null || oldMap.get(pmr.Id).PortfolioManagerCPU__c != pmr.PortfolioManagerCPU__c) {
				userCPUs.add(pmr.PortfolioManagerCPU__c);
			}
		}
		userCPUs.remove(null);
		Map<String, Id> usersByCPU = new Map<String, Id>();
		for (User u : [SELECT Id, CommissionAccountNr__c FROM User WHERE CommissionAccountNr__c IN :userCPUs]) {
			usersByCPU.put(u.CommissionAccountNr__c, u.Id);
		}
		for (PortfolioManagementRequest__c pmr : newList) {
			if (oldMap == null || oldMap.get(pmr.Id).PortfolioManagerCPU__c != pmr.PortfolioManagerCPU__c) {
				pmr.PortfolioManager__c = usersByCPU.get(pmr.PortfolioManagerCPU__c);
				if (pmr.PortfolioManagerCPU__c != null && pmr.PortfolioManager__c == null) {
					pmr.PortfolioManagerCPU__c.addError(Label.NoUserWithThisCPUFound);
				}
			}
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

	@Future(Callout=true)
	private static void changeCPEClientStateFuture(Set<Id> pmrIds, String batchId) {
		try {
			PortfolioManagementRequest__c[] pmrs = [
				SELECT Account__c, Account__r.GlobalId__c, PortfolioManChangeReason__c, ValidFrom__c, PortfolioManagementType__c, PortfolioManager__r.CommissionAccountNr__c
				FROM PortfolioManagementRequest__c
				WHERE Id IN :pmrIds
			];

			PortfolioManagementCalloutService.ListOfClientsStatesType clientStates = new PortfolioManagementCalloutService.ListOfClientsStatesType();
			clientStates.listOfClientsStatesItem = new PortfolioManagementCalloutService.ListOfClientsStatesItemType[]{
			};

			for (PortfolioManagementRequest__c pmr : pmrs) {
				if (pmr.PortfolioManager__r.CommissionAccountNr__c != null &&
					pmr.Account__c != null &&
					pmr.PortfolioManChangeReason__c != null &&
					pmr.ValidFrom__c != null &&
					pmr.PortfolioManagementType__c != null
					) {

					PortfolioManagementCalloutService.ListOfClientsStatesItemType item = new PortfolioManagementCalloutService.ListOfClientsStatesItemType();
					item.stateChangeRequestId = pmr.Id;
					item.accountId = pmr.Account__r.GlobalId__c;
					item.stateChangeReason = pmr.PortfolioManChangeReason__c;
					item.validFrom = pmr.ValidFrom__c.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
					item.validFrom = item.validFrom.substring(0, item.validFrom.length() - 2) + ':00';
					item.portfolioManagementType = pmr.PortfolioManagementType__c;
					if (pmr.PortfolioManagementType__c == 'A') {
						item.spS_A = pmr.PortfolioManager__r.CommissionAccountNr__c;
					} else {
						item.spS_C = pmr.PortfolioManager__r.CommissionAccountNr__c;
					}

					clientStates.listOfClientsStatesItem.add(item);
				} else {
					Logger.error('Request cannot be processed as it does not meet criteria', JSON.serializePretty(pmr));
				}
			}

			CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
			PortfolioManagementCalloutService.ChangeCPEClientStateRequestBody body = new PortfolioManagementCalloutService.ChangeCPEClientStateRequestBody();
			body.batchId = batchId;
			body.listOfClientStates = clientStates;

			PortfolioManagementCalloutService.PortfolioManagementServicePort stub = new PortfolioManagementCalloutService.PortfolioManagementServicePort();
			stub.changeCPEClientState_Http(header, body);
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	public class MultipleBatchIdsException extends Exception {
	}
}
