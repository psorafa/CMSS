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
		List<User> insertUsers = new List<User>();
		insertUsers.add(teamManager);
		insertUsers.add(regionManager);
		insertUsers.add(salesNetManager);
		insertUsers.add(currentTeamManager);
		insertUsers.add(currentRegionManager);
		insertUsers.add(currentSalesNetManager);
		insertUsers.add(updateUser);
		insertUsers.add(updateUser3);

		insert insertUsers;

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

	private static List<Production__Share> getProductionShare(Id prodId) {
		List<Production__Share> mgrs = [
			SELECT Id, ParentId, UserOrGroupId, RowCause
			FROM Production__Share
			WHERE
				ParentId = :prodId
				AND RowCause IN (
					:Schema.Production__Share.rowCause.TeamManager__c,
					:Schema.Production__Share.rowCause.RegionManager__c,
					:Schema.Production__Share.rowCause.SalesNetManager__c
				)
		];
		return mgrs;
	}

	@IsTest
	static void productionTriggerInsertTest() {
		createTestData();

		for (Production__Share ps : getProductionShare(prod.Id)) {
			if (ps.RowCause == Schema.Production__Share.rowCause.TeamManager__c) {
				System.assertEquals(
					ps.UserOrGroupId,
					teamManager.Id,
					'UserOrGroupId for Team Manager after insert not as expected.'
				);
			} else if (ps.RowCause == Schema.Production__Share.rowCause.RegionManager__c) {
				System.assertEquals(
					ps.UserOrGroupId,
					regionManager.Id,
					'UserOrGroupId for Region Manager after insert not as expected.'
				);
			} else {
				System.assertEquals(
					ps.UserOrGroupId,
					salesNetManager.Id,
					'UserOrGroupId for Sales Net Manager after insert not as expected.'
				);
			}
		}
	}

	@IsTest
	static void productionTriggerUpdateTest() {
		createTestData();
		prod.TeamManager__c = updateUser.Id;
		prod.RegionManager__c = updateUser.Id;
		prod.SalesNetManager__c = updateUser.Id;
		update prod;

		for (Production__Share ps : getProductionShare(prod.Id)) {
			System.assertEquals(
				ps.UserOrGroupId,
				updateUser.Id,
				'UserOrGroupId for ' +
				ps.RowCause +
				' after update not as expected.'
			);
		}
	}

	@IsTest
	static void errorHandlingTest() {
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
