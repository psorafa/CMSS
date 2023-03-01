import { LightningElement } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import ChatbotController from '@salesforce/resourceUrl/ChatbotController';
import ChatbotConfig from '@salesforce/resourceUrl/ChatbotConfig';
import ChatbotView from '@salesforce/resourceUrl/ChatbotView';

export default class ChatbotSite extends LightningElement {
	renderedCallback() {
		Promise.all([
			loadScript(this, ChatbotConfig),
			loadScript(this, ChatbotView),
			loadScript(this, ChatbotController)
		]).then(() => {
			console.info('Chatbot Loaded');
		});
	}
}