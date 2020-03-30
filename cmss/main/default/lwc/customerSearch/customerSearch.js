/**
 * Created by a.olexova on 3/17/2020.
 *
 * Component to allow searching among all the clients, even those that are not in the portfolio of the current user
 */

import { LightningElement, track, wire, api } from 'lwc';
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
    spinner = false;

    inputLastName = '';
    inputFirstName = '';
    inputBirthNumber = '';
    inputCompRegNum = '';
    inputAssetNumber = '';

    @track labelLastName = '';
    @track labelFirstName = '';
    @track labelBirthNumber = '';
    @track labelCompRegNum = '';
    @track labelAssetNumber = '';

    @track label = {clientIdentificationTitle, firstNamePlaceholder, lastNamePlaceholder, birthNrPlaceholder,
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

    @api
    get isSearchButtonDisabled() {
        let disabled = false;
        let inputFields = this.template.querySelectorAll('lightning-input');
        inputFields.forEach(field => {
            if ((field.name !== 'firstName' && field.name !== 'lastName' && !field.checkValidity())
                || ((field.name === 'firstName' || field.name === 'lastName') && this.inputFirstName == '' && this.inputLastName == '')) {
                disabled = true;
            }
        });
        return disabled;
    }

    @api
    get isBirthNumberRequiredAndVisible() {
        if ((this.inputCompRegNum == undefined || this.inputCompRegNum == '')
                && (this.inputAssetNumber == undefined || this.inputAssetNumber == '')) {
            return true;
        } else {
            return false;
        }
    }

    @api
    get isCompRegNumRequiredAndVisible() {
        if ((this.inputBirthNumber == undefined || this.inputBirthNumber == '')
                && (this.inputAssetNumber == undefined || this.inputAssetNumber == '')) {
            return true;
        } else {
            return false;
        }
    }

    @api
    get isAssetNumberRequiredAndVisible() {
        if ((this.inputBirthNumber == undefined || this.inputBirthNumber == '')
                && (this.inputCompRegNum == undefined || this.inputCompRegNum == '')) {
            return true;
        } else {
            return false;
        }
    }

    @api
    get isFirstNameRequired() {
        if ((this.inputBirthNumber != undefined && this.inputBirthNumber != '')
                && (this.inputLastName == undefined || this.inputLastName == '')) {
            return true;
        } else {
            return false;
        }
    }

    @api
    get isLastNameRequired() {
        if ((this.inputBirthNumber != undefined && this.inputBirthNumber != '')
                && (this.inputFirstName == undefined || this.inputFirstName == '')) {
            return true;
        } else {
            return false;
        }
    }

    @api
    get showPersonArea() {
        if (this.inputBirthNumber != undefined && this.inputBirthNumber != '') {
            return true;
        } else {
            return false;
        }
    }

    @api
    get showClientSearch() {
        if (this.inputAssetNumber == undefined || this.inputAssetNumber == '') {
            return true;
        } else {
            return false;
        }
    }

    // function checking from which input field the change event was fired and updates the relevant variable
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
        if (!this.inputBirthNumber && !this.inputCompRegNum && !this.inputAssetNumber) {
            this.showToast('error', this.label.errorLabel, this.label.missingMessage);
        } else if (this.inputBirthNumber && !this.inputFirstName && !this.inputLastName) {
            this.showToast('error', this.label.errorLabel, this.label.nameMissingMessage);
        } else {
            this.isSearchButtonDisabled = true;
            this.spinner = true;
            let searchCriteria = {firstName: this.inputFirstName, lastName: this.inputLastName, birthNumber: this.inputBirthNumber,
                                  compRegNum: this.inputCompRegNum, assetNumber: this.inputAssetNumber, searchAmong: CLIENTS};

            findRecords({
                searchCriteria : searchCriteria
            })
            .then ((data) => {
                if (data && data !== undefined && data.length > 0) {
                    this.navigateToFoundRecord(data);
                } else {
                    this.hideSpinner();
                    this.showToast('warning', this.label.noRecordsFound, '');
                    this.isSearchButtonDisabled = false;
                }
            })
            .catch ((error) => {
                this.hideSpinner();
                this.showToast('error', this.label.errorLabel, error.body.exceptionType + ': ' + error.body.message);
                this.isSearchButtonDisabled = false;
            })
        }
    }

    // called from  searchClient method
    //if apex returns some records, the page is redirected to the first record page (account or lead)
    //in case assets are returned from apex, the method redirects to their related Account instead
    navigateToFoundRecord(data) {
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