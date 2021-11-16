import { api, LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getData from '@salesforce/apex/FinancialOperationsController.getData';

const columns = [
	{
		type: 'button',
		initialWidth: 30,
		typeAttributes: {
			label: 'View',
			title: 'View',
			name: 'view',
			iconPosition: 'center',
			variant: 'base'
		}
	},
	{ label: 'Název operace', fieldName: 'transactionDescription', type: 'text' },
	{ label: 'Datum operace', fieldName: 'transactionDateTime', type: 'date' },
	{ label: 'Jméno odesílatele', fieldName: 'senderReceiverName', type: 'text' },
	{ label: 'Předčíslí účtu', fieldName: 'senderReceiverAccountPrefix', type: 'text' },
	{ label: 'Číslo účtu ', fieldName: 'senderReceiverAccountNumber', type: 'text' },
	{ label: 'Směrový kód banky ', fieldName: 'senderReceiverBankIdNumber', type: 'text' },
	{ label: 'Částka', fieldName: 'amount', type: 'text' }
];

export default class FinancialOperationsDataTable extends LightningElement {
	@api recordId;
	@track dateTo;
	@track dateFrom;
	@track openImportFOModal = false;
	@track openDetailModal = false;
	@track data = [];
	@track allData = {};
	columns = columns;
	showSpinner = false;

	showImportFOModal() {
		this.openImportFOModal = true;
	}

	closeDetailModal() {
		this.openDetailModal = false;
	}
	closeImportFOModal() {
		this.openImportFOModal = false;
	}

	showData() {
		this.data.length > 0;
	}

	get defaultDateFrom() {
		let date = new Date();
		date.setFullYear(date.getFullYear() - 1);
		this.dateFrom = date.toISOString().substr(0, 10);
		return date.toISOString().substr(0, 10);
	}

	get defaultDateTo() {
		let date = new Date();
		this.dateTo = date.toISOString().substr(0, 10);
		return date.toISOString().substr(0, 10);
	}

	handleFormInputChange(event) {
		if (event.target.value != null) {
			if (event.target.name == 'dateTo') {
				this.dateTo = event.target.value;
				console.log(this.dateTo);
			}
			if (event.target.name == 'dateFrom') {
				this.dateFrom = event.target.value;
				console.log(this.dateFrom);
			}
		}
	}

	handleClick() {
		if (this.dateTo <= this.dateFrom) {
			this.fireToast('error', 'Invalid data', 'Datum do by měl být větší než Datum od');
			return;
		}
		this.openImportFOModal = false;
		this.showSpinner = true;
		getData({
			dateTo: this.dateTo,
			dateFrom: this.dateFrom,
			recordId: this.recordId
		})
			.then(result => {
				this.data = JSON.parse(result);
				this.showSpinner = false;
				console.log('susccess');
			})
			.catch(error => {
				this.showSpinner = false;
				console.log(JSON.stringify(error));
				this.fireToast('error', 'Nebyly nalezene žádné záznamy');
			});
	}

	handleRowAction(event) {
		if (event.detail.action.name === 'view') {
			this.allData = event.detail.row;
			this.openDetailModal = true;
		}
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
