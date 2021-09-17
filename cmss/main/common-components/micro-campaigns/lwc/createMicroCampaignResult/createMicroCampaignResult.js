import { LightningElement, track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class CreateMicroCampaignResult extends NavigationMixin(LightningElement) {

	@track _result
	@track error

	@api
	get result() {
	    return this._result
 	}
 	set result(value) {
 	    this._result = value
	}

	@api
	get error() {
		return this.error
	}
	set error(value) {
	    this.error = value
 	}

	get showError() {
	    return !!this.error
	}

	get errorString() {
	    return JSON.stringify(this.error, null, 2)
	}

	get completeSuccess() {
	    return this._result.numberOfErrors == 0
	}

   	get numberOfSuccesses() {
   	    return this._result.numberOfSuccesses
    }

    get campaignCreated() {
        return !!this._result.campaignId
    }

    get erroredAccountsNotEmpty() {
        return this._result.erroredAccounts?.length > 0
    }

    get erroredRecordsNotEmpty() {
        return this._result.erroredRecords?.length > 0
    }
    

    handleCampaignClick(event) {
        event.stopPropagation()
        this.navigateToSObjectRecord(this._result.campaignId)
    }

    handleAccountClick(event) {
        event.stopPropagation()
        console.log(JSON.stringify(event.target))
        this.navigateToSObjectRecord(event.target.name)
    }

    navigateToSObjectRecord(id) {
		/*
		doesn't seem to be working in Flow:
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: id,
				actionName: 'view'
			},
		})*/
        window.open('/' + id)
	}
}