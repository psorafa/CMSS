public class TaskTriggerHandler extends TriggerHandler {
	public override void beforeInsert() {
		TaskService.setRecordType(Trigger.new);
		IntegrationUtility.populateDefaultExternalId(Trigger.new);
	}

	public override void beforeUpdate() {
		TaskService.setRecordType(Trigger.new);
		IntegrationUtility.populateDefaultExternalId(Trigger.new);
	}

	public override void beforeDelete() {
		AQMessageService.handleDelete(Trigger.old, Task.SObjectType);
	}

	public override void afterInsert() {
		AQMessageService.handleInsert(Trigger.new, Task.SObjectType);
		handleInsertedTasksShares(Trigger.new);
	}

	public override void afterUpdate() {
		AQMessageService.handleUpdate(Trigger.new, Trigger.oldMap, Task.SObjectType);
		handleUpdatedTasksShares(Trigger.old, Trigger.new);
	}

	public override void afterUndelete() {
		AQMessageService.handleInsert(Trigger.new, Task.SObjectType);
	}

	public void handleInsertedTasksShares(SObject[] soList) {
		//TODO VM move outside
		// if (!DataFactoryTest.shouldRunTrigger()) {
		// 	return;
		// }

		// // Logged because of owner changes based on allocation rules in before insert
		// insert IntegrationLogService.createIntegrationLog(
		// 	new Integration_Log__c(),
		// 	soList,
		// 	'Batch',
		// 	'Tasks before insert',
		// 	'Processed',
		// 	'All Tasks have been processed on before insert'
		// );

		// if (System.UserInfo.getUserId() != ETL_USR_ID) {
		Task[] assignAccessList = new List<Task>{};

		// Id clientsRequestRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName()
		// 	.get('Clients_request_CRM')
		// 	.getRecordTypeId();

		for (Task newTask : (Task[]) soList) {
			// if (newTask.OwnerId != ETL_USR_ID && newTask.RecordTypeId != clientsRequestRecordTypeId) {
			assignAccessList.add(newTask);
			// }
		}

		AccessShareController.assignTaskAccessBulk(assignAccessList);

		// }
	}

	public void handleUpdatedTasksShares(SObject[] oldListSo, SObject[] newListSo) {
		// if (!DataFactoryTest.shouldRunTrigger()) {
		//     return;
		// }

		// // Logged because of owner changes based on allocation rules in before insert
		// insert IntegrationLogService.createIntegrationLog(
		//     new Integration_Log__c(),
		//     newListSo,
		//     'Batch',
		//     'Tasks before update',
		//     'Processed',
		//     'All Tasks have been processed on before update'
		// );

		// if (System.UserInfo.getUserId() != ETL_USR_ID) {
		Task[] removeAccessList = new List<Task>{};
		Task[] assignAccessList = new List<Task>{};

		// Id clientsRequestRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName()
		// 	.get('Clients_request_CRM')
		// 	.getRecordTypeId();

		for (Task newTask : (Task[]) newListSo) {
			Task oldTask = (Task) Trigger.oldMap.get(newTask.Id);

			// if (newTask.OwnerId != ETL_USR_ID && oldTask.RecordTypeId != clientsRequestRecordTypeId) {
			Boolean isWhatIdNull = (oldTask.WhatId == null && newTask.WhatId == null);

			if (!oldTask.OwnerId.equals(newTask.OwnerId) && !isWhatIdNull) {
                System.debug('### remove and assign access');
				removeAccessList.add(oldTask);
				assignAccessList.add(newTask);
			} else if (newTask.Status.equals('Closed') || newTask.ActivityDate <= Date.today()) {
                System.debug('### remove access');
				removeAccessList.add(newTask);
			} else if (oldTask.ActivityDate != newTask.ActivityDate && !isWhatIdNull) {
                System.debug('### assign access');
				assignAccessList.add(newTask);
			}
			// }
		}

        System.debug('### remove access list: '+ removeAccessList);
        System.debug('### remove access list: '+ assignAccessList);

		AccessShareController.removeTaskAccessBulk(removeAccessList);
		AccessShareController.assignTaskAccessBulk(assignAccessList);
		// }
	}
}
