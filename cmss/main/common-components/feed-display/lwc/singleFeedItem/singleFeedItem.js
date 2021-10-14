import { LightningElement, api } from 'lwc';

export default class SingleFeedItem extends LightningElement {
	@api
	feed;

	isFeedExtended = true;
	initialRender = true;
	isExtendable = false;

	renderedCallback() {
		if (this.initialRender) {
			let elementHeight = this.template.querySelector('.content').scrollHeight;

			if (elementHeight > 250) {
				this.isExtendable = true;
				this.isFeedExtended = false;
			}

			this.initialRender = false;
		}
	}

	get extendLabel() {
		return this.isFeedExtended ? 'Zobrazit méně' : 'Zobrazit více';
	}

	get feedItemUrl() {
		return '/' + this.feed.Id;
	}

	get groupIdUrl() {
		return '/' + this.feed.GroupId;
	}

	get authorIdUrl() {
		return '/' + this.feed.AuthorId;
	}

	get feedItemCardBodyStyle() {
		return (
			'slds-post__content slds-text-longform ' +
			(this.isFeedExtended && !this.initialRender ? 'feed--extended' : 'feed--not-extended')
		);
	}

	handleExtend() {
		this.isFeedExtended = !this.isFeedExtended;
	}
}
