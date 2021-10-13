@IsTest
public with sharing class OpportunityExpireBatchTest {
	private static Integer cntr = 1;

	static final Date today = System.today();
	static final Date tomorrow = System.today().addDays(1);
	static final Date yesterday = System.today().addDays(-1);
	static final Date before120 = System.today().addDays(-120);

	static final Date validToTreshold = System.today();
	static final Date validFromTreshold = System.today().addDays(-120);
    static final String SERVICE_CATEGORY = '3';
	@IsTest
	static void finishTest() {
		OpportunityExpireBatch batch = new OpportunityExpireBatch();
		batch.cfg.ChainActivityExpireBatch__c = true;

		List<AsyncApexJob> jobsBefore = [SELECT Id, ApexClassID, ApexClass.Name, Status, JobType FROM AsyncApexJob];

		Test.startTest();
		batch.finish(null);

		List<AsyncApexJob> jobsAfter = [
			SELECT Id, ApexClassID, ApexClass.Name, Status, JobType
			FROM AsyncApexJob
			WHERE Id NOT IN :jobsBefore
		];
		System.assertEquals(1, jobsAfter.size(), 'The expected job is not scheduled');
		System.debug('First new job: ' + jobsAfter[0]);
		Test.stopTest();
	}

	@IsTest
	static void executeShedulableTest() {
		OpportunityExpireBatch batch = new OpportunityExpireBatch();
		batch.cfg.ChainActivityExpireBatch__c = false;

		List<AsyncApexJob> jobsBefore = [SELECT Id, ApexClassID, ApexClass.Name, Status, JobType FROM AsyncApexJob];

		Test.startTest();
		batch.execute(null);

		List<AsyncApexJob> jobsAfter = [
			SELECT Id, ApexClassID, ApexClass.Name, Status, JobType
			FROM AsyncApexJob
			WHERE Id NOT IN :jobsBefore
		];
		System.assertEquals(1, jobsAfter.size(), 'The expected job is not scheduled');
		System.debug('First new job: ' + jobsAfter[0]);
		Test.stopTest();
	}

	private static Id accId;

	private static Opportunity getOpp(Date validFrom, Date validTo, String statusOpp) {
		Integer i = cntr++;
		return new Opportunity(
            Category__c = SERVICE_CATEGORY,
			ValidFrom__c = validFrom,
			ValidTo__c = validTo,
			StageName = statusOpp,
			CloseDate = tomorrow,
			AccountId = accId,
			Reason__c = (statusOpp == '5' || statusOpp == '4') ? '8' : null,
			CustomText__c = 'TestOpp' + (i < 10 ? '0' : '') + i,
			Name = 'TestOpp' + (i < 10 ? '0' : '') + i
		);
	}

	private static Task getTask(String statusTask, Opportunity opp) {
		Integer i = cntr++;
		return new Task(
			ValidTo__c = tomorrow,
			Status = statusTask,
			WhatId = opp?.Id,
			Subject = 'TestTask' + (i < 10 ? '0' : '') + i
		);
	}

	private static void createData() {
		Account acc = new Account(Name = 'TestAcc');
		insert acc;
		accId = acc.Id;

		List<Opportunity> opps = new List<Opportunity>{
			getOpp(null, before120, '4'), //0
			getOpp(null, yesterday, '4'),
			getOpp(null, today, '4'), //2
			getOpp(null, tomorrow, '4'),
			getOpp(before120, null, '4'), //4
			getOpp(yesterday, null, '4'),
			getOpp(today, null, '4'), //6
			getOpp(tomorrow, null, '4'),
			getOpp(null, before120, '8'), //8
			getOpp(null, yesterday, '8'),
			getOpp(null, today, '8'),
			getOpp(null, tomorrow, '8'),
			getOpp(before120, null, '8'),
			getOpp(yesterday, null, '8'),
			getOpp(today, null, '8'),
			getOpp(tomorrow, null, '8'),
			getOpp(yesterday, tomorrow, '4'),
			getOpp(yesterday, tomorrow, '8')
		};
		insert opps;

		insert new List<Task>{
			getTask('4', opps[0]),
			getTask('4', opps[1]),
			getTask('4', opps[2]),
			getTask('4', opps[3]),
			getTask('4', opps[4]),
			getTask('4', opps[5]),
			getTask('4', opps[6]),
			getTask('4', opps[7]),
			getTask('4', opps[8]),
			getTask('4', null),
			getTask('5', null)
		};
	}

	@IsTest
	static void startTest() {
		OpportunityExpireBatch batch = new OpportunityExpireBatch();
		batch.cfg.ChainActivityExpireBatch__c = false;
		batch.validToTreshold = validToTreshold;
		batch.validFromTreshold = validFromTreshold;

		createData();

		List<Opportunity> opps = (List<Opportunity>) batch.start(null);

		System.assertEquals(4, opps.size(), 'Invalid opps set found');

		for (Opportunity op : opps) {
			System.assert(
				op.Name.contains('TestOpp01') ||
				op.Name.contains('TestOpp02') ||
				op.Name.contains('TestOpp03') ||
				op.Name.contains('TestOpp05'),
				'Invalid opp found: ' + op.Name
			);
		}
	}

	@IsTest
	static void executeBatchableTest() {
		OpportunityExpireBatch batch = new OpportunityExpireBatch();
		batch.cfg.ChainActivityExpireBatch__c = false;
		batch.validToTreshold = validToTreshold;
		batch.validFromTreshold = validFromTreshold;

		createData();

		List<Opportunity> opps = (List<Opportunity>) batch.start(null);

		batch.execute(null, opps);

		List<Opportunity> postOpps = [SELECT Id, Name, StageName, Reason__c FROM Opportunity ORDER BY Name];

		String[] expectedStage = new List<String>{
			'8',
			'8',
			'8',
			'4',
			'8',
			'4',
			'4',
			'4',
			'8',
			'8',
			'8',
			'8',
			'8',
			'8',
			'8',
			'8',
			'4',
			'8'
		};
		Integer idx = 0;
		for (Opportunity po : postOpps) {
			System.debug(po);
			System.assertEquals(expectedStage[idx], po.StageName, 'Invalid StageName in ' + po.Name);
			idx++;
		}

		String[] expectedStatus = new List<String>{
			'5',
			'5',
			'5',
			'4',
			'5',
			'4',
			'4',
			'4',
			'4', // the opportunity connected has alread been in 8 state, so no change to its tasks status
			'4', // no opportunity connected
			'5'
		};

		idx = 0;
		List<Task> postTasks = [SELECT Id, Subject, Status FROM Task ORDER BY Subject];
		for (Task t : postTasks) {
			System.debug(t);
			System.assertEquals(expectedStatus[idx], t.Status, 'Invalid Status in ' + t.Subject);
			idx++;
		}
	}
}