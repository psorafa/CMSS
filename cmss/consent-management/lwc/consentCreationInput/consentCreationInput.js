import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import enableGeneralConsents from '@salesforce/apex/GeneralConsentEnablement.enableGeneralConsents';
import checkAgentCPU from '@salesforce/apex/AgentCPUCheck.checkAgentCPU';
import AGE from '@salesforce/schema/Account.PersonAge__c';
import save from '@salesforce/label/c.Save';
import cancel from '@salesforce/label/c.Cancel';
import errorMessage from '@salesforce/label/c.Error';
import recordsCreated from '@salesforce/label/c.RecordsCreated';
import newConsent from '@salesforce/label/c.NewConsent';
import errorMessageNoUser from '@salesforce/label/c.NoUserWithThisCPUFound';

export default class ConsentCreationInput extends LightningElement {
	@track generalConsent = {};
	@api accountId;
	isSaving = false;
	labels = {
		save,
		cancel,
		newConsent,
		errorMessageNoUser
	};
	agentCPU = '';
	agentCPUError = false;

	@wire(getRecord, { recordId: '$accountId', fields: [AGE] })
	account({ error, data }) {
		if (data) {
			if (data.fields.PersonAge__c.value) {
				let substitutePerson = this.template.querySelector('[data-id="SubstitutePerson__c"]');
				let substituteRole = this.template.querySelector('[data-id="SubstituteRole__c"]');
				substitutePerson.required = data.fields.PersonAge__c.value < 18;
				substituteRole.required = data.fields.PersonAge__c.value < 18;
			}
		} else if (error) {
			this.handleErrors(error);
		}
	}

	handleValueChange(event) {
		const inputFields = this.template.querySelectorAll('[data-isconsenttype="true"]');
		if (inputFields) {
			inputFields.forEach((field) => {
				field.value = event.target.value;
			});
		}
	}

	handleAgentCPUChange() {
		const inputField = this.template.querySelector('[data-id="AgentCPU__c"]');
		const spanElement = this.template.querySelector('[data-id="agentCPUSpan"]');
		if (this.agentCPU !== inputField.value) {
			this.agentCPU = inputField.value;
			checkAgentCPU({ agentCPU: inputField.value })
				.then((data) => {
					if (data) {
						spanElement.className = '';
						this.agentCPUError = false;
					} else {
						spanElement.className = 'slds-has-error';
						this.agentCPUError = true;
					}
				})
				.catch((error) => {
					this.handleErrors(error);
				});
		}
	}

	handleClose() {
		this.handleDispatchEvent(true, false);
	}

	handleDispatchEvent(isClosed, isCreated) {
		const valueChangeEvent = new CustomEvent('valuechange', {
			detail: {
				isClosed: isClosed,
				isCreated: isCreated
			}
		});
		this.dispatchEvent(valueChangeEvent);
	}

	handleSave() {
		if (!this.agentCPUError) {
			this.toggleSpinner();
			let isValid = true;
			const inputFields = this.template.querySelectorAll('lightning-input-field');
			if (inputFields) {
				inputFields.forEach((field) => {
					if (field.required && !field.value) {
						isValid = false;
						field.reportValidity();
					}
					this.generalConsent[field.fieldName] = field.value;
				});
			} else {
				return;
			}

			if (isValid) {
				this.generalConsent.Account__c = this.accountId;
				enableGeneralConsents({ c: this.generalConsent })
					.then((data) => {
						if (data === 'OK') {
							this.fireToast('success', recordsCreated);
							this.handleDispatchEvent(true, true);
						} else if (data) {
							this.fireToast('error', errorMessage, data);
						} else {
							this.fireToast('error', errorMessage);
						}
						this.toggleSpinner();
					})
					.catch((error) => {
						this.handleErrors(error);
						this.toggleSpinner();
					});
			} else {
				this.generalConsent = {};
				this.toggleSpinner();
			}
		}
	}

	handleErrors(error) {
		console.log(JSON.stringify(error));
		this.fireToast('error', errorMessage);
	}

	toggleSpinner() {
		this.isSaving = !this.isSaving;
	}

	fireToast(variant, title, message) {
		const evt = new ShowToastEvent({
			variant: variant,
			title: title,
			message: message
		});
		this.dispatchEvent(evt);
	}
}
