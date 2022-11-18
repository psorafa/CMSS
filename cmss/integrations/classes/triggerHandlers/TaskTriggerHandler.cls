public class TaskTriggerHandler extends TriggerHandler {
	public override void beforeInsert() {
		TaskService.setRecordType(Trigger.new);
		IntegrationUtility.populateDefaultExternalId(Trigger.new);
		updateTaskFields(null, Trigger.new);
	}

	public override void beforeUpdate() {
		TaskService.setRecordType(Trigger.new);
		IntegrationUtility.populateDefaultExternalId(Trigger.new);
		updateTaskFields((Map<Id, Task>) Trigger.oldMap, Trigger.new);
	}

	public override void beforeDelete() {
		checkDeletePermission();
		AQMessageService.handleDelete(Trigger.old, Task.SObjectType);
		AccessShareController.removeTaskAccessBulk(Trigger.old);
		createEventSyncs((Map<Id, Task>) Trigger.oldMap, false, true);
	}

	public override void afterInsert() {
		handleInsertedTasksShares(Trigger.new);
		handleUpdateAccountDateFields();
		if (!System.isBatch()) {
			handleAqMessagingInsertInFuture(Trigger.newMap.keySet());
			createNewTaskNotifications(new List<Id>(Trigger.newMap.keySet()));
			createEventSyncsFuture(Trigger.newMap.keySet(), true, false);
		}
	}

	public override void afterUpdate() {
		AQMessageService.handleUpdate(Trigger.new, Trigger.oldMap, Task.SObjectType);
		handleUpdatedTasksShares(Trigger.old, Trigger.new);
		handleUpdateAccountDateFields();
		sendDelegatedTaskNotifications(Trigger.new, Trigger.oldMap);
		if (!System.isBatch()) {
			createEventSyncsFuture(Trigger.newMap.keySet(), false, false);
		}
	}

	public override void afterUndelete() {
		AQMessageService.handleInsert(Trigger.new, Task.SObjectType);
	}

	public void updateTaskFields(Map<Id, Task> oldTasksMap, List<Task> newTasks) {
		Map<Id, Task> contactsToTasksToGetAlias = new Map<Id, Task>();
		for (Task task : newTasks) {
			if (task.Source__c == '54') {
				task.Category__c = '1';
			}
			if (task.Type != null) {
				task.ActivityType__c = task.Type;
			}
			if (task.IsVisibleInSelfService == false) {
				task.IsVisibleInSelfService = true;
			}
			if (task.Description != null) {
				task.Summary__c = task.Description.length() > 30 ? task.Description.left(30) + '...' : task.Description;
			}
			if (oldTasksMap == null || oldTasksMap.get(task.Id).WhoId != task.WhoId) {
				task.AccountAlias__c = '';
				if (task.WhoId != null) {
					contactsToTasksToGetAlias.put(task.WhoId, task);
				}
			}
		}

		if (contactsToTasksToGetAlias.size() > 0) {
			completeAccountAliases(contactsToTasksToGetAlias);
		}
	}

	private static void completeAccountAliases(Map<Id, Task> contactsToTasksToGetAlias) {
		Map<Id, Contact> contactsMap = new Map<Id, Contact>(
			[
				SELECT Account.LastName, Account.FirstName, Account.Birthdate__c
				FROM Contact
				WHERE Id IN :contactsToTasksToGetAlias.keySet()
			]
		);
		for (Contact contact : contactsMap.values()) {
			contactsToTasksToGetAlias.get(contact.Id).AccountAlias__c =
				contact.Account?.LastName.left(3) +
				contact.Account?.FirstName?.left(3) +
				'_' +
				String.valueOf(contact?.Account?.Birthdate__c?.year())?.right(2);
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
	private static Set<Id> getIntegrationUserIds() {
		Set<Id> integrationUserIds = new Set<Id>();
		for (User u : [SELECT Id, Profile.Name FROM User WHERE Profile.Name = 'IntegrationUser']) {
			integrationUserIds.add(u.Id);
		}
		return integrationUserIds;
	}
	public void sendDelegatedTaskNotifications(List<SObject> newTasks, Map<Id, SObject> oldTasksMap) {
		Set<Id> integrationUserIds = getIntegrationUserIds();
		List<Id> potentialTasksToNotifyAbout = new List<Id>();
		List<Id> tasksToNotifyAbout = new List<Id>();

		for (Task task : (List<Task>) newTasks) {
			if (
				task.OwnerId != ((Task) oldTasksMap.get(task.Id)).OwnerId &&
				!integrationUserIds.contains(task.LastModifiedById) &&
				task.isClosed == false
			) {
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
			SELECT Id, OwnerId, Owner.Email, Owner.IsActive, Subject, CreatedById, Source__c
			FROM Task
			WHERE
				Id IN :taskIds
				AND Status = '1'
				AND Category__c = '1'
				AND (IsVisibleForNel__c = TRUE
				OR Source__c = '54')
		];

		List<Task> otherTasks = [
			SELECT Id, OwnerId, Owner.Email, Subject, CreatedById, Source__c, isClosed, LastModifiedById
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

	private static EventSync__c getEventSync(Task task, Boolean isNew, Boolean isDeleted) {
		EventSync__c newEventSync = new EventSync__c();
		newEventSync.IsTask__c = true;
		newEventSync.GoogleEventId__c = task.GoogleId__c;
		newEventSync.SFTaskId__c = task.Id;
		newEventSync.ChangeFromGoogle__c = false;
		newEventSync.IsNew__c = isNew;
		newEventSync.IsDeleted__c = isDeleted;

		return newEventSync;
	}

	@testVisible
	private static void createEventSyncs(Map<Id, Task> tasksMap, Boolean isNew, Boolean isDeleted) {
		List<String> googleIds = new List<String>();
		List<Id> ownerIds = new List<Id>();
		Map<String, Task> tasksToGoogleIds = new Map<String, Task>();
		Map<Id, Task> tasksToCreateSyncsTo = tasksMap.clone();

		for (Task task : tasksToCreateSyncsTo.values()) {
			ownerIds.add(task.OwnerId);
			if (String.isNotBlank(task.GoogleId__c)) {
				googleIds.add(task.GoogleId__c);
				tasksToGoogleIds.put(task.GoogleId__c, task);
			}
		}
		Map<Id, UserCalendarSetting__c> calendarSettingsByOwnerIds = new Map<Id, UserCalendarSetting__c>();
		calendarSettingsByOwnerIds = getSettingsByOwnerIds(ownerIds);
		for (Task task : tasksToCreateSyncsTo.values()) {
			if (!calendarSettingsByOwnerIds.containsKey(task.OwnerId)) {
				tasksToCreateSyncsTo.remove(task.Id);
			}
		}
		Set<Id> taskIds = tasksToCreateSyncsTo.keySet();
		Map<Id, EventSync__c> existingSyncsMap = new Map<Id, EventSync__c>(
			(List<EventSync__c>) Database.query(
				'SELECT Id, SFTaskId__c, GoogleEventId__c, IsNew__c, IsDeleted__c, ChangeFromGoogle__c FROM EventSync__c ' +
				'WHERE (GoogleEventId__c IN :googleIds OR SFTaskId__c IN :taskIds) ' +
				(isDeleted ? ' AND IsDeleted__c = true' : '')
			)
		);

		Set<Id> eventSyncsToPreserve = new Set<Id>();
		for (EventSync__c existingSync : existingSyncsMap.values()) {
			Task task;
			task = tasksToCreateSyncsTo.get(existingSync.SFTaskId__c);
			if (task == null) {
				task = tasksToGoogleIds.get(existingSync.GoogleEventId__c);
			}
			if (task != null) {
				if (!existingSync.ChangeFromGoogle__c && existingSync.IsNew__c) {
					eventSyncsToPreserve.add(existingSync.Id);
					tasksToCreateSyncsTo.remove(task.Id);
				} else if (existingSync.ChangeFromGoogle__c || existingSync.IsDeleted__c) {
					tasksToCreateSyncsTo.remove(task.Id);
				}
			}
		}

		existingSyncsMap.keySet().removeAll(eventSyncsToPreserve);
		List<EventSync__c> syncsToCreate = new List<EventSync__c>();

		for (Task task : tasksToCreateSyncsTo.values()) {
			if ((isNew && task.GoogleId__c == null) || isDeleted || (!isNew && !isDeleted))
				syncsToCreate.add(getEventSync(task, isNew, isDeleted));
		}

		insert syncsToCreate;
		delete existingSyncsMap.values();
	}

	private static Map<Id, UserCalendarSetting__c> getSettingsByOwnerIds(List<Id> ownerIds) {
		List<UserCalendarSetting__c> activeSettings = [
			SELECT User__c, SyncActive__c
			FROM UserCalendarSetting__c
			WHERE User__c IN :ownerIds AND SyncActive__c = TRUE
		];
		Map<Id, UserCalendarSetting__c> settingsByOwnerIds = new Map<Id, UserCalendarSetting__c>();
		for (UserCalendarSetting__c setting : activeSettings) {
			settingsByOwnerIds.put(setting.User__c, setting);
		}
		return settingsByOwnerIds;
	}

	@testVisible
	@future
	private static void createEventSyncsFuture(Set<Id> taskIds, Boolean isTaskNew, Boolean isTaskDeleted) {
		Map<Id, Task> tasksMap = new Map<Id, Task>([SELECT Id, GoogleId__c, OwnerId FROM Task WHERE Id IN :taskIds]);
		createEventSyncs(tasksMap, isTaskNew, isTaskDeleted);
	}

	private static void createMailServiceNotifications(List<Task> tasksToNotifyAbout) {
		String linkToNel = IntegrationSettings__c.getOrgDefaults().NELBaseUrl__c + '/group/nel/prehled-op/aktivit';

		Set<Id> inactiveOwnersIds = new Set<Id>();
		for (Task task : tasksToNotifyAbout) {
			if (!task.Owner.IsActive) {
				inactiveOwnersIds.add(task.OwnerId);
			}
		}
		Map<Id, String> emailByInactiveUserId = new Map<Id, String>();

		for (ContactInformation__c ci : [
			SELECT Email__c, User__c
			FROM ContactInformation__c
			WHERE Area__c = '3' AND SubType__c = '3000001' AND User__c IN :inactiveOwnersIds
		]) {
			emailByInactiveUserId.put(ci.User__c, ci.Email__c);
		}

		SendNotificationHandler notificationHandler = new SendNotificationHandler();
		notificationHandler.setEmailTemplate('ServiceActivityNotification')
			.setSpecialVariables(new Map<String, String>{ 'LinkToNEL' => linkToNel })
			.setSender('noreply@csobstavebni-oz.cz');

		for (Task task : tasksToNotifyAbout) {
			if (!task.Owner.IsActive && !emailByInactiveUserId.containsKey(task.OwnerId)) {
				continue;
			}
			if (task.CreatedById != task.OwnerId || task.Source__c == '54') {
				String ownerEmailAddress = task.Owner.IsActive
					? task.Owner.Email
					: emailByInactiveUserId.get(task.OwnerId);
				notificationHandler.generateNotifications(task, new List<String>{ ownerEmailAddress });
			}
		}
		notificationHandler.handleInsertNotifications();
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

		ActivityExpirationConfig__mdt config = [SELECT FinalStatuses__c FROM ActivityExpirationConfig__mdt LIMIT 1];
		List<String> closedStatuses = config.FinalStatuses__c.split(',');

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

	private void checkDeletePermission() {
		Boolean isRestrictedUser = false;
		User currentUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];

		if (
			currentUser.Profile.Name == 'CMSS User' ||
			currentUser.Profile.Name == 'CMSS Experience User' ||
			currentUser.Profile.Name == 'CMSS Headquarters User'
		) {
			isRestrictedUser = true;
		}

		if (isRestrictedUser) {
			for (sObject t : Trigger.old) {
				if (t.get('CreatedById') != currentUser.Id) {
					t.addError(Label.YouDoNotHavePermissionToDeleteTask);
				}
			}
		}
	}
}
