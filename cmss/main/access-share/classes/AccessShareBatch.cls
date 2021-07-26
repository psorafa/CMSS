/*
 * Created by mkyoung01 on 5/13/19.
 */

global class AccessShareBatch implements Database.Batchable<sObject>, Database.Stateful {
	string type;
	private Id[] deletedIds = new List<Id>();
	private String[] errors = new List<String>();
	global AccessShareBatch(String t) {
		type = t;
	}

	global Database.QueryLocator start(Database.BatchableContext bc) {
		System.debug('### start');
		System.debug('### type: ' + type);
		return Database.getQueryLocator(
			[
				SELECT
					AccessTo__c,
					CreatedById,
					CreatedDate,
					ExpirationDate__c,
					Id,
					IsDeleted,
					LastModifiedById,
					LastModifiedDate,
					LastReferencedDate,
					LastViewedDate,
					Name,
					Reason__c,
					RequestedBy__c,
					StartDate__c,
					SystemModstamp,
					Type__c
				FROM AccessShare__c
				WHERE ExpirationDate__c <= :Datetime.now() AND Type__c = :type
			]
		);
	}

	public Void execute(Database.BatchableContext jobId, List<AccessShare__c> accessShareList) {
		System.debug('### execute');
		Map<Id, Set<Id>> accountIdByUser = new Map<Id, Set<id>>();
		Set<Id> accountIds = new Set<Id>();

		for (AccessShare__c accessShare : accessShareList) {
			Utils.addToMapsSet(accountIdByUser, accessShare.RequestedBy__c, accessShare.AccessTo__c);
			accountIds.add(accessShare.AccessTo__c);
		}
		// for all account share - for all accessshare - if match tak obohatit accessShareDao o reason
		//mozna prepsat user a account na UserAccountId - merge
		//all manual account share
		Set<AccessShareDTO.Remove> accessShareDtoRemoves = new Set<AccessShareDTO.Remove>();
		List<AccountShare> accountShareListToRemove = new List<AccountShare>();
		for (
			AccountShare accountSh : AccountShareDao.getAccountShareByUserAndAccountIds(
				accountIdByUser.keyset(),
				accountIds
			)
		) {
			if (accountIdByUser.get(accountSh.userOrGroupId).contains(accountSh.AccountId))
				accountShareListToRemove.add(accountSh);
			for (AccessShare__c accessSh : accessShareList) {
				if (accessSh.RequestedBy__c == accountSh.UserOrGroupId && accessSh.AccessTo__c == accountSh.AccountId) {
					AccessShareController.addAccessShareDtoRemoveToSet(
						accountSh,
						accessSh.Reason__c,
						accessShareDtoRemoves
					);
				}
			}
		}
		//all accessShares with all types
		List<AccessShare__c> accessSharesToConsider = new List<AccessShare__C>();
		for (
			AccessShare__c AccessSh : AccessShareDao.getAccessShareByUserAndAccountIds(
				accountIdByUser.keyset(),
				accountIds
			)
		) {
			if (accountIdByUser.get(AccessSh.RequestedBy__c).contains(AccessSh.AccessTo__c))
				accessSharesToConsider.add(accessSh);
		}

		System.debug('ACCOUNT SHARE LIST: ' + accountShareListToRemove);
		System.debug('ACCESS SHARE LIST: ' + accessSharesToConsider);

		try {
			AccessShareController.removeAccess(accessShareDtoRemoves, accessSharesToConsider, type);
			deletedIds.addAll(new Map<Id, SObject>(accessShareList).keySet());
		} catch (Exception e) {
			errors.add(e.getMessage());
		}
	}

	public Void finish(Database.BatchableContext jobId) {
		System.debug('### finish');
		// Integration_Log__c log = new Integration_Log__c();

		// if (!errors.isEmpty()) {
		// 	IntegrationLogService.errorIntegrationLog(
		// 		log,
		// 		deletedIds,
		// 		'AccessShareBatch',
		// 		'Failed to remove Expired AccessShares -> ' + type,
		// 		String.join(errors, '\n')
		// 	);
		// } else {
		// 	IntegrationLogService.createIntegrationLog(
		// 		log,
		// 		deletedIds,
		// 		'Batch',
		// 		'AccessShareBatch',
		// 		'Removed Expired -> ' + type,
		// 		'Expired Access Shares removed.'
		// 	);
		// 	log.Number_Of_Rows__c = deletedIds.size();
		// }

		// insert log;
	}
}
