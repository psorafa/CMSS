import { LightningElement, api, wire } from 'lwc';

import { getRecord } from 'lightning/uiRecordApi';

import strUserId from '@salesforce/user/Id';
import PROFILE_NAME_FIELD from '@salesforce/schema/User.Profile.Name';

import LBL_CREATE_PMR_BUTTON_TITLE from '@salesforce/label/c.NewPortfolioManagementChangeRequest';

const EXPERIENCE_USER_PROFILE_NAME = 'CMSS Experience User';

export default class ChangePortfolioManagementButton extends LightningElement {
	_ids = [];
	_label = LBL_CREATE_PMR_BUTTON_TITLE;
	profileName;

	@wire(getRecord, {
		recordId: strUserId,
		fields: [PROFILE_NAME_FIELD]
	})
	wireuser({ error, data }) {
		if (error) {
			this.error = error;
		} else if (data) {
			this.profileName = data.fields.Profile.value.fields.Name.value;
		}
	}

	@api
	get recordId() {}
	set recordId(value) {
		this._ids = [value];
	}

	@api
	get ids() {
		return this._ids;
	}
	set ids(value) {
		this._ids = [...value];
	}

	@api
	get label() {
		return this._label;
	}
	set label(value) {
		this._label = value;
	}

	get isRowNotSelected() {
		return this._ids.length === 0;
	}

	get isVisibleToUser() {
		return this.profileName != EXPERIENCE_USER_PROFILE_NAME;
	}

	handleClick(event) {
		this.template.querySelector('[data-id="modal"]').open();
	}
}
