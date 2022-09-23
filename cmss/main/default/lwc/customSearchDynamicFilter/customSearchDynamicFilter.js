import { api, LightningElement, wire } from 'lwc';
import getCustomFilterMap from '@salesforce/apex/CustomSearchController.getCustomFilterMap';
import LBL_AdditionFilterParams from '@salesforce/label/c.AdditionFilterParams';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CustomSearchDynamicFilter extends LightningElement {
	@api
	objectType;

	@api
	productName;

	customFilterItems;

	fieldsWithCustomFilters = [];

	labels = { LBL_AdditionFilterParams };

	@wire(getCustomFilterMap, { objectType: '$objectType', productName: '$productName' })
	loadCustomFilterMap({ error, data }) {
		if (data) {
			this.customFilterItems = data;
			this.fieldsWithCustomFilters = [];
		} else if (error) {
			this.errorToastMessage('', error.body.message);
		}
	}

	handleFieldChange(event) {
		const eventData = event.detail;

		const existingItem = this.fieldsWithCustomFilters.filter(
			item =>
				item.fieldName === eventData.fieldName &&
				item.objectName === eventData.objectType &&
				item.productType === eventData.productType
		);

		if (existingItem.length >= 1) {
			if (eventData.filters.length > 0) {
				existingItem[0].filters = eventData.filters;
			} else {
				this.fieldsWithCustomFilters.splice(existingItem[0], 1);
			}
		} else {
			const selectedFilterItems = this.customFilterItems.filter(
				item =>
					item.fieldName === eventData.fieldName &&
					item.relatedObject === eventData.objectType &&
					item.productType === eventData.productType
			);
			const item = selectedFilterItems[0];
			const newItem = {
				productType: item.productType,
				objectName: item.relatedObject,
				fieldName: item.fieldName,
				dataType: item.dataType,
				filters: eventData.filters
			};
			if (newItem.filters.length > 0) {
				this.fieldsWithCustomFilters.push(newItem);
			}
		}

		const filterEvent = new CustomEvent('updatefilter', {
			detail: {
				filterItems: this.fieldsWithCustomFilters
			}
		});
		this.dispatchEvent(filterEvent);
	}

	errorToastMessage(title, message) {
		this.toastMessage('error', title, message);
	}

	loadFromArray(fieldName, objectName, productType, array) {
		return array.filter(
			item => item.fieldName === fieldName && item.objectName === objectName && item.productType === productType
		);
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
