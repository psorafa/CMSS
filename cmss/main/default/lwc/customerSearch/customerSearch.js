/**
 * Created by a.olexova on 3/17/2020.
 *
 * Component to allow searching among all the clients, even those that are not in the portfolio of the current user
 */

import { LightningElement, track, wire } from 'lwc';
import findRecords from '@salesforce/apex/CustomerSearchController.findRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import ASSET_OBJECT from '@salesforce/schema/Asset';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

import clientIdentificationTitle from '@salesforce/label/c.ClientIdentification';
import firstNamePlaceholder from '@salesforce/label/c.InputPlaceholderFirstName';
import lastNamePlaceholder from '@salesforce/label/c.InputPlaceholderLastName';
import birthNrPlaceholder from '@salesforce/label/c.InputPlaceholderBirthNumber';
import compRegNrPlaceholder from '@salesforce/label/c.InputPlaceholderCompRegNr';
import assetPlaceholder from '@salesforce/label/c.InputPlaceholderAssetNumber';
import clientLabel from '@salesforce/label/c.Client';
import assetLabel from '@salesforce/label/c.Asset';
import missingMessage from '@salesforce/label/c.RequiredFieldsMessage';
import searchButton from '@salesforce/label/c.SearchButton';

const CLIENTS = 'CLIENTS';

export default class CustomerSearch extends LightningElement {
    @track spinner = false;

    @track inputLastName = '';
    @track inputFirstName = '';
    @track inputBirthNumber = '';
    @track inputCompRegNum = '';
    @track inputAssetNumber = '';

    @track labelLastName = '';
    @track labelFirstName = '';
    @track labelBirthNumber = '';
    @track labelCompRegNum = '';
    @track labelAssetNumber = '';

    @track showCompRegNum = true;
    @track showBirthNumber = true;
    @track showAssetNumber= true;
    @track showPersonArea = false;
    @track showClientSearch = true;

    @track isBirthNumberRequired = true;
    @track isBirthNumberDisabled = false;
    @track isCompRegNumRequired = true;
    @track isCompRegNumDisabled = false;
    @track isFirstNameRequired = false;
    @track isFirstNameDisabled = false;
    @track isLastNameRequired = false;
    @track isLastNameDisabled = false;
    @track isAssetNumberRequired = true;
    @track isAssetNumberDisabled = false;
    @track isSearchButtonDisabled = true;

    label = {clientIdentificationTitle, firstNamePlaceholder, lastNamePlaceholder, birthNrPlaceholder,
                compRegNrPlaceholder, assetPlaceholder, clientLabel, assetLabel, missingMessage, searchButton
                };

    //getting the labels of the fields from account object
    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
        accInfo({ data, error }) {
            if (data) {
                this.labelBirthNumber = data.fields.PersonalIdentificationNr__c.label;
                this.labelCompRegNum = data.fields.CompanyRegistrationNumber__c.label;
                this.labelFirstName = data.fields.FirstName.label;
                this.labelLastName = data.fields.LastName.label;
            }
        }

    //getting the labels of the fields from asset object
    @wire(getObjectInfo, { objectApiName: ASSET_OBJECT })
        assetInfo({ data, error }) {
            if (data) {
                this.labelAssetNumber = data.fields.Name.label;
            }
        }

    renderedCallback(){
    }

    connectedCallback(){
    }

    disconnectedCallback(){
    }

    // function that handles input fields in case of inserting either Company Registration Number or Birth Number or Asset Number
    // only one of them can be filled at the time and person area is shown only if Birth Number is not empty
    disableInputs(event) {
//        console.log(' =====> disableInputs <===== ');
//        console.log(' =====> event.target.name ' + event.target.name);
//        console.log(' =====> event.detail.value ' + event.detail.value);

        if(event.target.name === 'compRegNr') this.inputCompRegNum = event.detail.value;
        else if(event.target.name === 'birthNumber') this.inputBirthNumber = event.detail.value;
        else if(event.target.name === 'assetNumber') this.inputAssetNumber = event.detail.value;
        else if(event.target.name === 'lastName') this.inputLastName = event.detail.value;
        else if(event.target.name === 'firstName') this.inputFirstName = event.detail.value;

        // if nothing is filled
        if ((this.inputCompRegNum == undefined || this.inputCompRegNum == '') && (this.inputBirthNumber == undefined || this.inputBirthNumber == '') && (this.inputAssetNumber == undefined || this.inputAssetNumber == '')) {
            this.showClientSearch = true;
            this.showCompRegNum = true;
            this.isCompRegNumRequired = true;
            this.isCompRegNumDisabled = false;
            this.showBirthNumber = true;
            this.isBirthNumberRequired = true;
            this.isBirthNumberDisabled = false;
            this.showPersonArea = false;
            this.showAssetNumber = true;
            this.isAssetNumberRequired = true;
            this.isAssetNumberDisabled = false;
            this.isSearchButtonDisabled = true;
        }
        // if Personal Identification Number is filled in
        else if ((this.inputBirthNumber != undefined && this.inputBirthNumber != '') && (this.inputCompRegNum == undefined || this.inputCompRegNum == '' ) && (this.inputAssetNumber == undefined || this.inputAssetNumber == '')) {
            this.showClientSearch = true;
            this.showBirthNumber = true;
            this.isBirthNumberRequired = true;
            this.isBirthNumberDisabled = false;
            this.showPersonArea = true;
            this.isLastNameRequired = false;
            this.isLastNameDisabled = false;
            this.isFirstNameRequired = false;
            this.isFirstNameDisabled = false;
            this.showCompRegNum = false;
            this.isCompRegNumRequired = false;
            this.isCompRegNumDisabled = true;
            this.inputCompRegNum = '';
            this.showAssetNumber = false;
            this.isAssetNumberRequired = false;
            this.isAssetNumberDisabled = true;
            this.inputAssetNumber = '';
            if (event.target.checkValidity()) this.isSearchButtonDisabled = false;

            if ((this.inputFirstName == undefined || this.inputFirstName == '') && (this.inputLastName == undefined || this.inputLastName == '')) {
                this.isLastNameRequired = true;
                this.isFirstNameRequired = true;
                this.isSearchButtonDisabled = true;
            } else {
                this.isSearchButtonDisabled = false;
                this.isFirstNameRequired = false;
                this.isLastNameRequired = false;
                if (event.target.checkValidity()) this.isSearchButtonDisabled = false;
            }
        }

        // if Company Registration Number is filled in
        else if ((this.inputCompRegNum != undefined && this.inputCompRegNum != '') && (this.inputBirthNumber == undefined || this.inputBirthNumber == '') && (this.inputAssetNumber == undefined || this.inputAssetNumber == '')) {
            this.showClientSearch = true;
            this.showCompRegNum = true;
            this.isCompRegNumRequired = true;
            this.isCompRegNumDisabled = false;
            this.showBirthNumber = false;
            this.isBirthNumberRequired = false;
            this.isBirthNumberDisabled = true;
            this.inputBirthNumber = '';
            this.showPersonArea = false;
            this.isLastNameRequired = false;
            this.isLastNameDisabled = true;
            this.isFirstNameRequired = false;
            this.isFirstNameDisabled = true;
            this.showAssetNumber = false;
            this.isAssetNumberRequired = false;
            this.isAssetNumberDisabled = true;
            this.inputAssetNumber = '';
            if (event.target.checkValidity()) this.isSearchButtonDisabled = false;
        }

        // if Asset Name is filled in
        else if ((this.inputAssetNumber != undefined && this.inputAssetNumber != '') && (this.inputCompRegNum == undefined || this.inputCompRegNum == '') && (this.inputBirthNumber == undefined || this.inputBirthNumber == '')) {
            this.showClientSearch = false;
            this.showAssetNumber = true;
            this.isAssetNumberRequired = true;
            this.isAssetNumberDisabled = false;
            this.showCompRegNum = false;
            this.isCompRegNumRequired = false;
            this.isCompRegNumDisabled = true;
            this.inputCompRegNum = '';
            this.showBirthNumber = false;
            this.isBirthNumberRequired = false;
            this.isBirthNumberDisabled = true;
            this.inputBirthNumber = '';
            this.showPersonArea = false;
            this.isLastNameRequired = false;
            this.isLastNameDisabled = true;
            this.isFirstNameRequired = false;
            this.isFirstNameDisabled = true;
            this.isSearchButtonDisabled = false;
            if (event.target.checkValidity()) this.isSearchButtonDisabled = false;
        }

    }

    searchClient(event) {
        console.log(' =====> searchClient() <===== ')
        console.log(' =====> this.inputCompRegNum ' + this.inputCompRegNum);
        console.log(' =====> this.inputBirthNumber ' + this.inputBirthNumber);
        console.log(' =====> this.inputFirstName ' + this.inputFirstName);
        console.log(' =====> this.inputLastName ' + this.inputLastName);
        console.log(' =====> this.inputAssetNumber ' + this.inputAssetNumber);

        if (!this.inputBirthNumber && !this.inputCompRegNum && !this.inputAssetNumber) {
            this.showToast('error', 'Vyplňte alespoň jedno pole.', 'test1');
        } else if (this.inputBirthNumber && !this.inputFirstName && !this.inputLastName) {
            this.showToast('error', 'Vyplňte alespoň část jmen.', 'test2');
        } else {
            this.spinner = true;
            findRecords({
                firstName: this.inputFirstName,
                lastName: this.inputLastName,
                birthNumber: this.inputBirthNumber,
                compRegNum: this.inputCompRegNum,
                assetNumber: this.inputAssetNumber,
                searchAmong: CLIENTS
            })
            .then ((data) => {
                this.hideSpinner();
                if (data && data !== undefined) {
                    this.showToast('success', 'succes call', '');
                    data.forEach((row) => {
                        console.log('success call ' + row.Id);
                    });
                } else {
                    this.showToast('warning', 'success call but empty list', 'test4');
                }
            })
            .catch ((data) => {
                this.hideSpinner();
                this.showToast('error', 'call error', data.body.exceptionType);
            })

        }
    }

    hideSpinner(){
        this.delayTimeout = setTimeout(() => {
            this.spinner = false;
        }, 1000);
    }

    showToast(v, t, m){
//        if(m === 'System.LimitException') {
//            t = this.label.generalRequest;
//            m = this.label.refineCriteria;
//        }
        this.dispatchEvent(
            new ShowToastEvent({
                title: t,
                message: m,
                variant: v
            })
        );
    }
}