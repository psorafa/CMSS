import { LightningElement, track, wire, api } from 'lwc';

import Documents from '@salesforce/apex/DocumentsListController.getDocuments';
import Labels from '@salesforce/apex/DocumentsListController.getLabels';

export default class ContentDocumentFilteredList extends LightningElement {
    sfdcBaseURL;

    @api recordId;
    @api documentType;

    @track fieldData;
    @track error;
    @track columns;

    @track document;
    @track documentList = [];    

    renderedCallback() {
        this.sfdcBaseURL = window.location.origin;
    }

    @wire(Labels)
    wiredLabels({error, data}) {
        if (data) {
            this.fieldData = data;
            this.columns = [
                { label: this.fieldData.title, fieldName: 'url', type: 'url', sortable: false, typeAttributes: {label: { fieldName: 'Title' }, target: '_self'}},
                { label: this.fieldData.author__c, fieldName: 'Author__c', type: 'text', sortable: false},
                { label: this.fieldData.validfrom__c, fieldName: 'ValidFrom__c', type: 'date', sortable: false},
                { label: this.fieldData.validto__c, fieldName: 'ValidTo__c', type: 'date', sortable: false},
                { label: this.fieldData.priority__c, fieldName: 'Priority__c', type: 'text', sortable: false},
                { label: this.fieldData.currentlyvalid__c, fieldName: 'CurrentlyValid__c', type: 'boolean', sortable: false},
                { label: this.fieldData.lastmodifieddate, fieldName: 'LastModifiedDate', type: 'date', sortable: false},
                { label: this.fieldData.filetype, fieldName: 'FileType', type: 'text', sortable: false}
            ];
        } else {
            this.error = JSON.stringify(error);
        }        
    }
    
    @wire(Documents, {topicId : '$recordId', documentType : '$documentType'})
    wiredDocuments({error, data}) {
        if (data) {

            this.docList = [];
            for (let document of data) {
                let lDocument = {};
                lDocument = {...document};
                lDocument.url = this.sfdcBaseURL + "/fenixdocs/s/contentdocument/" + document.ContentDocumentId;
                this.documentList.push(lDocument);
                this.documentList = [...this.documentList];                        
                console.log(JSON.stringify(lDocument));
                console.log(JSON.stringify(this.documentList));
            }

            this.error = undefined;
        }
        if (error) {
            this.error = JSON.stringify(error);
            this.documentList = undefined;
        }
        console.log(JSON.stringify(this.documentList));
    } 

}