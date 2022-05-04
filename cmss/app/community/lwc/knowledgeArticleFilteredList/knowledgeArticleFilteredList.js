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
					typeAttributes: { label: { fieldName: 'Title' }, target: '_self' }
				},
				{
					label: this.fieldData.cmssarticlenumber__c,
					fieldName: 'CMSSArticleNumber__c',
					type: 'text',
					sortable: false
				},
				{ label: this.fieldData.author__c, fieldName: 'Author__c', type: 'text', sortable: false },
				{ label: this.fieldData.validfrom__c, fieldName: 'ValidFrom__c', type: 'date', sortable: false },
				{ label: this.fieldData.validto__c, fieldName: 'ValidTo__c', type: 'date', sortable: false },
				{ label: this.fieldData.priority__c, fieldName: 'Priority__c', type: 'text', sortable: false },
				{
					label: this.fieldData.currentlyvalid__c,
					fieldName: 'CurrentlyValid__c',
					type: 'boolean',
					sortable: false
				},
				{
					label: this.fieldData.lastpublisheddate,
					fieldName: 'LastPublishedDate',
					type: 'date',
					sortable: false
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
