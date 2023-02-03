import { api, LightningElement } from 'lwc';
import LBL_FROM from '@salesforce/label/c.From';
import LBL_TO from '@salesforce/label/c.To';

export default class CustomSearchDynamicRangeFilter extends LightningElement {
	@api
	label;

	@api
	inputType;

	@api
	filterValues;

	@api
	fieldName;

	@api
	productType;

	@api
	objectType;

	selectedFromEvent;
	selectedToEvent;

	labels = {
		from: LBL_FROM,
		to: LBL_TO
	};

	handleFromChange(event) {
		if (event.detail.type && event.detail.value) {
			this.selectedFromEvent = {
				type: event.detail.type,
				value: event.detail.value
			};
		} else {
			this.selectedFromEvent = null;
		}
		this.publishChange();
	}

	handleToChange(event) {
		if (event.detail.type && event.detail.value) {
			this.selectedToEvent = {
				type: event.detail.type,
				value: event.detail.value
			};
		} else {
			this.selectedToEvent = null;
		}
		this.publishChange();
	}

	publishChange() {
		this.dispatchEvent(
			new CustomEvent('fieldchange', {
				detail: {
					productType: this.productType,
					objectType: this.objectType,
					fieldName: this.fieldName,
					filters: [this.selectedFromEvent, this.selectedToEvent]
				},
				bubbles: true,
				composed: true
			})
		);
	}
}