import { api, LightningElement } from 'lwc';

export default class CustomSearchDynamicSingleFilter extends LightningElement {
	@api
	filterValues = [];

	@api
	inputType;

	@api
	label;

	@api
	fieldDataType;

	selectedFilterValue;
	selectedValue;

	get isNotPicklist() {
		return this.fieldDataType !== 'Picklist';
	}

	handleValueChange(event) {
		this.selectedValue = event.target.value;
		this.publishEventToParent();
	}

	handleFilterChange(event) {
		this.selectedFilterValue = this.template.querySelector('select.slds-select').value;
		if (this.fieldDataType === 'Picklist') {
			this.selectedValue = this.selectedFilterValue;
		}
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