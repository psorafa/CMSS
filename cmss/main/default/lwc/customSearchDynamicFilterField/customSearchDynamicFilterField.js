import { LightningElement, api, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CustomSearchDynamicFilterField extends LightningElement {
	@api
	filterValues = [];

	@api
	fieldDataType;

	@api
	objectType;

	@api
	fieldName;

	@api
	productType;

	@api
	label;

	selectedValue;

	/*@wire(getObjectInfo, { objectApiName: '$objectType' })
	oppInfo({ data, error }) {
		if (data) {
			this.label = data.fields[this.fieldName].label;
		}

		if (error) {
			this.errorToastMessage('', error.body.message);
		}
	}*/

	get inputType() {
		if (this.fieldDataType === 'Date') {
			return 'date';
		} else if (this.fieldDataType === 'Boolean') {
			return 'toggle';
		} else if (this.fieldDataType === 'Number') {
			return 'number';
		}
		return 'text';
	}

	get isDateOrNumber() {
		return this.fieldDataType === 'Date' || this.fieldDataType === 'Number';
	}

	get isText() {
		return this.inputType === 'text';
	}

	get isBoolean() {
		return this.inputType === 'toggle';
	}

	handleBooleanChanged(event) {
		this.selectedValue = event.target.checked;
		let eventData = {};
		if (event.target.checked) {
			eventData = {
				productType: this.productType,
				objectType: this.objectType,
				fieldName: this.fieldName,
				filters: [{ type: '=', value: event.target.checked }]
			};
		} else {
			eventData = {
				productType: this.productType,
				objectType: this.objectType,
				fieldName: this.fieldName,
				filters: []
			};
		}
		this.publishEventToParent(eventData);
	}

	handleSingleFieldChange(event) {
		const eventDetail = event.detail;
		if (eventDetail.type && eventDetail.value) {
			const eventData = {
				productType: this.productType,
				objectType: this.objectType,
				fieldName: this.fieldName,
				filters: [{ type: eventDetail.type, value: eventDetail.value }]
			};
			this.publishEventToParent(eventData);
		} else {
			const eventData = {
				productType: this.productType,
				objectType: this.objectType,
				fieldName: this.fieldName,
				filters: []
			};
			this.publishEventToParent(eventData);
		}
	}

	handleRangeFieldChange(event) {
		this.publishEventToParent(event.detail);
	}

	publishEventToParent(eventData) {
		const event = new CustomEvent('fieldchange', {
			detail: eventData
		});
		this.dispatchEvent(event);
	}

	errorToastMessage(title, message) {
		this.toastMessage('error', title, message);
	}

	toastMessage(variant, title, message) {
		const evt = new ShowToastEvent({
			variant: variant,
			title: title,
			message: message,
			mode: 'sticky'
		});
		this.dispatchEvent(evt);
	}
}
