/*
 * AccessShareSchedule remove all expired access from AccessShare and AccountShare tables
 *
 */

//Scheduling example:
//System.schedule('Delete search access shares','0 0 0 * * ?', new AccessShareSchedule());

global class AccessShareSchedule implements Schedulable {
	/*****************************************************************************************************
	@methodName: removeAccess
	@description: AccessShareSchedule remove all expired access from AccessShare and AccountShare tables
	@date: 20190215
	*****************************************************************************************************/
	global void execute(System.SchedulableContext context) {
		Database.executeBatch(new AccessShareBatch('Search'), 50);
		// Database.executeBatch(new AccessShareBatch('Opportunity'), 50);
		// Database.executeBatch(new AccessShareBatch('Task'), 50);
		// Database.executeBatch(new AccessShareBatch('Owner'), 50);
	}
}
