/**
 * Custom related list with filter (SOQL where) and columns selection options. If any of selected columns is 'Name'
 * it will render clickable link to that object. See metadata file for configuration.
 */

import { LightningElement, api, track } from 'lwc';
import getDataForDatatable from '@salesforce/apex/GenericRelatedListController.getDataForDataTable';

export default class FilterableRelatedList extends LightningElement {
	@track jsonData;
	@track error;

	@api recordId
	@api childObjectName
	@api parentFieldName
	@api columns
	@api listName
	@api condition
	@api iconName


	connectedCallback() {
	    let fullCondition = this.parentFieldName + '=\'' + this.recordId + '\''
	    if (this.condition) {
	        fullCondition += ' AND ' + this.condition
        }
		getDataForDatatable({
            sObjectName: this.childObjectName,
            fieldsToShow: this.columns.split(','),
            condition: fullCondition
		})
        .then(dataForDatatable => {
            this.jsonData = dataForDatatable;
        })
        .catch(error => {
            console.log('error', error);
            this.error = JSON.stringify(error, undefined, 4);
        });
	}
}
