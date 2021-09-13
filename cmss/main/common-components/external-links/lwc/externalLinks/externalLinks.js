import { LightningElement, track, api, wire } from 'lwc';
import getIntegrationSettings from '@salesforce/apex/ExternalLinksController.getIntegrationSettings';
import getClientGlobalId from '@salesforce/apex/ExternalLinksController.getClientGlobalId';

export default class ExternalLinks extends LightningElement {

	@api recordId

	@wire(getClientGlobalId, { accountOrTaskOrOpportunityId: '$recordId' })
	clientGlobalIdResult

	@wire(getIntegrationSettings)
	integrationSettings

	@track showModal = false

	get baseUrls() {
	    return this.integrationSettings.data
	}
	get clientGlobalId() {
	    return this.clientGlobalIdResult.data
	}

	handleOpenModal(event) {
	    this.showModal = true
 	}

 	handleCloseModal(event) {
 	    this.showModal = false
	}

	handleClickStavebniSporeni(e) {
	    window.open(this.baseUrls.NELBaseUrl__c + '/group/nel/sjednani-esporeni?clientId=' + this.clientGlobalId, "_blank")
 	}
	handleClickEUver(e) {
	    window.open(this.baseUrls.NELBaseUrl__c + '/group/nel/sjednani-euveru?clientId=' + this.clientGlobalId, "_blank")
 	}
	handleClickEPrescore(e) {
	    window.open(this.baseUrls.NELBaseUrl__c + '/group/nel/sjednani-eprescore?clientId=' + this.clientGlobalId, "_blank")
 	}
	handleClickBeznyUcet(e) {
	    window.open(this.baseUrls.NELBaseUrl__c, "_blank")
 	}
	handleClickZeus(e) {
	    window.open(this.baseUrls.CasselBaseUrl__c + '/cas/login?domain=cmss&service=' + this.baseUrls.ZeusBaseUrl__c + '/zeus-rest/redirect;ZEUS;_blank', "_blank")
 	}
 	handleClickCsobPenze(e) {
 	    window.open('https://csob-penze.cz/distribuce', "_blank")
  	}
 	handleClickCsobPlusKonto(e) {
 	    window.open('https://www.csobpluskonto.cz/big-lead?partner=true&cmss=true', "_blank")
  	}
 	handleClickCsobPremium(e) {
 	    window.open('https://www.csobpremium.cz/portal/nezarazene/referovani-premium-klientu-z-cmss', "_blank")
  	}
  	handleClickOsobniUdaje(e) {
  	    window.open(this.baseUrls.NELBaseUrl__c + '/api/1.0.0/persons/clients/' + this.clientGlobalId + '?fullData=true', "_blank")
   	}
  	handleClickKlientskaZona(e) {
  	    window.open(this.baseUrls.NELBaseUrl__c + '/group/nel/detail-klienta?clientId=' + this.clientGlobalId, "_blank")
   	}
}