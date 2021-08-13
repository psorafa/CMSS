@isTest
private class AccessLogServiceTest {
	@isTest
	static void testInsertLogsFromShares() {
		Account acc = TestDataFactory.getAccount();
		insert acc;

		AccessShare__c accessShare = new AccessShare__c();
		accessShare.AccessTo__c = acc.Id;
		accessShare.RequestedBy__c = UserInfo.getUserId();
		accessShare.Type__c = 'Search';
		accessShare.StartDate__c = Datetime.now();
		accessShare.ExpirationDate__c = Datetime.now().addDays(1);

		insert accessShare;

		AccessLogService.insertAccessLogsFromShares(new List<AccessShare__c>{ accessShare });

		List<Access_Log__c> accessLogs = [
			SELECT Id, AccessTo__c, RequestedBy__c, StartDate__c, ExpirationDate__c
			FROM Access_Log__c
		];
		System.assertEquals(1, accessLogs.size());
		System.assertEquals(acc.Id, accessLogs[0].AccessTo__c);
	}

	@isTest
	static void testInsertErrorLog() {
		AccessLogService.insertErrorLog('Error', 'Access Share creation failed');

		List<Access_Log__c> accessLogs = [SELECT Id, Type__c FROM Access_Log__c];

		System.assertEquals(1, accessLogs.size());
		System.assertEquals('Error', accessLogs[0].Type__c);
	}
}
