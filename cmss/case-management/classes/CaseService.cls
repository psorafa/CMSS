public with sharing class CaseService {
	public static final String CASE_OWNER_MISSING_PERMISSION_ERR = 'Selected Owner doesn\'t have appropriate permission to handle this type of case.';

	public static final String CASE_PCF_RECORDTYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName()
		.get('PCF')
		.getRecordTypeId();

	public static final String CASE_PMCR_RECORDTYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
		.get('PortfolioManagementChangeRequest')
		.getRecordTypeId();

	public static void changeCPEClientState(List<Case> newCaseList, Map<Id, Case> oldCases) {
		if (FeatureManagement.checkPermission('Bypass_AQ_Messaging')) {
			return;
		}

		Set<Id> pmrCaseIds = new Set<Id>();
		for (Case newCase : newCaseList) {
			if (
				newCase.RecordTypeId == CASE_PMCR_RECORDTYPE_ID &&
				newCase.Status == '23' &&
				oldCases.get(newCase.Id).Status != '23'
			) {
				newCase.Status = '27';
				pmrCaseIds.add(newCase.Id);
			}
		}

		if (!pmrCaseIds.isEmpty()) {
			PortfolioManagementRequestService.callCPEClientStateFuture(pmrCaseIds);
		}
	}

	public static void setGDPRAndClientCaseOnAccount(List<Case> newCaseList, Map<Id, Case> oldCases) {
		Set<Id> allCaseAccIds = new Set<Id>();

		if (oldCases == null) {
			for (Case c : newCaseList) {
				if (c.AccountId != null && c.RecordTypeId != CASE_PCF_RECORDTYPE_ID) {
					allCaseAccIds.add(c.AccountId);
				}
			}
		} else {
			for (Case newCase : newCaseList) {
				Case oldCase = oldCases.get(newCase.Id);
				if (newCase.AccountId != oldCase.AccountId && newCase.RecordTypeId != CASE_PCF_RECORDTYPE_ID) {
					if (newCase.AccountId != null) {
						allCaseAccIds.add(newCase.AccountId);
					}
					if (oldCase.AccountId != null) {
						allCaseAccIds.add(oldCase.AccountId);
					}
				}
				if (newCase.Status != oldCase.Status && newCase.RecordTypeId != CASE_PCF_RECORDTYPE_ID) {
					if (newCase.AccountId != null) {
						allCaseAccIds.add(newCase.AccountId);
					}
				}
			}
		}

		if (allCaseAccIds.size() == 0) {
			return;
		}

		List<AggregateResult> activeClientCaseCounts = [
			SELECT AccountId, Count(Id) amount
			FROM Case
			WHERE
				AccountId IN :allCaseAccIds
				AND (RecordType.DeveloperName = 'NewClientClaim'
				OR RecordType.DeveloperName = 'ClientClaimConfirmationSent')
				AND Status = '1'
			GROUP BY AccountId
		];
		Map<Id, AggregateResult> idsToActiveClientCaseCounts = new Map<Id, AggregateResult>();
		for (AggregateResult ag : activeClientCaseCounts) {
			idsToActiveClientCaseCounts.put((Id) ag.get('AccountId'), ag);
		}

		List<AggregateResult> activeGDPRCaseCounts = [
			SELECT AccountId, Count(Id) amount
			FROM Case
			WHERE AccountId IN :allCaseAccIds AND RecordType.DeveloperName = 'GDPR' AND Status = '1'
			GROUP BY AccountId
		];
		Map<Id, AggregateResult> idsToActiveGDPRCaseCounts = new Map<Id, AggregateResult>();
		for (AggregateResult ag : activeGDPRCaseCounts) {
			idsToActiveGDPRCaseCounts.put((Id) ag.get('AccountId'), ag);
		}

		List<Account> accountsToUpdate = new List<Account>();
		for (Id accId : allCaseAccIds) {
			Account a = new Account(Id = accId);
			AggregateResult clientAG = idsToActiveClientCaseCounts.get(accId);
			if (clientAG != null) {
				a.ClientCase__c = (Integer) clientAG.get('amount') > 0 ? '1' : '0';
			} else {
				a.ClientCase__c = '0';
			}
			AggregateResult gdprAG = idsToActiveGDPRCaseCounts.get(accId);
			if (gdprAG != null) {
				a.GDPRCase__c = (Integer) gdprAG.get('amount') > 0 ? '1' : '0';
			} else {
				a.GDPRCase__c = '0';
			}
			accountsToUpdate.add(a);
		}

		update accountsToUpdate;
	}

	public static void assignCaseID(List<Case> newCaseList) {
		Set<Id> ClientClaimRecordTypes = new Set<Id>{
			SObjectType.Case.getRecordTypeInfosByDeveloperName().get('NewClientClaim').getRecordTypeId(),
			SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ClientClaimConfirmationSent').getRecordTypeId(),
			SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ClosedClientClaim').getRecordTypeId()
		};
		Set<Id> GDPRRecordTypes = new Set<Id>{
			SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDPR').getRecordTypeId(),
			SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ClosedGDPRClaim').getRecordTypeId()
		};

		NumericalSeriesSettings__c lastIssuedCaseID = NumericalSeriesSettings__c.getOrgDefaults();

		if (lastIssuedCaseID.GDPRClaimID__c == null) {
			lastIssuedCaseID.GDPRClaimID__c = 0;
		}
		if (lastIssuedCaseID.ClientClaimID__c == null) {
			lastIssuedCaseID.ClientClaimID__c = 0;
		}
		for (Case caseItem : newCaseList) {
			if (GDPRRecordTypes.contains(caseItem.RecordTypeId)) {
				lastIssuedCaseID.GDPRClaimID__c += 1;
				caseItem.CaseID__c = String.valueOf(
						'' +
						Integer.valueOf(lastIssuedCaseID.GDPRClaimID__c) +
						Date.today().year()
					)
					.leftPad(10, '0');
			}
			if (ClientClaimRecordTypes.contains(caseItem.RecordTypeId)) {
				lastIssuedCaseID.ClientClaimID__c += 1;
				caseItem.CaseID__c =
					String.valueOf('' + Date.today().year()) +
					String.valueOf(Integer.valueOf(lastIssuedCaseID.ClientClaimID__c)).leftPad(5, '0');
			}
		}
		upsert lastIssuedCaseID;
	}

	public static void validateOwnerPermission(List<Case> newCases, Map<Id, Case> oldCases) {
		Id GDPRRecordTypeId = RecordTypeUtils.getRecordTypeIdByDeveloperName('GDPR', 'Case');
		Id CCCSRecordTypeId = RecordTypeUtils.getRecordTypeIdByDeveloperName('ClientClaimConfirmationSent', 'Case');
		Id NCCRecordTypeId = RecordTypeUtils.getRecordTypeIdByDeveloperName('NewClientClaim', 'Case');

		Map<Id, List<Case>> ownerIdsToCases = new Map<Id, List<Case>>();
		Set<Case> errorCases = new Set<Case>();
		if (oldCases == null) {
			for (Case c : newCases) {
				if (
					c.RecordTypeId == GDPRRecordTypeId ||
					c.RecordTypeId == CCCSRecordTypeId ||
					c.RecordTypeId == NCCRecordTypeId
				) {
					setupOwnerIdsToCases(ownerIdsToCases, c);
					errorCases.add(c);
				}
			}
		} else {
			for (Case newCase : newCases) {
				Case oldCase = oldCases.get(newCase.Id);
				if (
					newCase.OwnerId != oldCase.OwnerId &&
					(newCase.RecordTypeId == GDPRRecordTypeId ||
					newCase.RecordTypeId == CCCSRecordTypeId ||
					newCase.RecordTypeId == NCCRecordTypeId)
				) {
					setupOwnerIdsToCases(ownerIdsToCases, newCase);
					errorCases.add(newCase);
				}
			}
		}

		Map<Id, CustomPermission> idsToCustomPermissions = new Map<Id, CustomPermission>(
			[
				SELECT DeveloperName
				FROM CustomPermission
				WHERE
					DeveloperName IN ('ClaimCaseManager', 'ClientOmbudsman', 'GDPRCaseManager')
					AND NamespacePrefix = NULL
			]
		);

		Boolean GDPRCaseManagerHasCustPerm = false;
		Boolean ClientOmbudsmanHasCustPerm = false;
		Boolean CaseManagerHasCustPerm = false;

		Set<Id> permissionSetIds = new Set<Id>();
		for (SetupEntityAccess sea : [
			SELECT ParentId, Parent.Name, SetupEntityId
			FROM SetupEntityAccess
			WHERE
				SetupEntityId IN :idsToCustomPermissions.keySet()
				AND Parent.Name IN ('CaseManager', 'ClientOmbudsman', 'GDPRCaseManager')
		]) {
			String custPermDevName = idsToCustomPermissions.get(sea.SetupEntityId).DeveloperName;
			if (sea.Parent.Name == 'GDPRCaseManager' && custPermDevName == 'GDPRCaseManager') {
				GDPRCaseManagerHasCustPerm = true;
			} else if (sea.Parent.Name == 'ClientOmbudsman' && custPermDevName == 'ClientOmbudsman') {
				ClientOmbudsmanHasCustPerm = true;
			} else if (sea.Parent.Name == 'CaseManager' && custPermDevName == 'ClaimCaseManager') {
				CaseManagerHasCustPerm = true;
			}

			permissionSetIds.add(sea.ParentId);
		}

		for (PermissionSetAssignment psa : [
			SELECT AssigneeId, PermissionSetId, PermissionSet.Name
			FROM PermissionSetAssignment
			WHERE PermissionSetId IN :permissionSetIds AND AssigneeId IN :ownerIdsToCases.keySet()
		]) {
			List<Case> cases = ownerIdsToCases.get(psa.AssigneeId);
			for (Case c : cases) {
				if (
					(c.RecordTypeId == GDPRRecordTypeId &&
					psa.PermissionSet.Name == 'GDPRCaseManager' &&
					GDPRCaseManagerHasCustPerm) ||
					((c.RecordTypeId == CCCSRecordTypeId || c.RecordTypeId == NCCRecordTypeId) &&
					((psa.PermissionSet.Name == 'ClientOmbudsman' && ClientOmbudsmanHasCustPerm) ||
					(psa.PermissionSet.Name == 'CaseManager' && CaseManagerHasCustPerm)))
				) {
					errorCases.remove(c);
				}
			}
		}

		for (Case c : errorCases) {
			c.addError(CASE_OWNER_MISSING_PERMISSION_ERR);
		}
	}

	public static void populateUserLookupsFromCPU(List<Case> newList, Map<Id, Case> oldMap) {
		Set<String> complainerContractorCPUs = new Set<String>();
		Set<String> contractorCPUs = new Set<String>();
		for (Case c : newList) {
			if (oldMap == null || oldMap.get(c.Id).ComplainerContractorCPU__c != c.ComplainerContractorCPU__c) {
				complainerContractorCPUs.add(c.ComplainerContractorCPU__c);
			}
			if (oldMap == null || oldMap.get(c.Id).ContractorCPU__c != c.ContractorCPU__c) {
				contractorCPUs.add(c.ContractorCPU__c);
			}
		}
		complainerContractorCPUs.remove(null);
		contractorCPUs.remove(null);
		Map<String, Id> usersByCPU = new Map<String, Id>();
		for (User u : [
			SELECT Id, CommissionAccountBase__c
			FROM User
			WHERE CommissionAccountBase__c IN :complainerContractorCPUs OR CommissionAccountBase__c IN :contractorCPUs
		]) {
			usersByCPU.put(u.CommissionAccountBase__c, u.Id);
		}
		for (Case c : newList) {
			if (oldMap == null || oldMap.get(c.Id).ComplainerContractorCPU__c != c.ComplainerContractorCPU__c) {
				c.ComplainerContractor__c = usersByCPU.get(c.ComplainerContractorCPU__c);
				if (c.ComplainerContractorCPU__c != null && c.ComplainerContractor__c == null) {
					c.ComplainerContractorCPU__c.addError(Label.NoUserWithThisCPUFound);
				}
			}
			if (oldMap == null || oldMap.get(c.Id).ContractorCPU__c != c.ContractorCPU__c) {
				c.Contractor__c = usersByCPU.get(c.ContractorCPU__c);
				if (c.ContractorCPU__c != null && c.Contractor__c == null) {
					c.ContractorCPU__c.addError(Label.NoUserWithThisCPUFound);
				}
			}
		}
	}

	private static void setupOwnerIdsToCases(Map<Id, List<Case>> ownerIdsToCases, Case c) {
		List<Case> cases = ownerIdsToCases.get(c.OwnerId);
		if (cases == null) {
			ownerIdsToCases.put(c.OwnerId, new List<Case>{ c });
		} else {
			cases.add(c);
			ownerIdsToCases.put(c.OwnerId, cases);
		}
	}

	public static void setupCaseStatuses(List<Case> newCases) {
		for (Case singleCase : newCases) {
			if (
				singleCase.TotalRequestsNumber__c != null &&
				singleCase.CompletedRequestsNumber__c == singleCase.TotalRequestsNumber__c
			) {
				if (singleCase.TotalRequestsNumber__c == singleCase.SuccessRequestsNumber__c) {
					singleCase.Status = '29';
				}
				if (singleCase.TotalRequestsNumber__c > singleCase.SuccessRequestsNumber__c) {
					singleCase.Status = '30';
				}
			}
		}
	}

	public class CaseOwnerPermissionMissingException extends Exception {
	}
}
