/**
 * Created by a.olexova on 5/21/2020.
 */

trigger CaseTrigger on Case(
	before insert,
	before update,
	before delete,
	after insert,
	after update,
	after delete,
	after undelete
) {
	new CaseTriggerHandler().run();
}
