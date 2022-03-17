public class ProcessEventSyncSchedule implements Schedulable {
	private Boolean triggerOnce;

	public ProcessEventSyncSchedule() {
		this.triggerOnce = false;
	}
	public ProcessEventSyncSchedule(Boolean triggerOnlyOnce) {
		this.triggerOnce = triggerOnlyOnce;
	}

	public void execute(SchedulableContext context) {
		if (triggerOnce) {
			System.abortJob(context.getTriggerId());
		}
		System.enqueueJob(new ProcessEventSyncQueue());
	}
}
