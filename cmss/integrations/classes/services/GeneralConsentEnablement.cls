public with sharing class GeneralConsentEnablement {

	@InvocableMethod
	public static Result[] enableGeneralConsents(Request[] requests) {
		try {
			Result[] results = new Result[]{
			};

			Set<Id> accountIds = new Set<Id>();
			accountIds.add(requests[0].accountId);
            if (String.isNotBlank(requests[0].substitutePersonId)) {
                accountIds.add(requests[0].substitutePersonId);
            }

			Map<Id, Account> idsToAccounts = new Map<Id, Account>([
				SELECT GlobalId__c
				FROM Account
				WHERE Id IN :accountIds
			]);

			Account client = idsToAccounts.get(requests[0].accountId);
			Validation.requireAttribute(client, 'Account');
			Validation.requireAttribute(client.GlobalId__c, 'GlobalId__c');
			Account substitutePerson;
            if (String.isNotBlank(requests[0].substitutePersonId)) {
                substitutePerson = idsToAccounts.get(requests[0].substitutePersonId);
            }

			CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
			ConsentCalloutService.ConsentServicePort stub = new ConsentCalloutService.ConsentServicePort();
			ConsentDataTypesService.EnableGeneralConsentRequestBodyType body = new ConsentDataTypesService.EnableGeneralConsentRequestBodyType();
			body.consentEntityId = requests[0].consentEntityId;
			body.consentVersionId = requests[0].consentVersionId;
			body.globalId = client.GlobalId__c;
			body.consentSourceId = '20';
			body.validFrom = Datetime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
			body.validFrom = body.validFrom.substring(0, body.validFrom.length() - 2) + ':00';
			body.agentCPU = requests[0].agentCPU;
			if (substitutePerson != null) {
				body.substitutePersonId = substitutePerson.GlobalId__c;
			}
			body.substituteRoleId = requests[0].substituteRoleId;
			ConsentDataTypesService.EnableGeneralConsentResponseBodyType response = stub.enableGeneralConsent_Http(header, body);
			if (response != null) {
				results.add(new Result(response.consentGuid));
			}

			return results;
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	public class Request {
		@InvocableVariable(Label='Consent Entity Id' Required=true)
		public String consentEntityId;

		@InvocableVariable(Label='Consent Version Id' Required=true)
		public String consentVersionId;

		@InvocableVariable(Label='Agent CPU' Required=false)
		public String agentCPU;

		@InvocableVariable(Label='Account Id' Required=true)
		public String accountId;

		@InvocableVariable(Label='Substitute Person Id' Required=false)
		public String substitutePersonId;

		@InvocableVariable(Label='Substitute Role Id' Required=false)
		public String substituteRoleId;
	}

	public class Result {
		public Result(String externalId) {
			this.externalId = externalId;
		}

		@InvocableVariable(Label='External Id' Required=true)
		public String externalId;
	}
}
