import { LightningElement, api, track } from 'lwc';
import customCSS from '@salesforce/resourceUrl/commissionReportsDetailCSS';
import { loadStyle } from 'lightning/platformResourceLoader';

export default class CommissionReportsDetailParams extends LightningElement {
	@track value = 'monthyear';
	initYearValue;
	initMonthValue;
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
		this.monthValue = this.initMonthValue;
		this.monthToValue = this.initMonthValue;
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
	}

	get options() {
		return [
			{ label: 'Měsíc a rok', value: 'monthyear' },
			{ label: 'Od - do', value: 'sinceto' }
		];
	}

	handlePeriodRadioChange(event) {
		this.value = event.detail.value;
		this.showTo = this.value == 'sinceto' ? true : false;
	}

	handleYearChange(event) {
		this.yearValue = event.detail.value;
		this.monthOptions = this.yearMonthOptions(this.yearValue);
		this.monthValue = '';
	}

	handleMonthChange(event) {
		this.monthValue = event.detail.value;
	}

	handleYearToChange(event) {
		this.yearToValue = event.detail.value;
		this.monthToOptions = this.yearMonthOptions(this.yearToValue);
		this.monthToValue = '';
	}

	handleMonthToChange(event) {
		this.monthToValue = event.detail.value;
	}

	handleCpuChange(event) {
		this.cpuValue = event.target.value;
	}

	handleFromRecordChange(event) {
		this.fromRecordValue = event.target.value;
	}

	handleToRecordChange(event) {
		this.toRecordValue = event.target.value;
	}
}