import { LightningElement, track } from 'lwc';
import Id from '@salesforce/user/Id';
import getCampaignData from '@salesforce/apex/SearchController.getCampaign';

const DEFAULT_CAMPAIGN_VALUES = {
	startDate: new Date().toISOString().substr(0, 10),
	endDate: null,
	name: '',
	describtion: ''
};

export default class CampaignForm extends LightningElement {
	@track doNotCreateCampaign = false;
	campaignSearchCondition = "CreatedById = '" + Id + "' AND IsActive = true";
	campaignExists;

	@track _campaign = JSON.parse(JSON.stringify(DEFAULT_CAMPAIGN_VALUES));

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
		console.log('Idčko', event.detail);
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
			this._campaign = JSON.parse(JSON.stringify(DEFAULT_CAMPAIGN_VALUES));
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
