public with sharing class TaskService {

    public static Id createTask(SF_ActivityManagementSOAPService.ActivityType data) {
		if (data.id != null) {
			throw new SOAPCommonTypes.BusinessException(102, 'Invalid attribute specified: cannot specifiy "id" in createTask');
		}
        Validation.requireAttribute(data.name, 'name');
        Validation.requireAttribute(data.type, 'type');
        Validation.requireAttribute(data.stateCode, 'stateCode');
        Task task = prepareTask(data);
		SObjectUtil.stripNullFields(task);
        DmlUtility.insertRecord(task);
        return task.Id;
    }
    
    public static void updateTask(SF_ActivityManagementSOAPService.ActivityType data) {
        Validation.requireAttribute(data.id, 'id');
        Task task = prepareTask(data);
		SObjectUtil.stripNullFields(task);
		DmlUtility.updateRecord(task);
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
        if (data.id != null) {
            t.Id = findTaskByExternalId(data.id).Id;
        }
        t.Type = data.type;
        t.Description = data.describe;
        t.CallDirectionCode__c = data.direction;
        t.InternalAttendee__c = data.oz;
        t.Phone__c = data.phoneNumber;
        t.ActivityDate = data.dueDate;
        if (data.stateCode != null) {
            t.Status = data.stateCode;
        }
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
        if (data.isVisibleForNEL != null) {
            t.IsVisibleForNel__c = data.isVisibleForNEL;
        }
        t.Opportunity__c = data.opportunityId;
        t.Location__c = data.location; 
        t.PlannedToDate__c = data.plannedToDate;
        t.WebLink__c = data.webLink;
        t.City__c = data.letterCity;
        t.HouseNumber__c = data.letterHouseNr;
        t.PostCode__c = data.letterPostcode;
        t.Street__c = data.letterStreet;
        if (data.isKZMessage != null) {
            t.IsKZMessage__c = data.isKZMessage;
        }
        if (data.isRead != null) {
            t.IsRead__c = data.isRead;
        }
        if (data.clientGlobalId != null) {
			t.WhoId = ReferenceUtility.getAccountByGlobalId(data.clientGlobalId).PersonContactId;
        }
        t.ValidFrom__c = data.validFrom == null ? Date.today() : data.validFrom;

		return t;
	}

	private static Task findTaskByExternalId(String externalId) {
		for (Task t : [SELECT Id FROM Task WHERE ExternalId__c = :externalId LIMIT 1]) {
			return t;
		}
		throw new SOAPCommonTypes.BusinessException(201, 'Record not found: Task - External ID: ' + externalId);
	}
}
