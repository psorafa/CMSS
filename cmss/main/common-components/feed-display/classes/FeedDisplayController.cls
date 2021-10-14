public class FeedDisplayController {
	@AuraEnabled(Cacheable=true)
	public static List<ExtractedFeedItem> getPinnedFeedItems(String chatterGroupId, Integer maxNumberOfItems) {
		List<Id> ids = new List<Id>();
		ConnectApi.PinnedFeedElements pfe = ConnectApi.ChatterFeeds.getPinnedFeedElementsFromFeed(
			Network.getNetworkId(),
			ConnectApi.FeedType.Record,
			chatterGroupId
		);

		Map<Id, ExtractedFeedItem> feedItemsMap = new Map<Id, ExtractedFeedItem>();

		for (ConnectApi.FeedElement feedElement : pfe.elements) {
			ConnectApi.FeedItem feedItem = (ConnectApi.FeedItem) feedElement;
			ExtractedFeedItem item = new ExtractedFeedItem();

			item.AuthorDisplayName = feedItem.actor.name;
			item.GroupDisplayName = feedItem.parent.name;
			item.PhotoUrl = feedItem.photoUrl;
			item.IsRichtext = feedItem.body.isRichText;
			item.Text = feedItem.body.text;
			item.CreatedDate = feedItem.createdDate;
			item.Id = feedItem.id;
			item.RelativeCreatedDate = feedItem.relativeCreatedDate;
			feedItemsMap.put(item.Id, item);
		}

		List<FeedItem> sOFeedItemsWithBody = [
			SELECT Body, ParentId, InsertedById
			FROM FeedItem
			WHERE Id IN :feedItemsMap.keySet()
		];
		for (FeedItem sOFeedItem : sOFeedItemsWithBody) {
			feedItemsMap.get(sOFeedItem.Id).Text = sOFeedItem.Body;
			feedItemsMap.get(sOFeedItem.Id).AuthorId = sOFeedItem.InsertedById;
			feedItemsMap.get(sOFeedItem.Id).GroupId = sOFeedItem.ParentId;
		}

		return trimResponse(feedItemsMap.values(), maxNumberOfItems);
	}

	private static List<ExtractedFeedItem> trimResponse(List<ExtractedFeedItem> itemsList, Integer maxSizeOfResult) {
		List<ExtractedFeedItem> result = new List<ExtractedFeedItem>();
		Integer i = 0;
		while (i < maxSizeOfResult) {
			if (itemsList.size() > i) {
				result.add(itemsList[i]);
			}
			i++;
		}
		return result;
	}

	public class ExtractedFeedItem {
		@AuraEnabled
		public String Id;
		@AuraEnabled
		public String AuthorDisplayName;
		@AuraEnabled
		public string AuthorId;
		@AuraEnabled
		public String GroupDisplayName;
		@AuraEnabled
		public String GroupId;
		@AuraEnabled
		public String PhotoUrl;
		@AuraEnabled
		public Boolean IsRichText;
		@AuraEnabled
		public String Text;
		@AuraEnabled
		public Datetime CreatedDate;
		@AuraEnabled
		public String RelativeCreatedDate;
	}
}
