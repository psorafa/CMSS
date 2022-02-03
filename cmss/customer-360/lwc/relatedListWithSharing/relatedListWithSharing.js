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
		let fieldsToQuery = this.fieldsToDisplay;
		//Special case for AssetRelationship
		if (this.relationshipObjectName === 'AssetRelationship') {
			fieldsToQuery += ',ProductTypeAssetId__c';
		}
		//Special case for AccountRelation__c
		if (this.relationshipObjectName === 'AccountRelation__c') {
			fieldsToQuery += ',AccountRole__c';
		}
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
			fieldsToShow: fieldsToQuery.split(','),
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
				let specificValues = this.getSpecificValues(record);
				return {
					...record,
					[this.relationPrimaryLookupField.replace('Id', '').replace('__c', '__r')]:
						record[this.relationSecondaryLookupField.replace('Id', '').replace('__c', '__r')],
					[this.relationSecondaryLookupField.replace('Id', '').replace('__c', '__r')]: primaryValue,
					[this.relationPrimaryLookupField]: record[this.relationSecondaryLookupField],
					[this.relationSecondaryLookupField]: primaryIdValue,
					...specificValues
				};
			} else {
				return record;
			}
		});
		return resultArray;
	}

	getSpecificValues(record) {
		if (record.hasOwnProperty('ProductTypeRelatedAsset__c')) {
			//Special case for AssetRelationship
			return {
				ProductTypeAssetId__c: record['ProductTypeRelatedAsset__c'],
				ProductTypeRelatedAsset__c: record['ProductTypeAssetId__c']
			};
		}
		if (record.hasOwnProperty('RelatedAccountRole__c')) {
			//Special case for AccountRelation__c
			return {
				AccountRole__c: record['RelatedAccountRole__c'],
				RelatedAccountRole__c: record['AccountRole__c']
			};
		}
		return {};
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
		let clickedFieldNameRaw = event.detail.action?.label?.fieldName;
		let splitedName = clickedFieldNameRaw.split('.');
		let clickedFieldName = splitedName.length === 1 ? splitedName[0] : splitedName[splitedName.length - 2];
		clickedFieldName = clickedFieldName.endsWith('__r') ? clickedFieldName.replace('__r', '__c') : clickedFieldName;
		splitedName.pop();
		let objectRelation = splitedName.join('.') + '';
		if (objectRelation.endsWith('Asset') || objectRelation.endsWith('Account')) {
			objectRelation = objectRelation + 'Id';
		}
		if (splitedName.length === 0) {
			objectRelation = 'Id';
		}
		let clickedObjId = event.detail.row[objectRelation].replaceAll('/', '').replaceAll('\\', '');

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
