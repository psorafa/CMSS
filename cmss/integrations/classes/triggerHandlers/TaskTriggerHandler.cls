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
		AccessShareController.removeTaskAccessBulk(Trigger.old);
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
		// insert IntegrationLogService.createIntegrationLog(
		// 	new Integration_Log__c(),
		// 	soList,
		// 	'Batch',
		// 	'Tasks before insert',
		// 	'Processed',
		// 	'All Tasks have been processed on before insert'
		// );

		Task[] assignAccessList = new List<Task>{};

		for (Task newTask : (Task[]) soList) {
			assignAccessList.add(newTask);
		}

		AccessShareController.assignTaskAccessBulk(assignAccessList);
	}

	private void handleUpdatedTasksShares(SObject[] oldListSo, SObject[] newListSo) {
		// insert IntegrationLogService.createIntegrationLog(
		//     new Integration_Log__c(),
		//     newListSo,
		//     'Batch',
		//     'Tasks before update',
		//     'Processed',
		//     'All Tasks have been processed on before update'
		// );

		Task[] removeAccessList = new List<Task>{};
		Task[] assignAccessList = new List<Task>{};

		List<String> closedStatuses = new List<String>{ '0', '2' };

		for (Task newTask : (Task[]) newListSo) {
			Task oldTask = (Task) Trigger.oldMap.get(newTask.Id);

			Boolean isAccountNull = (oldTask.AccountId == null && newTask.AccountId == null);

			if (!oldTask.OwnerId.equals(newTask.OwnerId) && !isAccountNull) {
				removeAccessList.add(oldTask);
				assignAccessList.add(newTask);
			} else if (closedStatuses.contains(newTask.Status) || newTask.ActivityDate <= Date.today()) {
				removeAccessList.add(newTask);
			} else if (oldTask.ActivityDate != newTask.ActivityDate && !isAccountNull) {
				assignAccessList.add(newTask);
			}
		}

		AccessShareController.removeTaskAccessBulk(removeAccessList);
		AccessShareController.assignTaskAccessBulk(assignAccessList);
	}
}
