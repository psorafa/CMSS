import { LightningElement, wire, api, track } from 'lwc';
import ACCOUNT_OBJ from '@salesforce/schema/Account';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAccounts from '@salesforce/apex/AccountRelatedListController.getAccounts';
import getUserId from '@salesforce/apex/AccountRelatedListController.getUserId';
import createPortManRequests from '@salesforce/apex/AccountRelatedListController.createPortManRequests';
import createPortManRequestsForUsersClients from '@salesforce/apex/AccountRelatedListController.createPortManRequestsForUsersClients';
import save from '@salesforce/label/c.Save';
import cancel from '@salesforce/label/c.Cancel';
import selectAll from '@salesforce/label/c.SelectAll';
import bulkOwnershipStateChange from '@salesforce/label/c.BulkOwnershipStateChange';
import transferAllClients from '@salesforce/label/c.TransferAllClients';
import errorMessage from '@salesforce/label/c.Error';
import requiredFields from '@salesforce/label/c.RequiredFields';
import recordsCreated from '@salesforce/label/c.RecordsCreated';
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
    isAccessEnabled = false;
    labels = {
        save,
        cancel,
        selectAll,
        bulkOwnershipStateChange,
        transferAllClients
    };

    get cityLabel() {
        return ( this.accountFieldLabels && this.accountFieldLabels.BillingCity && this.accountFieldLabels.BillingCity.label ) || '';
    }

    get postalCodeLabel() {
        return ( this.accountFieldLabels && this.accountFieldLabels.BillingPostalCode && this.accountFieldLabels.BillingPostalCode.label ) || '';
    }

    connectedCallback() {
        this.handleGetAccounts(
            null, 
            null, 
            recordsToShow, 
            this.offset, 
            data => {
                this.accountCount = data.accountCount;
                this.data = data.accounts;
        })
    }

    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJ })
    handleAccountInfo({ data, error }) {
        if (data) {
            this.columns = [
                { label: data.fields.Name.label, fieldName: 'Name' },
                { label: data.fields.BillingCity.label, fieldName: 'BillingCity' },
                { label: data.fields.BillingPostalCode.label, fieldName: 'BillingPostalCode' },
            ];
            this.accountFieldLabels = data.fields;
        } else if (error) {
            this.fireToast('error', errorMessage);
        }
    }

    @wire(checkUserCRUD, { objectName: 'PortfolioManagementRequest__c', operation: 'insert' })
    handleCheckUserCRUD({ data, error }) {
        if (data) {
            this.isAccessEnabled = data;
        } else if (error) {
            this.fireToast('error', errorMessage);
        }
    }

    loadMoreData(event) {
        if (this.accountCount && this.offset < this.accountCount) {
            this.tableElement = event.target;
            this.tableElement.isLoading = true;
            this.tableElement.enableInfiniteLoading = false;
            this.offset += recordsToShow;

            this.handleGetAccounts(
                this.billingCity, 
                this.billingPostalCode, 
                recordsToShow, 
                this.offset, 
                data => {
                    this.accountCount = data.accountCount;
                    this.data = this.data.concat(data.accounts);
                    this.setInfiniteLoading();
                    this.tableElement.isLoading = false;
            })
        }
    }

    setInfiniteLoading() {
        if (this.tableElement) {
            this.tableElement.enableInfiniteLoading = this.offset < this.accountCount ? true : false;
        }
    }

    handleSelectAll() {
        this.handleGetAccounts(
            this.billingCity, 
            this.billingPostalCode, 
            50000, 
            0, 
            data => {
                this.accountCount = data.accountCount;
                this.selectedData = data.accounts.map(row => row.Id);
        })
        this.changeModalVisibility();
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
                .then(data => {
                    this.template.querySelector('[data-element="PortfolioManager__c"]').value = data;
                    this.portManRequest['PortfolioManager__c'] = data;
                })
                .catch(error => { this.handleErrors(error, errorMessage, false) });
        }
    }

    handleCheckboxChange() {
        this.transferAllClients = this.template.querySelectorAll('[data-element="transfer-all-clients"]')[0].checked;
    }

    handleFilterChange(event) {
        this.offset = 0;
        
        if (event.target.name === 'billingCity') {
            this.billingCity = event.target.value ? '%' + event.target.value + '%' : '';
        } else if (event.target.name === 'billingPostalCode') {
            this.billingPostalCode = event.target.value ? '%' + event.target.value + '%' : '';
        }

        this.handleGetAccounts(
            this.billingCity, 
            this.billingPostalCode, 
            recordsToShow, 
            this.offset, 
            data => {
                this.accountCount = data.accountCount;
                this.data = data.accounts;
                this.setInfiniteLoading();
        })
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
        .catch(error => { this.handleErrors(error, errorMessage, false) });
    }

    getSelectedRows(event) {
        this.selectedData = event.detail.selectedRows.map(row => row.Id);
    }

    changeModalVisibility() {
        this.portManRequest = {};
        this.isModalOpen = !this.isModalOpen;
    }

    saveModal() {
        if (!this.portManRequest.PortfolioManager__c || !this.portManRequest.PortfolioManagerCPU__c) {
            this.fireToast('error', errorMessage, requiredFields);
            return;
        }

        this.toggleSpinner();

        this.portManRequest.PortfolioManagementType__c = this.portManType;
        const parameters = { pmr: this.portManRequest }
        if (this.transferAllClients) {
            parameters.userId = this.recordId;
            parameters.portManType = this.portManType;
            createPortManRequestsForUsersClients(parameters)
                .then(data => { this.handleCreatePMRSuccess(recordsCreated) })
                .catch(error => { this.handleErrors(error, errorMessage, true) });
        } else {
            parameters.accountIds = this.selectedData;
            createPortManRequests(parameters)
                .then(data => { this.handleCreatePMRSuccess(recordsCreated) })
                .catch(error => { this.handleErrors(error, errorMessage, true) });
        }
    }

    handleCreatePMRSuccess(toastMessage) {
        this.fireToast('success', toastMessage);
        this.changeModalVisibility();
        this.toggleSpinner();
    }

    handleErrors(error, toastMessage, disableSpinner) {
        console.log(JSON.stringify(error))
        this.fireToast('error', toastMessage);
        if (disableSpinner) {
            this.toggleSpinner();
        }
    }

    toggleSpinner() {
        this.isSaving = !this.isSaving;
    }

    fireToast(variant, title, message) {
        const evt = new ShowToastEvent({
            variant: variant,
            title: title,
            message: message,
        });
        this.dispatchEvent(evt);
    }
}