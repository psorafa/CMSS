@isTest
private class AccessShareScheduleTest {
	@isTest
	static void scheduleExecuteBatchTest() {
		User userCreator = new User(FirstName = 'Tester1', LastName = 'Creator');
		userCreator = TestDataFactory.getUser(userCreator);
		User userObserver = new User(FirstName = 'Tester2', LastName = 'Observer');
		userObserver = TestDataFactory.getUser(userObserver);
		insert new List<User>{ userCreator, userObserver };

		System.runAs(userCreator) {
			Account acc1 = new Account(Name = 'Test Acc1');
			acc1 = TestDataFactory.getAccount(acc1);
			insert acc1;
		}

		Integer accessShareSizeOrig = AccessShareDao.getAllRecordsFromAccessShare().size();
		Id testAccId = [SELECT Id FROM Account WHERE Name = 'Test Acc1' LIMIT 1].Id;

		Test.startTest();

		AccessShareController.getSearchAccess(userObserver, testAccId, 'Account');
		Integer accessShareNewRecord = AccessShareDao.getAllRecordsFromAccessShare().size();
		AccessShare__c accessShare1 = [SELECT Id, ExpirationDate__c FROM AccessShare__c LIMIT 1];
		Datetime expDate = accessShare1.ExpirationDate__c;
		accessShare1.ExpirationDate__c = expDate.addDays(-10);
		update accessShare1;

		System.schedule('Delete search access TEST', '0 0 0 * * ?', new AccessShareSchedule());
		DataBase.executeBatch(new AccessShareBatch('Search'));

		Test.stopTest();

		Integer accessShareAfterCleanup = AccessShareDao.getAllRecordsFromAccessShare().size();

		System.assertEquals(accessShareSizeOrig, accessShareAfterCleanup, 'Access share not removed');
	}

	@isTest
	static void testUserAccess() {
		User userCreator = new User(FirstName = 'Tester1', LastName = 'Creator');
		userCreator = TestDataFactory.getUser(userCreator);
		User userObserver = new User(FirstName = 'Tester2', LastName = 'Observer');
		userObserver = TestDataFactory.getUser(userObserver);
		insert new List<User>{ userCreator, userObserver };

		System.runAs(userCreator) {
			Account acc1 = new Account(Name = 'Test Acc1');
			acc1 = TestDataFactory.getAccount(acc1);
			Asset asset1 = new Asset(Name = '132435');
			asset1 = TestDataFactory.getAsset(asset1);
			insert new List<SObject>{ acc1, asset1 };
		}

		Id testAccId = [SELECT Id FROM Account WHERE Name = 'Test Acc1' LIMIT 1].Id;

		Test.startTest();
		AccessShareController.getSearchAccess(userObserver, testAccId, 'Account');
		Test.stopTest();

		Id testAssetId = [SELECT Id FROM Asset WHERE Name = '132435' LIMIT 1].Id;

		System.assert(
			[
				SELECT RecordId, HasEditAccess
				FROM UserRecordAccess
				WHERE UserId = :userObserver.Id AND recordId = :testAssetId
			]
			.HasEditAccess
		);

		System.assert(
			[
				SELECT RecordId, HasEditAccess
				FROM UserRecordAccess
				WHERE UserId = :userObserver.Id AND recordId = :testAccId
			]
			.HasEditAccess
		);
	}
}
