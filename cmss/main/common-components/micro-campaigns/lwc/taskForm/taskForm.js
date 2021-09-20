import { LightningElement, track, wire, api } from 'lwc';
import getPicklistValues from '@salesforce/apex/CreateMicroCampaignController.getPicklistValues';

export default class TaskForm extends LightningElement {
	@wire(getPicklistValues, { objectName: 'Task', fieldName: 'Category__c' })
	categoryValues;

	@wire(getPicklistValues, { objectName: 'Task', fieldName: 'ProductType__c' })
	productTypeValues;

	@wire(getPicklistValues, { objectName: 'Task', fieldName: 'Type' })
	typeValues;

	@track _task = {
		type: '5',
		category: '3',
		validFrom: this.validFromDate,
		dueDate: this.dueDate
	};

	@api validFromDate;
	@api dueDate;

	get task() {
		return JSON.stringify(this._task);
	}

	get productTypeOptions() {
		return this.productTypeValues.data ? [{ label: ' ' }, ...this.productTypeValues.data] : [];
	}

	get categoryOptions() {
		return this.categoryValues.data;
	}

	get typeOptions() {
		return this.typeValues.data;
	}

	handleSubjectChange(event) {
		event.stopPropagation();
		this._task.subject = event.detail.value;
		this.fireUpdate();
	}

	handleDescriptionChange(event) {
		event.stopPropagation();
		this._task.description = event.detail.value;
		this.fireUpdate();
	}

	handleDueDateChange(event) {
		event.stopPropagation();
		this.dueDate = event.detail.value;
		this._task.dueDate = this.dueDate;
		this.fireUpdate();
	}

	handleValidFromChange(event) {
		event.stopPropagation();
		this.validFromDate = event.detail.value;
		this._task.validFrom = this.validFromDate;
		this.fireUpdate();
	}

	handleCategoryChange(event) {
		event.stopPropagation();
		this._task.category = event.detail.value;
		this.fireUpdate();
	}

	handleTypeChange(event) {
		event.stopPropagation();
		this._task.type = event.detail.value;
		this.fireUpdate();
	}

	handleProductTypeChange(event) {
		event.stopPropagation();
		this._task.productType = event.detail.value;
		this.fireUpdate();
	}

	fireUpdate() {
		this.dispatchEvent(
			new CustomEvent('change', {
				detail: this._task
			})
		);
	}
}
