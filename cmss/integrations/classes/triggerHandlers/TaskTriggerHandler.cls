public class TaskTriggerHandler extends TriggerHandler {
	public override void beforeInsert() {
		TaskService.setRecordType(Trigger.new);
		IntegrationUtility.populateDefaultExternalId(Trigger.new);
		updateTaskFields(Trigger.new);
	}

	public override void beforeUpdate() {
		TaskService.setRecordType(Trigger.new);
		IntegrationUtility.populateDefaultExternalId(Trigger.new);
		updateTaskFields(Trigger.new);
	}

	public override void beforeDelete() {
		AQMessageService.handleDelete(Trigger.old, Task.SObjectType);
		AccessShareController.removeTaskAccessBulk(Trigger.old);
	}

	public override void afterInsert() {
		handleAqMessagingInsertInFuture(Trigger.newMap.keySet());
		handleInsertedTasksShares(Trigger.new);
		handleUpdateAccountDateFields();
		sendNewTaskNotifications(Trigger.new);
	}

	public override void afterUpdate() {
		AQMessageService.handleUpdate(Trigger.new, Trigger.oldMap, Task.SObjectType);
		handleUpdatedTasksShares(Trigger.old, Trigger.new);
		handleUpdateAccountDateFields();
		sendDelegatedTaskNotifications(Trigger.new, Trigger.oldMap);
	}

	public override void afterUndelete() {
		AQMessageService.handleInsert(Trigger.new, Task.SObjectType);
	}

	public void updateTaskFields(List<Task> newTasks) {
		for (Task task : newTasks) {
			if (task.Type != null) {
				task.ActivityType__c = task.Type;
			}
			if (task.IsVisibleInSelfService == false) {
				task.IsVisibleInSelfService = true;
			}
			if (task.Description != null) {
				task.Summary__c = task.Description.length() > 30 ? task.Description.left(30) + '...' : task.Description;
			}
		}
	}

	public void sendNewTaskNotifications(List<Task> newTasks) {
		List<Id> tasksToNotifyAbout = new List<Id>();
		for (Task task : newTasks) {
			if (task.Status == '1' && task.CreatedById != task.OwnerId) {
				tasksToNotifyAbout.add(task.Id);
			}
		}
		if (tasksToNotifyAbout.size() > 0 && !System.isBatch()) {
			sendNewTaskNotificationEmails(tasksToNotifyAbout);
		}
	}

	public void sendDelegatedTaskNotifications(List<SObject> newTasks, Map<Id, SObject> oldTasksMap) {
		List<Id> tasksToNotifyAbout = new List<Id>();
		for (Task task : (List<Task>) newTasks) {
			if (task.OwnerId != ((Task) oldTasksMap.get(task.Id)).OwnerId) {
				tasksToNotifyAbout.add(task.Id);
			}
		}
		if (tasksToNotifyAbout.size() > 0 && !System.isBatch()) {
			sendDelegatedTaskNotificationEmails(tasksToNotifyAbout);
		}
	}

	@testVisible
	@future
	private static void sendNewTaskNotificationEmails(List<Id> taskIds) {
		Map<String, Object> params = new Map<String, Object>{ 'newTasks' => taskIds };
		Flow.Interview.SendNewTaskEmailNotifications sendEmailsFlow = new Flow.Interview.SendNewTaskEmailNotifications(
			params
		);
		sendEmailsFlow.start();
	}

	@testVisible
	@future
	private static void sendDelegatedTaskNotificationEmails(List<Id> taskIds) {
		Map<String, Object> params = new Map<String, Object>{ 'delegatedTasks' => taskIds };
		Flow.Interview.SendDelegatedTaskEmailNotifications sendEmailsFlow = new Flow.Interview.SendDelegatedTaskEmailNotifications(
			params
		);
		sendEmailsFlow.start();
	}

	@testVisible
	@future
	private static void handleAqMessagingInsertInFuture(Set<Id> taskIds) {
		String idsString = '(';
		for (Id singleId : taskIds) {
			idsString += '\'' + singleId + '\'' + ', ';
		}
		idsString = idsString.removeEnd(', ');
		idsString += ')';

		String accessibleFields = '';
		for (SObjectField field : Task.SObjectType.getDescribe().fields.getMap().values()) {
			DescribeFieldResult describe = field.getDescribe();
			if (describe.isAccessible()) {
				accessibleFields += describe.getName() + ', ';
			}
		}
		accessibleFields = accessibleFields.removeEnd(', ');

		String queryString = 'SELECT ' + accessibleFields + ' FROM Task WHERE Id IN ' + idsString;

		List<Task> tasks = Database.query(queryString);

		AQMessageService.handleInsert(tasks, Task.SObjectType);
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
		Task[] assignAccessList = new List<Task>{};

		for (Task newTask : (Task[]) soList) {
			assignAccessList.add(newTask);
		}

		AccessShareController.assignTaskAccessBulk(assignAccessList);
	}

	private void handleUpdatedTasksShares(SObject[] oldListSo, SObject[] newListSo) {
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
