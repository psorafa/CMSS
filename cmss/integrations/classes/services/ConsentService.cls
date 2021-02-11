public with sharing class ConsentService {

	private static final List<String> CHANNEL_FIELD_NAMES = new List<String>{
		'EmailConsent__c', 'PhoneConsent__c', 'PortalConsent__c', 'PostConsent__c', 'SMSConsent__c'
	};

	public static void processChannelConsent(List<Consent__c> newConsents, Map<Id, Consent__c> oldIdsToConsents) {
		if (FeatureManagement.checkPermission('Bypass_AQ_Messaging')) {
			return;
		}
		List<List<ConsentDataTypesService.EnableChannelConsentRequestBodyType>> listOfEnableChannelRequestLists =
			new List<List<ConsentDataTypesService.EnableChannelConsentRequestBodyType>>{
				new List<ConsentDataTypesService.EnableChannelConsentRequestBodyType>(),
				new List<ConsentDataTypesService.EnableChannelConsentRequestBodyType>(),
				new List<ConsentDataTypesService.EnableChannelConsentRequestBodyType>(),
				new List<ConsentDataTypesService.EnableChannelConsentRequestBodyType>()
			};
		List<List<ConsentDataTypesService.DisableChannelConsentRequestBodyType>> listOfDisableChannelRequestLists =
			new List<List<ConsentDataTypesService.DisableChannelConsentRequestBodyType>>{
				new List<ConsentDataTypesService.DisableChannelConsentRequestBodyType>(),
				new List<ConsentDataTypesService.DisableChannelConsentRequestBodyType>(),
				new List<ConsentDataTypesService.DisableChannelConsentRequestBodyType>(),
				new List<ConsentDataTypesService.DisableChannelConsentRequestBodyType>()
			};

		Map<String, String> fieldNamesToConsentChannelIds = setUpFieldNamesToConsentChannelIds();
		Set<Id> accountIds = new Set<Id>();
		for (Consent__c c : newConsents) {
			Validation.requireAttribute(c.Account__c, 'Account__c');
			accountIds.add(c.Account__c);
		}
		Map<Id, Account> idsToAccounts = setUpIdsToAccounts(accountIds);
		categorizeConsentsToLists(
			newConsents,
			oldIdsToConsents,
			fieldNamesToConsentChannelIds,
			idsToAccounts,
			listOfEnableChannelRequestLists,
			listOfDisableChannelRequestLists
		);

		for (Integer i = 0; i < 4; i++) {
			if (listOfEnableChannelRequestLists[i].size() > 0 || listOfDisableChannelRequestLists[i].size() > 0) {
				makeChannelConsentCallout(
					JSON.serialize(listOfEnableChannelRequestLists[i]), JSON.serialize(listOfDisableChannelRequestLists[i])
				);
			}
		}
		Set<Account> accountsToUpdate = new Set<Account>();
		for (Consent__c consent : newConsents) {
			accountsToUpdate.add(new Account(
				Id = consent.Account__c,
				ConsentManualChange__c = Date.today()
			));
		}
		update new List<Account>(accountsToUpdate);
	}

	public static void processInternalConsent(List<InternalConsent__c> newConsents, Map<Id, InternalConsent__c> oldIdsToConsents) {
		if (FeatureManagement.checkPermission('Bypass_AQ_Messaging')) {
			return;
		}
		List<List<ConsentDataTypesService.EnableInternalConsentRequestBodyType>> listOfEnableConsentRequestLists =
			new List<List<ConsentDataTypesService.EnableInternalConsentRequestBodyType>>{
				new List<ConsentDataTypesService.EnableInternalConsentRequestBodyType>(),
				new List<ConsentDataTypesService.EnableInternalConsentRequestBodyType>(),
				new List<ConsentDataTypesService.EnableInternalConsentRequestBodyType>(),
				new List<ConsentDataTypesService.EnableInternalConsentRequestBodyType>()
			};
		List<List<ConsentDataTypesService.DisableInternalConsentRequestBodyType>> listOfDisableConsentRequestLists =
			new List<List<ConsentDataTypesService.DisableInternalConsentRequestBodyType>>{
				new List<ConsentDataTypesService.DisableInternalConsentRequestBodyType>(),
				new List<ConsentDataTypesService.DisableInternalConsentRequestBodyType>(),
				new List<ConsentDataTypesService.DisableInternalConsentRequestBodyType>(),
				new List<ConsentDataTypesService.DisableInternalConsentRequestBodyType>()
			};

		Set<Id> accountIds = new Set<Id>();
		for (InternalConsent__c c : newConsents) {
			accountIds.add(c.Account__c);
		}
		Map<Id, Account> idsToAccounts = setUpIdsToAccounts(accountIds);

		for (Integer i = 0; i < newConsents.size(); i++) {
			InternalConsent__c oldConsent = oldIdsToConsents.get(newConsents[i].Id);

			if (newConsents[i].InternalConsentValue__c != oldConsent.InternalConsentValue__c && newConsents[i].InternalConsentValue__c == '1') {
				Validation.requireAttribute(newConsents[i].InternalConsentType__c, 'InternalConsentType__c');
				listOfEnableConsentRequestLists[i / 50].add(getEnableInternalConsentWSDefinition(newConsents[i], idsToAccounts.get(newConsents[i].Account__c)));
			} else if (newConsents[i].InternalConsentValue__c != oldConsent.InternalConsentValue__c && newConsents[i].InternalConsentValue__c == '2') {
				Validation.requireAttribute(newConsents[i].ExternalId__c, 'ExternalId__c');
				listOfDisableConsentRequestLists[i / 50].add(getDisableInternalConsentWSDefinition(newConsents[i]));
			}
		}

		for (Integer i = 0; i < 4; i++) {
			if (listOfEnableConsentRequestLists[i].size() > 0 || listOfDisableConsentRequestLists[i].size() > 0) {
				makeInternalConsentCallout(
					JSON.serialize(listOfEnableConsentRequestLists[i]), JSON.serialize(listOfDisableConsentRequestLists[i])
				);
			}
		}
		Set<Account> accountsToUpdate = new Set<Account>();
		for (InternalConsent__c consent : newConsents) {
			accountsToUpdate.add(new Account(
				Id = consent.Account__c,
				ConsentManualChange__c = Date.today()
			));
		}
		update new List<Account>(accountsToUpdate);
	}

	private static Map<String, String> setUpFieldNamesToConsentChannelIds() {
		Map<String, String> fieldNamesToConsentChannelIds = new Map<String, String>();
		ConsentChannelIdsMapping__mdt[] consentChannelIdsMapping = [
			SELECT FieldName__c, ConsentChannelId__c
			FROM ConsentChannelIdsMapping__mdt
		];
		for (ConsentChannelIdsMapping__mdt ccim : consentChannelIdsMapping) {
			fieldNamesToConsentChannelIds.put(ccim.FieldName__c, ccim.ConsentChannelId__c);
		}

		return fieldNamesToConsentChannelIds;
	}

	private static Map<Id, Account> setUpIdsToAccounts(Set<Id> accountIds) {
		Map<Id, Account> idsToAccounts = new Map<Id, Account>([
			SELECT GlobalId__c
			FROM Account
			WHERE Id IN :accountIds
		]);

		return idsToAccounts;
	}

	private static void categorizeConsentsToLists(
		List<SObject> newConsents,
		Map<Id, SObject> oldIdsToConsents,
		Map<String, String> fieldNamesToConsentChannelIds,
		Map<Id, Account> idsToAccounts,
		List<List<ConsentDataTypesService.EnableChannelConsentRequestBodyType>> listOfEnableChannelRequestLists,
		List<List<ConsentDataTypesService.DisableChannelConsentRequestBodyType>> listOfDisableChannelRequestLists) {

		if (oldIdsToConsents != null) {
			for (Integer i = 0; i < newConsents.size(); i++) {
				SObject oldConsent = oldIdsToConsents.get((Id) newConsents[i].get('Id'));
				Account acc = validateConsents(i, newConsents, idsToAccounts);

				for (String fieldName : CHANNEL_FIELD_NAMES) {
					String consentChannelId = fieldNamesToConsentChannelIds.get(fieldName);

					if (newConsents[i].get(fieldName) != oldConsent.get(fieldName) && newConsents[i].get(fieldName) == '1') {
						listOfEnableChannelRequestLists[i / 50].add(getEnableChannelWSDefinition((Consent__c) newConsents[i], consentChannelId, acc.GlobalId__c));
					} else if (newConsents[i].get(fieldName) != oldConsent.get(fieldName) && newConsents[i].get(fieldName) == '2') {
						listOfDisableChannelRequestLists[i / 50].add(getDisableChannelWSDefinition((Consent__c) newConsents[i], consentChannelId, acc.GlobalId__c));
					}
				}
			}
		} else {
			for (Integer i = 0; i < newConsents.size(); i++) {
				Account acc = validateConsents(i, newConsents, idsToAccounts);

				for (String fieldName : CHANNEL_FIELD_NAMES) {
					String consentChannelId = fieldNamesToConsentChannelIds.get(fieldName);

					if (newConsents[i].get(fieldName) == '1') {
						listOfEnableChannelRequestLists[i / 50].add(getEnableChannelWSDefinition((Consent__c) newConsents[i], consentChannelId, acc.GlobalId__c));
					} else if (newConsents[i].get(fieldName) == '2') {
						listOfDisableChannelRequestLists[i / 50].add(getDisableChannelWSDefinition((Consent__c) newConsents[i], consentChannelId, acc.GlobalId__c));
					}
				}
			}
		}
	}

	private static Account validateConsents(Integer i, List<SObject> newConsents, Map<Id, Account> idsToAccounts) {
		Validation.requireAttribute(newConsents[i].get('EntityConsent__c'), 'EntityConsent__c');
		Account acc = idsToAccounts.get((Id) newConsents[i].get('Account__c'));
		Validation.requireAttribute(acc, 'Account');
		Validation.requireAttribute(acc.GlobalId__c, 'GlobalId__c');
		return acc;
	}

	@Future(Callout=true)
	private static void makeChannelConsentCallout(String enableConsentRequestsJSON, String disableConsentRequestsJSON) {
		try {
			List<ConsentDataTypesService.EnableChannelConsentRequestBodyType> enableConsentRequests =
				(List<ConsentDataTypesService.EnableChannelConsentRequestBodyType>) JSON.deserialize(
					enableConsentRequestsJSON, List<ConsentDataTypesService.EnableChannelConsentRequestBodyType>.class
				);
			List<ConsentDataTypesService.DisableChannelConsentRequestBodyType> disableConsentRequests =
				(List<ConsentDataTypesService.DisableChannelConsentRequestBodyType>) JSON.deserialize(
					disableConsentRequestsJSON, List<ConsentDataTypesService.DisableChannelConsentRequestBodyType>.class
				);

			CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
			ConsentCalloutService.ConsentServicePort stub = new ConsentCalloutService.ConsentServicePort();
			for (ConsentDataTypesService.EnableChannelConsentRequestBodyType body : enableConsentRequests) {
				stub.enableChannelConsent_Http(header, body);
			}
			for (ConsentDataTypesService.DisableChannelConsentRequestBodyType body : disableConsentRequests) {
				stub.disableChannelConsent_Http(header, body);
			}
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	@Future(Callout=true)
	private static void makeInternalConsentCallout(String enableConsentRequestsJSON, String disableConsentRequestsJSON) {
		try {
			List<ConsentDataTypesService.EnableInternalConsentRequestBodyType> enableConsentRequests =
				(List<ConsentDataTypesService.EnableInternalConsentRequestBodyType>) JSON.deserialize(
					enableConsentRequestsJSON, List<ConsentDataTypesService.EnableInternalConsentRequestBodyType>.class
				);
			List<ConsentDataTypesService.DisableInternalConsentRequestBodyType> disableConsentRequests =
				(List<ConsentDataTypesService.DisableInternalConsentRequestBodyType>) JSON.deserialize(
					disableConsentRequestsJSON, List<ConsentDataTypesService.DisableInternalConsentRequestBodyType>.class
				);

			CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
			ConsentCalloutService.ConsentServicePort stub = new ConsentCalloutService.ConsentServicePort();
			for (ConsentDataTypesService.EnableInternalConsentRequestBodyType body : enableConsentRequests) {
				stub.enableInternalConsent_Http(header, body);
			}
			for (ConsentDataTypesService.DisableInternalConsentRequestBodyType body : disableConsentRequests) {
				stub.disableInternalConsent_Http(header, body);
			}
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	private static ConsentDataTypesService.EnableChannelConsentRequestBodyType getEnableChannelWSDefinition(Consent__c c, String consentChannelId, String clientId) {
		ConsentDataTypesService.EnableChannelConsentRequestBodyType body = new ConsentDataTypesService.EnableChannelConsentRequestBodyType();
		body.consentEntityId = c.EntityConsent__c;
		body.consentChannelId = consentChannelId;
		body.globalId = clientId;
		body.consentSourceId = '20';
		body.validFrom = Datetime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
		body.validFrom = body.validFrom.substring(0, body.validFrom.length() - 2) + ':00';
		body.agentCPU = c.AgentCPU__c;
		return body;
	}

	private static ConsentDataTypesService.DisableChannelConsentRequestBodyType getDisableChannelWSDefinition(Consent__c c, String consentChannelId, String clientId) {
		ConsentDataTypesService.DisableChannelConsentRequestBodyType body = new ConsentDataTypesService.DisableChannelConsentRequestBodyType();
		body.consentEntityId = c.EntityConsent__c;
		body.consentChannelId = consentChannelId;
		body.globalId = clientId;
		body.consentSourceId = '20';
		body.validFrom = Datetime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
		body.validFrom = body.validFrom.substring(0, body.validFrom.length() - 2) + ':00';
		body.agentCPU = c.AgentCPU__c;
		return body;
	}

	public static ConsentDataTypesService.EnableInternalConsentRequestBodyType getEnableInternalConsentWSDefinition(InternalConsent__c c, Account client) {
		ConsentDataTypesService.EnableInternalConsentRequestBodyType body = new ConsentDataTypesService.EnableInternalConsentRequestBodyType();
		if (client != null) {
			body.globalId = client.GlobalId__c;
		}
		body.consentKind = c.InternalConsentType__c;
		body.consentValidFrom = Datetime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
		body.consentValidFrom = body.consentValidFrom.substring(0, body.consentValidFrom.length() - 2) + ':00';
		body.consentSourceId = '20';
		body.consentProvidedBy = '1';
		return body;
	}

	private static ConsentDataTypesService.DisableInternalConsentRequestBodyType getDisableInternalConsentWSDefinition(InternalConsent__c c) {
		ConsentDataTypesService.DisableInternalConsentRequestBodyType body = new ConsentDataTypesService.DisableInternalConsentRequestBodyType();
		body.consentCrmGuid = c.ExternalId__c;
		body.consentSourceId = '20';
		body.consentProvidedById = '1';
		return body;
	}
}
