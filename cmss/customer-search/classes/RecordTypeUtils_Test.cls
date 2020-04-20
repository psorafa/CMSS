/**
 * Created by a.kovacova on 3/27/2020.
 */

@IsTest
private class RecordTypeUtils_Test {
	static final String BUS_ACC_RT_DEV_NAME = 'Business_Account';
	static final String PERSON_ACC_RT_DEV_NAME = 'PersonAccount';
	static final String ACCOUNT_SOBJECT = 'Account';

	@IsTest
	static void getBusAccountRecordTypeIdTest() {
		RecordType busAccountRT = [
			SELECT Id
			FROM RecordType
			WHERE DeveloperName = :BUS_ACC_RT_DEV_NAME AND SobjectType = :ACCOUNT_SOBJECT
			LIMIT 1
		];
		Test.startTest();
		System.assertEquals(
			busAccountRT.Id,
			RecordTypeUtils.getRecordTypeIdByDeveloperName(BUS_ACC_RT_DEV_NAME, ACCOUNT_SOBJECT),
			'The record type id is not as expected.'
		);
		Test.stopTest();
	}

	@IsTest
	static void getPersonAccountRecordTypeIdTest() {
		RecordType personAccountRT = [
			SELECT Id
			FROM RecordType
			WHERE DeveloperName = :PERSON_ACC_RT_DEV_NAME AND SobjectType = :ACCOUNT_SOBJECT
			LIMIT 1
		];
		Test.startTest();
		System.assertEquals(
			personAccountRT.Id,
			RecordTypeUtils.getRecordTypeIdByDeveloperName(PERSON_ACC_RT_DEV_NAME, ACCOUNT_SOBJECT),
			'The record type id is not as expected.'
		);
		Test.stopTest();
	}
}
