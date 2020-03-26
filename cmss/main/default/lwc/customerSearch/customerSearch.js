/**
 * Created by a.olexova on 3/17/2020.
 *
 * Component to allow searching among all the clients, even those that are not in the portfolio of the current user
 */

import { LightningElement, track, wire } from 'lwc';
import findRecords from '@salesforce/apex/CustomerSearchController.findRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

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
import nameMissingMessage from '@salesforce/label/c.NamesMissingMessage';
import searchButton from '@salesforce/label/c.SearchButton';
import errorLabel from '@salesforce/label/c.Error';
import noRecordsFound from '@salesforce/label/c.NoRecordsFound';

const CLIENTS = 'CLIENTS';

export default class CustomerSearch extends NavigationMixin(LightningElement) {
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
    @track isCompRegNumRequired = true;
    @track isFirstNameRequired = false;
    @track isLastNameRequired = false;
    @track isAssetNumberRequired = true;

    @track isSearchButtonDisabled = true;

    label = {clientIdentificationTitle, firstNamePlaceholder, lastNamePlaceholder, birthNrPlaceholder,
                compRegNrPlaceholder, assetPlaceholder, clientLabel, assetLabel, missingMessage, searchButton,
                nameMissingMessage, errorLabel, noRecordsFound
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

    // function that handles input fields in case of change of any input field on the screen
    // only one of compRegNr, birthNumber and assetNumber can be filled at the time and person area (names) is shown only if Birth Number is not empty
    disableInputs(event) {
        this.updateVariables(event);

        if ((this.inputCompRegNum == undefined || this.inputCompRegNum == '') && (this.inputBirthNumber == undefined || this.inputBirthNumber == '') && (this.inputAssetNumber == undefined || this.inputAssetNumber == '')) {
            // if nothing is filled
            this.showClientSearch = true;
            this.showCompRegNum = true;
            this.isCompRegNumRequired = true;
            this.showBirthNumber = true;
            this.isBirthNumberRequired = true;
            this.showPersonArea = false;
            this.showAssetNumber = true;
            this.isAssetNumberRequired = true;
            this.isSearchButtonDisabled = true;
        } else if ((this.inputBirthNumber != undefined && this.inputBirthNumber != '') && (this.inputCompRegNum == undefined || this.inputCompRegNum == '' ) && (this.inputAssetNumber == undefined || this.inputAssetNumber == '')) {
            // if Personal Identification Number is filled in
            this.showClientSearch = true;
            this.showBirthNumber = true;
            this.isBirthNumberRequired = true;
            this.showPersonArea = true;
            this.isLastNameRequired = false;
            this.isFirstNameRequired = false;
            this.showCompRegNum = false;
            this.isCompRegNumRequired = false;
            this.inputCompRegNum = '';
            this.showAssetNumber = false;
            this.isAssetNumberRequired = false;
            this.inputAssetNumber = '';
            if (event.target.checkValidity()) this.isSearchButtonDisabled = false;

            if ((this.inputFirstName == undefined || this.inputFirstName == '') && (this.inputLastName == undefined || this.inputLastName == '')) {
                //if neither FirstName nor LastName filled in
                this.isLastNameRequired = true;
                this.isFirstNameRequired = true;
                this.isSearchButtonDisabled = true;
            } else {
                //if one of FirstName or LastName not blank
                this.isSearchButtonDisabled = false;
                this.isFirstNameRequired = false;
                this.isLastNameRequired = false;
                if (event.target.checkValidity()) this.isSearchButtonDisabled = false;
            }
        } else if ((this.inputCompRegNum != undefined && this.inputCompRegNum != '') && (this.inputBirthNumber == undefined || this.inputBirthNumber == '') && (this.inputAssetNumber == undefined || this.inputAssetNumber == '')) {
            // if Company Registration Number is filled in
            this.showClientSearch = true;
            this.showCompRegNum = true;
            this.isCompRegNumRequired = true;
            this.showBirthNumber = false;
            this.isBirthNumberRequired = false;
            this.inputBirthNumber = '';
            this.showPersonArea = false;
            this.isLastNameRequired = false;
            this.isFirstNameRequired = false;
            this.showAssetNumber = false;
            this.isAssetNumberRequired = false;
            this.inputAssetNumber = '';
            if (event.target.checkValidity()) this.isSearchButtonDisabled = false;
        } else if ((this.inputAssetNumber != undefined && this.inputAssetNumber != '') && (this.inputCompRegNum == undefined || this.inputCompRegNum == '') && (this.inputBirthNumber == undefined || this.inputBirthNumber == '')) {
            // if Asset Name is filled in
            this.showClientSearch = false;
            this.showAssetNumber = true;
            this.isAssetNumberRequired = true;
            this.showCompRegNum = false;
            this.isCompRegNumRequired = false;
            this.inputCompRegNum = '';
            this.showBirthNumber = false;
            this.isBirthNumberRequired = false;
            this.inputBirthNumber = '';
            this.showPersonArea = false;
            this.isLastNameRequired = false;
            this.isFirstNameRequired = false;
            if (event.target.checkValidity()) this.isSearchButtonDisabled = false;
        }
    }

    // function checking from which input field the change event was fired and updates the relevant variable
    // used in disableInputs method
    updateVariables(event) {
        if(event.target.name === 'compRegNr') this.inputCompRegNum = event.detail.value;
        else if(event.target.name === 'birthNumber') this.inputBirthNumber = event.detail.value;
        else if(event.target.name === 'assetNumber') this.inputAssetNumber = event.detail.value;
        else if(event.target.name === 'lastName') this.inputLastName = event.detail.value;
        else if(event.target.name === 'firstName') this.inputFirstName = event.detail.value;
    }

    //function triggered by onclick event of the search button
    //calls the apex method to search the database providing the attributes from input fields
    //on success shows the message that no record found or redirect to the record page (account or lead)
    searchClient(event) {
        console.log(' =====> searchClient() <===== ')
        console.log(' =====> compRegNum ' + this.inputCompRegNum + ', birthNum ' + this.inputBirthNumber+ ', firstName ' + this.inputFirstName + ', lastName ' + this.inputLastName + ', assetNum ' + this.inputAssetNumber);

        if (!this.inputBirthNumber && !this.inputCompRegNum && !this.inputAssetNumber) {
            this.showToast('error', this.label.errorLabel, this.label.missingMessage);
        } else if (this.inputBirthNumber && !this.inputFirstName && !this.inputLastName) {
            this.showToast('error', this.label.errorLabel, this.label.nameMissingMessage);
        } else {
            this.spinner = true;
            findRecords({
                searchedFirstName: this.inputFirstName,
                searchedLastName: this.inputLastName,
                searchedBirthNumber: this.inputBirthNumber,
                searchedCompRegNum: this.inputCompRegNum,
                searchedAssetNumber: this.inputAssetNumber,
                searchAmongWhat: CLIENTS
            })
            .then ((data) => {
                if (data && data !== undefined && data.length > 0) {
                    this.navigateToFoundRecord(data);
                } else {
                    this.hideSpinner();
                    this.showToast('warning', this.label.noRecordsFound, '');
                }
            })
            .catch ((error) => {
                this.hideSpinner();
                this.showToast('error', this.label.errorLabel, error.body.exceptionType + ': ' + error.body.message);
            })
        }
    }

    // called from  searchClient method
    //if apex returns some records, the page is redirected to the first record page (account or lead)
    //in case assets are returned from apex, the method redirects to their related Account instead
    navigateToFoundRecord(data) {
        console.log(' =====> navigateToFoundRecord() <===== ')
        this.hideSpinner();
        if (this.inputAssetNumber != undefined && this.inputAssetNumber != '') {
            this.navigateToRecordPage(data[0].AccountId);
        } else {
            this.navigateToRecordPage(data[0].Id);
        }
    }

    navigateToRecordPage(recordIdToRedirect) {
        // Navigate to the record page
        console.log(' =====> navigating to record page for Id : ' + recordIdToRedirect);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordIdToRedirect,
                objectApiName: 'Account',
                actionName: 'view',
            },
        });
    }

    hideSpinner() {
        this.delayTimeout = setTimeout(() => {
            this.spinner = false;
        }, 500);
    }

    showToast(v, t, m) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: t,
                message: m,
                variant: v
            })
        );
    }

}