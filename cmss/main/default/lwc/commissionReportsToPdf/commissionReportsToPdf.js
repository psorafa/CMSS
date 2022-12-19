import { LightningElement, wire, api } from 'lwc';
import getReportsMap from '@salesforce/apex/CommissionRunReportController.getReportsMap';
import runReport from '@salesforce/apex/CommissionRunReportController.runReport';
import checkStatus from '@salesforce/apex/CommissionRunReportController.checkStatus';
import getReportData from '@salesforce/apex/CommissionRunReportController.getReportData';
import { subscribe, unsubscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';
import COMMISSION_CHANNEL from '@salesforce/messageChannel/Commission_Reports__c';

export default class commissionReportsToPdf extends LightningElement {
	data;
	loaded = false;

	@api selectedReport;
	year;
	month;
	yearTo;
	monthTo;
	showTo;
	cpu;
	fromRecord;
	toRecord;
	selectedReport;

	@wire(MessageContext)
	messageContext;

	reportInstance;
	reportStatus;
	reportData;
	reportHtmlData;
	error;
	loading = false;
	subscription = null;

	subscribeToMessageChannel() {
		this.subscription = subscribe(
			this.messageContext,
			COMMISSION_CHANNEL,
			(message) => this.handleMessage(message),
			{ scope: APPLICATION_SCOPE }
		);
	}

	handleMessage(message) {
		this.year = message.year;
		this.month = message.month;
		this.yearTo = message.yearTo;
		this.monthTo = message.monthTo;
		this.showTo = message.showTo;
		this.cpu = message.cpu;
		this.fromRecord = message.fromRecord;
		this.toRecord = message.toRecord;
		this.selectedReport = message.selectedReport;
	}

	connectedCallback() {
		this.subscribeToMessageChannel();
	}

	handleRunReport(event) {
		this.loading = true;
		runReport({ reportId: this.selectedReport })
			.then((result) => {
				this.reportInstance = result;
				this.loading = false;
			})
			.catch((error) => {
				this.error = JSON.stringify(error);
				this.loading = false;
			});
	}

	handleCheckStatus(event) {
		this.loading = true;
		checkStatus({ instanceId: this.reportInstance })
			.then((result) => {
				this.reportStatus = result;
				this.loading = false;
			})
			.catch((error) => {
				this.error = JSON.stringify(error);
				this.loading = false;
			});
	}

	handleGetData(event) {
		this.loading = true;
		getReportData({ instanceId: this.reportInstance })
			.then((result) => {
				this.reportData = result;
				let html = '<table>';
				for (let id of this.reportData) {
					html += '<tr><td>' + id + '</td></tr>';
				}
				html += '</table>';
				this.reportHtmlData = html;
				this.loading = false;
			})
			.catch((error) => {
				this.error = JSON.stringify(error);
				this.loading = false;
			});
	}
}