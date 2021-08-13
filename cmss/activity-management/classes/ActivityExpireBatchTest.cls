@IsTest
public with sharing class ActivityExpireBatchTest {
    private static Integer cntr = 1;

    private static final Date before40days = System.today().addDays(-40);
    private static final Date yesterday = System.today().addDays(-1);
    private static final Date today = System.today();
    private static final Date tomorrow = System.today().addDays(1);

    private static Event getEvent(Date validTo, String status) {
        return new Event(
            ActivityDateTime = before40days,
            ValidTo__c = validTo,
            Status__c = status,
            Subject = 'TestEvent' + (cntr++),
            DurationInMinutes = 60
        );
    }

    private static Task getTask(Date validTo, String status) {
        return new Task(
            ValidTo__c = validTo,
            Status = status,
            Subject = 'TestTask' + (cntr++)
        );
    }

    @IsTest
    static void finishTaskTest() {
        ActivityExpireBatch batch1 = new ActivityExpireBatch();
        List<AsyncApexJob> jobsBefore = [
            SELECT Id, ApexClassID, ApexClass.Name, Status, JobType
            FROM AsyncApexJob
        ];

        Test.startTest();
        batch1.finish(null);

        List<AsyncApexJob> jobsAfter = [
            SELECT Id, ApexClassID, ApexClass.Name, Status, JobType
            FROM AsyncApexJob
            WHERE Id NOT IN :jobsBefore
        ];
        System.assertEquals(
            1,
            jobsAfter.size(),
            'The expected job is not scheduled'
        );
        System.debug('First new job: ' + jobsAfter[0]);
        Test.stopTest();
    }

    @IsTest
    static void finishEventTest() {
        ActivityExpireBatch batch2 = new ActivityExpireBatch('event');
        List<AsyncApexJob> jobsBefore = [
            SELECT Id, ApexClassID, ApexClass.Name, Status, JobType
            FROM AsyncApexJob
        ];

        Test.startTest();
        batch2.finish(null);

        List<AsyncApexJob> jobsAfter = [
            SELECT Id, ApexClassID, ApexClass.Name, Status, JobType
            FROM AsyncApexJob
            WHERE Id NOT IN :jobsBefore
        ];
        System.assertEquals(
            0,
            jobsAfter.size(),
            'An unexpected job is scheduled'
        );
        Test.stopTest();
    }

    private static void createTestData() {
        insert new List<sObject> {
            getTask(yesterday, '1'),
            getTask(today, '1'),
            getTask(tomorrow, '1'),
            getTask(before40days, '1'),
            getEvent(yesterday, '1'),
            getEvent(today, '1'),
            getEvent(tomorrow, '1'),
            getEvent(before40days, '1')
        };
    }

    @IsTest
    static void startTaskTest() {
        ActivityExpireBatch batch = new ActivityExpireBatch();

        createTestData();

        List<sObject> objects = (List<sObject>)batch.start(null);

        Integer found = 0;
        for(sObject a: objects) {
            found++;
            System.debug(a);
            String subj = (String)a.get('subject');
            System.assert(subj=='TestTask1' || subj=='TestTask2' || subj=='TestTask4','Unexpected row subject found: '+subj);
        }
        System.assertEquals(3,found,'Invalid set of selected tasks');
    }

    @IsTest
    static void startEventTest() {
        ActivityExpireBatch batch = new ActivityExpireBatch('event');

        createTestData();

        List<sObject> objects = (List<sObject>)batch.start(null);

        Integer found = 0;
        for(sObject a: objects) {
            found++;
            System.debug(a);
            String subj = (String)a.get('subject');
            System.assert(subj=='TestEvent5' || subj=='TestEvent6' || subj=='TestEvent8','Unexpected row subject found: '+subj);
        }
        System.assertEquals(3,found,'Invalid set of selected events');
    }

    @IsTest
    static void executeBatchTest() {

        ActivityExpireBatch batch = new ActivityExpireBatch();

        createTestData();

        List<Task> before = (List<Task>)batch.start(null);
        batch.execute(null, before );

        List<Task> after = [SELECT Id,Subject,ValidTo__c, Status__c,DeactivateDate__c FROM Task WHERE Id IN :before ORDER BY Subject ];

        Integer idx = 0;
        for(Task a: after) {
            System.debug('AFTER '+ (idx++) +': '+JSON.serializePretty(a));
            System.assertEquals( a.Subject=='TestTask4' ? '5' :  '4', a.Status__c,'Invalid Status__c');
        }

        System.assertEquals(today, after[2].DeactivateDate__c, 'Wrong DeactivateDate__c');
    }

    @IsTest
    static void executeSchedulableTest() {
        ActivityExpireBatch batch1 = new ActivityExpireBatch();
        List<AsyncApexJob> jobsBefore = [
            SELECT Id, ApexClassID, ApexClass.Name, Status, JobType
            FROM AsyncApexJob
        ];

        Test.startTest();
        batch1.execute(null);

        List<AsyncApexJob> jobsAfter = [
            SELECT Id, ApexClassID, ApexClass.Name, Status, JobType
            FROM AsyncApexJob
            WHERE Id NOT IN :jobsBefore
        ];
        System.assertEquals(
            1,
            jobsAfter.size(),
            'The expected job is not scheduled'
        );
        System.debug('First new job: ' + jobsAfter[0]);
        Test.stopTest();
    }

}
