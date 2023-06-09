import { LightningElement, wire } from 'lwc';
import { getFieldValue, getRecord } from 'lightning/uiRecordApi';

import Id from '@salesforce/user/Id';
import getCampaignData from '@salesforce/apex/SearchController.getCampaign';

import MARKETING_PERMISSION from '@salesforce/schema/User.UserPermissionsMarketingUser';

const DEFAULT_CAMPAIGN_VALUES = {
	startDate: new Date().toISOString().substr(0, 10),
	name: '',
	describtion: ''
};

export default class CampaignForm extends LightningElement {
	@wire(getRecord, { recordId: Id, fields: [MARKETING_PERMISSION] })
	retrieveCurrentUserDatadata({ error, data }) {
		if (data) {
			const hasMarketingUserPermission = getFieldValue(data, MARKETING_PERMISSION);
			this.doNotCreateCampaign = !hasMarketingUserPermission;
			this.canNotCreateCampaigns = !hasMarketingUserPermission;
			this.fireUpdate();
		} else if (error) {
			console.log(JSON.stringify(error));
		}
	}

	doNotCreateCampaign = false;
	canNotCreateCampaigns = false;
	campaignSearchCondition = "CreatedById = '" + Id + "' AND IsActive = true";
	campaignExists;

	_campaign = {
		...JSON.parse(JSON.stringify(DEFAULT_CAMPAIGN_VALUES)),
		endDate: this.defaultDate
	};

	get defaultDate() {
		let date = new Date();
		date.setDate(date.getDate() + 30);
		return date.toISOString().substr(0, 10);
	}

	handleCheckboxChange(event) {
		event.stopPropagation();
		this.doNotCreateCampaign = event.detail.checked;
		this.fireUpdate();
	}

	handleNameChange(event) {
		event.stopPropagation();
		this._campaign.name = event.detail.value;
		this.fireUpdate();
	}

	handleStartDateChange(event) {
		event.stopPropagation();
		this._campaign.startDate = event.detail.value;
		this.fireUpdate();
	}

	handleEndDateChange(event) {
		event.stopPropagation();
		this._campaign.endDate = event.detail.value;
		this.fireUpdate();
	}

	handleDescriptionChange(event) {
		event.stopPropagation();
		this._campaign.description = event.detail.value;
		this.fireUpdate();
	}

	handleLookupChange(event) {
		event.stopPropagation();
		if (event.detail) {
			getCampaignData({ campaignId: event.detail, fields: 'Name, Description, EndDate, StartDate' }).then(
				(campaign) => {
					this._campaign.Id = campaign.Id;
					this._campaign.name = campaign.Name;
					this._campaign.startDate = campaign.StartDate;
					this._campaign.endDate = campaign.EndDate;
					this._campaign.describtion = campaign.Description;
					this.campaignExists = true;
					this.dispatchEvent(new CustomEvent('change', { detail: this._campaign }));
				}
			);
		} else {
			this._campaign = {
				...JSON.parse(JSON.stringify(DEFAULT_CAMPAIGN_VALUES)),
				endDate: this.defaultDate
			};
			this.campaignExists = false;

			this.dispatchEvent(new CustomEvent('change', { detail: this._campaign }));
		}
	}

	fireUpdate() {
		if (this.doNotCreateCampaign) {
			this.dispatchEvent(
				new CustomEvent('change', {
					detail: null
				})
			);
		} else {
			this.dispatchEvent(
				new CustomEvent('change', {
					detail: this._campaign
				})
			);
		}
	}
}
