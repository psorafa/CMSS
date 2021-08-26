@IsTest
private class MicroCampaignCreatorTest {

	private static Campaign getCampaignTemplate() {
		return new Campaign(
			Name = 'test campaign',
			EndDate = Date.today().addDays(30),
			Description = 'test description',
			Type = 'Microcampaign',
			DataSource__c = '73',
			IsActive = true
		);
	}
	private static Task getTaskTemplate() {
		return new Task(
			ActivityDate = Date.today().addDays(15),
			Category__c = '1',
			Description = 'test description',
			OwnerId = null,
			Priority = 'Low',
			ProductType__c = '1',
			Source__c = '73',
			Status = '0',
			StatusReason__c = '12',
			Subject = 'test subject',
			ValidFrom__c = Date.today(),
			ValidTo__c = Date.today().addMonths(3)
		);
	}

	@IsTest
	static void testBehaviorWithAccountIds() {
        Account a1 = TestDataFactory.getPersonAccount(new Account());
        Account a2 = TestDataFactory.getPersonAccount(new Account());
		insert new List<Account>{ a1, a2 };

		List<Id> ids = new List<Id>{ a1.Id, a2.Id };

		Campaign campaignTemplate = getCampaignTemplate();
		Task taskTemplate = getTaskTemplate();

		Test.startTest();
		MicroCampaignCreator creator = new MicroCampaignCreator(ids, campaignTemplate, taskTemplate);
		MicroCampaignCreator.CreationResult result = creator.create();
		Test.stopTest();

		Campaign campaign = [SELECT Id FROM Campaign];

		System.assertEquals(2, result.numberOfSuccesses);
		System.assertEquals(0, result.numberOfErrors);
		System.assertEquals(Logger.getTransactionId(), result.transactionId);
		System.assertEquals(campaign.Id, result.campaignId);

		Account a = [SELECT Id, Name, PersonContactId, PersonEmail, BillingStreet, BillingCity, BillingPostalCode, Phone, OwnerId FROM Account WHERE Id = :a1.Id];
		Task t = [SELECT ActivityDate, Author__c, Category__c, Description, OwnerId, Priority, ProductType__c,
					Source__c, Status, StatusReason__c, Subject, ValidFrom__c, ValidTo__c, WhoId, WhatId, Email__c,
					Location__c, Phone__c
					FROM Task WHERE WhoId = :a.PersonContactId];

		System.assertEquals(taskTemplate.ActivityDate, t.ActivityDate);
		System.assertEquals(taskTemplate.Author__c, t.Author__c);
		System.assertEquals(taskTemplate.Category__c, t.Category__c);
		System.assertEquals(taskTemplate.Description, t.Description);
		System.assertEquals(taskTemplate.Priority, t.Priority);
		System.assertEquals(taskTemplate.ProductType__c, t.ProductType__c);
		System.assertEquals(taskTemplate.Source__c, t.Source__c);
		System.assertEquals(taskTemplate.Status, t.Status);
		System.assertEquals(taskTemplate.StatusReason__c, t.StatusReason__c);
		System.assertEquals(taskTemplate.Subject, t.Subject);
		System.assertEquals(taskTemplate.ValidFrom__c, t.ValidFrom__c);
		System.assertEquals(taskTemplate.ValidTo__c, t.ValidTo__c);
		System.assertEquals(a.OwnerId, t.OwnerId);
		System.assertEquals(a.PersonContactId, t.WhoId);
		System.assertEquals(campaign.Id, t.WhatId);
		System.assertEquals(a.PersonEmail, t.Email__c);
		System.assertEquals(a.BillingStreet + ' ' + a.BillingCity + ' ' + a.BillingPostalCode, t.Location__c);
		System.assertEquals(a.Phone, t.Phone__c);

		a = [SELECT Id, Name, PersonContactId, PersonEmail, BillingStreet, BillingCity, BillingPostalCode, Phone, OwnerId FROM Account WHERE Id = :a2.Id];
		t = [SELECT ActivityDate, Author__c, Category__c, Description, OwnerId, Priority, ProductType__c,
			Source__c, Status, StatusReason__c, Subject, ValidFrom__c, ValidTo__c, WhoId, WhatId, Email__c,
			Location__c, Phone__c
		FROM Task WHERE WhoId = :a.PersonContactId];

		System.assertEquals(taskTemplate.ActivityDate, t.ActivityDate);
		System.assertEquals(taskTemplate.Author__c, t.Author__c);
		System.assertEquals(taskTemplate.Category__c, t.Category__c);
		System.assertEquals(taskTemplate.Description, t.Description);
		System.assertEquals(taskTemplate.Priority, t.Priority);
		System.assertEquals(taskTemplate.ProductType__c, t.ProductType__c);
		System.assertEquals(taskTemplate.Source__c, t.Source__c);
		System.assertEquals(taskTemplate.Status, t.Status);
		System.assertEquals(taskTemplate.StatusReason__c, t.StatusReason__c);
		System.assertEquals(taskTemplate.Subject, t.Subject);
		System.assertEquals(taskTemplate.ValidFrom__c, t.ValidFrom__c);
		System.assertEquals(taskTemplate.ValidTo__c, t.ValidTo__c);
		System.assertEquals(a.OwnerId, t.OwnerId);
		System.assertEquals(a.PersonContactId, t.WhoId);
		System.assertEquals(campaign.Id, t.WhatId);
		System.assertEquals(a.PersonEmail, t.Email__c);
		System.assertEquals(a.BillingStreet + ' ' + a.BillingCity + ' ' + a.BillingPostalCode, t.Location__c);
		System.assertEquals(a.Phone, t.Phone__c);
	}

	@IsTest
	static void testBehaviorWithAssetsIds() {
		Account a1 = TestDataFactory.getPersonAccount(new Account());
		Account a2 = TestDataFactory.getPersonAccount(new Account());
		insert new List<Account>{ a1, a2 };

		Asset ass1 = TestDataFactory.getAsset(new Asset(
			AccountId = a1.Id
		));
		Asset ass2 = TestDataFactory.getAsset(new Asset(
			AccountId = a2.Id
		));
		Asset ass3 = TestDataFactory.getAsset(new Asset(
			AccountId = a2.Id   // second asset for same account
		));
		insert new List<Asset> {ass1, ass2, ass3};

		List<Id> ids = new List<Id>{ ass1.Id, ass2.Id, ass3.Id };

		Campaign campaignTemplate = null;
		Task taskTemplate = getTaskTemplate();

		Test.startTest();
		MicroCampaignCreator creator = new MicroCampaignCreator(ids, campaignTemplate, taskTemplate);
		MicroCampaignCreator.CreationResult result = creator.create();
		Test.stopTest();

		System.assertEquals(3, result.numberOfSuccesses);
		System.assertEquals(0, result.numberOfErrors);
		System.assertEquals(Logger.getTransactionId(), result.transactionId);
		System.assertEquals(null, result.campaignId);

		Account a = [SELECT Id, Name, PersonContactId, PersonEmail, BillingStreet, BillingCity, BillingPostalCode, Phone, OwnerId FROM Account WHERE Id = :a1.Id];
		Task t = [SELECT ActivityDate, Author__c, Category__c, Description, OwnerId, Priority, ProductType__c,
			Source__c, Status, StatusReason__c, Subject, ValidFrom__c, ValidTo__c, WhoId, WhatId, Email__c,
			Location__c, Phone__c
		FROM Task WHERE Asset__c = :ass1.Id];

		System.assertEquals(taskTemplate.ActivityDate, t.ActivityDate);
		System.assertEquals(taskTemplate.Author__c, t.Author__c);
		System.assertEquals(taskTemplate.Category__c, t.Category__c);
		System.assertEquals(taskTemplate.Description, t.Description);
		System.assertEquals(taskTemplate.Priority, t.Priority);
		System.assertEquals(taskTemplate.ProductType__c, t.ProductType__c);
		System.assertEquals(taskTemplate.Source__c, t.Source__c);
		System.assertEquals(taskTemplate.Status, t.Status);
		System.assertEquals(taskTemplate.StatusReason__c, t.StatusReason__c);
		System.assertEquals(taskTemplate.Subject, t.Subject);
		System.assertEquals(taskTemplate.ValidFrom__c, t.ValidFrom__c);
		System.assertEquals(taskTemplate.ValidTo__c, t.ValidTo__c);
		System.assertEquals(a.OwnerId, t.OwnerId);
		System.assertEquals(a.PersonContactId, t.WhoId);
		System.assertEquals(null, t.WhatId);
		System.assertEquals(a.PersonEmail, t.Email__c);
		System.assertEquals(a.BillingStreet + ' ' + a.BillingCity + ' ' + a.BillingPostalCode, t.Location__c);
		System.assertEquals(a.Phone, t.Phone__c);

		a = [SELECT Id, Name, PersonContactId, PersonEmail, BillingStreet, BillingCity, BillingPostalCode, Phone, OwnerId FROM Account WHERE Id = :a2.Id];
		t = [SELECT ActivityDate, Author__c, Category__c, Description, OwnerId, Priority, ProductType__c,
			Source__c, Status, StatusReason__c, Subject, ValidFrom__c, ValidTo__c, WhoId, WhatId, Email__c,
			Location__c, Phone__c
		FROM Task WHERE Asset__c = :ass2.Id];

		System.assertEquals(taskTemplate.ActivityDate, t.ActivityDate);
		System.assertEquals(taskTemplate.Author__c, t.Author__c);
		System.assertEquals(taskTemplate.Category__c, t.Category__c);
		System.assertEquals(taskTemplate.Description, t.Description);
		System.assertEquals(taskTemplate.Priority, t.Priority);
		System.assertEquals(taskTemplate.ProductType__c, t.ProductType__c);
		System.assertEquals(taskTemplate.Source__c, t.Source__c);
		System.assertEquals(taskTemplate.Status, t.Status);
		System.assertEquals(taskTemplate.StatusReason__c, t.StatusReason__c);
		System.assertEquals(taskTemplate.Subject, t.Subject);
		System.assertEquals(taskTemplate.ValidFrom__c, t.ValidFrom__c);
		System.assertEquals(taskTemplate.ValidTo__c, t.ValidTo__c);
		System.assertEquals(a.OwnerId, t.OwnerId);
		System.assertEquals(a.PersonContactId, t.WhoId);
		System.assertEquals(null, t.WhatId);
		System.assertEquals(a.PersonEmail, t.Email__c);
		System.assertEquals(a.BillingStreet + ' ' + a.BillingCity + ' ' + a.BillingPostalCode, t.Location__c);
		System.assertEquals(a.Phone, t.Phone__c);

		t = [SELECT ActivityDate, Author__c, Category__c, Description, OwnerId, Priority, ProductType__c,
			Source__c, Status, StatusReason__c, Subject, ValidFrom__c, ValidTo__c, WhoId, WhatId, Email__c,
			Location__c, Phone__c
		FROM Task WHERE Asset__c = :ass3.Id];

		System.assertEquals(taskTemplate.ActivityDate, t.ActivityDate);
		System.assertEquals(taskTemplate.Author__c, t.Author__c);
		System.assertEquals(taskTemplate.Category__c, t.Category__c);
		System.assertEquals(taskTemplate.Description, t.Description);
		System.assertEquals(taskTemplate.Priority, t.Priority);
		System.assertEquals(taskTemplate.ProductType__c, t.ProductType__c);
		System.assertEquals(taskTemplate.Source__c, t.Source__c);
		System.assertEquals(taskTemplate.Status, t.Status);
		System.assertEquals(taskTemplate.StatusReason__c, t.StatusReason__c);
		System.assertEquals(taskTemplate.Subject, t.Subject);
		System.assertEquals(taskTemplate.ValidFrom__c, t.ValidFrom__c);
		System.assertEquals(taskTemplate.ValidTo__c, t.ValidTo__c);
		System.assertEquals(a.OwnerId, t.OwnerId);
		System.assertEquals(a.PersonContactId, t.WhoId);
		System.assertEquals(null, t.WhatId);
		System.assertEquals(a.PersonEmail, t.Email__c);
		System.assertEquals(a.BillingStreet + ' ' + a.BillingCity + ' ' + a.BillingPostalCode, t.Location__c);
		System.assertEquals(a.Phone, t.Phone__c);
	}
}