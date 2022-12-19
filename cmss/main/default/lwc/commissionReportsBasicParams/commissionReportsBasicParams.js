import { LightningElement, wire, track } from 'lwc';
import getReportsMap from '@salesforce/apex/CommissionRunReportController.getReportsMap';
import { publish, subscribe, MessageContext } from 'lightning/messageService';
import COMMISSION_CHANNEL from '@salesforce/messageChannel/Commission_Reports__c';

export default class commissionReportsBasicParams extends LightningElement {
	data;
	loaded = false;
	pload = [];
	@track folderOptions = [
		{
			label: 'test',
			value: 'test'
		}
	];
	@track reportOptions = [];
	selectedReport;
	reportInstance;
	reportStatus;
	reportData;
	reportHtmlData;
	error;
	loading = false;
	subscription = null;

	@wire(MessageContext)
	messageContext;

	subscribeToMessageChannel() {
		this.subscription = subscribe(this.messageContext, COMMISSION_CHANNEL, (message) =>
			this.handleMessage(message)
		);
	}

	handleMessage(message) {
		this.pload = JSON.parse(JSON.stringify(message));
	}

	connectedCallback() {
		if (!this.loaded) {
			this.loaded = true;
			getReportsMap().then((result) => {
				this.processResult(result);
			});
		}
		this.subscribeToMessageChannel();
	}

	processResult(result) {
		console.log('Zoznam reportov result: ' + JSON.stringify(result));
		this.data = result;
		let folderOptions = [];
		for (let folder in result) {
			folderOptions.push({
				label: result[folder].ReportName,
				value: folder
			});
		}
		this.folderOptions = folderOptions;
	}

	handleFolderChange(event) {
		//this.reportOptions = this.data[event.detail.value];
		this.selectedReport = event.detail.value;
		if (this.pload.length === 0) {
			this.pload = { selectedReport: this.selectedReport };
		} else {
			this.pload.selectedReport = this.selectedReport;
		}
		publish(this.messageContext, COMMISSION_CHANNEL, this.pload);
	}

	handleReportChange(event) {
		this.selectedReport = event.detail.value;
	}
}