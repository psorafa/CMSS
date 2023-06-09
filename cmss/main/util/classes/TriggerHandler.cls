/**
 * Created by a.olexova on 5/21/2020.
 *
 * Taken from CSOB implementation
 * Class to make the process of TriggerHandlers simpler and cleaner
 * The class in CSOB contains the logic avoiding never ending looping and enabling bypassing the triggers when necessary - to be reviewed with the architects when possible
 */

public virtual class TriggerHandler {
	public TriggerHandler() {
	}

	/***************************************
	 * public methods
	 ***************************************/

	// main method that will be called during execution
	public void run() {
		if (!validateRun()) {
			return;
		}

		// dispatch to the correct handler method
		if (Trigger.isBefore && Trigger.isInsert) {
			this.beforeInsert();
		} else if (Trigger.isBefore && Trigger.isUpdate) {
			this.beforeUpdate();
		} else if (Trigger.isBefore && Trigger.isDelete) {
			this.beforeDelete();
		} else if (Trigger.isAfter && Trigger.isInsert) {
			this.afterInsert();
		} else if (Trigger.isAfter && Trigger.isUpdate) {
			this.afterUpdate();
		} else if (Trigger.isAfter && Trigger.isDelete) {
			this.afterDelete();
		} else if (Trigger.isAfter && Trigger.isUndelete) {
			this.afterUndelete();
		}
	}

	// make sure this trigger should continue to run
	private Boolean validateRun() {
		if (!Trigger.isExecuting) {
			throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
		}
		return true;
	}

	/***************************************
	 * context methods
	 ***************************************/

	// context-specific methods for override
	protected virtual void beforeInsert() {
	}
	protected virtual void beforeUpdate() {
	}
	protected virtual void beforeDelete() {
	}
	protected virtual void afterInsert() {
	}
	protected virtual void afterUpdate() {
	}
	protected virtual void afterDelete() {
	}
	protected virtual void afterUndelete() {
	}

	// exception class
	public class TriggerHandlerException extends Exception {
	}
}
