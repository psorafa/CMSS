@IsTest
private class SF_ActivityManagementSOAPServiceTest {

	@IsTest
	static void createActivityTest() {
		User user = TestDataFactory.getUser(new User(CommissionAccountNr__c = 'CPU111'));
		insert user;
		Account account = TestDataFactory.getPersonAccount(new Account(GlobalId__c = 'G111'));
        insert account;
        Opportunity opp = TestDataFactory.getOpportunity();
        insert opp;

		SF_ActivityManagementSOAPService.ActivityRequestType request = new SF_ActivityManagementSOAPService.ActivityRequestType();
		SF_ActivityManagementSOAPService.ActivityType actType = new SF_ActivityManagementSOAPService.ActivityType();
        actType.type = '1';
        actType.describe = getDummyLongText();
        actType.direction = '0';
        actType.oz = 'internal attendee';
        actType.phoneNumber = '123456789';
        actType.dueDate = Date.today();
        actType.stateCode = '0';
        actType.statusCode = '0';
        actType.name = 'subject';
        actType.validTo = Date.today();
        actType.result = '2';
        actType.statusManagerCPU = 'CPU111';
        actType.modifyByOzCPU = 'updated by';
        actType.authorCPU = 'author';
        actType.whatId = (String) account.Id;
        actType.email = 'testemail@test.com';
        actType.isVisibleForNEL = true;
        actType.opportunityId = (String) opp.Id;
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

        request.requestBody = actType;

		Test.startTest();
		SF_ActivityManagementSOAPService.ActivityManagementResponseType response = SF_ActivityManagementSOAPService.createActivity(request);
		Test.stopTest();

		System.assert(response.isFault == false, JSON.serializePretty(response.fault));
		Task queriedTask = [
			SELECT
				Id, Type, Description, CallDirectionCode__c, InternalAttendee__c, Phone__c, ActivityDate, Status, 
                StatusReason__c, Subject, ValidTo__c, Result__c, OwnerId, UpdatedBy__c, Author__c, WhatId,
                Email__c, IsVisibleForNel__c, Opportunity__c, Location__c, PlannedToDate__c, WebLink__c, City__c, 
                HouseNumber__c, PostCode__c, Street__c, IsKZMessage__c, IsRead__c, WhoId, ValidFrom__c
			FROM Task
			WHERE Id = :response.responseBody.activityId
        ];
        
        Account queriedAccount = [SELECT PersonContactId FROM Account WHERE Id =: account.Id];

        System.assertEquals(queriedTask.Type, actType.type);
        System.assertEquals(queriedTask.Description, actType.describe);
        System.assertEquals(queriedTask.CallDirectionCode__c, actType.direction);
        System.assertEquals(queriedTask.InternalAttendee__c, actType.oz);
        System.assertEquals(queriedTask.Phone__c, actType.phoneNumber);
        System.assertEquals(queriedTask.ActivityDate, actType.dueDate);
        System.assertEquals(queriedTask.Status, actType.stateCode);
        System.assertEquals(queriedTask.StatusReason__c, actType.statusCode);
        System.assertEquals(queriedTask.Subject, actType.name);
        System.assertEquals(queriedTask.ValidTo__c, actType.validTo);
        System.assertEquals(queriedTask.Result__c, actType.result);
        System.assertEquals(queriedTask.OwnerId, user.Id);
        System.assertEquals(queriedTask.UpdatedBy__c, actType.modifyByOzCPU);
        System.assertEquals(queriedTask.Author__c, actType.authorCPU);
        System.assertEquals(queriedTask.WhatId, actType.whatId);
        System.assertEquals(queriedTask.Email__c, actType.email);
        System.assertEquals(queriedTask.IsVisibleForNel__c, actType.isVisibleForNEL);
        System.assertEquals(queriedTask.Opportunity__c, actType.opportunityId);
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

	@IsTest
	static void updateActivityTest() {
		User user = TestDataFactory.getUser(new User(CommissionAccountNr__c = 'CPU111'));
		insert user;
		Account account = TestDataFactory.getPersonAccount(new Account(GlobalId__c = 'G111'));
        insert account;
        Opportunity opp = TestDataFactory.getOpportunity();
        insert opp;
        Task task = TestDataFactory.getTask(new Task());
        insert task;

		SF_ActivityManagementSOAPService.ActivityRequestType request = new SF_ActivityManagementSOAPService.ActivityRequestType();
        SF_ActivityManagementSOAPService.ActivityType actType = new SF_ActivityManagementSOAPService.ActivityType();
        actType.id = task.ExternalId__c;
        actType.type = '1';
        actType.describe = getDummyLongText();
        actType.direction = '0';
        actType.oz = 'internal attendee';
        actType.phoneNumber = '123456789';
        actType.dueDate = Date.today();
        actType.stateCode = '0';
        actType.statusCode = '0';
        actType.name = 'subject';
        actType.validTo = Date.today();
        actType.result = '2';
        actType.statusManagerCPU = 'CPU111';
        actType.modifyByOzCPU = 'updated by';
        actType.authorCPU = 'author';
        actType.whatId = (String) account.Id;
        actType.email = 'testemail@test.com';
        actType.isVisibleForNEL = true;
        actType.opportunityId = (String) opp.Id;
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

        request.requestBody = actType;

		Test.startTest();
		SF_ActivityManagementSOAPService.ActivityManagementResponseType response = SF_ActivityManagementSOAPService.updateActivity(request);
		Test.stopTest();

		System.assert(response.isFault == false, JSON.serializePretty(response.fault));
		Task queriedTask = [
			SELECT
				Id, Type, Description, CallDirectionCode__c, InternalAttendee__c, Phone__c, ActivityDate, Status, 
                StatusReason__c, Subject, ValidTo__c, Result__c, OwnerId, UpdatedBy__c, Author__c, WhatId,
                Email__c, IsVisibleForNel__c, Opportunity__c, Location__c, PlannedToDate__c, WebLink__c, City__c, 
                HouseNumber__c, PostCode__c, Street__c, IsKZMessage__c, IsRead__c, WhoId, ValidFrom__c
			FROM Task
			WHERE Id = :task.Id
        ];
        
        Account queriedAccount = [SELECT PersonContactId FROM Account WHERE Id =: account.Id];

        System.assertEquals(queriedTask.Type, actType.type);
        System.assertEquals(queriedTask.Description, actType.describe);
        System.assertEquals(queriedTask.CallDirectionCode__c, actType.direction);
        System.assertEquals(queriedTask.InternalAttendee__c, actType.oz);
        System.assertEquals(queriedTask.Phone__c, actType.phoneNumber);
        System.assertEquals(queriedTask.ActivityDate, actType.dueDate);
        System.assertEquals(queriedTask.Status, actType.stateCode);
        System.assertEquals(queriedTask.StatusReason__c, actType.statusCode);
        System.assertEquals(queriedTask.Subject, actType.name);
        System.assertEquals(queriedTask.ValidTo__c, actType.validTo);
        System.assertEquals(queriedTask.Result__c, actType.result);
        System.assertEquals(queriedTask.OwnerId, user.Id);
        System.assertEquals(queriedTask.UpdatedBy__c, actType.modifyByOzCPU);
        System.assertEquals(queriedTask.Author__c, actType.authorCPU);
        System.assertEquals(queriedTask.WhatId, actType.whatId);
        System.assertEquals(queriedTask.Email__c, actType.email);
        System.assertEquals(queriedTask.IsVisibleForNel__c, actType.isVisibleForNEL);
        System.assertEquals(queriedTask.Opportunity__c, actType.opportunityId);
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
    
    static String getDummyLongText() {
        return 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Integer malesuada. Nullam eget nisl. Vestibulum erat nulla, ullamcorper nec, rutrum non, nonummy ac, erat. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Etiam quis quam. Aenean fermentum risus id tortor. Maecenas lorem. Nullam eget nisl. Nulla quis diam. Aenean id metus id velit ullamcorper pulvinar. Praesent vitae arcu tempor neque lacinia pretium. Etiam dictum tincidunt diam. Phasellus rhoncus. Cras pede libero, dapibus nec, pretium sit amet, tempor quis. Pellentesque ipsum. Aenean placerat. Donec quis nibh at felis congue commodo.';
    }
}
