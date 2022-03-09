public with sharing class AccountRelatedListController {
	@AuraEnabled(cacheable=true)
	public static AccountInfo getAccounts(
		Id userId,
		String portManType,
		String city,
		String billingPostalCode,
		Integer recordsToShow,
		Integer offset
	) {
		AccountInfo ai = new AccountInfo();
		ai.accountCount = Database.countQuery(
			'SELECT COUNT() ' +
			'FROM Account ' +
			'WHERE PortfolioMngmt' +
			portManType +
			'__c = :userId ' +
			(String.isNotBlank(city) ? 'AND City__c = :city ' : '') +
			(String.isNotBlank(billingPostalCode) ? 'AND BillingPostalCode LIKE :billingPostalCode ' : '')
		);
		ai.accounts = queryAccounts(userId, portManType, city, billingPostalCode, recordsToShow, offset);

		return ai;
	}

	@AuraEnabled(cacheable=true)
	public static Id getUserId(String commAccountBase) {
		User[] users = [SELECT Id FROM User WHERE CommissionAccountBase__c = :commAccountBase];
		return users.size() > 0 ? users[0].Id : null;
	}

	@AuraEnabled(cacheable=true)
	public static Boolean checkPermission(String permissionName) {
		return FeatureManagement.checkPermission(permissionName);
	}

	@AuraEnabled
	public static String createPortManRequestsForUsersClients(
		PortfolioManagementRequest__c pmr,
		Id userId,
		String portManType
	) {
		try {
			PortfolioManagementRequest__c[] pmrs = new List<PortfolioManagementRequest__c>{};
			Integer index = 0;
			String message = Label.RecordsCreated;
			for (Account a : queryAccounts(userId, portManType, null, null, 50000, 0)) {
				if (index == 5000) {
					message = Label.TooManyClients;
					break;
				}
				clonePMR(pmrs, pmr, a.Id);
				index++;
			}
			insert pmrs;
			return message;
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	@AuraEnabled
	public static String createPortManRequests(PortfolioManagementRequest__c pmr, String[] accountIds) {
		try {
			PortfolioManagementRequest__c[] pmrs = new List<PortfolioManagementRequest__c>{};
			Integer index = 0;
			String message = Label.RecordsCreated;
			for (Id accId : accountIds) {
				if (index == 5000) {
					message = Label.TooManyClients;
					break;
				}
				clonePMR(pmrs, pmr, accId);
				index++;
			}
			insert pmrs;
			return message;
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	private static void clonePMR(PortfolioManagementRequest__c[] pmrs, PortfolioManagementRequest__c pmr, Id accId) {
		PortfolioManagementRequest__c newPMR = pmr.clone(false, true, false, false);
		newPMR.Account__c = accId;
		newPMR.BatchID__c = '1';
		pmrs.add(newPMR);
	}

	private static Account[] queryAccounts(
		Id userId,
		String portManType,
		String city,
		String billingPostalCode,
		Integer recordsToShow,
		Integer offset
	) {
		return Database.query(
			'SELECT CombinedName__c, BillingStreet, City__c, BillingPostalCode, Phone, PersonEmail, PersonType__c ' +
			'FROM Account ' +
			'WHERE PortfolioMngmt' +
			portManType +
			'__c = :userId ' +
			(String.isNotBlank(city) ? 'AND City__c = :city ' : '') +
			(String.isNotBlank(billingPostalCode) ? 'AND BillingPostalCode LIKE :billingPostalCode ' : '') +
			'LIMIT ' +
			recordsToShow +
			' ' +
			'OFFSET ' +
			offset
		);
	}

	public class AccountInfo {
		@AuraEnabled
		public Integer accountCount;
		@AuraEnabled
		public Account[] accounts;
	}
}
