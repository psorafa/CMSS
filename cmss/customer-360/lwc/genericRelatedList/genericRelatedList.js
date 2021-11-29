/*
 * Will render custom related list using lightning-datatable. Takes data in json string (via jsonData parameter) and
 * columns to be displayed as comma-separated list of API names.
 */
import { LightningElement, api, track } from 'lwc';
import getFieldsDetails from '@salesforce/apex/GenericRelatedListController.getFieldsDetails';
import { loadStyle } from 'lightning/platformResourceLoader';
import genericRelatedListCSS from '@salesforce/resourceUrl/genericRelatedList';

export default class GenericRelatedList extends LightningElement {
	@track data;
	@track colsData;
	@track error;

	@api cols;
	@api iconName;
	@api relatedObjectName;
	@api colsAddition;

	sfdcBaseURL;

	renderedCallback() {
		this.sfdcBaseURL = window.location.origin;
		Promise.all([loadStyle(this, genericRelatedListCSS)])
			.then(() => {
				console.log('css loaded');
			})
			.catch(error => {
				console.log('error', error);
			});
	}

	@api
	set relatedListName(value) {
		if (value) {
			this.headerTitle = value;
		}
	}
	get relatedListName() {
		return this.headerTitle;
	}

	@api
	set jsonData(value) {
		if (value) {
			this.data = this.processData(value);
		}
	}

	get jsonData() {
		return this.data;
	}

	get records() {
		if (this.data) {
			return this.data;
		} else {
			return [];
		}
	}

	get anyData() {
		return this.data && this.colsData && this.data.length > 0;
	}

	connectedCallback() {
		var fields = this.cols.split(',');
		this.loading = true;

		getFieldsDetails({
			objectName: this.relatedObjectName,
			fieldsToShow: fields
		})
			.then(fieldsDetails => {
				this.colsData = fieldsDetails;
				if (this.colsAddition) {
					this.colsData.push(this.colsAddition);
				}
				this.loading = false;
			})
			.catch(error => {
				console.log('error', error);
				this.loading = false;
				this.error = JSON.stringify(error, undefined, 4);
			});
	}

	/*
	 * This function processes data and match correct Id Links to their records used in lightning-datatable
	 */
	processData(jsonData) {
		let parsedData = JSON.parse(jsonData);
		if (parsedData) {
			parsedData.forEach(record => {
				for (const fieldName in record) {
					const value = record[fieldName];
					if (value && typeof value === 'object') {
						const newValue = value.Id ? '/' + value.Id : null;
						this.flattenStructure(record, fieldName, value);
						if (newValue === null) {
							delete record[fieldName];
						} else {
							record[fieldName] = newValue;
						}
					}
				}
				record['Link'] = this.sfdcBaseURL + '/' + record.Id;
			});
		}
		this.headerTitle += ' (' + parsedData.length + ')';
		return parsedData;
	}

	/*
	 * to flatten the data structure, as datatable component does not allow to use deeper attributes. Also will
	 * generate '.Link' attributes to use in clickable links.
	 */
	flattenStructure(topObject, prefix, toBeFlattened) {
		for (const prop in toBeFlattened) {
			const curVal = toBeFlattened[prop];
			if (typeof curVal === 'object') {
				this.flattenStructure(topObject, prefix + '.' + prop, curVal);
			} else if (prop == 'Id') {
				if (window.location.toString().includes('lightning')) {
					topObject[prefix + '.Link'] = '/lightning/r/' + prefix + '/' + curVal + '/view';
				} else {
					topObject[prefix + '.Link'] =
						'/s/' + toBeFlattened.attributes.type.toLowerCase() + '/' + curVal + '/view';
				}
			} else {
				topObject[prefix + '.' + prop] = curVal;
			}
		}
	}
}
