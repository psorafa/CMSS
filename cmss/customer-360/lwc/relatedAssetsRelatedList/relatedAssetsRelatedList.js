import { LightningElement, api, wire } from 'lwc';
import getDataForDataTable from '@salesforce/apex/RelatedAssetsRelatedListController.getDataForDataTable';

export default class RelatedAssetsRelatedList extends LightningElement {
	@api recordId;
	@api columns = [
		{
			label: 'Navázaná smlouva',
			fieldName: 'relatedAssetUrl',
			type: 'url',
			typeAttributes: {
				label: {
					fieldName: 'relatedAsset'
				}
			}
		},
		{
			label: 'Typ produktu',
			fieldName: 'productType',
			type: 'text'
		},
		{
			label: 'Typ vztahu',
			fieldName: 'relationshipType',
			type: 'text'
		},
		{
			label: 'Klient navázané smlouvy',
			fieldName: 'clientUrl',
			type: 'url',
			typeAttributes: {
				label: {
					fieldName: 'clientName'
				}
			}
		},
		{ label: 'Platnost od', fieldName: 'fromDate', type: 'date' },
		{ label: 'Platnost do', fieldName: 'toDate', type: 'date' }
	];

	@api tableData = [];

	@wire(getDataForDataTable, { assetId: '$recordId' })
	getDataForTable({ data, error }) {
		if (data) {
			this.tableData = JSON.parse(data).map((assetRelation) => {
				const relatedAssetData =
					assetRelation.AssetId === this.recordId ? assetRelation.RelatedAsset : assetRelation.Asset;
				return {
					Id: assetRelation.Id,
					relatedAsset: relatedAssetData.Name,
					relatedAssetUrl: '/' + relatedAssetData.Id,
					clientName: relatedAssetData.Account.Name,
					clientUrl: '/' + relatedAssetData.Account.Id,
					productType: assetRelation.ProductTypeAssetId__c,
					relationshipType: assetRelation.RelationshipType,
					fromDate: assetRelation.FromDate,
					toDate: assetRelation.ToDate
				};
			});
			console.log(this.tableData);
		} else if (error) {
			console.log(error);
		}
	}
}
