/**
 * Created by a.olexova on 4/13/2020.
 */

import { LightningElement, api, wire } from 'lwc';
import consentIcons from '@salesforce/resourceUrl/ConsentIcons';
import findConsent from '@salesforce/apex/ConsentIconsController.findConsent';

export default class ConsentIcons extends LightningElement {
	@api recordId;
	foundConsent;

	//getting the consent of this account
	@wire(findConsent, { accountId: '$recordId' })
	consent({ data }) {
		this.foundConsent = data;
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
