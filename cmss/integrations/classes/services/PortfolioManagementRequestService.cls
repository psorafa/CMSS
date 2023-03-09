public without sharing class PortfolioManagementRequestService {
	public static final String INVALID_REQUEST_STATUS = '2';
	public static final String INVALID_REQUEST_RESULT = '927';
	public static final String RETRY_INTERVAL_CONFIGURATION_MDT = 'changeCPERequest_retryCalloutInterval';
	public static final String RETRY_MAX_ATTEMPTS_MDT = 'changeCPERequest_retryCalloutAttempts';
	public static final String CASE_REFUSED_STATUS = '28';
	public static final String PMR_REFUSED_STATUS = '6';

	public static void setPortfolioManager(
		List<PortfolioManagementRequest__c> newList,
		Map<Id, PortfolioManagementRequest__c> oldMap
	) {
		Set<String> userCPUs = new Set<String>();
		for (PortfolioManagementRequest__c pmr : newList) {
			if (oldMap == null || oldMap.get(pmr.Id).PortfolioManagerCPU__c != pmr.PortfolioManagerCPU__c) {
				userCPUs.add(pmr.PortfolioManagerCPU__c);
			}
		}
		userCPUs.remove(null);
		Map<String, Id> usersByCPU = new Map<String, Id>();
		for (User u : [SELECT Id, CommissionAccountBase__c FROM User WHERE CommissionAccountBase__c IN :userCPUs]) {
			usersByCPU.put(u.CommissionAccountBase__c, u.Id);
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

	public static void setExternalId(List<PortfolioManagementRequest__c> newList) {
		List<PortfolioManagementRequest__c> updatedPMRs = new List<PortfolioManagementRequest__c>();
		for (PortfolioManagementRequest__c pmr : newList) {
			if (pmr.ExternalId__c == null) {
				PortfolioManagementRequest__c updatedPMR = new PortfolioManagementRequest__c(
					Id = pmr.Id,
					ExternalId__c = pmr.Id
				);
				updatedPMRs.add(updatedPMR);
			}
		}
		update updatedPMRs;
	}

	public static RequestsWrapper preparePMRs(Set<Id> caseIds) {
		Map<Id, List<PortfolioManagementRequest__c>> pmrByCaseId = new Map<Id, List<PortfolioManagementRequest__c>>();
		List<PortfolioManagementRequest__c> invalidRequests = new List<PortfolioManagementRequest__c>();
		PortfolioManagementRequest__c[] pmrs = queryPortfolioManagementRequests(caseIds);
		for (PortfolioManagementRequest__c pmr : pmrs) {
			pmr.BatchID__c = pmr.Case__c;
			if (pmr.Case__r.NewPortfolioManager__c != null) {
				pmr.PortfolioManager__c = pmr.Case__r.NewPortfolioManager__c;
			}
			if (pmr.Case__r.PortfolioManagementType__c != null) {
				pmr.PortfolioManagementType__c = pmr.Case__r.PortfolioManagementType__c;
			}
			if (
				pmr.Account__r.LastPtfManAChangeDate__c == null ||
				pmr.Account__r.LastPtfManAChangeDate__c < pmr.CreatedDate
			) {
				if (pmrByCaseId.get(pmr.Case__c) == null) {
					pmrByCaseId.put(pmr.Case__c, new List<PortfolioManagementRequest__c>());
				}
				pmrByCaseId.get(pmr.Case__c).add(pmr);
			} else {
				pmr.RequestStatus__c = INVALID_REQUEST_STATUS;
				pmr.PortfolioManChangeResult__c = INVALID_REQUEST_RESULT;
				invalidRequests.add(pmr);
			}
			if (pmr.Case__r.ChangeReason__c != null) {
				pmr.PortfolioManChangeReason__c = pmr.Case__r.ChangeReason__c;
			}
		}
		RequestsWrapper wrapper = new RequestsWrapper(pmrByCaseId, invalidRequests);
		return wrapper;
	}

	public static List<PortfolioManagementRequest__c> queryPortfolioManagementRequests(Set<Id> caseIds) {
		PortfolioManagementRequest__c[] pmrs = [
			SELECT
				Id,
				Case__c,
				Case__r.CPECallAttempts__c,
				Case__r.PortfolioManagementType__c,
				Case__r.NewPortfolioManager__c,
				Case__r.ChangeReason__c,
				Account__c,
				Account__r.GlobalId__c,
				Account__r.LastPtfManAChangeDate__c,
				PortfolioManChangeReason__c,
				ValidFrom__c,
				PortfolioManagementType__c,
				PortfolioManager__c,
				PortfolioManager__r.CommissionAccountBase__c,
				CreatedDate
			FROM PortfolioManagementRequest__c
			WHERE Case__c IN :caseIds
		];
		return pmrs;
	}

	@Future(Callout=true)
	public static void callCPEClientStateFuture(Set<Id> caseIds) {
		RequestsWrapper wrapper = PortfolioManagementRequestService.preparePMRs(caseIds);
		List<PortfolioManagementRequest__c> processedRequests = new List<PortfolioManagementRequest__c>();
		List<Case> processedCases = new List<Case>();
		for (Id caseId : caseIds) {
			if (wrapper.pmrsByCaseId.get(caseId) != null && !wrapper.pmrsByCaseId.get(caseId).isEmpty()) {
				processedCases.add(
					new Case(
						Id = caseId,
						Status = '27',
						CPECallAttempts__c = wrapper.pmrsByCaseId.get(caseId)[0].Case__r.CPECallAttempts__c + 1
					)
				);
				processedRequests.addAll(changeCPEClientState(wrapper.pmrsByCaseId.get(caseId)));
			}
		}
		if (!processedRequests.isEmpty()) {
			update processedRequests;
		}
		if (!wrapper.invalidRequests.isEmpty()) {
			update wrapper.invalidRequests;
		}
		update processedCases;
	}

	private static List<PortfolioManagementRequest__c> changeCPEClientState(List<PortfolioManagementRequest__c> pmrs) {
		try {
			User runningUser = [SELECT Id, CommissionAccountBase__c FROM User WHERE Id = :UserInfo.getUserId()];
			String commissionAccountNumber = runningUser.CommissionAccountBase__c;

			PortfolioManagementCalloutService.ListOfClientsStatesType clientStates = new PortfolioManagementCalloutService.ListOfClientsStatesType();
			clientStates.listOfClientsStatesItem = new List<PortfolioManagementCalloutService.ListOfClientsStatesItemType>{};

			for (PortfolioManagementRequest__c pmr : pmrs) {
				if (
					pmr.PortfolioManager__r.CommissionAccountBase__c != null &&
					pmr.Account__c != null &&
					pmr.PortfolioManagementType__c != null
				) {
					PortfolioManagementCalloutService.ListOfClientsStatesItemType item = new PortfolioManagementCalloutService.ListOfClientsStatesItemType();
					item.stateChangeRequestId = pmr.Id;
					item.accountId = pmr.Account__r.GlobalId__c;
					item.stateChangeReason = pmr.PortfolioManChangeReason__c;
					item.portfolioManagementType = pmr.PortfolioManagementType__c;
					if (pmr.PortfolioManagementType__c == 'A') {
						item.spS_A = pmr.PortfolioManager__r.CommissionAccountBase__c;
					} else {
						item.spS_C = pmr.PortfolioManager__r.CommissionAccountBase__c;
					}

					clientStates.listOfClientsStatesItem.add(item);
				} else {
					Logger.error('Request cannot be processed as it does not meet criteria', JSON.serializePretty(pmr));
				}
			}

			CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
			PortfolioManagementCalloutService.ChangeCPEClientStateRequestBody body = new PortfolioManagementCalloutService.ChangeCPEClientStateRequestBody();
			body.batchId = pmrs[0].Case__c;
			body.listOfClientStates = clientStates;
			body.commissionAccountNumberBase = commissionAccountNumber;

			PortfolioManagementCalloutService stub = new PortfolioManagementCalloutService();
			PortfolioManagementCalloutService.ChangeCPEClientStateResponseBody response = stub.changeCPEClientState_Http(
				header,
				body
			);

			if (
				response != null &&
				response.listOfRequestStatuses != null &&
				response.listOfRequestStatuses.listOfRequestStatusesItem != null
			) {
				List<PortfolioManagementRequest__c> pmrToUpdate = new List<PortfolioManagementRequest__c>();
				for (
					PortfolioManagementCalloutService.ListOfRequestStatusesItemType responseItem : response.listOfRequestStatuses.listOfRequestStatusesItem
				) {
					PortfolioManagementRequest__c pmr = new PortfolioManagementRequest__c(
						Id = responseItem.stateChangeRequestId,
						RequestStatus__c = responseItem.requestStatus
					);
					pmrToUpdate.add(pmr);
				}

				return pmrToUpdate;
			} else {
				Logger.error('Invalid response!');
				scheduleJobOfFailureCallout(pmrs, Double.valueOf(pmrs[0].Case__r.CPECallAttempts__c + 1));
				return new List<PortfolioManagementRequest__c>();
			}
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			scheduleJobOfFailureCallout(pmrs, Double.valueOf(pmrs[0].Case__r.CPECallAttempts__c + 1));
		} finally {
			Logger.saveLogs();
		}
		return null;
	}

	public static Id scheduleJobOfFailureCallout(List<PortfolioManagementRequest__c> pmrs, Double currentAttempt) {
		Integer maxAttempts = 1;
		if (Configuration__mdt.getInstance(RETRY_MAX_ATTEMPTS_MDT) != null) {
			maxAttempts = Integer.valueOf(
				((Configuration__mdt) Configuration__mdt.getInstance(RETRY_INTERVAL_CONFIGURATION_MDT)).Value__c
			);
		}
		if (currentAttempt <= maxAttempts) {
			Double initialInterval = 5;
			if (Configuration__mdt.getInstance(RETRY_INTERVAL_CONFIGURATION_MDT) != null) {
				initialInterval = Double.valueOf(
					((Configuration__mdt) Configuration__mdt.getInstance(RETRY_INTERVAL_CONFIGURATION_MDT)).Value__c
				);
			}
			DateTime dt = System.now().addMinutes(Integer.valueOf(Math.pow(initialInterval, currentAttempt)));
			String day = string.valueOf(dt.day());
			String month = string.valueOf(dt.month());
			String hour = string.valueOf(dt.hour());
			String minute = string.valueOf(dt.minute());
			String year = string.valueOf(dt.year());
			String scheduledTime = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
			PMRequestRetryCalloutSchedule job = new PMRequestRetryCalloutSchedule(
				(new Map<Id, sObject>(pmrs)).keySet()
			);
			return System.schedule('Schedule Job ' + dt, scheduledTime, job);
		} else {
			Map<Id, Case> casesToProcessMap = new Map<Id, Case>();
			for (PortfolioManagementRequest__c pmr : pmrs) {
				if (!casesToProcessMap.containsKey(pmr.Case__c)) {
					casesToProcessMap.put(pmr.Case__c, new Case(Id = pmr.Case__c, Status = CASE_REFUSED_STATUS));
				}
				pmr.RequestStatus__c = PMR_REFUSED_STATUS;
			}

			update casesToProcessMap.values();
			update pmrs;
		}
		return null;
	}

	public class RequestsWrapper {
		public Map<Id, List<PortfolioManagementRequest__c>> pmrsByCaseId { get; set; }
		public List<PortfolioManagementRequest__c> invalidRequests { get; set; }

		public RequestsWrapper(
			Map<Id, List<PortfolioManagementRequest__c>> pmrsByCaseId,
			List<PortfolioManagementRequest__c> invalidRequests
		) {
			this.pmrsByCaseId = pmrsByCaseId;
			this.invalidRequests = invalidRequests;
		}
	}
}
