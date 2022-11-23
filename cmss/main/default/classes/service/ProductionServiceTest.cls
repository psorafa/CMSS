/**
 * Created by J.Birka on 22.11.2022
 */
@IsTest
public class ProductionServiceTest {
	static User teamManager;
	static User regionManager;
	static User salesNetManager;
	static User currentTeamManager;
	static User currentRegionManager;
	static User currentSalesNetManager;
	static User updateUser;
	static User updateUser2;
	static User updateUser3;
	static Production__c prod;
	static Production__c prod3;

	public static void createTestData() {
		teamManager = TestDataFactory.getUser(new User());
		regionManager = TestDataFactory.getUser(new User());
		salesNetManager = TestDataFactory.getUser(new User());
		currentTeamManager = TestDataFactory.getUser(new User());
		currentRegionManager = TestDataFactory.getUser(new User());
		currentSalesNetManager = TestDataFactory.getUser(new User());
		updateUser = TestDataFactory.getUser(new User());
		updateUser2 = TestDataFactory.getUser(new User());
		updateUser3 = TestDataFactory.getUser(new User());
		insert teamManager;
		insert regionManager;
		insert salesNetManager;
		insert currentTeamManager;
		insert currentRegionManager;
		insert currentSalesNetManager;
		insert updateUser;
		insert updateUser3;

		prod = new Production__c(
			CurrentTeamManager__c = currentTeamManager.Id,
			CurrentRegionManager__c = currentRegionManager.Id,
			CurrentSalesNetManager__c = currentSalesNetManager.Id,
			TeamManager__c = teamManager.Id,
			RegionManager__c = regionManager.Id,
			SalesNetManager__c = salesNetManager.Id
		);
		insert prod;

		prod3 = new Production__c(
			CurrentTeamManager__c = currentTeamManager.Id,
			CurrentRegionManager__c = currentRegionManager.Id,
			CurrentSalesNetManager__c = currentSalesNetManager.Id,
			TeamManager__c = updateUser3.Id,
			RegionManager__c = updateUser3.Id,
			SalesNetManager__c = updateUser3.Id
		);
		insert prod3;
	}

	@IsTest
	static void productionTriggerTest() {
		createTestData();

		//after insert test
		Production__Share teamManagerShr = [
			SELECT Id, ParentId, UserOrGroupId, RowCause
			FROM Production__Share
			WHERE ParentId = :prod.Id AND RowCause = :Schema.Production__Share.rowCause.TeamManager__c
		];
		Production__Share regionManagerShr = [
			SELECT Id, ParentId, UserOrGroupId, RowCause
			FROM Production__Share
			WHERE ParentId = :prod.Id AND RowCause = :Schema.Production__Share.rowCause.RegionManager__c
		];
		Production__Share salesNetManagerShr = [
			SELECT Id, ParentId, UserOrGroupId, RowCause
			FROM Production__Share
			WHERE ParentId = :prod.Id AND RowCause = :Schema.Production__Share.rowCause.SalesNetManager__c
		];
		System.assertEquals(
			teamManagerShr.UserOrGroupId,
			teamManager.Id,
			'UserOrGroupId for Team Manager after insert not as expected.'
		);
		System.assertEquals(
			regionManagerShr.UserOrGroupId,
			regionManager.Id,
			'UserOrGroupId for Region Manager after insert not as expected.'
		);
		System.assertEquals(
			salesNetManagerShr.UserOrGroupId,
			salesNetManager.Id,
			'UserOrGroupId for Sales Net Manager after insert not as expected.'
		);

		//after update test
		prod.TeamManager__c = updateUser.Id;
		prod.RegionManager__c = updateUser.Id;
		prod.SalesNetManager__c = updateUser.Id;
		update prod;
		teamManagerShr = [
			SELECT Id, ParentId, UserOrGroupId, RowCause
			FROM Production__Share
			WHERE ParentId = :prod.Id AND RowCause = :Schema.Production__Share.rowCause.TeamManager__c
		];
		regionManagerShr = [
			SELECT Id, ParentId, UserOrGroupId, RowCause
			FROM Production__Share
			WHERE ParentId = :prod.Id AND RowCause = :Schema.Production__Share.rowCause.RegionManager__c
		];
		salesNetManagerShr = [
			SELECT Id, ParentId, UserOrGroupId, RowCause
			FROM Production__Share
			WHERE ParentId = :prod.Id AND RowCause = :Schema.Production__Share.rowCause.SalesNetManager__c
		];
		System.assertEquals(
			teamManagerShr.UserOrGroupId,
			updateUser.Id,
			'UserOrGroupId for Team Manager after update not as expected.'
		);
		System.assertEquals(
			regionManagerShr.UserOrGroupId,
			updateUser.Id,
			'UserOrGroupId for Region Manager after update not as expected.'
		);
		System.assertEquals(
			salesNetManagerShr.UserOrGroupId,
			updateUser.Id,
			'UserOrGroupId for Sales Net Manager after update not as expected.'
		);
	}

	@IsTest
	static void errorHandlingTest() {
		//error handling test
		createTestData();
		updateUser2.IsActive = false;
		insert updateUser2;
		Production__c prod2 = new Production__c(
			CurrentTeamManager__c = currentTeamManager.Id,
			CurrentRegionManager__c = currentRegionManager.Id,
			CurrentSalesNetManager__c = currentSalesNetManager.Id,
			TeamManager__c = updateUser2.Id,
			RegionManager__c = updateUser2.Id,
			SalesNetManager__c = updateUser2.Id
		);
		insert prod2;
	}
}
