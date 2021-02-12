import { LightningElement, api, wire, track } from 'lwc';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import save from '@salesforce/label/c.Save';
import AGE from '@salesforce/schema/Account.Age__c';

export default class ConsentCreationInput extends LightningElement {
    @api availableActions = [];
    @api generalConsent = {};
    @api accountId;
    label = {
        save
    };

    @wire(getRecord, { recordId: '$accountId', fields: [AGE] })
    account({ error, data }) {
        if (data) {
            let substitutePerson = this.template.querySelector('[data-id="SubstitutePerson__c"]')
            let substituteRole = this.template.querySelector('[data-id="SubstituteRole__c"]')
            substitutePerson.required = data.fields.Age__c.value && data.fields.Age__c.value < 18;
            substituteRole.required = data.fields.Age__c.value && data.fields.Age__c.value < 18;
        } else if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            console.log(message)
        }
    }

    handleValueChange(event) {
        const inputFields = this.template.querySelectorAll('[data-isconsenttype="true"]');
        if (inputFields) {
            inputFields.forEach(field => {
                field.value = event.target.value;
            })
        }
    }

    handleGoNext() {
        if (this.availableActions.find(action => action === 'NEXT')) {
            let isValid = true;
            const inputFields = this.template.querySelectorAll('lightning-input-field');
            if (inputFields) {
                inputFields.forEach(field => {
                    if (field.required && !field.value) {
                        this.generalConsent = {};
                        isValid = false;
                        return;
                    }
                    this.generalConsent[field.fieldName] = field.value;
                });
            } else {
                return;
            }

            if (isValid) {
                this.dispatchEvent(new FlowNavigationNextEvent());
            }
        }
    }
}