trigger MailServiceNotificationTrigger on MailServiceNotification__c(after insert) {
	new MailServiceNotificationTriggerHandler().run();
}
