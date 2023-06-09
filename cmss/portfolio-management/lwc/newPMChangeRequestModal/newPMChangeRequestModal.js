import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import createCase from '@salesforce/apex/NewPMChangeRequestController.createCase';
import saveRequests from '@salesforce/apex/NewPMChangeRequestController.saveRequests';
import finalize from '@salesforce/apex/NewPMChangeRequestController.finalize';
import checkUserPermission from '@salesforce/apex/NewPMChangeRequestController.checkUserPermission';
import NewPortfolioManagementChangeRequest from '@salesforce/label/c.NewPortfolioManagementChangeRequest';
import Cancel from '@salesforce/label/c.Cancel';
import Save from '@salesforce/label/c.Save';
import unauthorizedUserLabel from '@salesforce/label/c.Unauthorized_User';
import tooManyRecordsLabel from '@salesforce/label/c.TooManyRecords';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';

const MAX_NUMBER_OF_CLIENTS = 1000;
export default class NewPMChangeRequestModal extends NavigationMixin(LightningElement) {
	connectedCallback() {
		this.showSpinner = true;
		checkUserPermission()
			.then((result) => {
				this.hasPermission = result;
			})
			.then((_) => {
				this.evaluatePermissionToShowModal();
				this.showSpinner = false;
			})
			.catch((error) => {
				console.error(error);
				this.validationError = error.body.message;
				this.showSpinner = false;
			});
	}

	evaluatePermissionToShowModal() {
		if (!this.hasPermission && (this._ids == null || this._ids.length == 0)) {
			this.showModal = false;
			this.warningMessage = '';
			this.validationError = unauthorizedUserLabel;
		} else if (this._ids.length > MAX_NUMBER_OF_CLIENTS) {
			this.showModal = false;
			this.warningMessage =
				tooManyRecordsLabel + ': Vybráno: ' + this._ids.length + ' Maximum: ' + MAX_NUMBER_OF_CLIENTS;
			this.validationError = null;
		} else {
			this.showModal = true;
			this.warningMessage = '';
			this.validationError = null;
		}
	}

	@api
	get ids() {
		return this.data.ids;
	}
	set ids(value) {
		if (value) {
			if (Array.isArray(value)) {
				this._ids = [...value];
			} else {
				this._ids = [value];
			}
		} else {
			this._ids = null;
		}
		this.evaluatePermissionToShowModal();
	}

	@wire(getObjectInfo, { objectApiName: 'Case' })
	caseInfo;

	@wire(getPicklistValues, {
		recordTypeId: '$caseInfo.data.defaultRecordTypeId',
		fieldApiName: 'Case.PortfolioManagementType__c'
	})
	typeOptions;

	@wire(getPicklistValues, {
		recordTypeId: '$caseInfo.data.defaultRecordTypeId',
		fieldApiName: 'Case.ChangeReason__c'
	})
	reasonOptions;

	_ids = [];
	show = false;
	validationError = null;
	showSpinner = false;
	hasPermission = false;
	showModal = false;
	warningMessage = '';
	progress = 0;
	@track data = {};

	get spinnerLabel() {
		return this.progress + ' / ' + this._ids.length;
	}

	labels = {
		NewPortfolioManagementChangeRequest,
		Save,
		Cancel
	};

	@api open() {
		this.show = true;
		this.data = {
			manager: null,
			type: 'A',
			reason: null,
			comments: null,
			ids: null,
			isEmptyCase: true
		};
		this.showSpinner = false;
	}

	handleClose() {
		this.show = false;
		this.dispatchEvent(new CustomEvent('close'));
	}

	async handleSave() {
		this.showSpinner = true;
		this.data.ids = this._ids;
		this.data.isEmptyCase = !(this._ids && this._ids.length);
		createCase({
			jsonData: JSON.stringify(this.data)
		})
			.then((result) => {
				this.data.caseId = result.caseId;
				return this.sendRequests();
			})
			.then((_) => {
				return finalize({
					jsonData: JSON.stringify(this.data)
				});
			})
			.then((_) => {
				this.navigateTo(this.data.caseId);
				this.showSpinner = false;
			})
			.catch((error) => {
				console.error(error);
				this.validationError = error.body.message;
				this.showSpinner = false;
				this.data.caseId = null;
			});
	}

	async sendRequests() {
		const chunkSize = 200;
		for (let i = 0; i < this._ids.length; i += chunkSize) {
			this.progress = i;
			const chunk = this._ids.slice(i, i + chunkSize);
			this.data.ids = chunk;
			await saveRequests({
				jsonData: JSON.stringify(this.data)
			});
		}
		this.data.ids = this._ids;
	}

	handleManagerChange(event) {
		this.data.manager = event.detail;
	}
	handleTypeChange(event) {
		this.data.type = event.target.value;
	}
	handleReasonChange(event) {
		this.data.reason = event.target.value;
	}
	handleCommentsChange(event) {
		this.data.comments = event.target.value;
	}
	navigateTo(id) {
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: id,
				actionName: 'view'
			}
		});
	}
}
