import { LightningElement, track, api, wire } from 'lwc';
import getIntegrationSettings from '@salesforce/apex/ExternalLinksController.getIntegrationSettings';
import getClientGlobalId from '@salesforce/apex/ExternalLinksController.getClientGlobalId';
import getObjectApiName from '@salesforce/apex/ExternalLinksController.getObjectApiName';
import LogoImg from '@salesforce/resourceUrl/LogoImg';

export default class ExternalLinks extends LightningElement {
	@api objectApiName;
	@api recordId;

	@wire(getClientGlobalId, { accountOrTaskOrOpportunityId: '$recordId' })
	clientGlobalIdResult;

	@wire(getIntegrationSettings)
	integrationSettings;

	@track showModal = false;

	nel = LogoImg + '/LogoImg/NEL_logo.PNG';
	zeus = LogoImg + '/LogoImg/ZEUS_logo.PNG';

	get baseUrls() {
		return this.integrationSettings.data;
	}
	get clientGlobalId() {
		return this.clientGlobalIdResult.data;
	}

	get hasClientContext() {
		return !!this.clientGlobalIdResult.data;
	}

	get isOnAccount() {
		return this.hasClientContext && this.objectApiName === 'Account';
	}

	connectedCallback() {
		if (!this.objectApiName && this.recordId) {
			getObjectApiName({ recordId: this.recordId }).then(apiName => (this.objectApiName = apiName));
		}
	}

	handleOpenModal(event) {
		this.showModal = true;
	}

	handleCloseModal(event) {
		this.showModal = false;
	}

	handleClickNEL(e) {
		window.open(this.baseUrls.NELBaseUrl__c, '_blank');
	}
	handleClickStavebniSporeni(e) {
		if (this.clientGlobalId) {
			window.open(
				this.baseUrls.NELBaseUrl__c + '/group/nel/sjednani-esporeni?clientId=' + this.clientGlobalId,
				'_blank'
			);
		} else {
			window.open(this.baseUrls.NELBaseUrl__c + '/group/nel/sjednani-esporeni', '_blank');
		}
	}
	handleClickEUver(e) {
		window.open(this.baseUrls.NELBaseUrl__c + '/group/nel/sjednani-euveru?&createNew=1', '_blank');
	}
	handleClickEPrescore(e) {
		window.open(this.baseUrls.NELBaseUrl__c + '/group/nel/sjednani-eprescore?&createNew=1', '_blank');
	}
	handleClickBeznyUcet(e) {
		if (this.clientGlobalId) {
			window.open(
				this.baseUrls.NELBaseUrl__c + '/group/nel/sjednani-csob-bu?clientId=' + this.clientGlobalId,
				'_blank'
			);
		} else {
			window.open(this.baseUrls.NELBaseUrl__c + '/group/nel/sjednani-csob-bu', '_blank');
		}
	}
	handleClickZeus(e) {
		window.open(
			this.baseUrls.CasselBaseUrl__c +
				'/cas/login?domain=cmss&service=' +
				this.baseUrls.ZeusBaseUrl__c +
				'/zeus-rest/redirect',
			'_blank'
		);
	}
	handleClickCsobPenze(e) {
		window.open('https://csob-penze.cz/distribuce', '_blank');
	}
	handleClickCsobPlusKonto(e) {
		window.open('https://www.csobpluskonto.cz/big-lead?partner=true&cmss=true', '_blank');
	}
	handleClickCsobPremium(e) {
		window.open('https://www.csobpremium.cz/portal/nezarazene/referovani-premium-klientu-z-cmss', '_blank');
	}
	handleClickOsobniUdaje(e) {
		window.open(
			this.baseUrls.NELBaseUrl__c + '/group/nel/detail-klienta?clientId=' + this.clientGlobalId,
			'_blank'
		);
	}
	handleClickKlientskaZona(e) {
		window.open(
			this.baseUrls.NELBaseUrl__c + '/group/nel/detail-klienta?clientId=' + this.clientGlobalId,
			'_blank'
		);
	}
	handleClickAxigen(e) {
		window.open('https://axigen.cmss-oz.cz', '_blank');
	}
	handleClickExpo(e) {
		window.open('https://expoplus.csobstavebni.cz/', '_blank');
	}
	handleClickOZCSOBStavebni(e) {
		window.open('https://oz.csobstavebni.cz/', '_blank');
	}
	handleClickINVOZNavod(e) {
		window.open('https://itweboz.csobstavebni.cz/knowledge-base-2/help24003-navod-na-instalaci-invozu/', '_blank');
	}
	handleClickNahlizeniDoKatastru(e) {
		window.open('https://nahlizenidokn.cuzk.cz/', '_blank');
	}
	handleClickVzdelavani(e) {
		window.open('https://cmssext.edoceo.cz/edng', '_blank');
	}
	handleClickAdministrace(e) {
		window.open('https://oz.csobstavebni.cz/login/', '_blank');
	}
	handleClickInSign(e) {
		window.open('https://insign.cmss.is2.cloud/anmelden', '_blank');
	}
	handleClickKontakty(e) {
		window.open('https://itweboz.csobstavebni.cz/transfer/NEL/Kontakty%204_2021%20CSOBS.htm', '_blank');
	}
	handleClickNovaModelovaHhypoteka(e) {
		window.open('https://portal.hypotecnibanka.cz/informatorium/login', '_blank');
	}
	handleClickSpotrebitelskeUveryCSOB(e) {
		window.open('https://www.csob.cz/portal/n/pujcky-pro-treti-strany?partnerNM=CMSS', '_blank');
	}
	handleClickDoporuceniKlientaNaPobockuCSOB(e) {
		window.open('https://www.csob.cz/portal/n/referovani-cmss/pobocka-csob', '_blank');
	}
	handleClickITWeb(e) {
		window.open('https://itweboz.csobstavebni.cz/', '_blank');
	}
	handleClickMobilniKalkulacka(e) {
		window.open('https://kalkulacka.csobstavebni.cz/', '_blank');
	}
	handleClickUloziste(e) {
		window.open('https://csobstavebni.cz/uloziste', '_blank');
	}
	handleClickO2Family(e) {
		window.open('https://www.o2family.cz/csob-stavebni/', '_blank');
	}
	handleClickEshop(e) {
		window.open('https://eshop.csobstavebni.cz/', '_blank');
	}
	handleClickINVOZInstalace(e) {
		window.open('https://itweboz.csobstavebni.cz/knowledge-base-2/help24002/', '_blank');
	}
	handleClickModel8(e) {
		window.open('https://model.csobstavebni.cz/CMSSModel/login.htm', '_blank');
	}
	handleClickVernostniProgram(e) {
		window.open('http://www.najdetesevevlastnim.cz/', '_blank');
	}
}
