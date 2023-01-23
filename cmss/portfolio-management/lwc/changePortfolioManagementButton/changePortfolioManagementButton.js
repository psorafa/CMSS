import { LightningElement, api } from 'lwc';

import LBL_CREATE_PMR_BUTTON_TITLE from '@salesforce/label/c.NewPortfolioManagementChangeRequest';

export default class ChangePortfolioManagementButton extends LightningElement {

    _ids = []
    _label = LBL_CREATE_PMR_BUTTON_TITLE

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

	get isRowNotSelected() {
		return this._ids.length === 0; 
	}

    handleClick(event) {
        this.template.querySelector('[data-id="modal"]').open()
    }
}