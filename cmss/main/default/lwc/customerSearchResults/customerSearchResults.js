/**
 * Created by a.olexova on 3/31/2020.
 * Component to show results from the search run by CustomerSearch component
 */

import { LightningElement, track, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import ASSET_OBJECT from '@salesforce/schema/Asset';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

import clientLabel from '@salesforce/label/c.Client';
import assetLabel from '@salesforce/label/c.Asset';
import errorLabel from '@salesforce/label/c.Error';
import noRecordsFound from '@salesforce/label/c.NoRecordsFound';
import goToRecordDetail from '@salesforce/label/c.NavigateToRecordButton';

export default class CustomerSearchResults extends LightningElement {
    @api searchResults;
    @api isAssetSearch;
    @api showSearchResults;
    @api showNoRecordFound;

    @track labelName = '';
    @track labelBirthNumber = '';
    @track labelCompRegNum = '';
    @track labelCity = '';
    @track labelPostalCode = '';
    @track labelAssetNumber = '';

    @track label = {clientLabel, assetLabel, errorLabel, noRecordsFound, goToRecordDetail};

    //getting the labels of the fields from Account object
    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
        accInfo({ data, error }) {
            if (data) {
                this.labelBirthNumber = data.fields.PersonalIdentificationNr__c.label;
                this.labelCompRegNum = data.fields.CompanyRegistrationNumber__c.label;
                this.labelName = data.fields.Name.label;
                this.labelCity = data.fields.BillingCity.label;
                this.labelPostalCode = data.fields.BillingPostalCode.label;
            }
        }

    //getting the labels of the fields from Asset object
    @wire(getObjectInfo, { objectApiName: ASSET_OBJECT })
        assetInfo({ data, error }) {
            if (data) {
                this.labelAssetNumber = data.fields.Name.label;
            }
        }

    navigateToRecordPage(event) {
        // Navigate to the record page
        const eventToFire = new CustomEvent('redirecttorecord', {
            detail: {recordId: event.target.value.recordId}
        });
        this.dispatchEvent(eventToFire);
    }
}