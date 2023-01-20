import { LightningElement, wire, track } from 'lwc';
import getUserInfo from '@salesforce/apex/CommissionRunReportController.getUserInfo';
import checkPermissionSets from '@salesforce/apex/CommissionRunReportController.checkPermissionSets';
import getContactInfo from '@salesforce/apex/CommissionRunReportController.getContactInfo';
import customCSS from '@salesforce/resourceUrl/commissionReportsDetailCSS';
import { loadStyle } from 'lightning/platformResourceLoader';
import { publish, subscribe, MessageContext } from 'lightning/messageService';
import COMMISSION_CHANNEL from '@salesforce/messageChannel/Commission_Reports__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

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
	@track tribeCpuValue;
	@track fromRecordValue;
	@track toRecordValue;
	loading = false;
	subscription = null;
	userId;
	address;
	adminProfile = false;
	adminPermissionSet = false;
	showTribeCPU = false;
	accountBaseCombinedName;
	profiles = ['System Administrator', 'Správce systému'];

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
		this.tribeCpuValue = '';
		this.fromRecordValue = '';
		this.toRecordValue = '';
		this.subscribeToMessageChannel();
		if (!this.loading) {
			this.loading = true;
			getUserInfo()
				.then((result) => {
					this.processResult(result);
				})
				.then(() =>
					getContactInfo({
						userId: this.userId
					})
						.then((data) => {
							this.processContactInfo(data);
						})
						.catch((error) => {
							this.handleErrors(error);
						})
				)
				.then(() =>
					checkPermissionSets()
						.then((cnt) => {
							console.log('cnt: ' + cnt);
							this.adminPermissionSet = Number(cnt) > 0 ? true : false;
							if (this.adminPermissionSet || this.adminProfile) {
								this.showTribeCPU = true;
							}
						})
						.catch((error) => {
							this.handleErrors(error);
						})
				)
				.catch((error) => {
					this.handleErrors(error);
				});
		}
	}

	processResult(result) {
		console.log('User info: ' + JSON.stringify(result));
		this.userId = result.Id;
		this.adminProfile = this.profiles.indexOf(result.Profile.Name) > -1 ? true : false;
		this.accountBaseCombinedName = (result.CommissionAccountBase__c !== undefined ? result.CommissionAccountBase__c : '') + ', ' + result.CombinedName__c;
		var localCpu = result.CommissionAccountNr__c;
		if (localCpu !== undefined) {
			this.cpuValue = localCpu.substring(localCpu.length - 3);
		}
		this.loading = false;
	}

	processContactInfo(result) {
		console.log('Contact info: ' + JSON.stringify(result));
		this.address = result.Value__c;
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
				tribeCpu: this.tribeCpuValue,
				fromRecord: this.fromRecordValue,
				toRecord: this.toRecordValue,
				accountBaseCombinedName: this.accountBaseCombinedName,
				address: this.address
			};
		} else {
			this.pload.year = this.yearValue;
			this.pload.month = this.monthValue;
			this.pload.yearTo = this.yearToValue;
			this.pload.monthTo = this.monthToValue;
			this.pload.showTo = this.showTo;
			this.pload.cpu = this.cpuValue;
			this.pload.tribeCpu = this.tribeCpuValue;
			this.pload.fromRecord = this.fromRecordValue;
			this.pload.toRecord = this.toRecordValue;
			this.pload.accountBaseCombinedName = this.accountBaseCombinedName;
			this.pload.address = this.address;
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

	handleTribeCpuChange(event) {
		this.tribeCpuValue = event.target.value;
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
