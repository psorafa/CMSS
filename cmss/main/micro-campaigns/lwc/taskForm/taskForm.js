import { LightningElement, track, wire } from 'lwc'
import getPicklistValues from '@salesforce/apex/CreateMicroCampaignController.getPicklistValues'

export default class TaskForm extends LightningElement {

    @wire(getPicklistValues, {objectName: 'Task', fieldName: 'Category__c'})
    categoryValues

    @wire(getPicklistValues, {objectName: 'Task', fieldName: 'ProductType__c'})
    productTypeValues

    @track _task = {
        dueDate : this.defaultDate,
        category : '3'
    }

    get task() {
        return JSON.stringify(this._task)
    }

    get productTypeOptions() {
        return this.productTypeValues.data ? [ { label: ' ' }, ...this.productTypeValues.data] : []
    }

    get categoryOptions() {
        return this.categoryValues.data
    }

    get defaultDate() {
        let date = new Date()
        date.setDate(date.getDate() + 30);
        return date.toISOString().substr(0, 10)
    }

    handleSubjectChange(event) {
        event.stopPropagation()
        this._task.subject = event.detail.value
        this.fireUpdate()
    }

    handleDescriptionChange(event) {
        event.stopPropagation()
        this._task.description = event.detail.value
        this.fireUpdate()
    }

    handleDueDateChange(event) {
        event.stopPropagation()
        this._task.dueDate = event.detail.value
        this.fireUpdate()
    }

    handleCategoryChange(event) {
        event.stopPropagation()
        this._task.category = event.detail.value
        this.fireUpdate()
    }

    handleProductTypeChange(event) {
        event.stopPropagation()
        this._task.productType = event.detail.value
        this.fireUpdate()
    }

    fireUpdate() {
        this.dispatchEvent(new CustomEvent('change', {
            detail : this._task
        }))
    }
}