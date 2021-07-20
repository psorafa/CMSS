import { LightningElement, track, wire } from 'lwc'
import getPicklistValues from '@salesforce/apex/CreateMicroCampaignController.getPicklistValues'

export default class TaskForm extends LightningElement {

    @wire(getPicklistValues, {objectName: 'Task', fieldName: 'Category__c'})
    categoryValues

    @track _task = {}

    get task() {
        return JSON.stringify(this._task)
    }

    get productTypeOptions() {
        return [
            {value : '1', label : 'produkt 1'},
            {value : '2', label : 'produkt 2'}
        ];
    }

    get categoryOptions() {
        return this.categoryValues.data
    }

    get defaultDate() {
        let date = new Date()
        date.setDate(date.getDate() + 30);
        return date.toISOString()
    }

    handleCategoryChange(event) {
        event.stopPropagation()
        this._task.category = event.detail.value
        this.fireUpdate()
    }

    handleSubjectChange(event) {
        event.stopPropagation()
        this._task.subject = event.detail.value
        this.fireUpdate()
    }

    fireUpdate() {
        this.dispatchEvent(new CustomEvent('change', {
            detail : this._task
        }))
    }
}