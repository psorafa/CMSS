@IsTest
public class AssetRelatedListControllerTest {

	private static Account acc;

	static void makeData() {
		acc = new Account();
		acc.Name = 'testAcc';
		insert acc;

		List<Asset> astInfos = new List<Asset>();
		Asset astInf1 = new Asset(Name = 'testAsset1', AccountId = acc.Id);
		Asset astInf2 = new Asset(Name = 'testAsset2', AccountId = acc.Id);

		astInfos.add(astInf1);
		astInfos.add(astInf2);

		insert astInfos;

		List<Asset> testAsts = [SELECT Id FROM Asset];

		List<AssetAccountRelation__c> asAcRels = new List<AssetAccountRelation__c>();
		AssetAccountRelation__c asAcRel1 = new AssetAccountRelation__c(
			Name = 'Vlastník',
			Account__c = acc.Id,
			Asset__c = testAsts[0].Id,
			RelationType__c = '1'
		);
		AssetAccountRelation__c asAcRel2 = new AssetAccountRelation__c(
			Name = 'Pojistník',
			Account__c = acc.Id,
			Asset__c = testAsts[1].Id,
			RelationType__c = '2'
		);
		AssetAccountRelation__c asAcRel3 = new AssetAccountRelation__c(
			Name = 'Pojištěná osoba',
			Account__c = acc.Id,
			Asset__c = testAsts[1].Id,
			RelationType__c = '3'
		);

		asAcRels.add(asAcRel1);
		asAcRels.add(asAcRel2);
		asAcRels.add(asAcRel3);

		insert asAcRels;
	}

	@IsTest
	static void testGetDataForDataTable() {
		makeData();
		Account testAcc = acc;

		List<String> listOfFields = new List<String>{
			'AccountId', 'Price', 'Name'
		};
		String myData = AssetRelatedListController.getDataForDataTable(
			listOfFields,
			testAcc.Id, null, null
		);

		System.debug('My data:' + myData);
		List<Asset> expectedData = [
			SELECT AccountId, Price, Id, Name
			FROM Asset
			WHERE AccountId = :testAcc.Id
			WITH SECURITY_ENFORCED
			ORDER BY CreatedDate DESC
		];
		// TODO incomplete test
	}

}
