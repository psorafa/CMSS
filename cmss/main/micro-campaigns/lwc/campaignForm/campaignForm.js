import { LightningElement, track, api } from 'lwc';

export default class CampaignForm extends LightningElement {

    @track doNotCreateCampaign = false
    _campaign = {}

    handleCheckboxChange(event) {
        event.stopPropagation()
        this.doNotCreateCampaign = event.detail.checked
        this.fireUpdate()
    }

    handleNameChange(event) {
        event.stopPropagation()
        this._campaign.name = event.detail.value
        this.fireUpdate()
    }

    handleEndDateChange(event) {
        event.stopPropagation()
        this._campaign.endDate = event.detail.value
        this.fireUpdate()
    }

    handleDescriptionChange(event) {
        event.stopPropagation()
        this._campaign.description = event.detail.value
        this.fireUpdate()
    }

    fireUpdate() {
        if (this.doNotCreateCampaign) {
            this.dispatchEvent(new CustomEvent('change', {
                detail : null
            }))
        } else {
            this.dispatchEvent(new CustomEvent('change', {
                detail : this._campaign
            }))
        }
    }
}