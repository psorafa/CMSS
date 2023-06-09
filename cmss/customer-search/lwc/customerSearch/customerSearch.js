/**
 * Created by a.olexova on 3/17/2020.
 *
 * Component to allow searching among all the clients, even those that are not in the portfolio of the current user
 */

import { LightningElement, track, wire, api } from 'lwc';
import findRecords from '@salesforce/apex/CustomerSearchController.findRecords';
import assignSearchAccess from '@salesforce/apex/CustomerSearchController.assignSearchAccess';
import riskDetectionCallout from '@salesforce/apex/CustomerSearchController.riskDetectionCallout';
import searchCSOBNonClient from '@salesforce/apex/PersonManagementController.searchCSOBNonClient';
import updateCSOBNonClient from '@salesforce/apex/PersonManagementController.updateCSOBNonClient';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import ASSET_OBJECT from '@salesforce/schema/Asset';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import helpText from '@salesforce/label/c.helpTextForCustomerSearchComponent';
import clientIdentificationTitle from '@salesforce/label/c.ClientIdentification';
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
import fraudDetectionSystemError from '@salesforce/label/c.UserDoesNotHaveAccessToNEL';

const CLIENTS = 'CLIENTS';

export default class CustomerSearch extends NavigationMixin(LightningElement) {
	spinner = false;

	inputLastName = '';
	inputBirthNumber = '';
	inputCompRegNum = '';
	inputAssetNumber = '';

	@track searchResults = [];
	@track noRecordsFound = true;
	@track showResults = false;
	@track isSearchButtonDisabled = true;
	@track labelName = '';
	@track labelLastName = '';
	@track labelBirthNumber = '';
	@track labelCompRegNum = '';
	@track labelAssetNumber = '';

	@track label = {
		clientIdentificationTitle,
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
		helpText,
		invalidValuesMessage
	};

	//getting the labels of the fields from account object
	@wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
	accInfo({ data }) {
		if (data) {
			this.labelBirthNumber = data.fields.PersonalIdentificationNr__c.label;
			this.labelCompRegNum = data.fields.CompanyRegistrationNumber__c.label;
			this.labelLastName = data.fields.LastName.label;
			this.labelName = data.fields.Name.label;
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
	get isLastNameRequiredAndVisible() {
		return this.inputBirthNumber || this.inputAssetNumber;
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
		}

		this.clearHiddenValues();
		event.target.reportValidity();
		this.isSearchCriteriaOk();
	}

	clearHiddenValues() {
		if (!this.isBirthNumberRequiredAndVisible) {
			this.inputBirthNumber = '';
		}
		if (!this.isCompRegNumRequiredAndVisible) {
			this.inputCompRegNum = '';
		}
		if (!this.isAssetNumberRequiredAndVisible) {
			this.inputAssetNumber = '';
		}
		if (!this.isLastNameRequiredAndVisible) {
			this.inputLastName = '';
		}
	}

	//function triggered by onclick event of the search button
	//calls the apex method to search the database providing the attributes from input fields
	//on success shows the message that no record found or redirect to the record page (account or lead)
	searchClient(event) {
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
					return data;
				})
				.then(data => this.dataProcessing(data))
				.then(() =>
					assignSearchAccess({
						accountId: this.recordId
					})
				)
				.then(() => {
					riskDetectionCallout({
						accountId: this.recordId,
						searchCriteria: searchCriteria
					}).then(isSuccess => {
						if (!isSuccess) {
							this.showToast('error', 'Error', fraudDetectionSystemError);
							setTimeout(() => {
								window.location.href = '/secur/logout.jsp';
							}, 3000);
						} else {
							this.navigateToRecordPage(this.recordId);
						}
					});
				})
				.catch(error => {
					this.handleErrors(error);
				});
		}
	}

	dataProcessing(data) {
		if (!data || data[0].accessToRecord == false) {
			return searchCSOBNonClient({
				birthNumber: this.inputBirthNumber,
				lastName: this.inputLastName
			})
				.then(result => {
					if (!result || result === 'null') {
						throw new Error('no data');
					} else {
						updateCSOBNonClient({
							serializedUpdatePersonCSOBDataRequest: result
						});
					}
					return result;
				})
				.then(result => {
					this.recordId = JSON.parse(result).Account.Id;
				});
		} else {
			this.recordId = data[0].recordId;
		}
	}

	handleErrors(error) {
		this.spinner = false;
		this.isSearchButtonDisabled = false;
		if (error.message === 'no data') {
			this.showToast('info', this.label.noRecordsFound, '');
			this.noRecordsFound = true;
		} else {
			this.showToast('error', this.label.errorLabel, error.body.exceptionType + ': ' + error.body.message);
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

	assignAccountAccess(accountId) {
		assignSearchAccess({
			accountId: accountId
		});
	}
}
