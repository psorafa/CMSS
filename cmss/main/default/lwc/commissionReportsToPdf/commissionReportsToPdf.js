import { LightningElement, wire } from 'lwc';
import getReportsMap from '@salesforce/apex/CommissionRunReportController.getReportsMap';
import runReport from '@salesforce/apex/CommissionRunReportController.runReport';
import getReportFilters from '@salesforce/apex/CommissionRunReportController.getReportFilters';
import checkStatus from '@salesforce/apex/CommissionRunReportController.checkStatus';
import getReportData from '@salesforce/apex/CommissionRunReportController.getReportData';
import getSummaryReportData from '@salesforce/apex/CommissionRunReportController.getSummaryReportData';
import { subscribe, unsubscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';
import COMMISSION_CHANNEL from '@salesforce/messageChannel/Commission_Reports__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class commissionReportsToPdf extends LightningElement {
	fixedWidth = 'width:10rem;';
	data;
	loaded = false;
	columnWidths = [];
	columnWidthsPx = [];
	columnWidthsPerc = [];
	columnWidthsPxSum = 0;
	timeout;
	timerCounter = 0;
	timeSpan = 1000;

	selectedReport;
	selectedReportDevName;
	selectedReportName;
	selectedReportDescription;
	year;
	month;
	yearTo;
	monthTo;
	showTo;
	cpu;
	tribeCpu;
	fromRecord;
	toRecord;
	accountBaseCombinedName;
	address;
	footerTimestamp;
	filterReport;
	filterRecordRange;

	@wire(MessageContext)
	messageContext;

	reportFilters;
	reportInstance;
	reportStatus = 'Not Started';
	reportData;
	reportHeader;
	reportHasRows = false;
	entitlementAmount;
	pendingAmount;
	showFooter;
	showPendingAmount;
	rowCount = 0;
	rowCountExceeded = false;
	viewHeader;
	reportHtmlData;
	error;
	loading = false;
	subscription = null;
	runReportDisabled = true;
	todayDate;
	dateValues;
	selectedPeriod;
	commissionAccount;
	combinedName;
	pdfUrl;

	subscribeToMessageChannel() {
		this.subscription = subscribe(
			this.messageContext,
			COMMISSION_CHANNEL,
			(message) => this.handleMessage(message),
			{ scope: APPLICATION_SCOPE }
		);
	}

	handleMessage(message) {
		this.selectedReport = message.selectedReport;
		this.selectedReportDevName = message.selectedReportDevName;
		this.selectedReportName = message.selectedReportName;
		this.selectedReportDescription = message.selectedReportDescription;
		this.filterReport = this.selectedReportDevName + '; ' + this.selectedReportDescription;
		this.year = message.year;
		this.month = message.month;
		this.yearTo = message.yearTo;
		this.monthTo = message.monthTo;
		this.showTo = message.showTo;
		this.cpu = message.cpu;
		this.tribeCpu = message.tribeCpu;
		this.fromRecord = message.fromRecord;
		this.toRecord = message.toRecord;
		this.filterRecordRange = this.fromRecord + ' - ' + this.toRecord;
		this.accountBaseCombinedName = message.accountBaseCombinedName;
		this.address = message.address;
		if (this.accountBaseCombinedName !== undefined) {
			this.commissionAccount =
				this.tribeCpu !== '' && this.tribeCpu !== undefined
					? this.tribeCpu
					: this.accountBaseCombinedName.slice(0, this.accountBaseCombinedName.indexOf(','));

			this.combinedName = this.accountBaseCombinedName.slice(this.accountBaseCombinedName.indexOf(',') + 1);
		}
		let endingTo = this.monthTo !== undefined ? this.monthTo + '.' + this.yearTo : '';
		this.dateValues = this.todayDate + ' / ' + this.month + '.' + this.year + ' - ' + endingTo;
		this.selectedPeriod = this.month + '.' + this.year + ' - ' + endingTo;

		console.log('selectedReport: ' + this.selectedReport);
		console.log('selectedReportDevName: ' + this.selectedReportDevName);
		console.log('selectedReportName: ' + this.selectedReportName);
		console.log('selectedReportDescription: ' + this.selectedReportDescription);
		console.log('year: ' + this.year);
		console.log('month: ' + this.month);
		console.log('yearTo: ' + this.yearTo);
		console.log('monthTo: ' + this.monthTo);
		console.log('showTo: ' + this.showTo);
		console.log('cpu: ' + this.cpu);
		console.log('tribeCpu: ' + this.tribeCpu);
		console.log('fromRecord: ' + this.fromRecord);
		console.log('toRecord: ' + this.toRecord);
		console.log('accountBaseCombinedName: ' + this.accountBaseCombinedName);
		console.log('address: ' + this.address);
		console.log('commissionAccount: ' + this.commissionAccount);
		console.log('combinedName: ' + this.combinedName);
		console.log('dateValues: ' + this.dateValues);
		console.log('selectedPeriod: ' + this.selectedPeriod);

		if (this.year && this.month && this.selectedReport) {
			this.runReportDisabled = false;
		}
	}

	connectedCallback() {
		this.subscribeToMessageChannel();
		let today = new Date();
		let dd = String(today.getDate()).padStart(2, '0');
		let mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
		let yyyy = today.getFullYear();
		let hh = today.getHours();
		let min = today.getMinutes();
		this.todayDate = dd + '.' + mm + '.' + yyyy;
		this.footerTimestamp = this.todayDate + ' ' + hh + ':' + min;
		let myDomain = window.location.hostname;
		console.log('domena: ' + window.location.hostname);
		this.pdfUrl =
			'https://' +
			myDomain.slice(0, myDomain.indexOf('.')) +
			'--c' +
			myDomain.slice(myDomain.indexOf('.')).replace('lightning', 'vf') +
			'/apex/CommissionPdfGenerator';
		console.log('pdfUrl: ' + this.pdfUrl);
	}

	handleRunReport(event) {
		this.loading = true;
		this.timerCounter = 0;
		let today = new Date();
		this.footerTimestamp = this.todayDate + ' ' + today.getHours() + ':' + today.getMinutes();
		console.log('Running selectedReport: ' + this.selectedReport);
		console.log('Running selectedReportDevName: ' + this.selectedReportDevName);
		runReport({
			reportId: this.selectedReport,
			fromYear: this.year,
			fromMonth: this.month,
			toYear: this.yearTo,
			toMonth: this.monthTo,
			fromRecord: this.fromRecord,
			toRecord: this.toRecord,
			cpu: this.cpu,
			tribeCpu: this.tribeCpu
		})
			.then((result) => {
				this.reportInstance = result;
				this.checkStatusContinuously();
			})
			.catch((error) => {
				this.error = JSON.stringify(error);
				this.loading = false;
			});
	}

	checkStatusContinuously() {
		this.timeout = setInterval(() => {
			this.checkStatus();
		}, this.timeSpan);
	}

	checkStatus() {
		console.log('reportStatus: ' + this.reportStatus + ', counter: ' + this.timerCounter);
		if (this.reportStatus === 'Success' || this.timerCounter > 300) {
			this.loading = false;
			clearInterval(this.timeout);
			this.handleGetData();
		}
		this.timerCounter++;
		checkStatus({ instanceId: this.reportInstance })
			.then((result) => {
				this.reportStatus = result;
			})
			.catch((error) => {
				this.error = JSON.stringify(error);
				this.loading = false;
			});
	}

	processHeaderMap(reportHeader) {
		let repHead = [];
		for (let col in reportHeader) {
			repHead.push(reportHeader[col].columnLabel);
		}
		this.viewHeader = repHead;
		this.reportStatus = 'Not started';
	}

	processHeader(reportHeader) {
		let repHead = [];
		let i = 0;
		for (let col in reportHeader) {
			repHead.push(reportHeader[i].columnLabel);
			i++;
		}
		this.viewHeader = repHead;
		this.reportStatus = 'Not started';
	}

	buildHTML() {
		this.recalcColumnWidths();
		let i = 0;
		let footer = '';
		let html = '<table style="width:100%; height: 95%;"><thead><tr>';
		for (let columnName of this.viewHeader) {
			html += '<th style="width:' + this.columnWidthsPerc[i] + '%;">' + columnName + '</th>';
			i++;
		}
		i = 0;
		let j = 0;
		html += '</thead><tbody>';
		for (let row of this.reportData) {
			html += '<tr>';
			for (let cell of row) {
				html += '<td style="width:' + this.columnWidthsPerc[i] + '%;">' + cell + '</td>';
				i++;
			}
			j++;
			i = 0;
			html += '</tr>';
		}

		html += '</tbody></table>';
		footer += '<br/><table style="width: 100%;">';
		footer += '<tbody><tr>';
		footer += '<td style="border-top: 1px solid black;">Počet záznamů:</td>';
		footer += '<td style="border-top: 1px solid black;">' + this.rowCount + '</td>';
		footer += '<td style="border-top: 1px solid black;">Součet hodnot zobrazených provizí:</td>';
		footer += '<td style="border-top: 1px solid black;"></td>';
		footer += '</tr><tr>';
		footer += '<td>Výpis z provizního účtu:</td>';
		footer += '<td>' + this.accountBaseCombinedName + '</td><td>';
		footer += this.showPendingAmount ? 'Čekatelství:' : '';
		footer += '</td><td>';
		footer += this.showPendingAmount ? this.pendingAmount : '';
		footer += '</td></tr><tr>';
		footer += '<td>Provizní zpracování k/OD-DO:</td>';
		footer += '<td>' + this.dateValues + '</td>';
		footer += '<td>Nárok:</td>';
		footer += '<td>' + this.entitlementAmount + '</td>';
		footer += '</tr></tbody></table>';
		this.reportHtmlData = html;
		this.reportHtmlData += this.showFooter ? footer : '';
		console.log('html: ' + this.reportHtmlData);
	}

	handleGetData() {
		console.log('Ready reportInstance: ' + this.reportInstance);
		getReportData({ instanceId: this.reportInstance, reportDevName: this.selectedReportDevName })
			.then((result) => {
				this.reportData = result.reportData;
				this.reportHeader = result.reportHeader;
				this.entitlementAmount = result.entitlementAmount;
				this.pendingAmount = result.pendingAmount;
				this.rowCount = result.rowCount;
				this.showFooter = result.showFooter;
				this.showPendingAmount = result.showPendingAmount;
				console.log('showFooter: ' + this.showFooter);
				console.log('showPendingAmount: ' + this.showPendingAmount);
				this.rowCountExceeded = Number(this.rowCount) > 2000 ? true : false;
				this.reportHasRows = Number(this.rowCount) > 0 ? true : false;
				if (this.rowCountExceeded) {
					throw new Error(
						'Snažíte se vyexportovat více záznamů, než je povolený limit 2000. Prosím zužte datovou sadu změnou upřesňujících kritérií zadáním užšího období, výběrem specifického typu provizního výpisu čí rozmezí pořadových čísel záznamů.'
					);
				}
				if (!this.reportHasRows) {
					throw new Error(
						'Dle zadaných parametrů export neobsahuje žádné záznamy. Prosím upravte parametry exportu.'
					);
				}
				console.log('reportHeader: ' + JSON.stringify(this.reportHeader));

				this.processHeader(this.reportHeader);
				this.buildHTML();
				//this.loading = false;
			})
			.catch((error) => {
				this.error = JSON.stringify(error);
				this.loading = false;
				this.handleErrors(error);
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
	recalcColumnWidths() {
		this.columnWidthsPxSum = 0;
		let tableThs = this.template.querySelectorAll('table thead .dv-dynamic-width');
		tableThs.forEach((th, ind) => {
			this.columnWidths[ind] = th.style.width;
			this.columnWidthsPx[ind] = th.style.width.includes('rem')
				? String(
						Number(th.style.width.replace('rem', '')) *
							parseFloat(getComputedStyle(document.documentElement).fontSize)
				  ) + 'px'
				: th.style.width;
			this.columnWidthsPxSum += Number(this.columnWidthsPx[ind].replace('px', ''));
		});
		for (let i = 0; i < this.columnWidthsPx.length; i++) {
			this.columnWidthsPerc[i] =
				(Number(this.columnWidthsPx[i].replace('px', '')) / this.columnWidthsPxSum) * 100;
		}
		console.log('columnWidths: ' + this.columnWidths);
		console.log('columnWidthsPx: ' + this.columnWidthsPx);
		console.log('columnWidthsPerc: ' + this.columnWidthsPerc);
		console.log('columnWidthsPxSum: ' + this.columnWidthsPxSum);
		console.log('columnWidths length: ' + this.columnWidths.length);

		this._tableThColumn = undefined;
		this._tableThInnerDiv = undefined;
		this._pageX = undefined;
		this._tableThWidth = undefined;
	}

	handlemouseup(e) {
		this.buildHTML();
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
		//console.log('handlemousedown this._tableThColumn.tagName => ', this._tableThColumn.tagName);
		this._pageX = e.pageX;

		this._padding = this.paddingDiff(this._tableThColumn);

		this._tableThWidth = this._tableThColumn.offsetWidth - this._padding;
		//console.log('handlemousedown this._tableThColumn.tagName => ', this._tableThColumn.tagName);
	}

	handlemousemove(e) {
		//.log('mousemove this._tableThColumn => ', this._tableThColumn);
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

	handleErrors(error) {
		if (error.message) {
			this.showToast('info', 'No data returned', error.message);
			this.noRecordsFound = true;
		} else {
			this.showToast('error', 'Error', error.body.message);
		}
	}

	showToast(v, t, msg) {
		this.dispatchEvent(
			new ShowToastEvent({
				title: t,
				message: msg,
				variant: v,
				mode: 'sticky'
			})
		);
	}
}
