public with sharing class TaskService {

    public static Id createTask(SF_ActivityManagementSOAPService.ActivityType data) {
		if (data.id != null) {
			throw new SOAPCommonTypes.BusinessException(102, 'Invalid attribute specified: cannot specifiy "id" in createTask');
		}
        Validation.requireAttribute(data.name, 'name');
        Validation.requireAttribute(data.type, 'type');

        Task task = prepareTask(data);
        
		try {
			insert task;
			return task.Id;
		} catch (DmlException e) {
			throw new SOAPCommonTypes.BusinessException(301, 'Cannot insert record: ' + e.getMessage(), e);
		}
	}

	public static void setRecordType(List<Task> taskList) {
		List<TaskRecordTypeMapping__mdt> rtMappingList = [
			SELECT RecordTypeDeveloperName__c, TypeAPIName__c
			FROM TaskRecordTypeMapping__mdt
		];
		Map<String, String> rtMappingMap = new Map<String, String>();

		for (TaskRecordTypeMapping__mdt rtMappingItem : rtMappingList) {
			rtMappingMap.put(rtMappingItem.TypeAPIName__c, rtMappingItem.RecordTypeDeveloperName__c);
		}

		for (Task taskItem : taskList) {
			String taskTypeDevName = rtMappingMap.get(taskItem.Type);
			if (taskTypeDevName != null) {
				taskItem.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName()
					.get(taskTypeDevName)
					.getRecordTypeId();
			}
		}
    }
    
    private static Task prepareTask(SF_ActivityManagementSOAPService.ActivityType data) {
		Task t = new Task();
        t.Id = data.id;
        t.Type = data.type;
        t.Description = data.describe;
        t.CallDirectionCode__c = data.direction;
        t.InternalAttendee__c = data.oz;
        t.Phone__c = data.phoneNumber;
        t.ActivityDate = data.dueDate;
        t.Status = data.stateCode;
        t.StatusReason__c = data.statusCode;
        t.Subject = data.name;
        t.ValidTo__c = data.validTo;
        t.Result__c = data.result;
        if (data.statusManagerCPU != null) {
			t.OwnerId = ReferenceUtility.getUserByCPU(data.statusManagerCPU).Id;
		}
        t.UpdatedBy__c = data.modifyByOzCPU;
        t.Author__c = data.authorCPU;
        t.WhatId = data.whatId;
        t.Email__c = data.email;
        t.IsVisibleForNel__c = data.isVisibleForNEL;
        t.Opportunity__c = data.opportunityId;
        t.Location__c = data.location; 
        t.PlannedToDate__c = data.plannedToDate;
        t.WebLink__c = data.webLink;
        t.City__c = data.letterCity;
        t.HouseNumber__c = data.letterHouseNr;
        t.PostCode__c = data.letterPostcode;
        t.Street__c = data.letterStreet;
        t.IsKZMessage__c = data.isKZMessage;
        t.IsRead__c = data.isRead;
        if (data.clientGlobalId != null) {
			t.WhoId = ReferenceUtility.getAccountByGlobalId(data.clientGlobalId).PersonContactId;
        }
        t.ValidFrom__c = data.validFrom == null ? Date.today() : data.validFrom;

		return t;
	}
}
