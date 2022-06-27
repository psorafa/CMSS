import { LightningElement, wire, track } from 'lwc';

import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import USERPROFILE_NAME from '@salesforce/schema/User.Profile.Name';

export default class SelectAssignee extends LightningElement {
	@track _options = [
		{ label: 'Správce stavu', value: 'portfolioManager' },
		{ label: 'Vybrat uživatele...', value: 'selectUser' }
	];
	@track _selection = 'portfolioManager';

	isPartnerUser = false;

	get displaySearch() {
		return this._selection === 'selectUser';
	}

	@wire(getRecord, { recordId: USER_ID, fields: [USERPROFILE_NAME] })
	userDetails({ error, data }) {
		if (data) {
			if (data.fields.Profile.value.fields.Name.value == 'CMSS Experience User') {
				this.isPartnerUser = true;
			}
		} else if (error) {
			this.error = error;
		}
	}

	handleSelectionChange(event) {
		event.stopPropagation();
		this._selection = event.detail.value;
		if (this._selection === 'portfolioManager') {
			this.dispatchEvent(new CustomEvent('change', { detail: undefined }));
		}
	}

	handleLookupChange(event) {
		event.stopPropagation();
		this.dispatchEvent(new CustomEvent('change', { detail: event.detail }));
	}
}
