/**
 * Created by a.olexova on 4/8/2020.
 */

public with sharing class ConsentIconsController {
	/**
	 * @author andrea olexova
	 * @description method to get a consent linked to the account with the ID from @param accountId
	 *     returns the latest created consent, although there should never be more than 1 consent per client
	 */
	@AuraEnabled(Cacheable=true)
	public static Consent__c getConsentForAccount(Id accountId) {
		if (String.isNotBlank(accountId)) {
			try {
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
					WITH SECURITY_ENFORCED
					ORDER BY CreatedDate DESC
					LIMIT 1
				];
				if (!consents.isEmpty()) {
					return consents.get(0);
				}
			} catch (QueryException qException) {
				String message = qException.getTypeName() + ': ' + qException.getMessage();
				AuraHandledException auraException = new AuraHandledException(message);
				auraException.setMessage(message);
				throw auraException;
			}
		} else {
			String message = 'Missing parameter: accountId.';
			AuraHandledException auraException = new AuraHandledException(message);
			auraException.setMessage(message);
			throw auraException;
		}
		return new Consent__c();
	}
}
