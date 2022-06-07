import { LightningElement, api, wire } from 'lwc';
import { createRecord, deleteRecord } from 'lightning/uiRecordApi';
import getUserCalendarSetting from '@salesforce/apex/CalendarSyncStatusController.getUserCalendarSetting';
import validateConnection from '@salesforce/apex/CalendarSyncStatusController.validateCalendarConnection';
import getTechnicalUserMail from '@salesforce/apex/CalendarSyncStatusController.getTechnicalUserMail';
import createWatch from '@salesforce/apex/CalendarSyncStatusController.createWatch';
import actualUserId from '@salesforce/user/Id';

import USER_CALENDAR_SETTING_OBJECT from '@salesforce/schema/UserCalendarSetting__c';

import CALENDAR_ID_FIELD from '@salesforce/schema/UserCalendarSetting__c.UserCalendarID__c';
import USER_FIELD from '@salesforce/schema/UserCalendarSetting__c.User__c';
import SYNC_ACTIVE_FIELD from '@salesforce/schema/UserCalendarSetting__c.SyncActive__c';
import EXPIRATION_FIELD from '@salesforce/schema/UserCalendarSetting__c.WatchExpirationDateTime__c';

export default class CalendarSyncStatus extends LightningElement {
	showModal;
	userCalendarSetting;
	googleCalendarIdInput;
	userId = actualUserId;
	syncStarted = false;
	existingSettingId = '';
	isConnectionValid = false;
	isConnectionInvalid = false;
	showSpinner = false;
	technicalUserMail;

	activeHelpSections = [];

	@wire(getUserCalendarSetting, {})
	userCalendarSetting({ _, data }) {
		if (data) {
			this.userCalendarSetting = data;
			this.existingSettingId = this.userCalendarSetting.UserCalendarID__c;
			this.googleCalendarIdInput = this.userCalendarSetting.UserCalendarID__c;
		}
	}

	@wire(getTechnicalUserMail, {})
	retrieveTechnicalUserMail({ _, data }) {
		if (data) {
			this.technicalUserMail = JSON.parse(data);
		}
	}

	get technicalUserMail() {
		return this.technicalUserMail;
	}

	handleHelpToggle() {
		this.activeHelpSections = this.activeHelpSections.length === 0 ? ['Help'] : [];
	}

	handleCloseModal() {
		this.showModal = false;
	}

	handleOpenModal() {
		this.showModal = true;
	}

	get isSettingActive() {
		return this.userCalendarSetting && this.userCalendarSetting.SyncActive__c;
	}

	handleCancelSync() {
		this.showSpinner = true;
		this.deleteExistingSetting().then(() => {
			this.userCalendarSetting = null;
			this.showSpinner = false;
		});
	}

	handleInputChange(event) {
		this.googleCalendarIdInput = event.detail.value;
	}

	handleValidateCalendarId() {
		try {
			this.showSpinner = true;
			validateConnection({ googleCalendarId: this.googleCalendarIdInput }).then((isValid) => {
				console.log(isValid);
				this.showSpinner = false;
				if (isValid) {
					this.isConnectionValid = true;
					this.isConnectionInvalid = false;
				} else {
					this.isConnectionInvalid = true;
				}
			});
		} catch (e) {
			console.log('Error:', e);
		}
	}

	handleSynchronize() {
		try {
			const fields = {};
			fields[CALENDAR_ID_FIELD.fieldApiName] = this.googleCalendarIdInput;
			fields[USER_FIELD.fieldApiName] = this.userId;
			fields[SYNC_ACTIVE_FIELD.fieldApiName] = false;
			const date = new Date();
			fields[EXPIRATION_FIELD.fieldApiName] = new Date(date.setMonth(date.getMonth() + 1));

			const recordInput = {
				apiName: USER_CALENDAR_SETTING_OBJECT.objectApiName,
				fields: fields
			};
			this.showSpinner = true;
			this.syncStarted = true;
			this.deleteExistingSetting()
				.then(() => createRecord(recordInput))
				.then((record) => {
					this.userCalendarSetting = record;
				})
				.then(() => {
					this.showSpinner = false;
					createWatch({ calendarId: this.userCalendarSetting.id });
				})
				.then(() => getUserCalendarSetting())
				.then((_, data) => {
					if (data) {
						this.userCalendarSetting = data;
						this.existingSettingId = this.userCalendarSetting.UserCalendarID__c;
						this.googleCalendarIdInput = this.userCalendarSetting.UserCalendarID__c;
					}
				});
		} catch (e) {
			console.log('Error:', e);
		}
	}

	deleteExistingSetting() {
		if (this.userCalendarSetting) {
			return deleteRecord(this.userCalendarSetting.Id);
		}
		return new Promise((resolve, _) => {
			resolve();
		});
	}
}
