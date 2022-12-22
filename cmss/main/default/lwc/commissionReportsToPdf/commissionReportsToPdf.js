import { LightningElement, wire } from 'lwc';
import getReportsMap from '@salesforce/apex/CommissionRunReportController.getReportsMap';
import runReport from '@salesforce/apex/CommissionRunReportController.runReport';
import getReportFilters from '@salesforce/apex/CommissionRunReportController.getReportFilters';
import checkStatus from '@salesforce/apex/CommissionRunReportController.checkStatus';
import getReportData from '@salesforce/apex/CommissionRunReportController.getReportData';
import { subscribe, unsubscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';
import COMMISSION_CHANNEL from '@salesforce/messageChannel/Commission_Reports__c';

export default class commissionReportsToPdf extends LightningElement {
	fixedWidth = 'width:10rem;';
	data;
	loaded = false;

	selectedReport;
	year;
	month;
	yearTo;
	monthTo;
	showTo;
	cpu;
	fromRecord;
	toRecord;
	selectedReport;
	selectedReportDevName;

	@wire(MessageContext)
	messageContext;

	reportFilters;
	reportInstance;
	reportStatus;
	reportData;
	reportHeader;
	viewHeader;
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
		this.selectedReportDevName = message.selectedReportDevName;
	}

	connectedCallback() {
		this.subscribeToMessageChannel();
	}

	handleRunReport(event) {
		this.loading = true;
		runReport({
			reportId: this.selectedReport,
			fromYear: this.year,
			fromMonth: this.month,
			toYear: this.yearTo,
			toMonth: this.monthTo
		})
			.then((result) => {
				this.reportInstance = result;
				this.loading = false;
			})
			.catch((error) => {
				this.error = JSON.stringify(error);
				this.loading = false;
			});
	}

	handleGetFilters(event) {
		getReportFilters({ reportId: this.selectedReport })
			.then((result) => {
				this.reportFilters = result;
				console.log('this.reportFilters: ' + JSON.stringify(this.reportFilters));
			})
			.catch((error) => {
				this.error = JSON.stringify(error);
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

	processHeader(reportHeader) {
		let repHead = [];
		for (let col in reportHeader) {
			repHead.push(reportHeader[col].columnLabel);
		}
		this.viewHeader = repHead;
	}

	handleGetData(event) {
		this.loading = true;
		getReportData({ instanceId: this.reportInstance, reportDevName: this.selectedReportDevName })
			.then((result) => {
				this.reportData = result.reportData;
				this.reportHeader = result.reportHeader;
				console.log('reportData: ' + JSON.stringify(this.reportData));
				console.log('reportData length: ' + this.reportData.length);
				console.log('reportHeader: ' + JSON.stringify(this.reportHeader));
				console.log('reportHeader length: ' + this.reportHeader.length);

				console.log('result.reportData[0]: ' + result.reportData[0]);
				console.log('result.reportData[0][7]: ' + result.reportData[0][7]);
				console.log('result.reportData[1][7]: ' + result.reportData[1][7]);
				console.log('result.reportData[2][7]: ' + result.reportData[2][7]);
				console.log('result.reportData[3][7]: ' + result.reportData[3][7]);
				console.log('result.reportData.length: ' + result.reportData.lenght);

				console.log(
					'result.reportHeader[Commission__c.ExpenditureFlatRate__c].columnLabel: ' +
						result.reportHeader['Commission__c.ExpenditureFlatRate__c'].columnLabel
				);

				this.processHeader(this.reportHeader);

				let html = '<table>';
				for (let id of this.reportData) {
					html += '<tr><td>' + id + '</td></tr>';
				}
				html += '</table>';
				this.reportHtmlData = html;
				console.log('html: ' + this.reportHtmlData);
				this.loading = false;
			})
			.catch((error) => {
				this.error = JSON.stringify(error);
				this.loading = false;
			});
	}

	//FOR HANDLING THE HORIZONTAL SCROLL OF TABLE MANUALLY
	tableOuterDivScrolled(event) {
		this._tableViewInnerDiv = this.template.querySelector('.tableViewInnerDiv');
		if (this._tableViewInnerDiv) {
			if (!this._tableViewInnerDivOffsetWidth || this._tableViewInnerDivOffsetWidth === 0) {
				this._tableViewInnerDivOffsetWidth = this._tableViewInnerDiv.offsetWidth;
			}
			this._tableViewInnerDiv.style =
				'width:' +
				(event.currentTarget.scrollLeft + this._tableViewInnerDivOffsetWidth) +
				'px;' +
				this.tableBodyStyle;
		}
		this.tableScrolled(event);
	}

	tableScrolled(event) {
		if (this.enableInfiniteScrolling) {
			if (event.target.scrollTop + event.target.offsetHeight >= event.target.scrollHeight) {
				this.dispatchEvent(
					new CustomEvent('showmorerecords', {
						bubbles: true
					})
				);
			}
		}
		if (this.enableBatchLoading) {
			if (event.target.scrollTop + event.target.offsetHeight >= event.target.scrollHeight) {
				this.dispatchEvent(
					new CustomEvent('shownextbatch', {
						bubbles: true
					})
				);
			}
		}
	}

	//#region ***************** RESIZABLE COLUMNS *************************************/
	handlemouseup(e) {
		this._tableThColumn = undefined;
		this._tableThInnerDiv = undefined;
		this._pageX = undefined;
		this._tableThWidth = undefined;
	}

	handlemousedown(e) {
		if (!this._initWidths) {
			this._initWidths = [];
			let tableThs = this.template.querySelectorAll('table thead .dv-dynamic-width');
			tableThs.forEach((th) => {
				this._initWidths.push(th.style.width);
			});
		}

		this._tableThColumn = e.target.parentElement;
		this._tableThInnerDiv = e.target.parentElement;
		while (this._tableThColumn.tagName !== 'TH') {
			this._tableThColumn = this._tableThColumn.parentNode;
		}
		while (!this._tableThInnerDiv.className.includes('slds-cell-fixed')) {
			this._tableThInnerDiv = this._tableThInnerDiv.parentNode;
		}
		console.log('handlemousedown this._tableThColumn.tagName => ', this._tableThColumn.tagName);
		this._pageX = e.pageX;

		this._padding = this.paddingDiff(this._tableThColumn);

		this._tableThWidth = this._tableThColumn.offsetWidth - this._padding;
		console.log('handlemousedown this._tableThColumn.tagName => ', this._tableThColumn.tagName);
	}

	handlemousemove(e) {
		console.log('mousemove this._tableThColumn => ', this._tableThColumn);
		if (this._tableThColumn && this._tableThColumn.tagName === 'TH') {
			this._diffX = e.pageX - this._pageX;

			this.template.querySelector('table').style.width =
				this.template.querySelector('table') - this._diffX + 'px';

			this._tableThColumn.style.width = this._tableThWidth + this._diffX + 'px';
			this._tableThInnerDiv.style.width = this._tableThColumn.style.width;

			let tableThs = this.template.querySelectorAll('table thead .dv-dynamic-width');
			let tableBodyRows = this.template.querySelectorAll('table tbody tr');
			let tableBodyTds = this.template.querySelectorAll('table tbody .dv-dynamic-width');
			tableBodyRows.forEach((row) => {
				let rowTds = row.querySelectorAll('.dv-dynamic-width');
				rowTds.forEach((td, ind) => {
					rowTds[ind].style.width = tableThs[ind].style.width;
				});
			});
		}
	}

	handledblclickresizable() {
		let tableThs = this.template.querySelectorAll('table thead .dv-dynamic-width');
		let tableBodyRows = this.template.querySelectorAll('table tbody tr');
		tableThs.forEach((th, ind) => {
			th.style.width = this._initWidths[ind];
			th.querySelector('.slds-cell-fixed').style.width = this._initWidths[ind];
		});
		tableBodyRows.forEach((row) => {
			let rowTds = row.querySelectorAll('.dv-dynamic-width');
			rowTds.forEach((td, ind) => {
				rowTds[ind].style.width = this._initWidths[ind];
			});
		});
	}

	paddingDiff(col) {
		if (this.getStyleVal(col, 'box-sizing') === 'border-box') {
			return 0;
		}

		this._padLeft = this.getStyleVal(col, 'padding-left');
		this._padRight = this.getStyleVal(col, 'padding-right');
		return parseInt(this._padLeft, 10) + parseInt(this._padRight, 10);
	}

	getStyleVal(elm, css) {
		return window.getComputedStyle(elm, null).getPropertyValue(css);
	}
}
