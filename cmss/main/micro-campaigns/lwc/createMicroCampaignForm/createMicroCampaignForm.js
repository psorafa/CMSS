import { LightningElement, api, track } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';

export default class CreateMicroCampaignForm extends LightningElement {

    @track _campaign
    @track _task
    @track _assignee

    @api
    get outputData() {
        return JSON.stringify({
            campaign : {...this._campaign},
            task : {...this._task},
            assignee : {...this._assignee}
        })
    }
    set outputData(val) {
    }

    propagateValuesToFlow() {
        console.log('output: ' + this.outputData)
        const attributeChangeEvent = new FlowAttributeChangeEvent('outputData', this.outputData)
        this.dispatchEvent(attributeChangeEvent)
    }

    handleAssigneeChange(event) {
        this._assignee = event.detail
        this.propagateValuesToFlow()
    }

    handleCampaignChange(event) {
        this._campaign = event.detail
        this.propagateValuesToFlow()
    }

    handleTaskChange(event) {
        this._task = event.detail
        this.propagateValuesToFlow()
    }
}