public with sharing class ExceededLogsNotificationSchedule implements Schedulable {
	private Integer notificationLogsLimit;
	private List<String> notificationReceivers;
	private String notificationReportUrl;

	private final String MAIL_TEMPLATE_NAME = 'LogsAccessLimitExceeded';

	public ExceededLogsNotificationSchedule() {
	}

	public ExceededLogsNotificationSchedule(
		Integer notificationLogsLimit,
		List<String> notificationReceivers,
		String notificationReportUrl
	) {
		this.notificationLogsLimit = notificationLogsLimit;
		this.notificationReceivers = notificationReceivers;
		this.notificationReportUrl = notificationReportUrl;
	}

	public void execute(SchedulableContext sc) {
		try {
			if (notificationLogsLimit == null && notificationReceivers == null && notificationReportUrl == null) {
				loadConfig();
			}
			List<AggregateResult> accessLogAggregations = [
				SELECT COUNT(Id) logsCount, RequestedBy__c
				FROM Access_Log__c
				WHERE CreatedDate = LAST_MONTH
				GROUP BY RequestedBy__c
			];
			List<Id> usersToNotifyAbout = getUsersToNotifyAbout(accessLogAggregations);
			if (usersToNotifyAbout.size() > 0) {
				processLimitExceededForUsers(usersToNotifyAbout);
			}
		} catch (Exception e) {
			Logger.error('Error in ExceededLogsNotificationSchedule: ', e);
			throw e;
		} finally {
			Logger.saveLogs();
		}
	}

	private void loadConfig() {
		try {
			notificationLogsLimit = Integer.valueOf(
				Configuration__mdt.getInstance('LogsNotification_Limit').get('Value__c')
			);
			notificationReceivers = String.valueOf(
					Configuration__mdt.getInstance('LogsNotification_Receivers').get('Value__c')
				)
				.deleteWhitespace()
				.split(',');
			notificationReportUrl = String.valueOf(
				Configuration__mdt.getInstance('LogsNotification_ReportURL').get('Value__c')
			);
		} catch (Exception e) {
			throw new MissingOrMalformedConfigException(
				'LogsNotification records in Configuration__mdt are missing or maformed, please ensure their correctness.',
				e
			);
		}
	}

	private List<Id> getUsersToNotifyAbout(List<AggregateResult> accessLogAggregations) {
		List<Id> userIds = new List<Id>();
		for (AggregateResult singleUserLogs : accessLogAggregations) {
			if (Integer.valueOf(singleUserLogs.get('logsCount')) > notificationLogsLimit) {
				userIds.add((Id) singleUserLogs.get('RequestedBy__c'));
			}
		}
		return userIds;
	}

	private void processLimitExceededForUsers(List<Id> usersToNotifyAbout) {
		String listOfUsersFormated = getFormatedListOfUsers(usersToNotifyAbout);

		MailNotificationsHandler notificationsHandler = new MailNotificationsHandler();
		notificationsHandler.setEmailTemplate(MAIL_TEMPLATE_NAME)
			.setSpecialVariables(
				new Map<String, String>{
					'LIMIT' => String.valueOf(notificationLogsLimit),
					'CLIENTS_SUMMARY' => listOfUsersFormated,
					'REPORT_LINK' => notificationReportUrl
				}
			)
			.setReceivers(notificationReceivers)
			.generateNotifications();

		notificationsHandler.handleInsertNotifications();
	}

	private String getFormatedListOfUsers(List<Id> userIds) {
		String basicStyle = 'style="border: 1px solid black; border-collapse: collapse;"';
		String resultTable = getTableHeader(basicStyle);

		for (User user : [SELECT FirstName, LastName, CommissionAccountNr__c FROM User WHERE Id IN :userIds]) {
			resultTable += getTableRow(basicStyle, user);
		}
		resultTable += '</table>';
		return resultTable;
	}

	private String getTableHeader(String basicStyle) {
		return '\n <table ' +
			basicStyle +
			'><tr ' +
			basicStyle +
			'><th ' +
			basicStyle +
			'>ČPÚ</th><th ' +
			basicStyle +
			'>OZ příjmení jméno</th></tr>';
	}
	private String getTableRow(String basicStyle, User user) {
		return '<tr ' +
			basicStyle +
			'><td ' +
			basicStyle +
			'>' +
			user.CommissionAccountNr__c +
			'</td><td ' +
			basicStyle +
			'>' +
			user.LastName +
			' ' +
			user.FirstName +
			'</td></tr>';
	}

	public class MissingOrMalformedConfigException extends Exception {
	}
}
