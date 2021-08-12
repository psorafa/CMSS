/**
 * @description Helper methods for creating and updating Access Logs
 * @author Vaclav Moldan
 */
public without sharing class AccessLogService {
	private static Access_Log__c createAccessLog(
		Id accessTo,
		Id requestedBy,
		String type,
		Datetime startDate,
		Datetime expirationDate
	) {
		Access_Log__c accessLog = new Access_Log__c();
		accessLog.AccessTo__c = accessTo;
		accessLog.RequestedBy__c = requestedBy;
		accessLog.Type__c = type;
		accessLog.StartDate__c = startDate;
		accessLog.ExpirationDate__c = expirationDate;

		return accessLog;
	}

	public static void insertAccessLogsFromShares(List<AccessShare__c> accessShares) {
		List<Access_Log__c> logsToInsert = new List<Access_Log__c>();
		for (AccessShare__c accessShare : accessShares) {
			logsToInsert.add(
				createAccessLog(
					accessShare.AccessTo__c,
					accessShare.RequestedBy__c,
					accessShare.Type__c,
					accessShare.StartDate__c,
					accessShare.ExpirationDate__c
				)
			);
		}

		insert logsToInsert;
	}

	public static void insertErrorLog(String type, String errorMessage) {
		Access_Log__c errorLog = new Access_Log__c();
		errorLog.type__c = type;
		errorLog.Message__c = errorMessage;

		insert errorLog;
	}
}
