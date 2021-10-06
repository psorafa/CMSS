import { LightningElement, wire, api, track } from 'lwc';
import ACCOUNT_OBJ from '@salesforce/schema/Account';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAccounts from '@salesforce/apex/AccountRelatedListController.getAccounts';
import getUserId from '@salesforce/apex/AccountRelatedListController.getUserId';
import checkPermission from '@salesforce/apex/AccountRelatedListController.checkPermission';
import createPortManRequests from '@salesforce/apex/AccountRelatedListController.createPortManRequests';
import createPortManRequestsForUsersClients from '@salesforce/apex/AccountRelatedListController.createPortManRequestsForUsersClients';
import save from '@salesforce/label/c.Save';
import cancel from '@salesforce/label/c.Cancel';
import selectAll from '@salesforce/label/c.SelectAll';
import bulkOwnershipStateChange from '@salesforce/label/c.BulkOwnershipStateChange';
import transferAllClients from '@salesforce/label/c.TransferAllClients';
import errorTitle from '@salesforce/label/c.Error';
import requiredFields from '@salesforce/label/c.RequiredFields';
import noRecordsFound from '@salesforce/label/c.NoRecordsFound';
import checkUserCRUD from '@salesforce/apex/PermissionUtility.checkUserCRUD';

const recordsToShow = 50;

export default class AccountRelatedList extends LightningElement {
	@api recordId;
	@api portManType;
	@track columns = [];
	@track data = [];
	@track selectedData = [];
	@track tableElement;
	@track accountFieldLabels = {};
	@track portManRequest = {};
	transferAllClients = false;
	offset = 0;
	accountCount;
	billingCity;
	billingPostalCode;
	isModalOpen = false;
	isSaving = false;
	isLoading = false;
	isAllSelected = false;
	isAccessEnabled = false;
	btnVisibility = false;
	labels = {
		save,
		cancel,
		selectAll,
		bulkOwnershipStateChange,
		transferAllClients
	};

	get cityLabel() {
		return (
			(this.accountFieldLabels &&
				this.accountFieldLabels.BillingCity &&
				this.accountFieldLabels.BillingCity.label) ||
			''
		);
	}

	get postalCodeLabel() {
		return (
			(this.accountFieldLabels &&
				this.accountFieldLabels.BillingPostalCode &&
				this.accountFieldLabels.BillingPostalCode.label) ||
			''
		);
	}

	@wire(checkPermission, { permissionName: 'BulkOwnershipStateChangeVisibility' })
	handlePerm({ data }) {
		this.btnVisibility = data;
	}

	connectedCallback() {
		this.isLoading = true;
		this.handleGetAccounts(null, null, recordsToShow, this.offset, (data) => {
			this.accountCount = data.accountCount;
			this.data = data.accounts.map((item) => ({ ...item, NameUrl: '/' + item.Id }));
			this.isLoading = false;
		});
	}

	@wire(getObjectInfo, { objectApiName: ACCOUNT_OBJ })
	handleAccountInfo({ data, error }) {
		if (data) {
			this.columns = [
				{
					label: data.fields.CombinedName__c.label,
					fieldName: 'NameUrl',
					type: 'url',
					typeAttributes: { label: { fieldName: 'CombinedName__c' } }
				},
				{ label: data.fields.BillingStreet.label, fieldName: 'BillingStreet' },
				{ label: data.fields.BillingCity.label, fieldName: 'BillingCity' },
				{ label: data.fields.BillingPostalCode.label, fieldName: 'BillingPostalCode' },
				{ label: data.fields.Phone.label, fieldName: 'Phone' },
				{ label: data.fields.PersonEmail.label, fieldName: 'PersonEmail' },
				{ label: data.fields.PersonType__c.label, fieldName: 'PersonType__c' }
			];
			this.accountFieldLabels = data.fields;
		} else if (error) {
			this.fireToast('error', errorTitle);
		}
	}

	@wire(checkUserCRUD, { objectName: 'PortfolioManagementRequest__c', operation: 'insert' })
	handleCheckUserCRUD({ data, error }) {
		if (data) {
			this.isAccessEnabled = data;
		} else if (error) {
			this.fireToast('error', errorTitle);
		}
	}

	loadMoreData(event) {
		if (this.accountCount && this.offset < this.accountCount) {
			this.tableElement = event.target;
			this.tableElement.isLoading = true;
			this.tableElement.enableInfiniteLoading = false;
			this.offset += recordsToShow;

			this.handleGetAccounts(this.billingCity, this.billingPostalCode, recordsToShow, this.offset, (data) => {
				this.accountCount = data.accountCount;
				const mappedData = data.accounts.map((item) => ({ ...item, NameUrl: '/' + item.Id }));
				this.data = this.data.concat(mappedData);
				this.setInfiniteLoading();
				this.tableElement.isLoading = false;
			});
		}
	}

	setInfiniteLoading() {
		if (this.tableElement) {
			this.tableElement.enableInfiniteLoading = this.offset < this.accountCount ? true : false;
		}
	}

	handleSelectAll() {
		this.isLoading = true;
		this.handleGetAccounts(this.billingCity, this.billingPostalCode, 50000, 0, (data) => {
			this.accountCount = data.accountCount;
			this.selectedData = data.accounts.map((row) => row.Id);
			this.isAllSelected = true;
			this.isLoading = false;
			this.changeModalVisibility();
		});
	}

	handleSelectedRows() {
		if (this.selectedData && this.selectedData.length > 0) {
			this.changeModalVisibility();
		} else {
			this.fireToast('error', noRecordsFound);
		}
	}

	handlePMRValueChange(event) {
		this.portManRequest[event.target.fieldName] = event.target.value;
		if (event.target.fieldName === 'PortfolioManagerCPU__c') {
			getUserId({ commAccountBase: event.target.value })
				.then((data) => {
					this.template.querySelector('[data-element="PortfolioManager__c"]').value = data;
					this.portManRequest['PortfolioManager__c'] = data;
				})
				.catch((error) => {
					this.handleErrors(error, false);
				});
		}
	}

	handleCheckboxChange() {
		this.transferAllClients = this.template.querySelectorAll('[data-element="transfer-all-clients"]')[0].checked;
	}

	handleFilterChange(event) {
		this.isLoading = true;
		this.offset = 0;

		if (event.target.name === 'billingCity') {
			this.billingCity = event.target.value ? '%' + event.target.value + '%' : '';
		} else if (event.target.name === 'billingPostalCode') {
			this.billingPostalCode = event.target.value ? '%' + event.target.value + '%' : '';
		}

		this.handleGetAccounts(this.billingCity, this.billingPostalCode, recordsToShow, this.offset, (data) => {
			this.accountCount = data.accountCount;
			this.data = data.accounts.map((item) => ({ ...item, NameUrl: '/' + item.Id }));
			this.setInfiniteLoading();
			this.isLoading = false;
		});
	}

	handleGetAccounts(billingCity, billingPostalCode, limit, offset, thenFunction) {
		getAccounts({
			userId: this.recordId,
			portManType: this.portManType,
			billingCity: billingCity,
			billingPostalCode: billingPostalCode,
			recordsToShow: limit,
			offset: offset
		})
			.then(thenFunction)
			.catch((error) => {
				this.handleErrors(error, false);
			});
	}

	getSelectedRows(event) {
		this.selectedData = event.detail.selectedRows.map((row) => row.Id);
	}

	changeModalVisibility() {
		this.portManRequest = {};
		this.isModalOpen = !this.isModalOpen;
		if (!this.isModalOpen && this.isAllSelected) {
			this.template.querySelector('lightning-datatable').selectedRows = [];
			this.selectedData = [];
			this.isAllSelected = false;
		}
	}

	saveModal() {
		if (!this.portManRequest.PortfolioManager__c || !this.portManRequest.PortfolioManagerCPU__c) {
			this.fireToast('error', errorTitle, requiredFields);
			return;
		}

		this.toggleSpinner();

		this.portManRequest.PortfolioManagementType__c = this.portManType;
		const parameters = { pmr: this.portManRequest };
		if (this.transferAllClients) {
			parameters.userId = this.recordId;
			parameters.portManType = this.portManType;
			createPortManRequestsForUsersClients(parameters)
				.then((data) => {
					this.handleCreatePMRSuccess(data);
				})
				.catch((error) => {
					this.handleErrors(error, true);
				});
		} else {
			parameters.accountIds = this.selectedData;
			createPortManRequests(parameters)
				.then((data) => {
					this.handleCreatePMRSuccess(data);
				})
				.catch((error) => {
					this.handleErrors(error, true);
				});
		}
	}

	handleCreatePMRSuccess(response) {
		this.fireToast('success', response);
		this.changeModalVisibility();
		this.toggleSpinner();
	}

	handleErrors(error, disableSpinner) {
		console.log(JSON.stringify(error));
		this.fireToast('error', errorTitle, error && error.body && error.body.message ? error.body.message : '');
		if (disableSpinner) {
			this.toggleSpinner();
		}
		if (this.isLoading) {
			this.isLoading = false;
		}
	}

	toggleSpinner() {
		this.isSaving = !this.isSaving;
	}

	fireToast(variant, title, message) {
		const evt = new ShowToastEvent({
			variant: variant,
			title: title,
			message: message
		});
		this.dispatchEvent(evt);
	}
}
