import { LightningElement, api, track } from 'lwc';

export default class CreateMicroCampaign extends LightningElement {

    @track _ids = []
    @track _jsonData
    @track _dataInvalid = true
    @track _results
    @track actionStep = 1 // 1 - creation form; 2 - form sent, action pending; 3 - action successful, show results;

    @api
    get ids() {
        return this._ids
    }
    set ids(val) {
        console.log(JSON.stringify(this._ids))
        this._ids = val ? val : []
    }


    get noIds() {
        return (this._ids == undefined || this._ids.length == 0)
    }
	get showForm() {
	    return (this._ids && this._ids.length > 0) && this.actionStep === 1
 	}
 	get showSpinner() {
 	    return this.actionStep === 2
  	}
  	get showResults() {
  	    return this.actionStep === 3
   	}



    handleFormChange(event) {
        event.stopPropagation()
        this._jsonData = JSON.stringify(event.detail.data)
        this._dataInvalid = !event.detail.valid
    }

    handleCreateClick(event) {
        event.stopPropagation()
        if (!this._dataInvalid) {
            // tak neco udelame
        }
    }
}