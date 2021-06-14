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
import invalidValuesMessage from '@salesforce/label/c.InputValuesNotValidMessage';
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

	@track searchResults = [];
	@track noRecordsFound = true;
	@track showResults = false;
	@track isSearchButtonDisabled = true;

    @track labelName = '';
    @track labelBirthNumber = '';
    @track labelCompRegNum = '';
    @track labelEmail = '';
    @track labelGlobalId = '';
    @track labelCompRegNum = '';
    @track labelCity = '';
    @track labelPostalCode = '';
    @track labelAssetNumber = '';

	@track label = {
		clientIdentificationTitle,
		firstNamePlaceholder,
		lastNamePlaceholder,
		birthNrPlaceholder,
		compRegNrPlaceholder,
		assetPlaceholder,
		clientLabel,
		assetLabel,
		missingMessage,
		searchButton,
		nameMissingMessage,
		errorLabel,
		noRecordsFound,
		invalidValuesMessage
	};

	//getting the labels of the fields from account object
	@wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
	accInfo({ data }) {
		if (data) {
			this.labelBirthNumber = data.fields.PersonalIdentificationNr__c.label;
			this.labelCompRegNum = data.fields.CompanyRegistrationNumber__c.label;
			this.labelFirstName = data.fields.FirstName.label;
			this.labelLastName = data.fields.LastName.label;
		}
	}

	//getting the labels of the fields from asset object
	@wire(getObjectInfo, { objectApiName: ASSET_OBJECT })
	assetInfo({ data }) {
		if (data) {
			this.labelAssetNumber = data.fields.Name.label;
		}
	}

	@api
	get isBirthNumberRequiredAndVisible() {
		return !this.inputCompRegNum && !this.inputAssetNumber;
	}

	@api
	get isCompRegNumRequiredAndVisible() {
		return !this.inputBirthNumber && !this.inputAssetNumber;
	}

	@api
	get isAssetNumberRequiredAndVisible() {
		return !this.inputBirthNumber && !this.inputCompRegNum;
	}

	@api
	get isFirstNameRequired() {
		return this.inputBirthNumber && !this.inputLastName;
	}

	@api
	get isLastNameRequired() {
		return this.inputBirthNumber && !this.inputFirstName;
	}

	@api
	get showPersonArea() {
		return this.inputBirthNumber && true;
	}

	@api
	get showClientSearch() {
		return !this.inputAssetNumber;
	}

	// function checking from which input field the change event was fired and updates the relevant variable
	updateVariables(event) {
		if (event.target.name === 'compRegNr') {
			this.inputCompRegNum = event.detail.value;
		} else if (event.target.name === 'birthNumber') {
			this.inputBirthNumber = event.detail.value;
		} else if (event.target.name === 'assetNumber') {
			this.inputAssetNumber = event.detail.value;
		} else if (event.target.name === 'lastName') {
			this.inputLastName = event.detail.value;
		} else if (event.target.name === 'firstName') {
			this.inputFirstName = event.detail.value;
		}
		event.target.reportValidity();
		this.isSearchCriteriaOk();
	}

	//function triggered by onclick event of the search button
	//calls the apex method to search the database providing the attributes from input fields
	//on success shows the message that no record found or redirect to the record page (account or lead)
	searchClient() {
		if (!this.inputBirthNumber && !this.inputCompRegNum && !this.inputAssetNumber) {
			this.showToast('error', this.label.errorLabel, this.label.missingMessage);
		} else if (this.inputBirthNumber && !this.inputFirstName && !this.inputLastName) {
			this.showToast('error', this.label.errorLabel, this.label.nameMissingMessage);
		} else if (!this.isSearchCriteriaOk()) {
			this.showToast('error', this.label.errorLabel, this.label.invalidValuesMessage);
		} else {
			this.isSearchButtonDisabled = true;
			this.spinner = true;
			this.searchResults = [];
			let searchCriteria = {
				firstName: this.inputFirstName,
				lastName: this.inputLastName,
				birthNumber: this.inputBirthNumber,
				compRegNum: this.inputCompRegNum,
				assetNumber: this.inputAssetNumber,
				searchAmong: CLIENTS
			};
			window.console.log(searchCriteria);
			findRecords({
				searchCriteria: searchCriteria
			})
				.then(data => {
					this.searchResults = data;
					this.isSearchButtonDisabled = false;
					if (data && data.length === 1) {
                        this.noRecordsFound = false;
                        // this.navigateToRecordPage(data[0].recordId); //### comment here
                    } else if (data && data.length > 1) {
						this.noRecordsFound = false;
					} else {
								this.showToast('info', this.label.noRecordsFound, '');
								this.noRecordsFound = true;
							}
					this.showResults = true;
					this.spinner = false;
				})
				.catch(error => {
					this.spinner = false;
					this.showToast(
						'error',
						this.label.errorLabel,
						error.body.exceptionType + ': ' + error.body.message
					);
					this.isSearchButtonDisabled = false;
				});
		}
	}

	isSearchCriteriaOk() {
		let ok = true;
		let inputFields = this.template.querySelectorAll('lightning-input');
		inputFields.forEach(field => {
			if (!field.checkValidity()) {
				ok = false;
			}
		});
		this.isSearchButtonDisabled = !ok;
		return ok;
	}

	//handler of the event fired from the child component c-customer-search-results
	//redirects to the specified record page
	handleRedirectToRecord(event) {
		this.navigateToRecordPage(event.detail.recordId);
	}

	// called from  searchClient method
	//redirects the page to the record page specified by the provided Id
	navigateToRecordPage(recordIdToRedirect) {
		// Navigate to the record page
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: recordIdToRedirect,
				actionName: 'view'
			}
		});
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

	handleKeyPress(event) {
		if ((event.keyCode === 13 || event.keyCode === '13') && this.isSearchCriteriaOk()) {
			this.searchClient();
		}
	}
}
