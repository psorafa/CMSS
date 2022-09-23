import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import checkAgentCPU from "@salesforce/apex/AgentCPUCheck.checkAgentCPU";
import save from '@salesforce/label/c.Save';
import cancel from '@salesforce/label/c.Cancel';
import errorMessage from '@salesforce/label/c.Error';
import recordUpdated from '@salesforce/label/c.RecordUpdated';
import errorMessageNoUser from '@salesforce/label/c.NoUserWithThisCPUFound';

export default class ConsentEditInput extends LightningElement {
  @api recordId;
  isSaving = false;
  labels = {
    save,
    cancel,
    errorMessageNoUser,
  };
  agentCPU = "";
  agentCPUError = false;

  handleValueChange(event) {
    const inputFields = this.template.querySelectorAll(
      '[data-isconsenttype="true"]'
    );
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
            spanElement.className = "";
            this.agentCPUError = false;
          } else {
            spanElement.className = "slds-has-error";
            this.agentCPUError = true;
          }
        })
        .catch((error) => {
          this.handleErrors(error);
        });
    }
  }

  handleSuccess(event) {
    this.fireToast("success", recordUpdated);
    this.toggleSpinner();
    this.handleClose();
  }

  handleSubmit(event) {
    event.preventDefault();

    if (!this.agentCPUError) {
      this.toggleSpinner();

      let isValid = true;
      const inputFields = this.template.querySelectorAll(
        "lightning-input-field"
      );
      if (inputFields) {
        inputFields.forEach((field) => {
          if (field.required && !field.value) {
            isValid = false;
            field.reportValidity();
          }
        });
      } else {
        return;
      }

      if (isValid) {
        this.template.querySelector('lightning-record-edit-form').submit(event.detail.fields);
      } else {
        this.toggleSpinner();
      }
    }
  }

  handleClose(event) {
    window.history.back();
  }

  handleErrors(error) {
    console.log(JSON.stringify(error));
    this.fireToast("error", errorMessage);
  }

  toggleSpinner() {
    this.isSaving = !this.isSaving;
  }

  fireToast(variant, title, message) {
    const evt = new ShowToastEvent({
      variant: variant,
      title: title,
      message: message,
    });
    this.dispatchEvent(evt);
  }
}