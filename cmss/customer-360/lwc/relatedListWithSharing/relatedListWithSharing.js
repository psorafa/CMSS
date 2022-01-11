import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getColumns from '@salesforce/apex/RelatedListWithSharingController.getFieldsDetailsWithButtons';
import getData from '@salesforce/apex/RelatedListWithSharingController.getDataForDataTable';

import shareRelatedAccount from '@salesforce/apex/RelatedListWithSharingController.shareRelatedAccount';

export default class RelatedListWithSharing extends NavigationMixin(LightningElement) {
	@api recordId;

	@api label;
	@api sharingEnabled;
	@api relationshipObjectName = '';
	@api relationPrimaryLookupField = '';
	@api relationSecondaryLookupField = '';
	@api fieldsToDisplay = '';
	@api fieldLabels = '';
	@api iconName;
	@api condition;

	tableData;
	tableColumns;
	loading;

	connectedCallback() {
		getColumns({
			objectName: this.relationshipObjectName,
			fieldsToShow: this.fieldsToDisplay.split(',')
		})
			.then((data) => {
				if (data) {
					this.tableColumns = data;
					if (this.fieldLabels) {
						const fieldLabelsParsed = this.fieldLabels.split(',');
						this.tableColumns = this.tableColumns.map((element) => {
							return {
								...element,
								label: fieldLabelsParsed[this.tableColumns.indexOf(element)]
							};
						});
					}
				}
			})
			.catch((error) => {
				console.log(error);
			});

		getData({
			sObjectName: this.relationshipObjectName,
			fieldsToShow: this.fieldsToDisplay.split(','),
			condition:
				' (' +
				this.relationPrimaryLookupField +
				" = '" +
				this.recordId +
				"' OR " +
				this.relationSecondaryLookupField +
				" = '" +
				this.recordId +
				"') " +
				(this.condition ? ' AND ' + this.condition : ''),
			recordId: this.recordId,
			primaryRelationField: this.relationPrimaryLookupField,
			secondaryRelationField: this.relationSecondaryLookupField
		})
			.then((data) => {
				if (data) {
					this.tableData = this.processData(data);
				}
			})
			.catch((error) => {
				console.log(error);
			});
	}

	processData(jsonData) {
		let parsedData = JSON.parse(jsonData);

		if (parsedData) {
			parsedData = this.switchPrimarySecondaryLookups(parsedData);

			parsedData.forEach((record) => {
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
				record['Link'] = window.location.origin;
				+'/' + record.Id;
			});
		}

		return parsedData;
	}

	switchPrimarySecondaryLookups(originalArray) {
		let resultArray = [];
		resultArray = originalArray.map((record) => {
			if (record[this.relationSecondaryLookupField].replace('/', '') === this.recordId) {
				const primaryValue = record[this.relationPrimaryLookupField.replace('Id', '').replace('__c', '__r')];
				const primaryIdValue = record[this.relationPrimaryLookupField];
				return {
					...record,
					[this.relationPrimaryLookupField.replace('Id', '').replace('__c', '__r')]:
						record[this.relationSecondaryLookupField.replace('Id', '').replace('__c', '__r')],
					[this.relationSecondaryLookupField.replace('Id', '').replace('__c', '__r')]: primaryValue,
					[this.relationPrimaryLookupField]: record[this.relationSecondaryLookupField],
					[this.relationSecondaryLookupField]: primaryIdValue
				};
			} else {
				return record;
			}
		});
		return resultArray;
	}

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

	handleRowActions(event) {
		var clickedFieldNameRaw = event.detail.action?.label?.fieldName;
		var splitedName = clickedFieldNameRaw.split('.');
		var clickedFieldName = splitedName.length === 1 ? splitedName[0] : splitedName[splitedName.length - 2];
		clickedFieldName = clickedFieldName.endsWith('__r') ? clickedFieldName.replace('__r', '__c') : clickedFieldName;
		splitedName.pop();
		var objectRelation = splitedName.join('.') + '';
		if (objectRelation.endsWith('Asset') || objectRelation.endsWith('Account')) {
			objectRelation = objectRelation + 'Id';
		}
		if (splitedName.length === 0) {
			objectRelation = 'Id';
		}
		var clickedObjId = event.detail.row[objectRelation].replaceAll('/', '').replaceAll('\\', '');

		this.loading = true;
		shareRelatedAccount({ objectId: clickedObjId, sharingDisabled: !this.sharingEnabled })
			.then((objectApiName) => {
				this[NavigationMixin.GenerateUrl]({
					type: 'standard__recordPage',
					attributes: {
						recordId: clickedObjId,
						objectApiName: objectApiName,
						actionName: 'view'
					}
				}).then((url) => {
					window.open(url, '_blank');
				});
			})
			.catch((error) => {
				console.error('Error:', error);
			})
			.finally(() => (this.loading = false));
	}
}
