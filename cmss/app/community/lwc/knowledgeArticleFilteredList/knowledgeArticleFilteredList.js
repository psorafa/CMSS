import { LightningElement, track, wire, api } from 'lwc';

import { NavigationMixin } from 'lightning/navigation';
import KnowledgeFieldLabels from '@salesforce/apex/KnowledgeArticlesListController.getKnowledgeLabels';
import KnowledgeArticles from '@salesforce/apex/KnowledgeArticlesListController.getKnowledgeArticles';

export default class KnowledgeArticleFilteredList extends NavigationMixin(LightningElement) {
	@api recordId;
	@api recordTypeName;
	@api arcticlesType;

	@track fieldData;
	@track error;
	@track columns;

	@track article;
	@track articleList = [];

	@wire(KnowledgeFieldLabels)
	wiredLabels({ error, data }) {
		if (data) {
			this.fieldData = data;
			this.columns = [
				{
					label: this.fieldData.title,
					fieldName: 'url',
					type: 'url',
					sortable: false,
					typeAttributes: { label: { fieldName: 'Title' }, target: '_self' }, 
					wrapText: true
				},
				{
					label: this.fieldData.cmssarticlenumber__c,
					fieldName: 'CMSSArticleNumber__c',
					type: 'text',
					sortable: false
				},
				{ label: this.fieldData.additionalquestionsanswers__c, fieldName: 'AdditionalQuestionsAnswers__c', type: 'text', sortable: false, wrapText: true },
				{ label: this.fieldData.validto__c, fieldName: 'ValidTo__c', type: 'date', sortable: false },
				{
					label: this.fieldData.currentlyvalid__c,
					fieldName: 'CurrentlyValid__c',
					type: 'boolean',
					sortable: false, 
					initialWidth: 50
				},
				{ 
					label: this.fieldData.type__c, 
					fieldName: 'Type__c', 
					type: 'text', 
					sortable: false,
					cellAttributes: {
						class: {
							fieldName: `format`
						},
					},
				}
					
			];
		} else {
			this.error = JSON.stringify(error);
		}
	}

	@wire(KnowledgeArticles, {
		topicId: '$recordId',
		recordTypeName: '$recordTypeName',
		arcticlesType: '$arcticlesType'
	})
	wiredArticles({ error, data }) {
		if (data) {
			for (let article of data) {
				let myArticle = {};

				// Get article url
				this.KnowledgePageRef = {
					type: 'standard__recordPage',
					attributes: {
						recordId: article.Id,
						objectApiName: 'Knowledge__kav',
						actionName: 'view'
					}
				};

				this[NavigationMixin.GenerateUrl](this.KnowledgePageRef).then((articleUrl) => {
					myArticle = { ...article };
					myArticle.url = articleUrl;
					myArticle.format = myArticle.Type__c == 'Info' ? 'slds-text-color_success' : 'slds-text-color_default';
					this.articleList.push(myArticle);
					this.articleList = [...this.articleList];
				});
			}

			this.error = undefined;
		}
		if (error) {
			this.error = JSON.stringify(error);
			this.articleList = undefined;
			console.log('ERROR::');
			console.log(JSON.stringify(error));
		}
	}
}