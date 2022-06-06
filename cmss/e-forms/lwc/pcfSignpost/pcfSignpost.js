/**
 * Created by lukas.krbec on 03.06.2022.
 */
import { LightningElement, api } from 'lwc';
import {NavigationMixin} from "lightning/navigation";
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import quickActionStyle from "@salesforce/resourceUrl/customQuickActionStyle";
import { loadStyle } from "lightning/platformResourceLoader";
import { CloseActionScreenEvent } from "lightning/actions";

import getRelatedMigrationProcesses from '@salesforce/apex/PcfSignpostController.getRelatedMigrationProcesses';

import Header from '@salesforce/label/c.SignpostHeader';
import MissingProcessesLabel from '@salesforce/label/c.MissingProcessesLabel';
import MissingProcessesText from '@salesforce/label/c.MissingProcessesText';


export default class pcfSignpost extends NavigationMixin(LightningElement) {
        @api recId;
        loaded;
        processes;
        labels = {
            missingProcessesLabel : MissingProcessesLabel,
            missingProcessesText : MissingProcessesText,
            header : Header,
        };

        toastVariant = {
                    ERR: 'error',
                    WAR: 'warning',
        };

        connectedCallback() {
            loadStyle(this, quickActionStyle);
            console.log('connect');
            getRelatedMigrationProcesses({recordId: this.recId})
                .then( data => {
                    this.processes = data;
                    if(data.length < 1){
                        this.showToast(this.labels.missingProcessesLabel,this.labels.missingProcessesText,this.toastVariant.WAR);
                    }
                    this.loaded = true;
                }).catch(error => {
                    console.log(error);
                    this.showToast(error.body.message,error.body.stackTrace,this.toastVariant.ERR);
                }).finally(() => {
                });
        }



        handleChooseMigration(evt){
            const name = evt.currentTarget.name;
            let recId = `${this.recId}`;
            let migrationProcess = name;
            let migrationLabel = evt.currentTarget.label;
            let label = name;
            this.navigateToMigrationWrapper(recId,migrationProcess,label,migrationLabel);
        }

        navigateToMigrationWrapper(recId,migrationProcess,errorLabel,migrationLabel) {
            this[NavigationMixin.Navigate]({
                type: 'standard__component',
                attributes: {
                    componentName: 'c__migrationPremiumWrapper'
                },
                state: {
                    c__migrationProcess : migrationProcess,
                    c__migrationLabel : migrationLabel,
                    c__recId : recId,
                }
            });
        }

        showToast(title, message, variant) {
                const event = new ShowToastEvent({
                    title: title,
                    variant: variant,
                    message: message,
                    mode:'sticky',
                });
                this.dispatchEvent(event);
            }
}