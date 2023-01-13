import { LightningElement, wire, api } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import SEARCH_CONFIGURATION_OBJECT from '@salesforce/schema/CustomSearchConfiguration__c';
import loadBaseConfiguration from '@salesforce/apex/CustomSearchController.loadBaseConfigurationList';
import LBL_SelectedConfiguration from '@salesforce/label/c.SelectedConfiguration';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CustomSearchSelectBaseConfiguration extends LightningElement {
	columns;
	data;

	@api
	objectType;

	@api
	productName;

	labels = { LBL_SelectedConfiguration };

	@wire(getObjectInfo, { objectApiName: SEARCH_CONFIGURATION_OBJECT })
	loadColumnsData({ error, data }) {
		if (data) {
			const columnNameLabel = data.fields.Name.label;
			const columnConditionLabel = data.fields.Description__c.label;
			this.columns = [
				{ label: columnNameLabel, fieldName: 'Name' },
				{ label: columnConditionLabel, fieldName: 'Description__c' }
			];
		} else if (error) {
			this.errorToastMessage('', error.body.message);
		}
	}

	@wire(loadBaseConfiguration, { objectApiName: '$objectType', productName: '$productName' })
	loadData({ error, data }) {
		if (data) {
			this.data = data;
		} else if (error) {
			this.errorToastMessage('', error.body.message);
		}
	}

	handleRowSelect(event) {
		const selectedRows = event.detail.selectedRows;
		if (selectedRows.length > 0) {
			const filterEvent = new CustomEvent('selectconfiguration', {
				detail: selectedRows[0]
			});
			this.dispatchEvent(filterEvent);
		}
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