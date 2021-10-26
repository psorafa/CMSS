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
		handleUpdateAccountDateFields();
	}

	public override void afterUpdate() {
		AQMessageService.handleUpdate(Trigger.new, Trigger.oldMap, Task.SObjectType);
		handleUpdatedTasksShares(Trigger.old, Trigger.new);
		handleUpdateAccountDateFields();
	}

	public override void afterUndelete() {
		AQMessageService.handleInsert(Trigger.new, Task.SObjectType);
	}

	public void handleUpdateAccountDateFields() {
		Set<Account> accountsToUpdate = new Set<Account>();
		Map<Id, Task> tasksWithAccount = new Map<Id, Task>(
			[
				SELECT AccountId, Account.LastInteractionDate__c, Account.OpenedActivityDate__c
				FROM Task
				WHERE Id IN :Trigger.newMap.keySet()
			]
		);

		for (Task newTask : (Task[]) Trigger.new) {
			Task oldTask = (Task) (Trigger.isInsert ? new Task() : Trigger.oldMap.get(newTask.Id));
			Account actualTaskAccount = tasksWithAccount.get(newTask.Id)?.Account;
			if (actualTaskAccount == null) {
				continue;
			}
			if (
				newTask.CompletedDateTime != oldTask?.CompletedDateTime &&
				newTask?.CompletedDateTime?.date() <= Date.today() &&
				(newTask.CompletedDateTime > actualTaskAccount?.LastInteractionDate__c ||
				actualTaskAccount?.LastInteractionDate__c == null)
			) {
				actualTaskAccount.LastInteractionDate__c = (Date) newTask?.CompletedDateTime?.date();
				accountsToUpdate.add(actualTaskAccount);
			}

			if (
				newTask.ActivityDate != oldTask?.ActivityDate &&
				newTask.ActivityDate >= Date.today() &&
				(newTask.Status == '1' ||
				newTask.Status == '2') && newTask.ActivityDate < actualTaskAccount?.OpenedActivityDate__c ||
				actualTaskAccount?.OpenedActivityDate__c == null
			) {
				actualTaskAccount.OpenedActivityDate__c = newTask?.ActivityDate;
				accountsToUpdate.add(actualTaskAccount);
			}
		}

		update new List<Account>(new Set<Account>(accountsToUpdate));
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
