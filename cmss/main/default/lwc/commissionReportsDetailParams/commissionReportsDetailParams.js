import { LightningElement, wire, track } from 'lwc';
import customCSS from '@salesforce/resourceUrl/commissionReportsDetailCSS';
import { loadStyle } from 'lightning/platformResourceLoader';
import { publish, subscribe, MessageContext } from 'lightning/messageService';
import COMMISSION_CHANNEL from '@salesforce/messageChannel/Commission_Reports__c';

export default class CommissionReportsDetailParams extends LightningElement {
	@track value = 'monthyear';
	initYearValue;
	initMonthValue;
	pload = [];
	@track yearOptions = [];
	@track monthOptions = [];
	@track monthToOptions = [];
	@track yearValue;
	@track monthValue;
	@track yearToValue;
	@track monthToValue;
	@track showTo = false;
	@track cpuValue;
	@track fromRecordValue;
	@track toRecordValue;
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

	yearMonthOptions(selectedYear) {
		var mOptions = [];
		var option;
		for (let i = selectedYear == this.initYearValue ? this.initMonthValue : 12; i > 0; i--) {
			option = {
				label: String(i),
				value: String(i)
			};
			mOptions = [...mOptions, option];
		}
		return mOptions;
	}

	connectedCallback() {
		loadStyle(this, customCSS);
		console.log('customCSS loaded');
		var d = new Date();
		this.initYearValue = String(d.getFullYear());
		this.initMonthValue = String(d.getMonth() + 1);
		this.yearValue = this.initYearValue;
		this.yearToValue = this.initYearValue;
		this.yearOptions = [
			{ label: String(this.initYearValue), value: String(this.initYearValue) },
			{ label: String(this.initYearValue - 1), value: String(this.initYearValue - 1) },
			{ label: String(this.initYearValue - 2), value: String(this.initYearValue - 2) }
		];
		this.monthOptions = this.yearMonthOptions(this.initYearValue);
		this.monthToOptions = this.yearMonthOptions(this.initYearValue);
		this.cpuValue = '';
		this.fromRecordValue = '';
		this.toRecordValue = '';
		this.subscribeToMessageChannel();
	}

	get options() {
		return [
			{ label: 'Měsíc a rok', value: 'monthyear' },
			{ label: 'Od - do', value: 'sinceto' }
		];
	}

	buildPayload() {
		if (this.pload.length === 0) {
			this.pload = {
				year: this.yearValue,
				month: this.monthValue,
				yearTo: this.yearToValue,
				monthTo: this.monthToValue,
				showTo: this.showTo,
				cpu: this.cpuValue,
				fromRecord: this.fromRecordValue,
				toRecord: this.toRecordValue
			};
		} else {
			this.pload.year = this.yearValue;
			this.pload.month = this.monthValue;
			this.pload.yearTo = this.yearToValue;
			this.pload.monthTo = this.monthToValue;
			this.pload.showTo = this.showTo;
			this.pload.cpu = this.cpuValue;
			this.pload.fromRecord = this.fromRecordValue;
			this.pload.toRecord = this.toRecordValue;
		}
	}

	handlePeriodRadioChange(event) {
		this.value = event.detail.value;
		this.showTo = this.value == 'sinceto' ? true : false;
		this.buildPayload();
		publish(this.messageContext, COMMISSION_CHANNEL, this.pload);
	}

	handleYearChange(event) {
		this.yearValue = event.detail.value;
		this.monthOptions = this.yearMonthOptions(this.yearValue);
		this.monthValue = '';
		this.buildPayload();
		publish(this.messageContext, COMMISSION_CHANNEL, this.pload);
	}

	handleMonthChange(event) {
		this.monthValue = event.detail.value;
		this.buildPayload();
		publish(this.messageContext, COMMISSION_CHANNEL, this.pload);
	}

	handleYearToChange(event) {
		this.yearToValue = event.detail.value;
		this.monthToOptions = this.yearMonthOptions(this.yearToValue);
		this.monthToValue = '';
		this.buildPayload();
		publish(this.messageContext, COMMISSION_CHANNEL, this.pload);
	}

	handleMonthToChange(event) {
		this.monthToValue = event.detail.value;
		this.buildPayload();
		publish(this.messageContext, COMMISSION_CHANNEL, this.pload);
	}

	handleCpuChange(event) {
		this.cpuValue = event.target.value;
		this.buildPayload();
		publish(this.messageContext, COMMISSION_CHANNEL, this.pload);
	}

	handleFromRecordChange(event) {
		this.fromRecordValue = event.target.value;
		this.buildPayload();
		publish(this.messageContext, COMMISSION_CHANNEL, this.pload);
	}

	handleToRecordChange(event) {
		this.toRecordValue = event.target.value;
		this.buildPayload();
		publish(this.messageContext, COMMISSION_CHANNEL, this.pload);
	}
}