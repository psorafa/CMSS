import { LightningElement, api, track } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';

export default class CreateMicroCampaignForm extends LightningElement {

    @track _ids = []
    @track _campaign
    @track _task
    @track _assignee

    @api
    get outputData() {
        return JSON.stringify({
            ids : [...this._ids],
            campaign : {...this._campaign},
            task : {...this._task},
            assignee : this._assignee
        })
    }
    set outputData(val) {
    }

    @api
    get ids() {
        return this._ids
    }
    set ids(val) {
        console.log(JSON.stringify(this._ids))
        this._ids = val ? val : []
    }

    @api
    get outputValid() {
        if (this._campaign != null && !(this._campaign.name && this._campaign.endDate && this._campaign.description)) {
            return false
        }
        return true
    }
    set outputValid(val) {
    }

    get noIds() {
        return !!this._ids && false // todo: temporarily always false
    }

    propagateValuesToFlow() {
        console.log('output: ' + this.outputData)
        this.dispatchEvent(new FlowAttributeChangeEvent('outputData', this.outputData))
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

    navigateNext(event) {
        event.stopPropagation()
        if (this._campaign !== null && !(this._campaign.name && this._campaign.description && this._campaign.endDate)) {
            return
        }
        if (!(this._task.subject && this._task.description && this._task.dueDate && this._task.category && this._task.productType)) {
            return
        }
        this.dispatchEvent(new FlowNavigationNextEvent())
    }
}