@IsTest
public with sharing class ActivityExpireBatchTest {
	private static Integer cntr = 1;

	private static final Date before40days = System.today().addDays(-40);
	private static final Date yesterday = System.today().addDays(-1);
	private static final Date today = System.today();
	private static final Date tomorrow = System.today().addDays(1);

	private static Task getTask(Date validTo, String status, String recordType) {
        Task t = new Task();
        t.ValidTo__c = validTo;
        t.Status = status;
        t.Subject = 'TestTask' + (cntr++);       
        t.RecordTypeId = Schema.Sobjecttype.Task.getRecordTypeInfosByDeveloperName().get(recordType).getRecordTypeId();          
        return t;    
	}

	private static void createTestData() {
        List<Task> tasks = new List<sObject>{
			getTask(yesterday, '1', 'Task'),
			getTask(today, '1', 'Task'),
			getTask(tomorrow, '1', 'Task'),
			getTask(before40days, '1', 'Task'),
			getTask(yesterday, '1', 'Letter')};
		insert tasks;
	}

	@IsTest
	static void executeBatchTest() {
		ActivityExpireBatch batch = new ActivityExpireBatch();

		createTestData();

		Test.startTest();
		Database.executeBatch(batch);
		Test.stopTest();

		List<Task> after = [
			SELECT Id, Subject, ValidTo__c, Status, DeactivateDate__c, RecordType.Name, RecordTypeId
			FROM Task
			WHERE ValidTo__c <= TODAY
			ORDER BY Subject
		];

		Integer idx = 0;
		for (Task a : after) {
			System.debug('AFTER ' + (idx++) + ': ' + JSON.serializePretty(a));
			System.assert((a.Subject == 'TestTask4' && a.Status == '5') || (a.Subject != 'TestTask4' && a.Status == '4' && a.RecordTypeId != Schema.Sobjecttype.Task.getRecordTypeInfosByDeveloperName().get('Letter').getRecordTypeId()), 'Invalid Status');           
		}

		System.assertEquals(today, after[2].DeactivateDate__c, 'Wrong DeactivateDate__c');
	}
}