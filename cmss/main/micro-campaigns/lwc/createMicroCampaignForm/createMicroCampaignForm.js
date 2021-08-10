import { LightningElement, api, track } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';

export default class CreateMicroCampaignForm extends LightningElement {

    @track _campaign
    @track _task
    @track _assignee


    get outputValid() {
        if (this._campaign != null && !(this._campaign.name && this._campaign.endDate)) {
            return false
        }
        if (this._task == null || !(this._task.subject && this._task.description && this._task.dueDate)) {
            return false
        }
        return true
    }

    get outputData() {
        return {
            campaign : {...this._campaign},
            task : {...this._task},
            assignee : this._assignee
        }
    }

    fireChangeEvent() {
        this.dispatchEvent(new CustomEvent('change', {
			detail : {
			    data : this.outputData,
			    valid : this.outputValid
			}
		}))
    }

    handleAssigneeChange(event) {
        event.stopPropagation()
        this._assignee = event.detail
        this.fireChangeEvent()
    }

    handleCampaignChange(event) {
        event.stopPropagation()
        this._campaign = event.detail
        this.fireChangeEvent()
    }

    handleTaskChange(event) {
        event.stopPropagation()
        this._task = event.detail
        this.fireChangeEvent()
    }

}