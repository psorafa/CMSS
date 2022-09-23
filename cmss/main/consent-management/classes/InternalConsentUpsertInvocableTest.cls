@isTest
public with sharing class InternalConsentUpsertInvocableTest {

	@testSetup
	static void testSetup() {
		Account acc = new Account(
			RecordTypeId = RecordTypeUtils.getRecordTypeIdByDeveloperName('PersonAccount', 'Account'),
			FirstName = 'Test',
			LastName = 'Test',
			Phone = '000000000',
			GlobalId__c = 'Test000001'
		);
		insert acc;
	}

	@isTest
	private static void testExecute() {
		List<InternalConsentUpsertInvocable.Request> requestWrapper = new List<InternalConsentUpsertInvocable.Request>();
		InternalConsentUpsertInvocable.Request request = new InternalConsentUpsertInvocable.Request();
		Id accId = [SELECT Id FROM Account LIMIT 1].Id;
		request.inputRecord = new InternalConsent__c();
		request.inputRecord.InternalConsentType__c = '1';
		request.inputRecord.Source__c = '1';
		request.inputRecord.InternalConsentValue__c = '1';
		request.inputRecord.ValidFrom__c = Date.today();
		request.inputRecord.ValidTo__c = Date.today();
		request.inputRecord.Account__c = accId;
		request.inputRecord.ExternalId__c = 'Test';
		requestWrapper.add(request);
		InternalConsentUpsertInvocable.execute(requestWrapper);
		requestWrapper[0].inputRecord.ValidTo__c = Date.today().addDays(3);
		InternalConsentUpsertInvocable.execute(requestWrapper);
		Integer lenOfInternalConsent = [SELECT Id FROM InternalConsent__c].size();
		System.assert(lenOfInternalConsent == 1, 'There must be only one consent as it is upserted based on ExternlId__c.');
	}
}