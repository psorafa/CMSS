public without sharing class PortfolioManagementRequestService {

    public static final String INVALID_REQUEST_STATUS = '2';
    public static final String INVALID_REQUEST_RESULT = '927';
    public static final String RETRY_INTERVAL_CONFIGURATION_MDT = 'changeCPERequest_retryCalloutInterval';
    public static final String RETRY_MAX_ATTEMPTS_MDT = 'changeCPERequest_retryCalloutAttempts';

	public static void setPortfolioManager(List<PortfolioManagementRequest__c> newList, Map<Id, PortfolioManagementRequest__c> oldMap) {
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

    @Future
    public static void updateInvalidRequests(Set<Id> invalidRequestIds) {
        List<PortfolioManagementRequest__c> invalidRequests = new List<PortfolioManagementRequest__c>();
        for (Id pmrId : invalidRequestIds) {
            PortfolioManagementRequest__c pmr = new PortfolioManagementRequest__c(
                Id = pmrId,
                RequestStatus__c = INVALID_REQUEST_STATUS,
                PortfolioManChangeResult__c = INVALID_REQUEST_RESULT
            );
            invalidRequests.add(pmr);
        }
        update invalidRequests;
    }

    public static Map<Id, Set<Id>> preparePMRs(Map<Id, Case> changeCPERequestCasesMap) {
        Map<Id, Set<Id>> pmrIdsByCaseId = new Map<Id, Set<Id>>();
        Set<Id> invalidRequests = new Set<Id>();

        PortfolioManagementRequest__c[] pmrs = queryPortfolioManagementRequests(changeCPERequestCasesMap.keySet());

        for (PortfolioManagementRequest__c pmr : pmrs) {
            pmr.BatchID__c = pmr.Case__c;
            if (changeCPERequestCasesMap.get(pmr.Case__c).NewPortfolioManager__c != null) {
                pmr.PortfolioManager__c = changeCPERequestCasesMap.get(pmr.Case__c).NewPortfolioManager__c;
            }
            if (changeCPERequestCasesMap.get(pmr.Case__c).PortfolioManagementType__c != null) {
                pmr.PortfolioManagementType__c = changeCPERequestCasesMap.get(pmr.Case__c).PortfolioManagementType__c;
            }
            if (pmr.Account__r.LastPtfManAChangeDate__c == null || pmr.Account__r.LastPtfManAChangeDate__c < pmr.CreatedDate) {
                if (pmrIdsByCaseId.get(pmr.Case__c) == null) {
                    pmrIdsByCaseId.put(pmr.Case__c, new Set<Id>());
                }
                pmrIdsByCaseId.get(pmr.Case__c).add(pmr.Id);
            } else {
                invalidRequests.add(pmr.Id);
            }                
        }
        
        updateInvalidRequests(invalidRequests);
        
        return pmrIdsByCaseId;
    }

    public static List<PortfolioManagementRequest__c> queryPortfolioManagementRequests(Set<Id> caseIds) {
        PortfolioManagementRequest__c[] pmrs = [
            SELECT
                Id,
                Case__c,
                Account__c, 
                Account__r.GlobalId__c, 
                Account__r.LastPtfManAChangeDate__c, 
                PortfolioManChangeReason__c, 
                ValidFrom__c, 
                PortfolioManagementType__c, 
                PortfolioManager__c,
                CreatedDate
            FROM PortfolioManagementRequest__c
            WHERE Case__c IN: caseIds
        ];
        return pmrs;
    }

	@Future(Callout=true)
	public static void changeCPEClientStateFuture(Set<Id> pmrIds, String batchId, Double attemptsCount) {
		try {

			PortfolioManagementRequest__c[] pmrs = [
				SELECT Account__c, Account__r.GlobalId__c, PortfolioManChangeReason__c, ValidFrom__c, PortfolioManagementType__c, PortfolioManager__r.CommissionAccountBase__c
				FROM PortfolioManagementRequest__c
				WHERE Id IN :pmrIds
			];

			User runningUser = [SELECT Id, CommissionAccountBase__c FROM User WHERE Id = :UserInfo.getUserId()];
			String commissionAccountNumber = runningUser.CommissionAccountBase__c;

			PortfolioManagementCalloutService.ListOfClientsStatesType clientStates = new PortfolioManagementCalloutService.ListOfClientsStatesType();
			clientStates.listOfClientsStatesItem = new PortfolioManagementCalloutService.ListOfClientsStatesItemType[]{};

			for (PortfolioManagementRequest__c pmr : pmrs) {
				if (pmr.PortfolioManager__r.CommissionAccountBase__c != null &&
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
			body.batchId = batchId;
			body.listOfClientStates = clientStates;
			body.commissionAccountNumberBase = commissionAccountNumber;

			PortfolioManagementCalloutService.PortfolioManagementServicePort stub = new PortfolioManagementCalloutService.PortfolioManagementServicePort();
			PortfolioManagementCalloutService.ChangeCPEClientStateResponseBody response = stub.changeCPEClientState_Http(header, body);

			if (response != null && response.listOfRequestStatuses != null && response.listOfRequestStatuses.listOfRequestStatusesItem != null) {
				List<PortfolioManagementRequest__c> pmrToUpdate = new List<PortfolioManagementRequest__c>();
				for (PortfolioManagementCalloutService.ListOfRequestStatusesItemType responseItem : response.listOfRequestStatuses.listOfRequestStatusesItem) {
					PortfolioManagementRequest__c pmr = new PortfolioManagementRequest__c(Id = responseItem.stateChangeRequestId, RequestStatus__c = responseItem.requestStatus);
					pmrToUpdate.add(pmr);
				}
				if (!pmrToUpdate.isEmpty() && !Test.isRunningTest()) {
					update pmrToUpdate;
				}
			} else {
				Logger.error('Invalid response!');
                scheduleJobOfFailureCallout(pmrIds, batchId, attemptsCount);
			}

		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
            scheduleJobOfFailureCallout(pmrIds, batchId, attemptsCount);
			throw e;
		} finally {
            CaseService.updateCPECallCounter(batchId, Double.valueOf(attemptsCount + 1));
			Logger.saveLogs();
		}
	}

    public static Id scheduleJobOfFailureCallout(Set<Id> pmrIds, String batchId, Double attemptsCount) {
        Integer maxAttempts = 1;
        if (Configuration__mdt.getInstance(RETRY_MAX_ATTEMPTS_MDT) != null) {
            maxAttempts = Integer.valueOf(((Configuration__mdt) Configuration__mdt.getInstance(RETRY_INTERVAL_CONFIGURATION_MDT)).Value__c);
        }
        if ((attemptsCount + 1) <= maxAttempts) {
            Double initialInterval = 5;
            if (Configuration__mdt.getInstance(RETRY_INTERVAL_CONFIGURATION_MDT) != null) {
                initialInterval = Double.valueOf(((Configuration__mdt) Configuration__mdt.getInstance(RETRY_INTERVAL_CONFIGURATION_MDT)).Value__c);
            }
            DateTime dt = System.now().addMinutes(Integer.valueOf(Math.pow(initialInterval, (attemptsCount + 1))));
            String day = string.valueOf(dt.day());                    
            String month = string.valueOf(dt.month());                      
            String hour = string.valueOf(dt.hour());                   
            String minute = string.valueOf(dt.minute());                                   
            String year = string.valueOf(dt.year());                  
            String scheduledTime = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
            PMRequestRetryCalloutSchedule job = new PMRequestRetryCalloutSchedule(pmrIds, batchId, attemptsCount);
            return System.schedule('Schedule Job ' + dt, scheduledTime, job);
        }
        return null;
    }
}