/*
 * Related list displays Assets including Assets related via Account-Asset relationships.
 * It uses genericRelatedList component and adds "Relation" as last column.
 */

import { LightningElement, api, track } from 'lwc';
import getDataForDatatable from '@salesforce/apex/AssetRelatedListController.getDataForDataTable';

import assetsLabel from '@salesforce/label/c.Assets';
import relationLabel from '@salesforce/label/c.Relation';

export default class AssetRelatedList extends LightningElement {

    label = {
        assetsLabel,
        relationLabel
    }

	@track jsonData;
	@track error;
	@api recordId;
	@api columns;
	@api conditionAssets;
	@api conditionRelations;

    get relationColumnDefinition() {
        return {
            label: this.label.relationLabel,
            fieldName: 'Relation.Link',
            hideDefaultActions: 'true',
            type: 'url',
            sortable: 'false',
            typeAttributes: {
                label: {
                    fieldName: 'Relation.RelationType__c'
                },
                target: '_blank'
            }
        }
    }

	connectedCallback() {
		getDataForDatatable({
            fieldsToShow: this.columns.split(','),
            accountId: this.recordId,
            conditionAssets: this.conditionAssets,
            conditionRelations: this.conditionRelations
		})
        .then(dataForDatatable => {
            this.jsonData = dataForDatatable;
        })
        .catch(error => {
            console.log('error', error);
            this.error = JSON.stringify(error, null, 4);
        });
	}
}
