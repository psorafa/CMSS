import { LightningElement, wire, api, track } from 'lwc';
import ACCOUNT_OBJ from '@salesforce/schema/Account';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAccounts from '@salesforce/apex/AccountRelatedListController.getAccounts';
import createPortManRequests from '@salesforce/apex/AccountRelatedListController.createPortManRequests';

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
            this.fireToast('error', 'Error', 'Unfortunately, there was an error.');
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
                    console.log(JSON.stringify(data))
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
                console.log(JSON.stringify(data))
                this.accountCount = data.accountCount;
                this.selectedData = data.accounts.map(row => row.Id);
        })
        this.openModal();
    }

    handleValueChange(event) {
        this.portManRequest[event.target.fieldName] = event.target.value;
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
                console.log(JSON.stringify(data))
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
        .catch(error => {
            console.log(JSON.stringify(error))
            this.fireToast('error', 'Error', 'Unfortunately, there was an error.');
        });
    }

    getSelectedRows(event) {
        this.selectedData = event.detail.selectedRows.map(row => row.Id);
    }

    openModal() {
        this.isModalOpen = true
    }

    closeModal() {
        this.isModalOpen = false
    } 

    saveModal() {
        const parameters = { pmr: this.portManRequest }
        if (this.transferAllClients) {
            parameters.userId = this.recordId;
            parameters.portManType = this.portManType;
        } else {
            parameters.accountIds = this.selectedData;
        }
        createPortManRequests(parameters)
            .then(data => {
                console.log(JSON.stringify(data))
                this.fireToast('success', 'Success', 'The records have been successfully created.');
                this.closeModal();
            })
            .catch(error => {
                console.log(JSON.stringify(error))
                this.fireToast('error', 'Error', 'Unfortunately, there was an error.');
            });
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