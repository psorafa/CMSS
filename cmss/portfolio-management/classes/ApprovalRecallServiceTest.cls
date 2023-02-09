@IsTest
private class ApprovalRecallServiceTest {
	@TestSetup
	static void makeData() {
		insert TestDataFactory.getNumericalSettings();
	}

	@IsTest
	static void recallApprovalsTest() {
		Test.setMock(HttpCalloutMock.class, new MailSOAPServiceHttpMock());
		insert TestDataFactory.getIntegrationSettings();
		Id userId = UserInfo.getUserId();
		Case testCase = TestDataFactory.getCase(
			new Case(
				OwnerId = userId,
				RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByDeveloperName()
					.get('PortfolioManagementChangeRequest')
					.getRecordTypeId(),
				NewPortfolioManager__c = userId,
				RegionalManager__c = userId,
				RegionalManagerAssistant__c = userId
			)
		);
		insert testCase;

		Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
		request.setObjectId(testCase.id);
		request.setProcessDefinitionNameOrId('Case_Approval');
		request.setSkipEntryCriteria(true);
		Approval.ProcessResult result = Approval.process(request);

		Test.startTest();
		System.assertEquals('Pending', result.getInstanceStatus());
		ApprovalRecallService.recallApprovals(new List<List<String>>{ new List<String>{ testCase.Id } });
		ProcessInstance processInstance = [
			SELECT Id, Status, TargetObject.type, TargetObject.Id, CompletedDate
			FROM ProcessInstance
			WHERE TargetObject.Id = :testCase.Id
		][0];
		System.assertEquals('Removed', processInstance.Status);
		Test.stopTest();
	}
}
