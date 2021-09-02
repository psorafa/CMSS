import { LightningElement, api, track } from 'lwc';

export default class SelectAssignee extends LightningElement {

    @track _options = [
        { label: 'Správce stavu', value: 'portfolioManager' },
        { label: 'Vybrat uživatele...', value: 'selectUser' }
    ]
    @track _selection = 'portfolioManager'

    get displaySearch() {
        return this._selection === 'selectUser'
    }

    handleSelectionChange(event) {
        event.stopPropagation()
        this._selection = event.detail.value
        if (this._selection === 'portfolioManager') {
            this.dispatchEvent(new CustomEvent('change', { detail: undefined } ) )
        }
    }

    handleLookupChange(event) {
        event.stopPropagation()
        this.dispatchEvent(new CustomEvent('change', { detail: event.detail } ) )
    }

}