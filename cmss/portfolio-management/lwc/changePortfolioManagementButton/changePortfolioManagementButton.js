import { LightningElement, api } from 'lwc';

export default class ChangePortfolioManagementButton extends LightningElement {

    _ids = []
    _label = 'Change Portfolio Management'

    @api
    get recordId() {
    }
    set recordId(value) {
        this._ids = [value]
    }

    @api
    get ids() {
        return this._ids
    }
    set ids(value) {
        this._ids = [...value]
    }

    @api
    get label() {
        return this._label
    }
    set label(value) {
        this._label = value
    }

    handleClick(event) {
        this.template.querySelector('[data-id="modal"]').open()
    }
}