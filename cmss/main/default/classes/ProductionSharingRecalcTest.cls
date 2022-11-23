/**
 * Created by J.Birka on 23.11.2022
 */
@IsTest
private class ProductionSharingRecalcTest {
	@IsTest
	static void executeBatchTest() {
		ProductionSharingRecalc batch = new ProductionSharingRecalc();
		ProductionServiceTest.createTestData();

		Test.startTest();
		Database.executeBatch(batch);
		Test.stopTest();

		List<Production__Share> prodShr = [
			SELECT Id, ParentId, UserOrGroupId, RowCause
			FROM Production__Share
			WHERE
				RowCause = :Schema.Production__Share.rowCause.TeamManager__c
				OR RowCause = :Schema.Production__Share.rowCause.RegionManager__c
				OR RowCause = :Schema.Production__Share.rowCause.SalesNetManager__c
		];
		System.assertEquals(prodShr.size(), 6, 'Records in Production__Share not as expected.');
	}
}
