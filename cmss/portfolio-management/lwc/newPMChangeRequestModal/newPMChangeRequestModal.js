/**
 * Created by tadeas on 31.12.2022.
 */

import { LightningElement, api } from 'lwc'
import { NavigationMixin } from 'lightning/navigation'
import saveData from '@salesforce/apex/NewPMChangeRequestController.saveData'

export default class NewPMChangeRequestModal extends NavigationMixin(LightningElement) {

    @api
    get ids() {
        return this.data.ids
    }
    set ids(value) {
        if (value) {
            if (Array.isArray(value)) {
                this.data.ids = [...value]
            } else {
                this.data.ids = [value]
            }
        } else {
            this.data.ids = null
        }
    }

    show = false
    validationError = null
    showSpinner = false
    data = {}

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
        console.log('close fired')
    }

    handleSave() {
        this.showSpinner = true
        console.log('data to be send', JSON.stringify(this.data))
        saveData({
            jsonData : JSON.stringify(this.data)
        }).then((result) => {
            // check result
            console.log('save done', JSON.stringify(result))
            if (result.isSuccess) {
                // todo
            } else {
                this.validationError = result.error
                this.showSpinner = false
            }
        }).catch((error) => {
            // todo: handle error
            console.error(error)
            this.showSpinner = false
        })
    }

    handleFormSubmit(event) {
        // override standard form submit, let user click on Save instead
        event.preventDefault()
        event.stopPropagation()
    }

    handleManagerChange(event) {
        this.data.manager = event.target.value
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
}