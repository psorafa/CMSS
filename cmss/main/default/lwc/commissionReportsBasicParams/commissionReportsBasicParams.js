import { LightningElement, wire, track } from 'lwc';
import getReportsMap from '@salesforce/apex/CommissionRunReportController.getReportsMap';
import { publish, subscribe, MessageContext } from 'lightning/messageService';
import COMMISSION_CHANNEL from '@salesforce/messageChannel/Commission_Reports__c';

export default class commissionReportsBasicParams extends LightningElement {
	data;
	loaded = false;
	pload = [];
	@track reportOptions = [
		{
			label: 'test',
			value: 'test'
		}
	];
	reportArray = {};
	selectedReport;
	selectedReportDevName;
	selectedReportName;
	selectedReportDescription;
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
		//console.log('Zoznam reportov result: ' + JSON.stringify(result));
		this.data = result;
		let folderOptions = [];
		let reportArr = {};
		let reportId;
		for (let folder in result) {
			folderOptions.push({
				label: result[folder].reportName,
				value: result[folder].reportId
			});
			reportId = result[folder].reportId;
			reportArr[reportId] = {
				devName: result[folder].reportDeveloperName,
				description: result[folder].reportDescription,
				name: result[folder].reportName
			};
		}
		this.reportOptions = folderOptions;
		this.reportArray = reportArr;
	}

	handleReportChange(event) {
		this.selectedReport = event.detail.value;
		this.selectedReportDevName = this.reportArray[event.detail.value].devName;
		this.selectedReportName = this.reportArray[event.detail.value].name;
		this.selectedReportDescription = this.reportArray[event.detail.value].description;
		if (this.pload.length === 0) {
			this.pload = {
				selectedReport: this.selectedReport,
				selectedReportDevName: this.selectedReportDevName,
				selectedReportName: this.selectedReportName,
				selectedReportDescription: this.selectedReportDescription
			};
		} else {
			this.pload.selectedReport = this.selectedReport;
			this.pload.selectedReportDevName = this.selectedReportDevName;
			this.pload.selectedReportName = this.selectedReportName;
			this.pload.selectedReportDescription = this.selectedReportDescription;
		}
		publish(this.messageContext, COMMISSION_CHANNEL, this.pload);
	}
}
