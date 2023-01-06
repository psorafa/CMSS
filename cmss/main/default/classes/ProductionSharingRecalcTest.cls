/**
 * Created by J.Birka on 23.11.2022
 */
@IsTest
private class ProductionSharingRecalcTest {
	@IsTest
	static void executeBatchTest() {
		ProductionSharingRecalc batch = new ProductionSharingRecalc();
		ProductionServiceTest.createTestData();
		Integer sharesCount = 0;
		Test.startTest();
		Database.executeBatch(batch);
		List<Production__Share> prodShr = [
			SELECT Id, ParentId, UserOrGroupId, RowCause
			FROM Production__Share
			WHERE
				RowCause = :Schema.Production__Share.rowCause.TeamManager__c
				OR RowCause = :Schema.Production__Share.rowCause.RegionManager__c
				OR RowCause = :Schema.Production__Share.rowCause.SalesNetManager__c
		];
		sharesCount = prodShr.size();
		Test.stopTest();

		System.assertEquals(6, sharesCount, 'Records in Production__Share not as expected.');
	}
}
