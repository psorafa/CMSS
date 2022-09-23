import { api, LightningElement } from 'lwc';

export default class CustomSearchDynamicSingleFilter extends LightningElement {
	@api
	filterValues = [];

	@api
	inputType;

	@api
	label;

	selectedFilterValue;
	selectedValue;

	handleValueChange(event) {
		this.selectedValue = event.target.value;
		this.publishEventToParent();
	}

	handleFilterChange(event) {
		this.selectedFilterValue = this.template.querySelector('select.slds-select').value;
		this.publishEventToParent();
	}

	publishEventToParent() {
		if (this.selectedValue && this.selectedFilterValue) {
			const event = new CustomEvent('fieldchange', {
				detail: {
					type: this.selectedFilterValue,
					value: this.selectedValue
				}
			});
			this.dispatchEvent(event);
		} else {
			const event = new CustomEvent('fieldchange', {
				detail: {}
			});
			this.dispatchEvent(event);
		}
	}
}
