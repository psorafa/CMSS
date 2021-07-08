/*
 * AccessShareSchedule remove all expired access from AccessShare and AccountShare tables
 *
 * @author Belimenko Nikita
 */
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