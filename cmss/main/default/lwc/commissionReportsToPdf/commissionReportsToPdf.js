import { LightningElement, track } from 'lwc';
import getReportsMap from '@salesforce/apex/CommissionRunReportController.getReportsMap';
import runReport from '@salesforce/apex/CommissionRunReportController.runReport';
import checkStatus from '@salesforce/apex/CommissionRunReportController.checkStatus';
import getReportData from '@salesforce/apex/CommissionRunReportController.getReportData';

export default class commissionReportsToPdf extends LightningElement {
	data;
	loaded = false;
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

	connectedCallback() {
		if (!this.loaded) {
			this.loaded = true;
			getReportsMap().then((result) => {
				this.processResult(result);
			});
		}
	}

	processResult(result) {
		this.data = result;
		let folderOptions = [];
		for (let folder in result) {
			console.log('folder:' + folder);
			console.log('inside:' + result[folder].ReportName__c);
			folderOptions.push({
				label: result[folder].ReportName__c,
				value: folder
			});
		}
		this.folderOptions = folderOptions;
		console.log('pokus:' + this.data.CommissionReport90.ReportName__c);
		console.log('result:' + JSON.stringify(result));
		/*this.data = result;
		let folderOptions = [];
		for (let folder in result) {
			folderOptions.push({
				label: folder,
				value: folder
			});
		}
		this.folderOptions = folderOptions;*/
	}

	handleFolderChange(event) {
		//this.reportOptions = this.data[event.detail.value];
	}

	handleReportChange(event) {
		this.selectedReport = event.detail.value;
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