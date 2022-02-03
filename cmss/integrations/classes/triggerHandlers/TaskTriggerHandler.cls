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
		if (!System.isBatch()) {
			createNewTaskNotifications(new List<Id>(Trigger.newMap.keySet()));
		}
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

	public static void sendNewTaskNotifications(List<Task> newTasks) {
		List<Id> tasksToNotifyAbout = new List<Id>();

		for (Task task : newTasks) {
			if (task.CreatedById != task.OwnerId) {
				tasksToNotifyAbout.add(task.Id);
			}
		}
		if (tasksToNotifyAbout.size() > 0 && !System.isBatch()) {
			sendNewTaskNotificationEmails(tasksToNotifyAbout);
		}
	}

	public void sendDelegatedTaskNotifications(List<SObject> newTasks, Map<Id, SObject> oldTasksMap) {
		List<Id> potentialTasksToNotifyAbout = new List<Id>();
		List<Id> tasksToNotifyAbout = new List<Id>();

		for (Task task : (List<Task>) newTasks) {
			if (task.OwnerId != ((Task) oldTasksMap.get(task.Id)).OwnerId) {
				potentialTasksToNotifyAbout.add(task.Id);
			}
		}
		Map<Id, Task> relatedOwnersMap = new Map<Id, Task>(
			[SELECT Owner.IsActive, Owner.Email FROM Task WHERE Id IN :potentialTasksToNotifyAbout]
		);
		for (Id taskId : potentialTasksToNotifyAbout) {
			if (relatedOwnersMap.get(taskId).Owner.IsActive && relatedOwnersMap.get(taskId).Owner.Email != null) {
				tasksToNotifyAbout.add(taskId);
			}
		}
		if (tasksToNotifyAbout.size() > 0 && !System.isBatch()) {
			sendDelegatedTaskNotificationEmails(tasksToNotifyAbout);
		}
	}

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
	private static void createNewTaskNotifications(List<Id> taskIds) {
		List<Task> serviceTasks = [
			SELECT Id, OwnerId, Opportunity__r.Author__c, Owner.Email, Subject, CreatedById, Source__c
			FROM Task
			WHERE
				Id IN :taskIds
				AND Status = '1'
				AND Category__c = '1'
				AND (IsVisibleForNel__c = TRUE
				OR Source__c = '54')
		];

		List<Task> otherTasks = [
			SELECT Id, OwnerId, Opportunity__r.Author__c, Owner.Email, Subject, CreatedById, Source__c
			FROM Task
			WHERE
				Id IN :taskIds
				AND Status = '1'
				AND Owner.IsActive = TRUE
				AND Owner.Email != NULL
				AND (Category__c != '1'
				OR (IsVisibleForNel__c = FALSE
				AND Source__c != '54'))
		];

		createMailServiceNotifications(serviceTasks);
		sendNewTaskNotifications(otherTasks);
	}

	private static void createMailServiceNotifications(List<Task> tasksToNotifyAbout) {
		EmailTemplate template = [
			SELECT HtmlValue, Subject
			FROM EmailTemplate
			WHERE DeveloperName = 'ServiceActivityNotification'
		];
		List<MailServiceNotification__c> notifications = new List<MailServiceNotification__c>();
		String linkToNel = IntegrationSettings__c.getOrgDefaults().NELBaseUrl__c + '/group/nel/prehled-op/aktivit';
		for (Task task : tasksToNotifyAbout) {
			if (task.Opportunity__r?.Author__c != task.OwnerId || task.Source__c == '54') {
				notifications.add(
					createMailServiceNotification(
						template,
						task,
						System.now(),
						'noreply@csobstavebni-oz.cz',
						new Map<String, String>{ 'LinkToNEL' => linkToNel }
					)
				);
			}
		}
		insert notifications;
	}

	private static MailServiceNotification__c createMailServiceNotification(
		EmailTemplate template,
		Task task,
		DateTime notificationDate,
		String senderEmailAddress,
		Map<String, String> specialValues
	) {
		MailServiceNotification__c newNotification = new MailServiceNotification__c();
		newNotification.FromEmailAddress__c = senderEmailAddress;
		newNotification.ToEmailAddress__c = task.Owner.Email;
		newNotification.Body__c = SendNotificationHandler.getTextationFromTemplate(
			task,
			template.HtmlValue,
			specialValues
		);
		newNotification.Subject__c = SendNotificationHandler.getTextationFromTemplate(
			task,
			template.Subject,
			new Map<String, String>()
		);
		newNotification.SendAfter__c = notificationDate;
		return newNotification;
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

		String allFields = '';
		for (SObjectField field : Task.SObjectType.getDescribe().fields.getMap().values()) {
			DescribeFieldResult describe = field.getDescribe();
			allFields += describe.getName() + ', ';
		}
		allFields = allFields.removeEnd(', ');

		String queryString = 'SELECT ' + allFields + ' FROM Task WHERE Id IN ' + idsString;

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
