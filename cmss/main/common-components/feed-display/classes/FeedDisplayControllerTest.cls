@IsTest
public class FeedDisplayControllerTest {
	@IsTest(SeeAllData=true)
	static void getPinnedFeedItemsTest() {
		CollaborationGroup testGroup = new CollaborationGroup();
		testGroup.Name = 'TestGroup';
		testGroup.CollaborationType = 'Public';
		insert testGroup;

		FeedItem newFeedItem = new FeedItem();
		newFeedItem.ParentId = testGroup.Id;
		newFeedItem.Body = 'Text';
		insert newFeedItem;

		User user = TestDataFactory.getUser(new User());

		System.runAs(user) {
			ConnectApi.PinCapabilityInput pin = new ConnectApi.PinCapabilityInput();
			pin.entityId = newFeedItem.Id;
			pin.isPinned = true;

			ConnectApi.ChatterFeeds.updatePinnedFeedElements(
				Network.getNetworkId(),
				ConnectApi.FeedType.Record,
				testGroup.Id,
				pin
			);
		}

		List<FeedDisplayController.ExtractedFeedItem> result = FeedDisplayController.getPinnedFeedItems(
			testGroup.Id,
			3
		);

		System.assertEquals(newFeedItem.Id, result[0].Id);
		System.assertEquals('Text', result[0].Text);
		System.assertEquals(1, result.size());
	}
}
