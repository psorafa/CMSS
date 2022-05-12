import { LightningElement, track, wire, api } from 'lwc';

import { NavigationMixin } from 'lightning/navigation';
import KnowledgeFieldLabels from '@salesforce/apex/KnowledgeArticlesListController.getKnowledgeLabels';
import KnowledgeArticles from '@salesforce/apex/KnowledgeArticlesListController.getKnowledgeArticles';

export default class KnowledgeArticleFilteredList extends NavigationMixin(LightningElement) {
    @api topicId;
    @api recordTypeName;
    @api arcticlesType;

    @track fieldData;
    @track error;
    @track columns;

    @track article;
    @track articleList = [];    

    @wire(KnowledgeFieldLabels)
    wiredLabels({error, data}) {
        if (data) {
            this.fieldData = data;
            this.columns = [
                { label: this.fieldData.cmssarticlenumber__c, fieldName: 'url', type: 'url', sortable: true, typeAttributes: {label: { fieldName: 'CMSSArticleNumber__c' }, target: '_self'}},
                { label: this.fieldData.title, fieldName: 'Title', type: 'text', sortable: true},
                { label: this.fieldData.author__c, fieldName: 'Author__c', type: 'text', sortable: true},
                { label: this.fieldData.validfrom__c, fieldName: 'ValidFrom__c', type: 'date', sortable: true},
                { label: this.fieldData.validto__c, fieldName: 'ValidTo__c', type: 'date', sortable: true},
                { label: this.fieldData.priority__c, fieldName: 'Priority__c', type: 'text', sortable: true},
                { label: this.fieldData.currentlyvalid__c, fieldName: 'CurrentlyValid__c', type: 'text', sortable: true},
                { label: this.fieldData.lastpublisheddate, fieldName: 'LastPublishedDate', type: 'date', sortable: true}
            ];
        } else {
            this.error = JSON.stringify(error);
        }        
    }
    
    @wire(KnowledgeArticles, {topicId : '$topicId', recordTypeName : '$recordTypeName', arcticlesType : '$arcticlesType'})
    wiredArticles({error, data}) {
        if (data) {

            this.articleList = [];
            for (let article of data) {
                let myArticle = {};


                // Get article url
                this.KnowledgePageRef = {
                    type: "standard__recordPage",
                    attributes: {
                        "recordId": article.Id,
                        "objectApiName": "Knowledge__kav",
                        "actionName": "view"
                    }
                };

                this[NavigationMixin.GenerateUrl](this.KnowledgePageRef)
                    .then(articleUrl => {
                        myArticle = {...article};
                        myArticle.url = articleUrl;
                        this.articleList.push(myArticle);
                        console.log(JSON.stringify(myArticle))
                        console.log(JSON.stringify(this.articleList));
                    });
            }

            this.error = undefined;
        }
        if (error) {
            this.error = JSON.stringify(error);
            this.articleList = undefined;
        }
        console.log(JSON.stringify(this.articleList));
    } 

}