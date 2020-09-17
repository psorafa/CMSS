trigger LogEventTrigger on LogEvent__e (after insert) {

	if (Trigger.isInsert && Trigger.isAfter) {
		LogEventTriggerHandler.afterInsert(Trigger.new);
	}
}