import { LightningElement, api } from 'lwc';
import getPinnedFeedItems from '@salesforce/apex/FeedDisplayController.getPinnedFeedItems';

export default class PinnedFeedDisplay extends LightningElement {
	@api chatterGroupId;
	@api maxNumberOfItems;

	feedItems;

	connectedCallback() {
		try {
			getPinnedFeedItems({ chatterGroupId: this.chatterGroupId, maxNumberOfItems: this.maxNumberOfItems }).then(
				(data) => {
					this.feedItems = data;
				}
			);
		} catch (e) {
			console.log('error: ', e);
		}
	}
}
