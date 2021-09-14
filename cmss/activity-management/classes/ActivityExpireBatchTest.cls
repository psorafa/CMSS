@IsTest
public with sharing class ActivityExpireBatchTest {
	private static Integer cntr = 1;

	private static final Date before40days = System.today().addDays(-40);
	private static final Date yesterday = System.today().addDays(-1);
	private static final Date today = System.today();
	private static final Date tomorrow = System.today().addDays(1);

	private static Task getTask(Date validTo, String status) {
		return new Task(ValidTo__c = validTo, Status = status, Subject = 'TestTask' + (cntr++));
	}

	private static void createTestData() {
		insert new List<sObject>{
			getTask(yesterday, '1'),
			getTask(today, '1'),
			getTask(tomorrow, '1'),
			getTask(before40days, '1')
		};
	}

	@IsTest
	static void startTaskTest() {
		ActivityExpireBatch batch = new ActivityExpireBatch();

		createTestData();

		List<sObject> objects = (List<sObject>) batch.start(null);

		Integer found = 0;
		for (sObject a : objects) {
			found++;
			System.debug(a);
			String subj = (String) a.get('subject');
			System.assert(
				subj == 'TestTask1' ||
				subj == 'TestTask2' ||
				subj == 'TestTask4',
				'Unexpected row subject found: ' + subj
			);
		}
		System.assertEquals(3, found, 'Invalid set of selected tasks');
	}

	@IsTest
	static void executeBatchTest() {
		ActivityExpireBatch batch = new ActivityExpireBatch();

		createTestData();

		List<Task> before = (List<Task>) batch.start(null);
		batch.execute(null, before);

		List<Task> after = [
			SELECT Id, Subject, ValidTo__c, Status, DeactivateDate__c
			FROM Task
			WHERE Id IN :before
			ORDER BY Subject
		];

		Integer idx = 0;
		for (Task a : after) {
			System.debug('AFTER ' + (idx++) + ': ' + JSON.serializePretty(a));
			System.assertEquals(a.Subject == 'TestTask4' ? '5' : '4', a.Status, 'Invalid Status');
		}

		System.assertEquals(today, after[2].DeactivateDate__c, 'Wrong DeactivateDate__c');
	}
}
