@IsTest
public class UpdateCampaignMemberOnAsset_BatchTest {
	@IsTest
	private static void UpdateCampaignMemberOnAssetWithDifferentProducts() {
		Account account = TestDataFactory.getAccount(new Account());
		insert account;
		Asset asset1 = new Asset(
			AccountId = account.Id,
			Name = 'Asset',
			ProductCloseDate__c = System.today(),
			ProductType__c = '1'
		);
		insert asset1;
		Campaign existingCampaign1 = new Campaign();
		existingCampaign1.Name = 'Campaign1';
		existingCampaign1.StartDate = System.today().addDays(-10);
		existingCampaign1.EndDate = System.today();
		existingCampaign1.Product__c = '2';
		existingCampaign1.Type = '1';
		existingCampaign1.Status = 'Planned';
		insert existingCampaign1;
		Campaign existingCampaign2 = new Campaign();
		existingCampaign2.Name = 'Campaign2';
		existingCampaign2.Type = '1';
		existingCampaign2.Status = 'Planned';
		existingCampaign2.StartDate = System.today().addDays(-1);
		existingCampaign2.EndDate = System.today().addDays(10);
		insert existingCampaign2;
		CampaignMember__c campMember1 = new CampaignMember__c(
			Account__c = account.Id,
			Name = 'CampaignMember1',
			Campaign__c = existingCampaign1.Id,
			Asset__c = asset1.Id
		);
		insert campMember1;

		CampaignMember__c campMember2 = new CampaignMember__c(
			Account__c = account.Id,
			Name = 'CampaignMember2',
			Campaign__c = existingCampaign2.Id,
			Asset__c = asset1.Id
		);
		insert campMember2;
		UpdateCampaignMemberOnAsset_Batch batch = new UpdateCampaignMemberOnAsset_Batch();

		Test.startTest();
		Database.executeBatch(batch);
		Test.stopTest();

		Asset asset = [SELECT Id, CampaignMember__c FROM Asset];
		System.assertEquals(asset.CampaignMember__c, campMember2.Id);
	}
	@IsTest
	private static void UpdateCampaignMemberOnAssetWithSameProducts() {
		Account account = TestDataFactory.getAccount(new Account());
		insert account;
		Asset asset1 = new Asset(
			AccountId = account.Id,
			Name = 'Asset',
			ProductCloseDate__c = System.today(),
			ProductType__c = '2'
		);
		insert asset1;
		Campaign existingCampaign1 = new Campaign();
		existingCampaign1.Name = 'Campaign1';
		existingCampaign1.StartDate = System.today().addDays(-1);
		existingCampaign1.EndDate = System.today();
		existingCampaign1.Product__c = '2';
		existingCampaign1.Type = '1';
		existingCampaign1.Status = 'Planned';
		insert existingCampaign1;
		Campaign existingCampaign2 = new Campaign();
		existingCampaign2.Name = 'Campaign2';
		existingCampaign2.Type = '1';
		existingCampaign2.Status = 'Planned';
		existingCampaign2.StartDate = System.today().addDays(-10);
		existingCampaign2.EndDate = System.today().addDays(10);
		insert existingCampaign2;
		CampaignMember__c campMember1 = new CampaignMember__c(
			Account__c = account.Id,
			Name = 'CampaignMember1',
			Campaign__c = existingCampaign1.Id,
			Asset__c = asset1.Id
		);
		insert campMember1;

		CampaignMember__c campMember2 = new CampaignMember__c(
			Account__c = account.Id,
			Name = 'CampaignMember2',
			Campaign__c = existingCampaign2.Id,
			Asset__c = asset1.Id
		);
		insert campMember2;
		UpdateCampaignMemberOnAsset_Batch batch = new UpdateCampaignMemberOnAsset_Batch();

		Test.startTest();
		Database.executeBatch(batch);
		Test.stopTest();

		Asset asset = [SELECT Id, CampaignMember__c FROM Asset];
		System.assertEquals(asset.CampaignMember__c, campMember1.Id);
	}
}
