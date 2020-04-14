/**
 * Created by a.olexova on 4/8/2020.
 */

/**
 * @author aolexova
 * @description method to get a consent linked to the account with the ID from @param accountId
 *     returns the latest created consent, although there should never be more than 1 consent per client
 */
public with sharing class ConsentIconsController {
	@AuraEnabled(Cacheable=true)
	public static Consent__c findConsent(String accountId) {
		if (String.isNotBlank(accountId)) {
			List<Consent__c> consents = [
				SELECT
					Id,
					Name,
					GeneralConsent__c,
					GeneralConsentVersion__c,
					Account__c,
					EmailConsent__c,
					EntityConsent__c,
					SMSConsent__c,
					PortalConsent__c,
					PhoneConsent__c,
					PostConsent__c
				FROM Consent__c
				WHERE Account__c = :accountId
				ORDER BY CreatedDate DESC
				LIMIT 1
			];
			if (!consents.isEmpty()) {
				return consents.get(0);
			}
		}
		return null;
	}
}
