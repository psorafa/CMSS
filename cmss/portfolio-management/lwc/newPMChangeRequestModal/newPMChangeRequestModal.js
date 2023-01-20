import { LightningElement, api, track, wire } from 'lwc'
import { NavigationMixin } from 'lightning/navigation'
import saveData from '@salesforce/apex/NewPMChangeRequestController.saveData'
import NewPortfolioManagementChangeRequest from '@salesforce/label/c.NewPortfolioManagementChangeRequest'
import Cancel from '@salesforce/label/c.Cancel'
import Save from '@salesforce/label/c.Save'

import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi'

export default class NewPMChangeRequestModal extends NavigationMixin(LightningElement) {

    @api
    get ids() {
        return this.data.ids
    }
    set ids(value) {
        if (value) {
            if (Array.isArray(value)) {
                this._ids = [...value]
            } else {
                this._ids = [value]
            }
        } else {
            this._ids = null
        }
    }

    @wire(getObjectInfo, { objectApiName: 'Case' })
    caseInfo

    @wire(getPicklistValues,
        {
            recordTypeId: '$caseInfo.data.defaultRecordTypeId',
            fieldApiName: 'Case.PortfolioManagementType__c'
        }
    )
    typeOptions

    @wire(getPicklistValues,
        {
            recordTypeId: '$caseInfo.data.defaultRecordTypeId',
            fieldApiName: 'Case.ChangeReason__c'
        }
    )
    reasonOptions

    _ids = []
    show = false
    validationError = null
    showSpinner = false
    @track data = {}

    labels = {
        NewPortfolioManagementChangeRequest,
        Save,
        Cancel
    }

    @api open() {
        this.show = true
        this.data = {
            manager : null,
            type : 'A',
            reason : null,
            comments : null,
            ids : null
        }
        this.validationError = null
        this.showSpinner = false
    }

    handleClose() {
        this.show = false
        this.dispatchEvent(new CustomEvent('close'))
    }

    handleSave() {
        this.showSpinner = true
        this.data.ids = this._ids
        saveData({
            jsonData : JSON.stringify(this.data)
        }).then((result) => {
            // check result
            console.log('save done', JSON.stringify(result))
            if (result.isSuccess) {
                this.navigateTo(result.caseId)
            } else {
                this.validationError = result.error
                this.showSpinner = false
            }
        }).catch((error) => {
            console.error(error)
            this.validationError = error.body.message
            this.showSpinner = false
        })
    }

    handleManagerChange(event) {
        this.data.manager = event.detail
    }
    handleTypeChange(event) {
        this.data.type = event.target.value
    }
    handleReasonChange(event) {
        this.data.reason = event.target.value
    }
    handleCommentsChange(event) {
        this.data.comments = event.target.value
    }
    navigateTo(id) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: id,
                actionName: 'view'
            }
        })
    }
}