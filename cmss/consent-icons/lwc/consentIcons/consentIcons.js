/**
 * Created by a.olexova on 4/13/2020.
 */

import { LightningElement, api, track, wire } from 'lwc';
import consentIcons from '@salesforce/resourceUrl/ConsentIcons';
import getConsentForAccount from '@salesforce/apex/ConsentIconsController.getConsentForAccount';

import postCommunication from '@salesforce/label/c.PostCommunication';
import phoneCommunication from '@salesforce/label/c.PhoneCommunication';
import emailCommunication from '@salesforce/label/c.EmailCommunication';
import smsCommunication from '@salesforce/label/c.SmsCommunication';
import portalCommunication from '@salesforce/label/c.PortalCommunication';
import errorLabel from '@salesforce/label/c.Error';

export default class ConsentIcons extends LightningElement {
	@api recordId;
	foundConsent;
	@track errorMessage;
	@track showErrorMessage = false;
	@track label = {
		errorLabel,
		postCommunication,
		phoneCommunication,
		emailCommunication,
		smsCommunication,
		portalCommunication
	};

	//getting the consent of this account
	@wire(getConsentForAccount, { accountId: '$recordId' })
	consent({ error, data }) {
		if (data) {
			this.foundConsent = data;
		}
		if (error) {
			this.showErrorMessage = true;
			this.errorMessage = this.label.errorLabel + ': ' + error.body.message;
		}
	}

	@api
	get phoneIcon() {
		if (this.foundConsent && this.foundConsent.PhoneConsent__c === '1') {
			return consentIcons + '/phone_yes.png';
		}
		return consentIcons + '/phone_no.png';
	}

	@api
	get smsIcon() {
		if (this.foundConsent && this.foundConsent.SMSConsent__c === '1') {
			return consentIcons + '/sms_yes.png';
		}
		return consentIcons + '/sms_no.png';
	}

	@api
	get emailIcon() {
		if (this.foundConsent && this.foundConsent.EmailConsent__c === '1') {
			return consentIcons + '/email_yes.png';
		}
		return consentIcons + '/email_no.png';
	}

	@api
	get postIcon() {
		if (this.foundConsent && this.foundConsent.PostConsent__c === '1') {
			return consentIcons + '/post_yes.png';
		}
		return consentIcons + '/post_no.png';
	}

	@api
	get portalIcon() {
		if (this.foundConsent && this.foundConsent.PortalConsent__c === '1') {
			return consentIcons + '/portal_yes.png';
		}
		return consentIcons + '/portal_no.png';
	}
}
