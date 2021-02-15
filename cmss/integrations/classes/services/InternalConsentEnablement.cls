public with sharing class InternalConsentEnablement {

	@InvocableMethod
	public static Result[] enableInternalConsents(Request[] requests) {
		try {
			Result[] results = new Result[]{
			};

			if (requests[0].consentValue != '1') {
				return null;
			}

			InternalConsent__c c = new InternalConsent__c(
				InternalConsentType__c = requests[0].consentType,
				InternalConsentValue__c = requests[0].consentValue,
				ValidFrom__c = requests[0].validFrom,
				ValidTo__c = requests[0].validTo,
				Source__c = requests[0].source,
				Account__c = requests[0].accountId
			);

			Account[] accounts = [
				SELECT GlobalId__c
				FROM Account
				WHERE Id = :requests[0].accountId
			];
			if (accounts.size() == 0) {
				return null;
			}

			CommonMessageService.RequestHeader header = new CommonMessageService.RequestHeader();
			ConsentCalloutService.ConsentServicePort stub = new ConsentCalloutService.ConsentServicePort();

			ConsentDataTypesService.EnableInternalConsentRequestBodyType body = ConsentService.getEnableInternalConsentWSDefinition(c, accounts[0]);
			ConsentDataTypesService.EnableInternalConsentResponseBodyType response = stub.enableInternalConsent_Http(header, body);
			if (response != null) {
				results.add(new Result(response.consentGuid));
			}
			Set<Account> accountsToUpdate = new Set<Account>();
			for (Request request : requests) {
				accountsToUpdate.add(new Account(
					Id = request.accountId,
					ConsentManualChange__c = Date.today()
				));
			}
			update new List<Account>(accountsToUpdate);
			return results;
		} catch (Exception e) {
			Logger.error('An unhandled exception thrown', e);
			return null;
		} finally {
			Logger.saveLogs();
		}
	}

	public class Request {
		@InvocableVariable(Label='Consent Type' Required=true)
		public String consentType;

		@InvocableVariable(Label='Consent Value' Required=true)
		public String consentValue;

		@InvocableVariable(Label='Valid From' Required=true)
		public Datetime validFrom;

		@InvocableVariable(Label='Valid To' Required=false)
		public Datetime validTo;

		@InvocableVariable(Label='Source' Required=true)
		public String source;

		@InvocableVariable(Label='Account Id' Required=true)
		public String accountId;
	}

	public class Result {
		public Result(String externalId) {
			this.externalId = externalId;
		}

		@InvocableVariable(Label='External Id' Required=true)
		public String externalId;
	}
}
