@isTest
private class TaskServiceTest {
	@isTest
	static void recordTypeAssignment() {
		List<Task> taskList = new List<Task>();

		for (Integer i = 6; i < 9; i++) {
			Integer modNumber = Math.mod(i, 5);
			String modText = String.valueOf(modNumber);
			Task taskItem = new Task();
			taskItem.Subject = 'New Task' + i;
			taskItem.Type = modText;
			taskList.add(taskItem);
		}
		Test.startTest();
		insert taskList;
		Test.stopTest();

		List<Task> updatedTaskList = [
			SELECT Id, RecordTypeId, Type, RecordType.DeveloperName
			FROM Task
			WHERE Id = :taskList
		];

		List<TaskRecordTypeMapping__mdt> rtMappingList = [
			SELECT RecordTypeDeveloperName__c, TypeAPIName__c
			FROM TaskRecordTypeMapping__mdt
		];
		Map<String, String> metadataMap = new Map<String, String>();
		for (TaskRecordTypeMapping__mdt rtMappingItem : rtMappingList) {
			metadataMap.put(rtMappingItem.TypeAPIName__c, rtMappingItem.RecordTypeDeveloperName__c);
		}

		for (Task taskItemWithRecordType : updatedTaskList) {
			String taskTypeDevName = metadataMap.get(taskItemWithRecordType.Type);
			System.assertEquals(taskTypeDevName, taskItemWithRecordType.RecordType.DeveloperName);
		}
	}
	@isTest
	static void createTask() {
		User user = TestDataFactory.getUser(new User(CommissionAccountNr__c = 'CPU111'));
		insert user;
		Account account = TestDataFactory.getPersonAccount(new Account(GlobalId__c = 'G111'));
		insert account;
		Opportunity opp = TestDataFactory.getOpportunity();
		insert opp;


		SF_ActivityManagementSOAPService.ActivityType actType = new SF_ActivityManagementSOAPService.ActivityType();
		SOAPCommonTypes.CommonHeader header = new SOAPCommonTypes.CommonHeader();
		header.userId = '7200';
		header.messageId = null;
		header.timestamp = Datetime.now();
		header.correlationId = null;
		header.sourceSystem = '45';
		header.physicalSource = null;
		header.targetSystem = 'ESB';
		header.conversationIdValue = null;
		header.conversationIdName = null;
		actType.type = '1';
		actType.describe = null;
		actType.direction = '0';
		actType.oz = 'internal attendee';
		actType.phoneNumber = '123456789';
		actType.dueDate = Date.today();
		actType.stateCode = '0';
		actType.statusCode = '0';
		actType.name = 'subject';
		actType.validTo = Date.today();
		actType.result = '1';
		actType.statusManagerCPU = 'CPU111';
		actType.modifyByOzCPU = 'updated by';
		actType.authorCPU = 'author';
		actType.whatId = (String) account.Id;
		actType.email = 'testemail@test.com';
		actType.isVisibleForNEL = true;
		actType.opportunityId = (String) opp.ExternalId__c;
		actType.location = 'location';
		actType.plannedToDate = Datetime.now();
		actType.webLink = 'webLink';
		actType.letterCity = 'letterCity';
		actType.letterHouseNr = 'letterHouseNr';
		actType.letterPostcode = 'letterPostcode';
		actType.letterStreet = 'letterStreet';
		actType.isKZMessage = false;
		actType.isRead = true;
		actType.clientGlobalId = 'G111';
		actType.validFrom = Date.today();

		Test.startTest();
		TaskService.createTask(actType, header);
		Test.stopTest();
		Task queriedTask = [
			SELECT
				Id, Type, Description, CallDirectionCode__c, Source__c, InternalAttendee__c, Phone__c, ActivityDate, Status,
				Subject, ValidTo__c, Result__c, OwnerId, UpdatedBy__c, Author__c, WhatId,
				Email__c, IsVisibleForNel__c, OpportunityExternalId__c, Location__c, PlannedToDate__c, WebLink__c, City__c,
				HouseNumber__c, PostCode__c, Street__c, IsKZMessage__c, IsRead__c, WhoId, ValidFrom__c
			FROM Task
		];
		Account queriedAccount = [SELECT PersonContactId FROM Account WHERE Id = :account.Id];
		System.assertEquals(queriedTask.Source__c, header.sourceSystem);
		System.assertEquals(queriedTask.Type, actType.type);
		System.assertEquals(queriedTask.Description, actType.describe);
		System.assertEquals(queriedTask.CallDirectionCode__c, actType.direction);
		System.assertEquals(queriedTask.InternalAttendee__c, actType.oz);
		System.assertEquals(queriedTask.Phone__c, actType.phoneNumber);
		System.assertEquals(queriedTask.ActivityDate, actType.dueDate);
		System.assertEquals(queriedTask.Status, actType.stateCode);
		System.assertEquals(queriedTask.Subject, actType.name);
		System.assertEquals(queriedTask.ValidTo__c, actType.validTo);
		System.assertEquals(queriedTask.Result__c, actType.result);
		System.assertEquals(queriedTask.OwnerId, user.Id);
		System.assertEquals(queriedTask.UpdatedBy__c, actType.modifyByOzCPU);
		System.assertEquals(queriedTask.Author__c, actType.authorCPU);
		System.assertEquals(queriedTask.WhatId, actType.whatId);
		System.assertEquals(queriedTask.Email__c, actType.email);
		System.assertEquals(queriedTask.IsVisibleForNel__c, actType.isVisibleForNEL);
		System.assertEquals(queriedTask.OpportunityExternalId__c, actType.opportunityId);
		System.assertEquals(queriedTask.Location__c, actType.location);
		System.assertEquals(queriedTask.PlannedToDate__c, actType.plannedToDate);
		System.assertEquals(queriedTask.WebLink__c, actType.webLink);
		System.assertEquals(queriedTask.City__c, actType.letterCity);
		System.assertEquals(queriedTask.HouseNumber__c, actType.letterHouseNr);
		System.assertEquals(queriedTask.PostCode__c, actType.letterPostcode);
		System.assertEquals(queriedTask.Street__c, actType.letterStreet);
		System.assertEquals(queriedTask.IsKZMessage__c, actType.isKZMessage);
		System.assertEquals(queriedTask.IsRead__c, actType.isRead);
		System.assertEquals(queriedTask.WhoId, queriedAccount.PersonContactId);
		System.assertEquals(queriedTask.ValidFrom__c, actType.validFrom);

	}
	@isTest
	static void updateTask() {
		User user = TestDataFactory.getUser(new User(CommissionAccountNr__c = 'CPU111'));
		insert user;
		Account account = TestDataFactory.getPersonAccount(new Account(GlobalId__c = 'G111'));
		insert account;
		Task task = TestDataFactory.getTask(new Task());
		insert task;
		Opportunity opp = TestDataFactory.getOpportunity();
		insert opp;


		SF_ActivityManagementSOAPService.ActivityType actType = new SF_ActivityManagementSOAPService.ActivityType();
		SOAPCommonTypes.CommonHeader header = new SOAPCommonTypes.CommonHeader();
		header.userId = '7200';
		header.messageId = null;
		header.timestamp = Datetime.now();
		header.correlationId = null;
		header.sourceSystem = '45';
		header.physicalSource = null;
		header.targetSystem = 'ESB';
		header.conversationIdValue = null;
		header.conversationIdName = null;
		actType.id = task.ExternalId__c;
		actType.type = '1';
		actType.describe = null;
		actType.direction = '0';
		actType.oz = 'internal attendee';
		actType.phoneNumber = '123456789';
		actType.dueDate = Date.today();
		actType.stateCode = '0';
		actType.statusCode = '0';
		actType.name = 'subject1';
		actType.validTo = Date.today();
		actType.result = '2';
		actType.statusManagerCPU = 'CPU111';
		actType.modifyByOzCPU = 'updated by';
		actType.authorCPU = 'author';
		actType.whatId = account.Id;
		actType.email = 'testemail@test.com';
		actType.isVisibleForNEL = true;
		actType.opportunityId = opp.ExternalId__c;
		actType.location = 'location';
		actType.plannedToDate = Datetime.now();
		actType.webLink = 'webLink';
		actType.letterCity = 'letterCity';
		actType.letterHouseNr = 'letterHouseNr';
		actType.letterPostcode = 'letterPostcode';
		actType.letterStreet = 'letterStreet';
		actType.isKZMessage = false;
		actType.isRead = true;
		actType.clientGlobalId = 'G111';
		actType.validFrom = Date.today();

		Test.startTest();
		TaskService.updateTask(actType, header);
		Test.stopTest();
		update task;
		Task queriedTask = [
			SELECT
				Id, Type, Description, CallDirectionCode__c, Source__c, InternalAttendee__c, Phone__c, ActivityDate, Status,
				Subject, ValidTo__c, Result__c, OwnerId, UpdatedBy__c, Author__c, WhatId,
				Email__c, IsVisibleForNel__c, OpportunityExternalId__c, Location__c, PlannedToDate__c, WebLink__c, City__c,
				HouseNumber__c, PostCode__c, Street__c, IsKZMessage__c, IsRead__c, WhoId, ValidFrom__c
			FROM Task
		];
		Account queriedAccount = [SELECT PersonContactId FROM Account WHERE Id = :account.Id];
		System.assertEquals(queriedTask.Type, actType.type);
		System.assertEquals(queriedTask.Source__c, header.sourceSystem);
		System.assertEquals(queriedTask.Description, actType.describe);
		System.assertEquals(queriedTask.CallDirectionCode__c, actType.direction);
		System.assertEquals(queriedTask.InternalAttendee__c, actType.oz);
		System.assertEquals(queriedTask.Phone__c, actType.phoneNumber);
		System.assertEquals(queriedTask.ActivityDate, actType.dueDate);
		System.assertEquals(queriedTask.Status, actType.stateCode);
		System.assertEquals(queriedTask.ValidTo__c, actType.validTo);
		System.assertEquals(queriedTask.Result__c, actType.result);
		System.assertEquals(queriedTask.OwnerId, user.Id);
		System.assertEquals(queriedTask.UpdatedBy__c, actType.modifyByOzCPU);
		System.assertEquals(queriedTask.Author__c, actType.authorCPU);
		System.assertEquals(queriedTask.Email__c, actType.email);
		System.assertEquals(queriedTask.IsVisibleForNel__c, actType.isVisibleForNEL);
		System.assertEquals(queriedTask.OpportunityExternalId__c, actType.opportunityId);
		System.assertEquals(queriedTask.Location__c, actType.location);
		System.assertEquals(queriedTask.PlannedToDate__c, actType.plannedToDate);
		System.assertEquals(queriedTask.WebLink__c, actType.webLink);
		System.assertEquals(queriedTask.City__c, actType.letterCity);
		System.assertEquals(queriedTask.HouseNumber__c, actType.letterHouseNr);
		System.assertEquals(queriedTask.PostCode__c, actType.letterPostcode);
		System.assertEquals(queriedTask.Street__c, actType.letterStreet);
		System.assertEquals(queriedTask.IsKZMessage__c, actType.isKZMessage);
		System.assertEquals(queriedTask.IsRead__c, actType.isRead);
		System.assertEquals(queriedTask.WhoId, queriedAccount.PersonContactId);
		System.assertEquals(queriedTask.ValidFrom__c, actType.validFrom);

	}

}