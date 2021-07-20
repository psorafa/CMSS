import { LightningElement, api, track } from 'lwc';

export default class CreateMicroCampaignForm extends LightningElement {

    @track _someValue
    @track _campaign

    @api
    get testInput() {
        return 'test input'
    }
    set testInput(str) {

    }
    @api
    get testOutput() {
        return this._someValue;
    }
    set testOutput(str) {

    }

    propagateValuesToFlow() {
        const attributeChangeEvent = new FlowAttributeChangeEvent('someValue', this._someValue)
        this.dispatchEvent(attributeChangeEvent)
        // todo
    }

    handleAssigneeChange(event) {
        this._someValue = event.detail
    }

    handleCampaignChange(event) {
        console.log(JSON.stringify(event.detail))
        this._campaign = event.detail
    }
}