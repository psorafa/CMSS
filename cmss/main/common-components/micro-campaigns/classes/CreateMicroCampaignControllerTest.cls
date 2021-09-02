@IsTest
private class CreateMicroCampaignControllerTest {

	@IsTest
	static void testGetPicklistValues() {
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get('Account');
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get('AccountStatus__c').getDescribe();
        List<CreateMicroCampaignController.PicklistEntry> pickListValuesList = new List<CreateMicroCampaignController.PicklistEntry>();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
			CreateMicroCampaignController.PicklistEntry entry = new CreateMicroCampaignController.PicklistEntry();
            entry.label = pickListVal.getLabel();
            entry.value = pickListVal.getValue();
            pickListValuesList.add(entry);
        }

		Test.startTest();
		List<CreateMicroCampaignController.PicklistEntry> entries = CreateMicroCampaignController.getPicklistValues('Account', 'AccountStatus__c');
		for (Integer i = 0; i < pickListValuesList.size(); i++) {
			System.assertEquals(pickListValuesList.get(i).label, entries.get(i).label);
			System.assertEquals(pickListValuesList.get(i).value, entries.get(i).value);
		}
	}

	@IsTest
	static void testBehaviorWithAccountIds() {
		Account a1 = TestDataFactory.getPersonAccount(new Account());
		insert a1;

		CreateMicroCampaignController.InputData data = new CreateMicroCampaignController.InputData();
		data.ids = new List<Id>{ a1.Id };
		data.campaign = new CreateMicroCampaignController.InputCampaign();
		data.campaign.name = 'test campaign';
		data.campaign.description = 'test description';
		data.campaign.endDate = Date.today().addDays(15);
		data.task = new CreateMicroCampaignController.InputTask();
		data.task.subject = 'test subject';
		data.task.description = 'test description';
		data.task.category = '1';
		data.task.productType = '1';
		data.task.dueDate = Date.today().addDays(10);

		String jsonData = JSON.serializePretty(data);

		Test.startTest();
		MicroCampaignCreator.CreationResult result = CreateMicroCampaignController.createMicroCampaign(jsonData);
		Test.stopTest();

		Campaign campaign = [SELECT Id FROM Campaign];

		System.assertEquals(1, result.numberOfSuccesses);
		System.assertEquals(0, result.numberOfErrors);
		System.assertEquals(Logger.getTransactionId(), result.transactionId);
		System.assertEquals(campaign.Id, result.campaignId);

		Account a = [SELECT Id, Name, PersonContactId, PersonEmail, BillingStreet, BillingCity, BillingPostalCode, Phone, OwnerId FROM Account];
		Task t = [SELECT ActivityDate, Author__c, Category__c, Description, OwnerId, Priority, ProductType__c,
			Source__c, Status, StatusReason__c, Subject, ValidFrom__c, ValidTo__c, WhoId, WhatId, Email__c,
			Location__c, Phone__c
		FROM Task WHERE WhoId = :a.PersonContactId];

		System.assertEquals(data.task.dueDate, t.ActivityDate);
		System.assertEquals(data.task.category, t.Category__c);
		System.assertEquals(data.task.description, t.Description);
		System.assertEquals('Low', t.Priority);
		System.assertEquals(data.task.productType, t.ProductType__c);
		System.assertEquals('73', t.Source__c);
		System.assertEquals('0', t.Status);
		System.assertEquals('12', t.StatusReason__c);
		System.assertEquals(data.task.subject, t.Subject);
		System.assertEquals(Date.today(), t.ValidFrom__c);
		System.assertEquals(Date.today().addMonths(3), t.ValidTo__c);
		System.assertEquals(a.OwnerId, t.OwnerId);
		System.assertEquals(a.PersonContactId, t.WhoId);
		System.assertEquals(campaign.Id, t.WhatId);
		System.assertEquals(a.PersonEmail, t.Email__c);
		System.assertEquals(a.BillingStreet + ' ' + a.BillingCity + ' ' + a.BillingPostalCode, t.Location__c);
		System.assertEquals(a.Phone, t.Phone__c);

	}
}