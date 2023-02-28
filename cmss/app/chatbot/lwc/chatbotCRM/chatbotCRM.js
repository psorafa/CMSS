import { LightningElement } from 'lwc';

export default class ChatbotCRM extends LightningElement {
	siteURL;

	connectedCallback() {
		this.siteURL = '/apex/chatbot';
	}
}
